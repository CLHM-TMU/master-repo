import subprocess
import sys
import tempfile
from pathlib import Path
import pandas as pd
import re

# ── Snakemake bindings ────────────────────────────────────────────────────────
feature_table  = snakemake.input.feature_table
taxonomy       = snakemake.input.taxonomy
metadata       = snakemake.input.metadata

lefse_results  = snakemake.output.lefse_results
lda_svg        = snakemake.output.lda_svg
cladogram_svg  = snakemake.output.cladogram_svg

group_col       = snakemake.params.group_col
lda_cutoff      = snakemake.params.lda_cutoff
kw_cutoff       = snakemake.params.kw_cutoff
wilcoxon_cutoff = snakemake.params.wilcoxon_cutoff
colors = list(snakemake.params.colors.values())

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
def run(cmd: list) -> None:
    print("Running:", " ".join(str(c) for c in cmd), flush=True)
    subprocess.run(cmd, check=True)

# ── Intermediates as tempfiles ────────────────────────────────────────────────
with tempfile.TemporaryDirectory() as tmpdir:
    tmpdir = Path(lefse_results).parent / "lefse_debug"
    tmpdir.mkdir(parents=True, exist_ok=True)
    lefse_input_tsv = tmpdir / "lefse_input.tsv"
    lefse_input_in  = tmpdir / "lefse_input.in"

    # Step 1 – QIIME 2 artefacts → LEfSe TSV
    run([
        CONDA_PYTHON, lefse("plugin_lefse_input.py"),
        "--table_file",    feature_table,
        "--taxonomy_file", taxonomy,
        "--metadata_file", metadata,
        "--output_file",   lefse_input_tsv,
        "--class_col",     group_col,
    ])

    # Step 1.5 – reorder columns by group order from metadata

    meta_df = pd.read_csv(metadata, sep="\t", index_col=0)
    # Build group -> order mapping
    group_order = meta_df.groupby(group_col)["Order"].first().sort_values().index.tolist()

    tsv = pd.read_csv(lefse_input_tsv, sep="\t", header=None)

    # Row 0 is group labels, col 0 is feature names
    feature_col = tsv.iloc[:, 0]           # save feature name column
    data = tsv.iloc[:, 1:]                 # everything except feature col
    group_row = data.iloc[0]               # group labels for each sample column

    # Reorder columns by group_order
    ordered_cols = sorted(data.columns, key=lambda c: group_order.index(group_row[c]))
    data = data[ordered_cols]

    # Reassemble and save
    tsv_reordered = pd.concat([feature_col, data], axis=1)
    tsv_reordered.to_csv(lefse_input_tsv, sep="\t", header=False, index=False)

    # Step 2 – format TSV → LEfSe .in
    run([
        CONDA_PYTHON, lefse("plugin_lefse_format.py"),
        lefse_input_tsv,
        lefse_input_in,
        "-c", "1",
        "-o", "1000000"
    ])

    # Step 3 – run LEfSe → results
    run([
        CONDA_PYTHON, lefse("plugin_lefse_run.py"),
        lefse_input_in,
        lefse_results,
        "-l", str(lda_cutoff),
        "-a", str(kw_cutoff),
        "-w", str(wilcoxon_cutoff)
    ])

    # Step 4 – LDA bar plot
    run([
        CONDA_PYTHON, lefse("plugin_lefse_barplot.py"),
        lefse_results,
        lda_svg,
        "--format", "svg",
        "--dpi",    "300",
        "--left_space", "0.3",    # more space on left for labels
        "--colors", *colors,
    ])

    # Step 5 – cladogram
    run([
        CONDA_PYTHON, lefse("plugin_lefse_treeplot.py"),
        lefse_results,
        cladogram_svg,
        "--format", "svg",
        "--dpi",    "300",
        "--colors", *colors,
        "--left_space_prop",  "0.15",  # was 0.1
        "--right_space_prop", "0.45",
        "--class_legend_font_size", "6",  # shrink group legend
        "--label_font_size",  "5",     # shrink feature key text
        "--labeled_start_lev", "3",    # only label from level 3 inward
        "--labeled_stop_lev",  "6",    # stop labeling at level 6     # smaller labels to fit more
        "--clade_sep",        "1.5",    # more separation between clades
        "--expand_void_lev",  "1",      # expand empty levels
        "--abrv_start_lev",   "3",      # abbreviate from level 3 onward
        "--abrv_stop_lev",    "5",      # stop abbreviating at level 5
    ])
