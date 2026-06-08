import os
import re

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
from qiime2 import Artifact, Metadata

# ──────────────────────────────────────────────
# Snakemake I/O
# ──────────────────────────────────────────────
shannon_path  = snakemake.input.shannon
evenness_path = snakemake.input.evenness
faith_pd_path = snakemake.input.faith_pd
simpson_path  = snakemake.input.simpson
metadata_path = snakemake.input.metadata
color_palette = snakemake.params.color_palette

database    = snakemake.params.db
output_dir  = snakemake.params.output_dir
factors     = snakemake.params.group_by
if isinstance(factors, str):
    factors = [factors]

output_plot_path = snakemake.output.alpha_plot
output_sentinel  = snakemake.output.sentinel

# ──────────────────────────────────────────────
# Constants
# ──────────────────────────────────────────────
METRICS = ["Shannon", "Evenness", "Faith PD", "Simpson"]

# ──────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────
def group_order_from_metadata(df, factor_col):
    """
    Return the unique values of *factor_col* sorted by the 'Order' column in
    *df* (one integer per group).  Each group must have a single unique Order
    value; the first encountered value is used if they somehow differ.
    Falls back to natural sort when 'Order' is absent.
    """
    if "Order" not in df.columns:
        return sorted(df[factor_col].dropna().unique(), key=natural_sort_key)

    order_map = (
        df[[factor_col, "Order"]]
        .dropna(subset=[factor_col, "Order"])
        .groupby(factor_col)["Order"]
        .first()
        .astype(int)
    )
    return order_map.sort_values().index.tolist()


def natural_sort_key(value):
    """Sort key that handles embedded integers correctly (e.g. Group2 < Group10)."""
    return [int(c) if c.isdigit() else c.lower() for c in re.split(r"(\d+)", str(value))]


def load_alpha_diversity(shannon_path, evenness_path, faith_pd_path, simpson_path):
    """Load the four QIIME 2 alpha-diversity vectors and return a combined DataFrame."""
    vectors = {
        "Shannon":  Artifact.load(shannon_path).view(pd.Series),
        "Evenness": Artifact.load(evenness_path).view(pd.Series),
        "Faith PD": Artifact.load(faith_pd_path).view(pd.Series),
        "Simpson":  Artifact.load(simpson_path).view(pd.Series),
    }
    return pd.concat({k: v.rename(k) for k, v in vectors.items()}, axis=1)


def load_metadata(metadata_path):
    return Metadata.load(metadata_path).to_dataframe()


def rotate_labels(axes, factor_col):
    """
    For each Axes in *axes*, rotate x-tick labels 45° and ensure the
    x-axis label (group name) is visible on every subplot.
    """
    for ax in axes:
        tick_labels = ax.get_xticklabels()
        if not tick_labels:
            continue

        ax.set_xticklabels(
            [t.get_text() for t in tick_labels],
            rotation=45,
            ha="right",
            rotation_mode="anchor",
        )
        ax.set_xlabel(factor_col)


def plot_alpha_diversity(df, factor_col, outfile, color_palette):
    """
    Box + strip plots for all four alpha-diversity metrics faceted by *factor_col*.
    Saves the figure to *outfile* as SVG.
    """
    group_order = group_order_from_metadata(df, factor_col)
    palette     = [color_palette[g] for g in group_order]

    melted = df.melt(
        id_vars=[factor_col],
        value_vars=METRICS,
        var_name="Metric",
        value_name="Diversity",
    )

    sns.set_theme(style="whitegrid")
    g = sns.catplot(
        data=melted,
        x=factor_col,
        y="Diversity",
        col="Metric",
        kind="box",
        order=group_order,
        palette=palette,
        col_wrap=2,
        sharex=False,
        sharey=False,
        height=4,
        aspect=1.2,
    )

    g.map_dataframe(
        sns.stripplot,
        x=factor_col,
        y="Diversity",
        order=group_order,
        color="black",
        alpha=0.5,
    )

    g.figure.suptitle(f"Alpha Diversity by {factor_col}", fontsize=16)
    g.figure.subplots_adjust(top=0.88, hspace=0.5)

    # Force layout computation so tick labels are populated before rotating
    g.figure.canvas.draw()
    rotate_labels(g.axes.flat, factor_col)

    g.savefig(outfile, format="svg", bbox_inches="tight")
    plt.close(g.figure)


# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
def main():
    alpha_df = load_alpha_diversity(shannon_path, evenness_path, faith_pd_path, simpson_path)
    metadata = load_metadata(metadata_path)
    merged   = alpha_df.join(metadata)

    print("Available metadata columns:", merged.columns.tolist())
    print("Requested factors:", factors)

    os.makedirs(output_dir, exist_ok=True)

    for factor in factors:
        outfile = os.path.join(output_dir, f"{database}_alpha_{factor}.svg")
        plot_alpha_diversity(merged, factor, outfile, color_palette)
        print(f"Saved: {outfile}")

    with open(output_sentinel, "w") as fh:
        fh.write("done\n")


main()