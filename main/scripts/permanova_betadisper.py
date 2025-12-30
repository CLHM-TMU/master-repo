import qiime2
import pandas as pd
from skbio.stats.distance import permanova, permdisp
from skbio import DistanceMatrix

# ------------------------------
# Inputs (from Snakemake or CLI)
# ------------------------------
distance_qzas = snakemake.input.dist
metadata_fp = snakemake.input.meta
output_fp = snakemake.output[0]

meta = pd.read_table(metadata_fp, index_col=0)
meta.index = meta.index.str.strip()

results = []

# ------------------------------
# Load distance matrices
# ------------------------------
for qza_fp in distance_qzas:
    name = qza_fp.split("/")[-1].replace("_distance_matrix.qza", "")
    artifact = qiime2.Artifact.load(qza_fp)
    dm: DistanceMatrix = artifact.view(DistanceMatrix)

    # Loop over all columns in metadata
    for col in meta.columns:
        # Keep only non-NA values
        meta_sub = meta[[col]].dropna()

        # Get the common samples between distance matrix and metadata
        common = meta_sub.index.intersection(dm.ids)
        if len(common) < 2:
            continue

        meta_sub = meta_sub.loc[common]
        dm_sub = dm.filter(common)

        # Skip if there is only one unique group
        if meta_sub[col].nunique() < 2:
            continue

        # ------------------------------
        # PERMANOVA
        # ------------------------------
        perm = permanova(
            dm_sub,
            meta_sub[col],
            permutations=9999
        )

        results.append({
            "distance": name,
            "comparison": col,
            "scope": "global",
            "pair": None,
            "test": "permanova",
            **perm.to_dict()
        })

        # ------------------------------
        # Betadisper
        # ------------------------------
        disp = permdisp(
            dm_sub,
            meta_sub[col],
            permutations=9999
        )

        results.append({
            "distance": name,
            "comparison": col,
            "scope": "global",
            "pair": None,
            "test": "betadisper",
            **disp.to_dict()
        })

# ------------------------------
# Save results
# ------------------------------
pd.DataFrame(results).to_csv(
    output_fp,
    sep="\t",
    index=False
)
