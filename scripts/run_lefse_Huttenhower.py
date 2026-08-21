import subprocess
import sys
import tempfile
import os
from pathlib import Path
import pandas as pd

# ── Snakemake bindings ────────────────────────────────────────────────────────
feature_table  = snakemake.input.feature_table
taxonomy       = snakemake.input.taxonomy
metadata       = snakemake.input.metadata

lefse_results  = snakemake.output.lefse_Huttenhower_results
lda_svg        = snakemake.output.lda_svg
cladogram_svg  = snakemake.output.cladogram_svg
lda_png        = snakemake.output.lda_png
cladogram_png  = snakemake.output.cladogram_png

group_col       = snakemake.params.group_col
lda_cutoff      = snakemake.params.lda_cutoff
kw_cutoff       = snakemake.params.kw_cutoff
wilcoxon_cutoff = snakemake.params.wilcoxon_cutoff
colors_map      = snakemake.params.colors
db              = snakemake.wildcards.db

# ── Per-database taxonomic resolution ──────────────────────────────────────
# Greengenes2's full-length 16S classifier resolves real species-level calls
# (e.g. "s__Duncaniella muris"); Silva138's species field is empty for every
# ASV, so collapsing/labeling it past genus would only add noise.
# `collapse_level` is the QIIME 2 `taxa collapse` rank (6 = genus, 7 =
# species) used when building the LEfSe input table. `abrv_stop_lev` /
# `labeled_stop_lev` are cladogram depths in tree-node units, where
# node depth = 1 (root) + number of taxonomic ranks in the collapsed name —
# e.g. genus (6 ranks) is tree depth 7, species (7 ranks) is tree depth 8.
DB_CONFIG = {
    "Silva138": {
        "display":          "SILVA 138",
        "collapse_level":   6,   # genus
        "labeled_stop_lev": 7,
        "abrv_stop_lev":    6,
    },
    "Greengenes2": {
        "display":          "Greengenes2",
        "collapse_level":   7,   # species
        "labeled_stop_lev": 8,
        "abrv_stop_lev":    7,
    },
}
if db not in DB_CONFIG:
    raise ValueError(f"No LEfSe display/depth config for db={db!r}. Known: {sorted(DB_CONFIG)}")
db_cfg = DB_CONFIG[db]

RANK_NAMES = {
    "d": "Domain", "p": "Phylum", "c": "Class",
    "o": "Order", "f": "Family", "g": "Genus", "s": "Species",
}

def deepest_significant_rank(res_path) -> str:
    """Deepest taxonomic rank among features LEfSe actually called significant."""
    deepest_depth = 0
    deepest_name = "Unknown"
    with open(res_path) as fh:
        for line in fh:
            fields = line.rstrip("\n").split("\t")
            if len(fields) < 3 or not fields[2]:
                continue  # no class assigned -> not significant
            ranks = fields[0].split(".")
            prefix = ranks[-1].split("_", 1)[0]
            rank_name = RANK_NAMES.get(prefix)
            if rank_name and len(ranks) > deepest_depth:
                deepest_depth = len(ranks)
                deepest_name = rank_name
    return deepest_name

# ── Resolve the conda env's own Python ───────────────────────────────────────
# sys.executable is Snakemake's Python; we need the one inside the rule's
# conda env, which is always at $CONDA_PREFIX/bin/python.
CONDA_PYTHON = Path(sys.executable).parent / "python"
if not CONDA_PYTHON.exists():
    raise FileNotFoundError(
        f"Could not find conda env Python at {CONDA_PYTHON}.\n"
        f"sys.executable was: {sys.executable}"
    )

# ── Resolve lefse/ folder relative to this script ────────────────────────────
SCRIPT_DIR = Path(__file__).resolve().parent
LEFSE_DIR  = SCRIPT_DIR / "lefse"

def lefse(name: str) -> str:
    p = LEFSE_DIR / name
    if not p.exists():
        raise FileNotFoundError(f"LEfSe script not found: {p}")
    return str(p)

# ── Helper ────────────────────────────────────────────────────────────────────
def run(cmd: list, env=None) -> None:
    print("Running:", " ".join(str(c) for c in cmd), flush=True)
    subprocess.run(cmd, check=True, env=env)

