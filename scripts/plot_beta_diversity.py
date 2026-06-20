import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
from qiime2 import Artifact, Metadata
from skbio.stats.ordination import OrdinationResults

# Paths
jaccard_path    = snakemake.input.jaccard_pcoa
braycurtis_path = snakemake.input.braycurtis_pcoa
unweighted_path = snakemake.input.unweighted_pcoa
weighted_path   = snakemake.input.weighted_pcoa
metadata_path   = snakemake.input.metadata_path
color_palette = snakemake.params.color_palette
group_order   = snakemake.params.group_order

output_plot     = snakemake.output.beta_diversity_plot
output_plot_png = snakemake.output.beta_diversity_plot_png
sentinel        = snakemake.output.sentinel

# ---------------- Factor ----------------
factor = snakemake.params.group_by

# ---------------- Load PCoA results ----------------
pcoa_results = {
    "Bray-Curtis":       Artifact.load(braycurtis_path).view(OrdinationResults),
    "Jaccard":           Artifact.load(jaccard_path).view(OrdinationResults),
    "Weighted UniFrac":  Artifact.load(weighted_path).view(OrdinationResults),
    "Unweighted UniFrac": Artifact.load(unweighted_path).view(OrdinationResults),
}

# ---------------- Load metadata ----------------
metadata = Metadata.load(metadata_path).to_dataframe()

# Strip whitespace from string columns
for col in metadata.select_dtypes(include="object"):
    metadata[col] = metadata[col].str.strip()

# ---------------- Validate factor ----------------
if factor not in metadata.columns:
    raise ValueError(
        f"Factor '{factor}' not found in metadata. "
        f"Available columns: {list(metadata.columns)}"
    )

categories = group_order

# Color palette
CATEGORY_COLORS = {g: color_palette[g] for g in categories}

# ---------------- Plot ----------------
fig, axes = plt.subplots(2, 2, figsize=(14, 12))
axes = axes.flatten()
for ax, (metric, pcoa_res) in zip(axes, pcoa_results.items()):
    # 1. Get coordinates and rename ONLY the PC columns immediately
    coords = pcoa_res.samples
    coords = coords.rename(columns={0: "PC1", 1: "PC2"})

    # 2. Merge with metadata
    df = coords.merge(metadata, left_index=True, right_index=True)

    # 3. Check if df is empty (common debug step)
    if df.empty:
        print(f"Warning: No overlapping indices for {metric}. Check your metadata IDs.")
        continue

    sns.scatterplot(
        x="PC1",
        y="PC2",
        hue=factor,
        hue_order=categories,
        data=df,
        palette=CATEGORY_COLORS,
        s=100,
        alpha=0.8,
        ax=ax,
    )

    # Ellipses + centroids
    for cat in categories:
        cat_df = df[df[factor] == cat]
        if len(cat_df) < 2:
            continue
        if cat_df["PC1"].std() == 0 or cat_df["PC2"].std() == 0:
            continue

        cx, cy = cat_df["PC1"].mean(), cat_df["PC2"].mean()
        w, h   = cat_df["PC1"].std() * 2, cat_df["PC2"].std() * 2

        ellipse = Ellipse(
            (cx, cy),
            width=w,
            height=h,
            edgecolor=CATEGORY_COLORS[cat],
            facecolor=CATEGORY_COLORS[cat],
            alpha=0.15,
            lw=2,
        )
        ax.add_patch(ellipse)
        ax.scatter(cx, cy, marker="D", s=150, color=CATEGORY_COLORS[cat])

    ax.set_title(metric)
    ax.set_xlabel("PC1")
    ax.set_ylabel("PC2")

fig.suptitle(f"PCoA on Samples by Factor: {factor}", fontsize=16)
plt.tight_layout()
plt.savefig(output_plot, dpi=300, bbox_inches="tight")
plt.savefig(output_plot_png, format="png", dpi=300, bbox_inches="tight")
plt.close()

# ---------------- Sentinel ----------------
with open(sentinel, "w") as f:
    f.write("done\n")