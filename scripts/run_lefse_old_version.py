import subprocess
import sys
import tempfile
import os
import re
from pathlib import Path
import pandas as pd

# ── Snakemake bindings ────────────────────────────────────────────────────────
feature_table  = snakemake.input.feature_table
taxonomy       = snakemake.input.taxonomy
metadata       = snakemake.input.metadata

lefse_results  = snakemake.output.lefse_results
lda_svg        = snakemake.output.lda_svg
cladogram_svg  = snakemake.output.cladogram_svg
lda_png        = snakemake.output.lda_png
cladogram_png  = snakemake.output.cladogram_png

group_col       = snakemake.params.group_col
lda_cutoff      = snakemake.params.lda_cutoff
kw_cutoff       = snakemake.params.kw_cutoff
wilcoxon_cutoff = snakemake.params.wilcoxon_cutoff
colors_map      = snakemake.params.colors

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
# the .res file and sort it ALPHABETICALLY before assigning both the legend order
# and the colors. Row order in the .res file is ignored, so reordering rows does
# nothing. To control the legend order we instead make the alphabetical order
# EQUAL the desired order by prefixing each class label with a sort key
# ("zzsort00_", "zzsort01_", ...). These prefixes exist only in the intermediate
# files; they are stripped back out of the final SVGs and the saved .res in
# Step 6, so every artefact the user sees shows the ORIGINAL group names.
order  = list(colors_map.keys())                 # desired legend order
colors = [colors_map[g] for g in order]          # colors in DESIRED order
#   (because the prefixed labels now sort into `order`, the plotting scripts
#    assign colors[i] to order[i] — so pass colors in desired order, not sorted.)

PREFIX_RE = re.compile(r"zzsort\d+_")

# Build sortkey: both the original (space) and QIIME 2 (underscore) forms of each
# group name map to an underscore-only prefixed label.
# LEfSe scripts split class names on whitespace internally, so spaces in class
# labels cause parse errors; underscores are safe.
sortkey = {}
for i, g in enumerate(order):
    g_norm = g.replace(" ", "_")
    label  = f"zzsort{i:02d}_{g_norm}"
    sortkey[g]      = label
    sortkey[g_norm] = label

# After strip_prefix removes "zzsortNN_", restore underscore→space for group names
_restore = {g.replace(" ", "_"): g for g in order if " " in g}

def strip_prefix(path) -> None:
    p = Path(path)
    text = PREFIX_RE.sub("", p.read_text())
    for g_norm, g in _restore.items():
        text = text.replace(g_norm, g)
    p.write_text(text)

# ── Intermediates as tempfiles ────────────────────────────────────────────────
with tempfile.TemporaryDirectory() as _tmp:
    tmpdir = Path(_tmp)
    tmpdir.mkdir(parents=True, exist_ok=True)
    lefse_input_tsv = tmpdir / "lefse_input.tsv"
    lefse_input_in  = tmpdir / "lefse_input.in"

    # A matplotlibrc that keeps SVG text as real characters instead of glyph
    # paths, so the sort-key prefix is searchable/strippable afterward. Supplied
    # via an env var, so the (read-only / encrypted) lefse scripts are untouched.
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

    # Step 4 – LDA bar plot (reads prefixed .res; env forces editable SVG text)
    run([
        CONDA_PYTHON, lefse("plugin_lefse_barplot.py"),
        lefse_results,
        lda_svg,
        "--format", "svg",
        "--dpi",    "300",
        "--left_space", "0.3",      # more space on left for labels
        "--colors", *colors,
    ], env=plot_env)

    # Step 5 – cladogram (same)
    run([
        CONDA_PYTHON, lefse("plugin_lefse_treeplot.py"),
        lefse_results,
        cladogram_svg,
        "--format", "svg",
        "--dpi",    "300",
        "--colors", *colors,
        "--left_space_prop",  "0.15",
        "--right_space_prop", "0.45",
        "--class_legend_font_size", "6",   # shrink group legend
        "--label_font_size",  "5",         # shrink feature key text
        "--labeled_start_lev", "3",        # only label from level 3 inward
        "--labeled_stop_lev",  "6",        # stop labeling at level 6
        "--clade_sep",        "1.5",       # more separation between clades
        "--expand_void_lev",  "1",         # expand empty levels
        "--abrv_start_lev",   "3",         # abbreviate from level 3 onward
        "--abrv_stop_lev",    "5",         # stop abbreviating at level 5
    ], env=plot_env)

    # Step 6 – strip the transient prefix from SVG plots.
    strip_prefix(lda_svg)
    strip_prefix(cladogram_svg)

    # Step 7 – PNG versions (300 dpi).
    # The LEfSe plotting scripts split class names on whitespace, so spaces in
    # group names cause column misalignment (e.g. "acid IR" → parser reads "IR"
    # as the LDA score and raises ValueError).  Feed the PNG commands a copy of
    # the .res file where only the sort-key prefix is removed but underscores are
    # kept in place of spaces; the persisted .res has spaces restored afterward.
    lefse_results_for_png = tmpdir / "lefse_results_for_png.txt"
    lefse_results_for_png.write_text(
        PREFIX_RE.sub("", Path(lefse_results).read_text())
    )
    # Colors must match the alphabetical order of the underscore-normalised names
    # (the form that the PNG plotting scripts will see).
    png_colors = [colors_map[g] for g in sorted(order, key=lambda g: g.replace(" ", "_"))]

    run([
        CONDA_PYTHON, lefse("plugin_lefse_barplot.py"),
        lefse_results_for_png,
        lda_png,
        "--format", "png",
        "--dpi",    "300",
        "--left_space", "0.3",
        "--feature_font_size", "4",
        "--colors", *png_colors,
    ], env=plot_env)

    run([
        CONDA_PYTHON, lefse("plugin_lefse_treeplot.py"),
        lefse_results_for_png,
        cladogram_png,
        "--format", "png",
        "--dpi",    "300",
        "--colors", *png_colors,
        "--left_space_prop",  "0.15",
        "--right_space_prop", "0.45",
        "--class_legend_font_size", "6",
        "--label_font_size",  "4",
        "--labeled_start_lev", "3",
        "--labeled_stop_lev",  "6",
        "--clade_sep",        "1.5",
        "--expand_void_lev",  "1",
        "--abrv_start_lev",   "3",
        "--abrv_stop_lev",    "5",
    ], env=plot_env)

    # Step 8 – restore original group names (spaces included) in the persisted
    # .res file so anything downstream sees clean labels.
    strip_prefix(lefse_results)