# ── Desired order, colors, and a transient sort-key prefix ────────────────────
# The LEfSe plotting scripts (barplot + cladogram) re-derive the class list from
# the .res file and sort it ALPHABETICALLY before assigning legend order, color,
# and (for the LDA barplot) which side of the diverging chart each group's bars
# land on. Row order in the .res file is ignored, so reordering rows does nothing.
# To control that ordering we make the alphabetical order EQUAL the desired order
# by prefixing each class label with a sort key ("zzsort00_", "zzsort01_", ...).
# This prefix exists only in the class column the plotting scripts read for
# ordering/color lookups (`--all_feats`); the TEXT they actually draw is taken
# from `--class_labels`, a raw->display lookup, so the figure never shows the
# prefix — for either SVG or PNG. (PNG's rasterized text can't be edited after
# the fact the way SVG text can, which is why display text has to be supplied
# at render time rather than stripped out afterward.)
order  = list(colors_map.keys())                 # desired legend order
colors = [colors_map[g] for g in order]          # colors in DESIRED order
#   (because the prefixed labels now sort into `order`, the plotting scripts
#    assign colors[i] to order[i] — so pass colors in desired order, not sorted.)

# Both the original (space) and QIIME 2 (underscore) forms of each group name
# map to an underscore-only prefixed label. LEfSe scripts split class names on
# whitespace internally, so spaces in class labels cause parse errors;
# underscores are safe.
sortkey = {}
for i, g in enumerate(order):
    g_norm = g.replace(" ", "_")
    label  = f"zzsort{i:02d}_{g_norm}"
    sortkey[g]      = label
    sortkey[g_norm] = label

all_feats    = ":".join(sortkey[g] for g in order)
class_labels = [f"{sortkey[g]}={g}" for g in order]

def strip_prefix(path) -> None:
    """Clean up the persisted .res file (a real pipeline output, unlike the
    SVG/PNG figures) so anything reading it downstream sees plain group names."""
    p = Path(path)
    text = p.read_text()
    for g in order:
        text = text.replace(sortkey[g], g)
    p.write_text(text)

