import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import biom

# ================================
# INPUTS FROM SNAKEMAKE
# ================================
feature_table_biom_dir = snakemake.input.feature_table_biom_dir
taxonomy_tsv = snakemake.input.taxonomy_tsv
db = snakemake.params.db_name
top_n = snakemake.params.top_n_taxa_shown_on_barplot
level = snakemake.wildcards.level
factor = snakemake.wildcards.factor   # factor name or comma-separated list
output_png = snakemake.output[0]
factor_mapping_file = snakemake.params.get("factor_mapping", None)

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
table = biom.load_table(f"{feature_table_biom_dir}/feature-table.biom")
df = table.to_dataframe(dense=True).T   # samples x features

# ================================
# LOAD TAXONOMY
# ================================
taxonomy = pd.read_csv(taxonomy_tsv, sep="\t", index_col=0)

# Ensure taxonomy matches features
taxonomy = taxonomy.loc[df.columns]

# ================================
# SPLIT TAXON STRINGS
# ================================
taxa_levels_ordered = ["Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"]
tax_split = taxonomy["Taxon"].str.split(";", expand=True)

for i, lvl in enumerate(taxa_levels_ordered):
    taxonomy[lvl] = tax_split[i].str.strip() if i in tax_split.columns else ""

level_dict = {lvl: i for i, lvl in enumerate(taxa_levels_ordered)}
level_index = level_dict[level]

# ================================
# RELABEL TAXA AT SELECTED LEVEL
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
# LOAD METADATA, FILTER & ORDER SAMPLES
# ================================
if factor_mapping_file:
    metadata = pd.read_csv(factor_mapping_file, sep="\t", index_col=0)

    # Align samples
    common_samples = df.index.intersection(metadata.index)
    df = df.loc[common_samples]
    metadata = metadata.loc[common_samples]

    # ---- OPTIONAL SAMPLE FILTERING ----
    # (replace condition with your own logic)
    if "include" in metadata.columns:
        samples_to_keep = metadata[metadata["include"] == True].index
        df = df.loc[df.index.intersection(samples_to_keep)]
        metadata = metadata.loc[df.index]

    # ---- ORDER BY FACTOR(S) ----
    if isinstance(factor, str):
        factor_list = [f.strip() for f in factor.split(",")]
    else:
        factor_list = list(factor)

    order_key = (
        metadata[factor_list]
        .astype(str)
        .agg(" | ".join, axis=1)
    )

    df = df.loc[order_key.sort_values().index]
    metadata = metadata.loc[df.index]

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

ax.set_ylabel("Relative abundance")
ax.set_xlabel("Samples")
ax.set_title(f"{db}: Relative abundance at {level} level")

plt.xticks(rotation=90)

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
