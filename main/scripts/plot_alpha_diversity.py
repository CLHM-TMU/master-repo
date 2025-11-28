import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
from qiime2 import Artifact
from skbio.stats.ordination import OrdinationResults


# ---- Get vector paths from snakemake variables ----
shannon_path = snakemake.input.shannon 
evenness_path = snakemake.input.evenness
chao1_path = snakemake.input.chao1
simpson_path = snakemake.input.simpson
metadata_path = snakemake.input.metadata_path
output_plot_path = snakemake.output.alpha_diversity_plot
group_columns = snakemake.params.group_columns
database = snakemake.params.database

# ---- Load vectors ----
shannon = Artifact.load(shannon_path).view(pd.Series)
evenness = Artifact.load(evenness_path).view(pd.Series)
chao1 = Artifact.load(chao1_path).view(pd.Series)
simpson = Artifact.load(simpson_path).view(pd.Series)

# ---- Load metadata ----
metadata = pd.read_csv(metadata_path, sep="\t", index_col=0)

# ---- Combine alpha diversity into one DataFrame ----
alpha_df = pd.concat([
    shannon.rename("Shannon"),
    evenness.rename("Evenness"),
    chao1.rename("Chao1"),
    simpson.rename("Simpson")
], axis=1)

# ---- Merge alpha diversity with metadata ----
merged = alpha_df.join(metadata)
merged['Group'] = merged['Group'].str.strip()

sns.set(style="whitegrid")

# ---- Function to plot alpha diversity ----
def plot_alpha_diversity(df, x_col, levels=None, title=None, outfile=None):
    # Subset if levels provided
    if levels is not None:
        df = df[df[x_col].isin(levels)]
    
    # Melt for seaborn
    melted = df.melt(
        id_vars=[x_col],
        value_vars=["Shannon", "Evenness", "Chao1", "Simpson"],
        var_name="Metric",
        value_name="Diversity"
    )
    
    # Plot
    g = sns.catplot(
        data=melted,
        x=x_col, y="Diversity",
        col="Metric",
        kind="box",
        col_wrap=2,
        sharey=False,
        height=4, aspect=1.2
    )
    g.map_dataframe(sns.stripplot, x=x_col, y="Diversity", color="black", alpha=0.5)
    plt.subplots_adjust(top=0.85)
    
    if title:
        g.figure.suptitle(title)
    if outfile:
        g.savefig(outfile, dpi=300, bbox_inches="tight")
    plt.close(g.fig)

# ---- Loop over comparisons ----
for x_col in group_columns:
    outfile = os.path.join(
        "alpha_diversity_plots",
        f"alpha_diversity_{x_col}.png"
    )
    title = f"Alpha Diversity – grouped by {x_col}"

    plot_alpha_diversity(
        df=merged,
        x_col=x_col,
        levels=None,   # <-- no subsetting, use all levels in that column
        title=title,
        outfile=outfile
    )
