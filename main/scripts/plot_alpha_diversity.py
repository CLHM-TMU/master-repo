import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from qiime2 import Artifact

# -----------------------------
# Snakemake parameters
# -----------------------------
shannon_path  = snakemake.input.shannon
evenness_path = snakemake.input.evenness
chao1_path    = snakemake.input.chao1
simpson_path  = snakemake.input.simpson
metadata_path = snakemake.input.metadata
dropped_sampleid = snakemake.input.dropped_sampleid

factors        = snakemake.params.factor   # <-- one factor per rule
db             = snakemake.params.database
output_dir     = snakemake.params.output_dir

output_plot_path = snakemake.output.alpha_plots  # <-- single file per factor
output_sentinel = snakemake.output.sentinel
# -----------------------------
# Load alpha diversity vectors
# -----------------------------
shannon  = Artifact.load(shannon_path).view(pd.Series)
evenness = Artifact.load(evenness_path).view(pd.Series)
chao1    = Artifact.load(chao1_path).view(pd.Series)
simpson  = Artifact.load(simpson_path).view(pd.Series)

# -----------------------------
# Load metadata
# -----------------------------
metadata = pd.read_csv(metadata_path, sep="\t", index_col=0)

# -----------------------------
# Build combined alpha-diversity df
# -----------------------------
alpha_df = pd.concat([
    shannon.rename("Shannon"),
    evenness.rename("Evenness"),
    chao1.rename("Chao1"),
    simpson.rename("Simpson")
], axis=1)

merged = alpha_df.join(metadata)
# Filter out ignored samples
merged = merged.loc[~merged.index.isin(dropped_sampleid)]


sns.set(style="whitegrid")

# -----------------------------
# Plotting function
# -----------------------------
def plot_one_factor(df, factor_col, outfile):
    melted = df.melt(
        id_vars=[factor_col],
        value_vars=["Shannon", "Evenness", "Chao1", "Simpson"],
        var_name="Metric",
        value_name="Diversity"
    )

    g = sns.catplot(
        data=melted,
        x=factor_col, y="Diversity",
        col="Metric",
        kind="box",
        col_wrap=2,
        sharey=False,
        height=4, aspect=1.2
    )

    g.map_dataframe(
        sns.stripplot,
        x=factor_col, y="Diversity",
        color="black", alpha=0.5
    )

    g.figure.suptitle(f"Alpha Diversity by {factor_col}", fontsize=16)
    plt.subplots_adjust(top=0.88)

    g.savefig(outfile, dpi=300, bbox_inches="tight")
    plt.close(g.fig)

# -----------------------------
# Loop through all factors
# -----------------------------
for factor in factors:
    outfile = os.path.join(output_dir, f"{db}_alpha_{factor}.png")
    plot_one_factor(merged, factor, outfile)

with open(output_sentinel, "w") as f:
    f.write("done\n")