import qiime2
import pandas as pd
from itertools import combinations
from skbio.stats.distance import permanova, permdisp
from skbio import DistanceMatrix
import numpy as np
import multiprocessing as mp
from functools import partial

# ------------------------------
# Inputs (from Snakemake or CLI)
# ------------------------------
distance_qzas = snakemake.input.dist
metadata_fp = snakemake.input.meta
output_fp = snakemake.output[0]
n_workers = snakemake.threads  # or hardcode: n_workers = mp.cpu_count()

meta = pd.read_table(metadata_fp, index_col=0)
meta.index = meta.index.astype(str).str.strip()


# ------------------------------
# Worker: one (distance_name, col) pair
# ------------------------------
def process_column(args):
    name, dm, meta, col = args
    results = []

    meta_sub = meta[[col]].dropna()
    common = meta_sub.index.intersection(dm.ids)
    if len(common) < 2:
        return results

    meta_sub = meta_sub.loc[common]
    dm_sub = dm.filter(common)

    n_groups = meta_sub[col].nunique()
    if n_groups < 2 or n_groups >= len(meta_sub):
        return results

    # Omnibus PERMANOVA + betadisper
    perm = permanova(dm_sub, meta_sub[col], permutations=9999)
    results.append({
        "distance": name, "comparison": col,
        "scope": "global", "pair": None, "test": "permanova",
        **perm.to_dict()
    })

    disp = permdisp(dm_sub, meta_sub[col], permutations=9999)
    results.append({
        "distance": name, "comparison": col,
        "scope": "global", "pair": None, "test": "betadisper",
        **disp.to_dict()
    })

    # Pairwise PERMANOVA + betadisper
    groups = sorted(meta_sub[col].unique())
    for g1, g2 in combinations(groups, 2):
        meta_pair = meta_sub[meta_sub[col].isin([g1, g2])]
        dm_pair = dm_sub.filter(meta_pair.index)

        if (meta_pair[col].value_counts() < 2).any():
            continue

        pair_label = f"{g1} vs {g2}"

        perm_pair = permanova(dm_pair, meta_pair[col], permutations=9999)
        results.append({
            "distance": name, "comparison": col,
            "scope": "pairwise", "pair": pair_label, "test": "permanova",
            **perm_pair.to_dict()
        })

        disp_pair = permdisp(dm_pair, meta_pair[col], permutations=9999)
        results.append({
            "distance": name, "comparison": col,
            "scope": "pairwise", "pair": pair_label, "test": "betadisper",
            **disp_pair.to_dict()
        })

    return results


# ------------------------------
# Build task list (name, dm, meta, col)
# QZAs are loaded in the main process to avoid repeated I/O in workers
# ------------------------------
tasks = []
for qza_fp in distance_qzas:
    name = qza_fp.split("/")[-1].replace("_distance_matrix.qza", "")
    artifact = qiime2.Artifact.load(qza_fp)
    dm: DistanceMatrix = artifact.view(DistanceMatrix)
    for col in meta.columns:
        if col == "Order":
            continue
        tasks.append((name, dm, meta, col))


# ------------------------------
# Run in parallel
# ------------------------------
with mp.Pool(processes=n_workers) as pool:
    nested = pool.map(process_column, tasks)

results = [row for sublist in nested for row in sublist]


# ------------------------------
# BH correction (unchanged)
# ------------------------------
def bh_adjust(p_values):
    n = len(p_values)
    order = np.argsort(p_values)
    adjusted = p_values[order] * n / (np.arange(n) + 1)
    np.minimum.accumulate(adjusted[::-1], out=adjusted[::-1])
    result = np.empty(n)
    result[order] = np.minimum(adjusted, 1.0)
    return result


df = pd.DataFrame(results)
df["p_adjusted"] = float("nan")

pairwise = df["scope"] == "pairwise"
for _, grp in df[pairwise].groupby(["distance", "comparison", "test"]):
    p_vals = grp["p-value"].values
    valid = pd.notna(p_vals)
    if valid.sum() < 2:
        df.loc[grp.index[valid], "p_adjusted"] = p_vals[valid]
    else:
        df.loc[grp.index[valid], "p_adjusted"] = bh_adjust(p_vals[valid].astype(float))

df.to_csv(output_fp, sep="\t", index=False)