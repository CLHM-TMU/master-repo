import os

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
chao1_path    = snakemake.input.chao1
metadata_path = snakemake.input.metadata
color_palette = snakemake.params.color_palette
group_order   = snakemake.params.group_order

database    = snakemake.params.db
output_dir  = snakemake.params.output_dir
factors     = snakemake.params.group_by
if isinstance(factors, str):
    factors = [factors]

output_plot_path  = snakemake.output.alpha_plot
chao1_plot_path   = snakemake.output.chao1_plot
chao1_plot_png_path = snakemake.output.chao1_plot_png
output_sentinel   = snakemake.output.sentinel

# ──────────────────────────────────────────────
# Constants
# ──────────────────────────────────────────────
METRICS = ["Shannon", "Evenness", "Faith PD", "Simpson"]

# ──────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────
def load_alpha_diversity(shannon_path, evenness_path, faith_pd_path, simpson_path):
    """Load the four QIIME 2 alpha-diversity vectors and return a combined DataFrame."""
    vectors = {
        "Shannon":  Artifact.load(shannon_path).view(pd.Series),
        "Evenness": Artifact.load(evenness_path).view(pd.Series),
        "Faith PD": Artifact.load(faith_pd_path).view(pd.Series),
        "Simpson":  Artifact.load(simpson_path).view(pd.Series),
    }
    return pd.concat({k: v.rename(k) for k, v in vectors.items()}, axis=1)


def load_chao1(chao1_path):
    """Load the Chao1 alpha-diversity vector and return a single-column DataFrame."""
    return Artifact.load(chao1_path).view(pd.Series).rename("Chao1").to_frame()


def load_metadata(metadata_path):
    return Metadata.load(metadata_path).to_dataframe()


def rotate_labels(axes, factor_col):
    """
    For each Axes in *axes*, rotate x-tick labels 30° and ensure the
    x-axis label (group name) is visible on every subplot.
    """
    for ax in axes:
        tick_labels = ax.get_xticklabels()
        if not tick_labels:
            continue

        ax.set_xticklabels(
            [t.get_text() for t in tick_labels],
            rotation=30,
            ha="right",
            rotation_mode="anchor",
        )
        ax.set_xlabel(factor_col)


def plot_chao1(df, factor_col, outfile, color_palette, group_order):
    """
    Box + strip plot for Chao1 richness alone, saved as an isolated figure.
    """
    palette = [color_palette[g] for g in group_order]

    sns.set_theme(style="whitegrid")
    fig, ax = plt.subplots(figsize=(max(4, len(group_order) * 1.2), 5))

    sns.boxplot(
        data=df,
        x=factor_col,
        y="Chao1",
        order=group_order,
        palette=palette,
        ax=ax,
    )
    sns.stripplot(
        data=df,
        x=factor_col,
        y="Chao1",
        order=group_order,
        color="black",
        alpha=0.5,
        ax=ax,
    )

    tick_labels = ax.get_xticklabels()
    if tick_labels:
        ax.set_xticklabels(
            [t.get_text() for t in tick_labels],
            rotation=25,
            ha="right",
            rotation_mode="anchor",
        )
    ax.set_xlabel(factor_col)
    ax.set_ylabel("Chao1")
    ax.set_title(f"Chao1 Richness by {factor_col}")

    fig.tight_layout()
    fig.savefig(outfile, format="svg", bbox_inches="tight")
    fig.savefig(outfile.replace(".svg", ".png"), format="png", dpi=300, bbox_inches="tight")
    plt.close(fig)


def plot_alpha_diversity(df, factor_col, outfile, color_palette, group_order):
    """
    Box + strip plots for all four alpha-diversity metrics faceted by *factor_col*.
    Saves the figure to *outfile* as SVG.

    Each facet keeps its own x-axis tick labels (sharex=False) so an individual
    panel remains legible if cropped out on its own.  Because the labels are
    rotated, the layout is solved *after* rotation so the row spacing accounts
    for their real height instead of letting top-row labels run into the panels
    below them.
    """
    palette = [color_palette[g] for g in group_order]

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

    # Draw once so tick labels exist, rotate them, then draw again so the new
    # (taller) extents are measurable before the layout is solved.
    g.figure.canvas.draw()
    rotate_labels(g.axes.flat, factor_col)
    g.figure.canvas.draw()

    # Let the FacetGrid layout space the rows using the rotated label heights
    # (this correctly handles col_wrap), then carve room for the suptitle.
    # Note: this must replace any manual subplots_adjust(hspace=...) — whichever
    # runs last wins, so we only nudge `top` afterward for the title.
    g.tight_layout()
    g.figure.subplots_adjust(top=0.90)
    g.figure.suptitle(f"Alpha Diversity by {factor_col}", fontsize=16, y=0.98)

    g.savefig(outfile, format="svg", bbox_inches="tight")
    g.savefig(outfile.replace(".svg", ".png"), format="png", dpi=300, bbox_inches="tight")
    plt.close(g.figure)


# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
def main():
    alpha_df  = load_alpha_diversity(shannon_path, evenness_path, faith_pd_path, simpson_path)
    chao1_df  = load_chao1(chao1_path)
    metadata  = load_metadata(metadata_path)
    merged       = alpha_df.join(metadata)
    chao1_merged = chao1_df.join(metadata)

    print("Available metadata columns:", merged.columns.tolist())
    print("Requested factors:", factors)

    os.makedirs(output_dir, exist_ok=True)

    for factor in factors:
        outfile = os.path.join(output_dir, f"{database}_alpha_{factor}.svg")
        plot_alpha_diversity(merged, factor, outfile, color_palette, group_order)
        print(f"Saved: {outfile}")

        chao1_outfile = os.path.join(output_dir, f"{database}_chao1_{factor}.svg")
        plot_chao1(chao1_merged, factor, chao1_outfile, color_palette, group_order)
        print(f"Saved: {chao1_outfile}")

    with open(output_sentinel, "w") as fh:
        fh.write("done\n")


main()