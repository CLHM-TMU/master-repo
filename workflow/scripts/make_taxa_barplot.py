import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import biom

# ================================
# INPUTS FROM SNAKEMAKE
# ================================
table_biom = snakemake.input.table_biom
taxonomy_tsv = snakemake.input.taxonomy_tsv
metadata_tsv = snakemake.params.metadata_tsv   
db = snakemake.params.database
top_n = snakemake.params.top_n_taxa_shown_on_barplot
level = snakemake.params.taxa_level
factor = snakemake.params.group_by           
output_png = snakemake.output[0]
dropped_samples = set(
    map(str, snakemake.params.get("dropped_sampleid", []))
)

# ================================
# HELPER FUNCTIONS
# ================================
def relabel_unassigned_taxa(row, current_level_index):
    tax_split = row["Taxon"].split(";")
    label = tax_split[current_level_index].strip() if current_level_index < len(tax_split) else ""
    if not label or "unassigned" in label.lower():
        for higher_tax in reversed(tax_split[:current_level_index]):
            higher_tax = higher_tax.strip()
            if higher_tax and "unassigned" not in higher_tax.lower():
                return f"Unassigned ({higher_tax})"
        return "Unassigned (All)"
    return label


def is_assigned(val):
    if val is None or pd.isna(val):
        return False
    val = str(val).strip()
    return val != "" and not val.lower().startswith("unassigned")


# ================================
# LOAD FEATURE TABLE
# ================================
table = biom.load_table(table_biom)
df = table.to_dataframe(dense=True).T  # samples x features

df.index = df.index.astype(str).str.strip()

# ================================
# LOAD TAXONOMY
# ================================
taxonomy = pd.read_csv(taxonomy_tsv, sep="\t", index_col=0)
taxonomy = taxonomy.loc[df.columns]

# ================================
# SPLIT TAXON STRINGS
# ================================
taxa_levels_ordered = ["Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"]
tax_split = taxonomy["Taxon"].str.split(";", expand=True)

for i, lvl in enumerate(taxa_levels_ordered):
    taxonomy[lvl] = tax_split[i].str.strip() if i in tax_split.columns else ""

level_index = taxa_levels_ordered.index(level)

# ================================
# RELABEL TAXA
# ================================
if level != "Kingdom":
    taxonomy[level] = taxonomy.apply(
        relabel_unassigned_taxa,
        axis=1,
        current_level_index=level_index,
    )
else:
    taxonomy[level] = (
        taxonomy["Taxon"]
        .str.split(";")
        .str[level_index]
        .str.strip()
        .fillna("Unassigned (All)")
    )

if level == "Genus":
    taxonomy[level] = taxonomy.apply(
        lambda r: f"{r['Family']}|{r[level]}"
        if is_assigned(r.get("Family")) and is_assigned(r.get(level))
        else r[level],
        axis=1,
    )

if level == "Species":
    taxonomy[level] = taxonomy.apply(
        lambda r: f"{r['Genus']}|{r[level]}"
        if is_assigned(r.get("Genus")) and is_assigned(r.get(level))
        else r[level],
        axis=1,
    )

# ================================
# LOAD METADATA
# ================================
metadata = pd.read_csv(metadata_tsv, sep="\t", index_col=0)
metadata.index = metadata.index.astype(str).str.strip()

# ================================
# ALIGN SAMPLES
# ================================
common_samples = df.index.intersection(metadata.index)
df = df.loc[common_samples]
metadata = metadata.loc[common_samples]

# ================================
# DROP SAMPLES
# ================================
if dropped_samples:
    df = df.loc[~df.index.isin(dropped_samples)]
    metadata = metadata.loc[df.index]

# ================================
# ORDER SAMPLES BY FACTOR(S)
# ================================
factor_list = [f.strip() for f in factor.split(",")]

df = df.loc[
    metadata.sort_values(
        by=factor_list,
        kind="stable"   
    ).index
]

# ================================
# AGGREGATE FEATURES BY TAXON
# ================================
df_tax = df.T.groupby(taxonomy[level]).sum().T
df_tax_norm = df_tax.div(df_tax.sum(axis=1), axis=0)

# ================================
# SELECT TOP N TAXA
# ================================
mean_abundance = df_tax_norm.mean(axis=0)
top_taxa = mean_abundance.sort_values(ascending=False).head(top_n).index

df_top = df_tax_norm[top_taxa].copy()
df_top["Other"] = df_tax_norm.drop(columns=top_taxa).sum(axis=1)

# ================================
# PLOT 
# ================================
fig, ax = plt.subplots(figsize=(12, 6))

bottom = np.zeros(df_top.shape[0])
cmap = plt.colormaps["tab20"]
colors = [cmap(i / max(df_top.shape[1] - 1, 1)) for i in range(df_top.shape[1])]

# Plot stacked bars
for i, col in enumerate(df_top.columns):
    ax.bar(
        df_top.index,
        df_top[col],
        bottom=bottom,
        color=colors[i],
        label=col,
        width=0.8,
        linewidth=0,
    )
    bottom += df_top[col].values

# Get group info
group_values = metadata[factor_list[0]]  # assumes first factor for grouping
group_ordered = group_values.loc[df_top.index]
unique_groups = group_ordered.unique()

# Add small padding above top bar
y_max = bottom.max()
ax.set_ylim(0, y_max * 1.08)  # 8% padding on top

# Draw vertical lines and annotate group names on top
for group in unique_groups:
    idxs = np.where(group_ordered == group)[0]
    first, last = idxs[0], idxs[-1]
    # Vertical separator line
    if first > 0:
        ax.axvline(first - 0.5, color="gray", linestyle="--", linewidth=0.7, alpha=0.5)
    # Group label above bars
    center = (first + last) / 2
    ax.text(
        center,
        y_max * 1.01,  # slightly above top of bars
        str(group),
        ha="center",
        va="bottom",
        fontsize=10,
        fontweight="bold",
        rotation=0,
        clip_on=False  # ensures label is not clipped by axes
    )

# Labels, title
ax.set_ylabel("Relative abundance")
ax.set_xlabel("Samples")
ax.set_title(f"{db}: Relative abundance at {level} level")

plt.xticks(rotation=90, ticks=np.arange(len(df_top.index)), labels=df_top.index)
handles, labels = ax.get_legend_handles_labels()
ax.legend(
    handles[::-1],
    labels[::-1],
    bbox_to_anchor=(1.05, 1),
    loc="upper left",
    fontsize=8,
    frameon=False,
)

plt.tight_layout()
plt.savefig(output_png, dpi=300, bbox_inches="tight")
plt.close()