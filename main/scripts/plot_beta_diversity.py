import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
from qiime2 import Artifact
from skbio.stats.ordination import OrdinationResults

# Paths
jaccard_path = snakemake.input.jaccard_pcoa 
braycurtis_path = snakemake.input.braycurtis_pcoa
unweighted_path = snakemake.input.unweighted_pcoa
weighted_path = snakemake.input.weighted_pcoa
metadata_path = snakemake.input.metadata_path
beta_plot_path = snakemake.output.beta_diversity_plot

# Load PCoA results
pcoa_results = {
    "Bray-Curtis": Artifact.load(braycurtis_path).view(OrdinationResults),
    "Jaccard": Artifact.load(jaccard_path).view(OrdinationResults),
    "Weighted": Artifact.load(weighted_path).view(OrdinationResults),
    "Unweighted": Artifact.load(unweighted_path).view(OrdinationResults),
}

# Load metadata
metadata = pd.read_csv(metadata_path, sep="\t", index_col=0)

# strip whitespace
for col_name in metadata.select_dtypes(include=['object']).columns:
    metadata[col_name] = metadata[col_name].str.strip()

Group_Column = "Group"

if Group_Column not in metadata.columns:
    raise ValueError(f"Required metadata column '{Group_Column}' not found.")

# --- AUTODETECT GROUP VALUES ---
groups = sorted(metadata[Group_Column].dropna().unique().tolist())

# Generate a color palette automatically
# palette = sns.color_palette("hls", len(groups))
# GROUP_COLORS = dict(zip(groups, palette))
# --- TEMPORARY MANUAL COLORS ---
MANUAL_GROUP_COLORS = {
    "control": "grey",
    "SCFA": "red",
    "Irradiation": "blue",
    "SCFA+irradiation": "green",
}

# Use manual colors where defined, fallback to auto colors if needed
palette = sns.color_palette("hls", len(groups))
AUTO_COLORS = dict(zip(groups, palette))

GROUP_COLORS = {
    g: MANUAL_GROUP_COLORS.get(g, AUTO_COLORS[g])
    for g in groups
}

# ---------------------------------------------------------------------

fig, axes = plt.subplots(2, 2, figsize=(14, 12))
axes = axes.flatten()

for ax, (distance_metric, pcoa_res) in zip(axes, pcoa_results.items()):
    coords = pcoa_res.samples
    df = coords.merge(metadata, left_index=True, right_index=True)

    # rename PCs
    df = df.rename(columns={i: f"PC{i+1}" for i in range(df.shape[1])})

    # scatter colored by group
    sns.scatterplot(
        x="PC1",
        y="PC2",
        hue=Group_Column,
        data=df,
        palette=GROUP_COLORS,
        s=100,
        alpha=0.8,
        ax=ax
    )

    # Draw ellipses for each group
    for grp in groups:
        group_data = df[df[Group_Column] == grp]

        if len(group_data) < 2:
            continue
        if group_data["PC1"].std() == 0 or group_data["PC2"].std() == 0:
            continue

        centroid_x = group_data["PC1"].mean()
        centroid_y = group_data["PC2"].mean()

        width = group_data["PC1"].std() * 2
        height = group_data["PC2"].std() * 2

        ellipse = Ellipse(
            (centroid_x, centroid_y),
            width=width,
            height=height,
            edgecolor=GROUP_COLORS[grp],
            facecolor=GROUP_COLORS[grp],
            lw=2,
            alpha=0.15
        )
        ax.add_patch(ellipse)

        # centroid point
        ax.scatter(
            centroid_x, centroid_y,
            marker="D",
            color=GROUP_COLORS[grp],
            s=150,
            label=f"{grp} centroid"
        )

    ax.set_title(distance_metric)
    ax.set_xlabel("PC1")
    ax.set_ylabel("PC2")

# ---------------- Legend ----------------

handles = [
    plt.Line2D([0], [0], marker='o', linestyle='', color=GROUP_COLORS[g], label=f"Group {g}")
    for g in groups
] + [
    plt.Line2D([0], [0], marker='D', linestyle='', color=GROUP_COLORS[g], label=f"{g} centroid/ellipse")
    for g in groups
]

fig.legend(
    handles,
    [h.get_label() for h in handles],
    title="Groups",
    bbox_to_anchor=(1.05, 0.5),
    loc='center left'
)

# ---------------- Save Figure ----------------

fig.suptitle("PCoA on Samples by Factor: 'Group'", fontsize=16)
plt.tight_layout(rect=[0, 0, 0.85, 0.95])

plt.savefig(beta_plot_path, dpi=300)
plt.close()

# Create sentinel to mark job completion
with open(snakemake.output.sentinel, "w") as f:
    f.write("done\n")