# ── Intermediates as tempfiles ────────────────────────────────────────────────
with tempfile.TemporaryDirectory() as _tmp:
    tmpdir = Path(_tmp)
    tmpdir.mkdir(parents=True, exist_ok=True)
    lefse_input_tsv = tmpdir / "lefse_input.tsv"
    lefse_input_in  = tmpdir / "lefse_input.in"

    # A matplotlibrc that keeps SVG text as real, searchable/selectable characters
    # instead of glyph paths. Supplied via an env var, so the (read-only /
    # encrypted) lefse scripts are untouched.
    mplrc_dir = tmpdir / "mplrc"
    mplrc_dir.mkdir(exist_ok=True)
    (mplrc_dir / "matplotlibrc").write_text("svg.fonttype: none\n")
    plot_env = {**os.environ, "MATPLOTLIBRC": str(mplrc_dir)}

    # Step 1 – QIIME 2 artefacts → LEfSe TSV
    run([
        CONDA_PYTHON, lefse("plugin_lefse_input.py"),
        "--table_file",    feature_table,
        "--taxonomy_file", taxonomy,
        "--metadata_file", metadata,
        "--output_file",   lefse_input_tsv,
        "--class_col",     group_col,
        "--level",         str(db_cfg["collapse_level"]),
    ])

    # Step 1.5 – rename class labels in the TSV group row with the sort-key
    # prefix so alphabetical order == desired order. No column reordering needed:
    # the plotting scripts re-derive class order from the labels themselves.
    tsv = pd.read_csv(lefse_input_tsv, sep="\t", header=None,
                      dtype=str, keep_default_na=False)
    feature_col = tsv.iloc[:, 0]          # feature-name column (untouched)
    data = tsv.iloc[:, 1:].copy()         # sample columns; row 0 = group labels

    present = set(data.iloc[0].unique())
    missing = present - set(sortkey)
    if missing:
        raise ValueError(
            f"Group(s) in the data are absent from colors_map: {sorted(missing)}.\n"
            f"colors_map keys: {sorted(sortkey)}"
        )

    data.iloc[0] = data.iloc[0].map(sortkey)
    pd.concat([feature_col, data], axis=1).to_csv(
        lefse_input_tsv, sep="\t", header=False, index=False
    )

    # Step 2 – format TSV → LEfSe .in
    run([
        CONDA_PYTHON, lefse("plugin_lefse_format.py"),
        lefse_input_tsv,
        lefse_input_in,
        "-c", "1",
        "-o", "1000000",
    ])

    # Step 3 – run LEfSe → results (class column now carries the prefixed labels)
    run([
        CONDA_PYTHON, lefse("plugin_lefse_run.py"),
        lefse_input_in,
        lefse_results,
        "-l", str(lda_cutoff),
        "-a", str(kw_cutoff),
        "-w", str(wilcoxon_cutoff),
    ])

    footnote = (
        f"Lowest taxonomic level differentially identified: "
        f"{deepest_significant_rank(lefse_results)}"
    )

    # Step 4 – LDA bar plot + cladogram, once per output format. Both formats
    # read the SAME prefixed .res file and use the SAME `--all_feats`/`--colors`
    # (pinned to the full configured group universe, not just whichever classes
    # happen to be significant this run — otherwise a group with zero hits would
    # make the rest compact into a shorter list and silently grab the wrong
    # PrimaryColor / bar position). `--class_labels` maps each prefixed class
    # back to its clean display name at render time, so the ordering-only prefix
    # never actually appears in either figure — this works for PNG too, unlike
    # a post-render text substitution, which only SVG's plain-text glyphs allow.
    formats = [
        {
            "fmt": "svg",
            "lda_out": lda_svg,
            "cladogram_out": cladogram_svg,
            "label_font_size": "5",
            "barplot_extra": [],
        },
        {
            "fmt": "png",
            "lda_out": lda_png,
            "cladogram_out": cladogram_png,
            "label_font_size": "4",
            "barplot_extra": ["--feature_font_size", "4"],
        },
    ]

    # db_label is drawn as a small kicker line ABOVE the main title (not merged
    # into the title string) so it can be cropped off independently if someone
    # wants a clean figure without the database name on it.
    db_label        = db_cfg["display"]
    lda_title       = "LEfSe LDA Effect Size"
    cladogram_title = "LEfSe Cladogram"

    for f in formats:
        run([
            CONDA_PYTHON, lefse("plugin_lefse_barplot.py"),
            lefse_results,
            f["lda_out"],
            "--format", f["fmt"],
            "--dpi",    "300",
            "--left_space", "0.3",      # more space on left for labels
            *f["barplot_extra"],
            "--colors", *colors,
            "--all_feats", all_feats,
            "--class_labels", *class_labels,
            "--title", lda_title,
            "--db_label", db_label,
            "--footnote", footnote,
        ], env=plot_env)

        run([
            CONDA_PYTHON, lefse("plugin_lefse_treeplot.py"),
            lefse_results,
            f["cladogram_out"],
            "--format", f["fmt"],
            "--dpi",    "300",
            "--colors", *colors,
            "--left_space_prop",  "0.15",
            "--right_space_prop", "0.45",
            "--class_legend_font_size", "6",   # shrink group legend
            "--label_font_size",  f["label_font_size"],  # shrink feature key text
            "--labeled_start_lev", "3",        # only label from level 3 inward
            "--labeled_stop_lev",  str(db_cfg["labeled_stop_lev"]),  # deepest rank this db resolves
            "--clade_sep",        "1.5",       # more separation between clades
            "--expand_void_lev",  "1",         # expand empty levels
            "--abrv_start_lev",   "3",         # abbreviate from level 3 onward
            "--abrv_stop_lev",    str(db_cfg["abrv_stop_lev"]),      # deepest rank this db resolves
            "--all_feats", all_feats,
            "--class_labels", *class_labels,
            "--title", cladogram_title,
            "--db_label", db_label,
            "--footnote", footnote,
        ], env=plot_env)

    # Step 5 – restore original group names (spaces included) in the persisted
    # .res file so anything downstream sees clean labels.
    strip_prefix(lefse_results)