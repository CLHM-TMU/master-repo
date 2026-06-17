# 16S rRNA Amplicon Sequencing Pipeline — Overview

This Snakemake pipeline processes 16S rRNA amplicon sequencing data (NGS or TGS) from raw reads through to diversity analyses, differential abundance testing, and functional prediction. Each stage is described below.

> **Plot outputs:** Every plot the pipeline generates is written in **two formats — one `.svg` and one `.png`** (e.g. `*.svg` and `*.png` of the same name). The **only exception is the PICRUSt2 heatmap, which is a single `.pdf`**.

---

## Stage 0 — Setup & Validation

**Rule:** `make_dirs`

Before any analysis begins, the pipeline:

- Validates the configuration (sequence type, targeted region, reference databases, experimental design).
- Creates all required output directories (`raw_data/`, `qiime2_artifacts/`, `plots/`, `tables/`, `tmp/`, and subdirectories for diversity, taxa barplots, and differential abundance).
- Reads the sample metadata (`metadata.tsv`) and determines which grouping axes (experimental factors) will drive downstream comparisons.

---

## Stage 1 — Manifest Building

**Rule:** `generate_manifest` → `scripts/build_manifest.py`

Scans the `raw_data/` directory and builds a QIIME2-compatible manifest TSV file that maps sample IDs to their raw FASTQ file paths. The manifest format differs slightly between NGS (paired-end) and TGS (single-end CCS) input.
Currently we work with Illumina for our NGS data and PacBio for our TGS data.

---

## Stage 2 — Adapter Trimming & Denoising

**Rules:** `NGS.smk` or `TGS.smk` (selected based on `SEQUENCE_TYPE`)

### 2a. Import
Raw reads are imported into QIIME2 as a demultiplexed artifact (`demux.qza`).
- **NGS**: imported as paired-end sequences (`PairedEndSequencesWithQuality`).
- **TGS**: imported as single-end sequences (`SequencesWithQuality`).

### 2b. Primer Trimming (Cutadapt)
- **NGS**: Adapter/primer sequences are removed using `qiime cutadapt trim-paired` with the standard V3V4 primer pair (341F/805R with Nextera adapter overhangs) at up to 10% error rate.
- **TGS**: The cutadapt step is a no-op — it renames `demux.qza` → `trimmed-demux.qza` without invoking cutadapt (CCS reads are already primer-free).

### 2c. Quality Profiling & Truncation Length Selection (NGS only)
- Quality scores are exported from the trimmed demux visualisation.
- `generate_trunc_length.py` automatically determines forward and reverse truncation lengths by finding where median quality drops below Q20 or when more than 10% of reads are being dropped.

### 2d. DADA2 Denoising
Sequences are denoised to produce **Amplicon Sequence Variants (ASVs)**:
- **NGS** (`denoise-paired`): paired-end reads are quality-filtered, denoised, merged, and chimera-filtered. Truncation lengths are applied automatically from Stage 2c.
- **TGS** (`denoise-ccs`): PacBio CCS reads are processed using the full-length denoising workflow with a 5′ primer anchor (`--p-front AGAGTTTGATCMTGGCTCAG`, the universal 27F primer). Truncation length is hard-coded to `0` (no truncation), which is correct for full-length CCS reads.

Outputs:
- `table-dada2.qza` — ASV feature table (samples × ASVs).
- `rep-seqs-dada2.qza` — representative sequences for each ASV.
- `dada2-stats.qza/.qzv` — per-sample denoising statistics.
- `base-transition-stats-dada2.qza` — base substitution/transition statistics from DADA2 (both NGS and TGS).

### 2e. Sample Filtering
After denoising, the feature table and representative sequences are automatically filtered to retain only samples that are present in `metadata.tsv`. This is the point at which you can edit `metadata.tsv` to exclude specific samples from all downstream analyses (e.g. failed libraries or QC outliers) — samples absent from the metadata are silently dropped. The result is:
- `table-analysis.qza` — filtered ASV feature table.
- `rep-seqs-analysis.qza` — filtered representative sequences.

### 2f. Rarefaction Depth Determination (Base)
The filtered feature table (`table-analysis.qza`) is exported and a base rarefaction depth is computed from per-sample read counts (`rarefy_depth.csv`). A configurable percentile (`RAREFY_DEPTH_PERCENTILE`) controls the selection: `0` selects the **minimum** read count across all samples; any other value (e.g. `10`) selects the corresponding percentile, which can preserve more samples when one sample has an unusually low count.

---

## Stage 3 — Taxonomy Classification & Phylogeny

**Rules:** `Greengenes2.smk` and/or `Silva138.smk` (one or both, based on `REFERENCE_DB`)

### 3a. Taxonomic Classification
Representative sequences are classified against a pre-trained Naive Bayes classifier for the chosen reference database and amplicon region:

| Database | V3V4 classifier | Full-length classifier |
|---|---|---|
| Greengenes2 | `Greengenes2/2024.09.custom.V3V4.nb.qza` | `Greengenes2/2024.09.backbone.full-length.nb.qza` |
| SILVA 138 | `Silva138/2024.09.custom.V3V4.nb.qza` | `Silva138/2024.09.backbone.full-length.nb.qza` |

Classifier files live in `REF_DIR/{database}/`. This produces a taxonomy artifact (`.qza`) and a tabular visualisation (`.qzv`).

### 3b. Genus-Level Collapse (V3V4 NGS only)
For V3V4 NGS data, the feature table is additionally collapsed to genus level (rank 6) using `qiime taxa collapse`. This produces `{db}-genus-table-collapsed.qza` and a corresponding exported `.biom` file (`study-seqs-genus.biom`). Differential abundance analyses in Stage 5 receive this genus-collapsed table rather than the ASV-level table, as genus is the finest reliable taxonomic resolution for the V3V4 region. Full-length TGS data operates at ASV level throughout.

### 3c. Phylogeny — Backbone Mapping
ASVs are mapped onto the full-length backbone sequence database using `qiime greengenes2 non-v4-16s` (or the equivalent for SILVA138). This produces:
- A **phylogeny-aware feature table** (`{db}-table.qza`) — ASVs remapped to backbone representatives.
- **Phylogeny-aware representative sequences** (`{db}-rep-seqs.qza`).

These are the inputs for phylogenetic diversity analyses. The actual **phylogenetic tree** used for UniFrac metrics (weighted and unweighted) is a **pre-built backbone `.nwk.qza`** that must already exist in `REF_DIR/{db}/`. The pipeline does not construct this tree itself.

### 3d. Taxa Barplot Visualisations
- **QIIME interactive barplot** (`.qzv`) — generated natively in QIIME2 from the filtered ASV table.
- **Custom static barplots** (`.svg` + `.png`) — generated per taxonomic level (Kingdom → Species) and per grouping axis using `make_taxa_barplot.py`, showing the top 20 taxa per group.

For every taxonomic level × grouping axis combination, **two versions are always produced**, distinguished by the `_samples` vs `_groups` suffix — for example:

- `taxa_barplot_Class_by_Group_samples.png` — **per-sample** view: each sample gets its own bin (bar).
- `taxa_barplot_Class_by_Group_groups.png` — **per-group** view: each group is collapsed into a single bin based on pooled abundance across its samples.

(Each version is written as both `.svg` and `.png`, following the pipeline-wide plot output convention.)

### 3e. Artifact Export
The feature table (`.biom`), representative sequences (`.fna`), and taxonomy assignments (`.tsv`) are exported from QIIME2 for use in downstream non-QIIME tools (differential abundance, PICRUSt2).

---

## Stage 4 — Diversity Analyses

**Rules:** `NGS.smk` / `TGS.smk` (rarefaction), `diversity.smk`

### 4a. Two-Stage Rarefaction

The pipeline performs **two independent rarefaction steps**, each targeting a different feature table:

**Base rarefaction** (ASV-level, non-phylogenetic):
The filtered ASV table (`table-analysis.qza`) is rarefied to the depth computed in Stage 2f (`rarefy_depth.csv`), producing `table-analysis-rarefied.qza`. This rarefied table is used for all non-phylogenetic diversity metrics (Shannon, Simpson, Pielou's evenness, Jaccard, Bray-Curtis).

**Per-DB rarefaction** (backbone-mapped, phylogenetic):
Each reference database's backbone-mapped table (`{db}-table.qza`) is rarefied independently. A separate rarefaction depth is calculated per database by reading the backbone table's per-sample counts and applying the same percentile logic (`{db}_rarefy_depth.csv`). This produces `{db}-table-rarefied.qza` and is used for all phylogenetic diversity metrics (Faith's PD, weighted and unweighted UniFrac). The two depths may differ because backbone mapping can change per-sample read counts.

### 4b. Alpha Diversity
Four within-sample diversity metrics are calculated for each reference database:

| Metric | What it measures | Phylogenetic? |
|---|---|---|
| Shannon index | Species richness and evenness | No |
| Simpson index | Dominance / evenness | No |
| Pielou's evenness | How evenly abundances are distributed | No |
| Chao1 | Estimated richness, weighting rare taxa | No |
| Faith's PD | Phylogenetic diversity (branch length sum) | Yes (per DB) |

Results are plotted as grouped box/violin plots per grouping axis (`plot_alpha_diversity.py`), each written as both `.svg` and `.png`.

### 4c. Beta Diversity
Four between-sample dissimilarity matrices are computed:

| Metric | Phylogenetic? | What it captures | Input table |
|---|---|---|---|
| Jaccard | No | Presence/absence overlap | Base rarefied |
| Bray-Curtis | No | Abundance-weighted overlap | Base rarefied |
| Unweighted UniFrac | Yes | Presence/absence + phylogenetic distance | Per-DB rarefied |
| Weighted UniFrac | Yes | Abundance-weighted phylogenetic distance | Per-DB rarefied |

PCoA ordinations are computed for all four matrices and plotted as 2D scatter plots coloured by grouping axis (`plot_beta_diversity.py`), each written as both `.svg` and `.png`.

### 4d. Statistical Testing (PERMANOVA / BetaDisper)
For all four distance matrices and all grouping axes, the pipeline runs:
- **PERMANOVA** — tests whether group centroids differ significantly.
- **BetaDisper** — tests whether group dispersions (spread) are homogeneous (a prerequisite for interpreting PERMANOVA).

Results are saved to `{db}_permanova_betadisper.tsv`.

---

## Stage 5 — Differential Abundance Analysis

**Rules:** `LEfSe.smk`, `ANCOMBC2.smk` (maintenance), `ALDEX2.smk` (maintenance)

### LEfSe (Linear Discriminant Analysis Effect Size)
The only currently active differential abundance method. Uses the exported `.biom` feature table and taxonomy TSV as input. For V3V4 NGS data the genus-collapsed table is used; for full-length TGS data the ASV-level table is used.

LEfSe is run with **two implementations**: the original **Python-style Huttenhower LEfSe** and an **R reimplementation through the `microbiomeMarker` package**.

For each grouping axis (FACTORS, and composite labels if defined):
- **`run_lefse.R`** — runs LEfSe to identify taxa that are significantly enriched in one or more groups, ranked by LDA score.
- **`plot_lefse.R`** — generates (each as both `.svg` and `.png`):
  - **LDA bar chart** — ranked differentially abundant taxa with LDA scores.
  - **`LEfSe_Cladogram_by_{group}`** — attempts `plot_cladogram()` from `microbiomeMarker`; if that call fails (e.g. due to missing tree data), the script falls back silently and writes a duplicate of the LDA bar chart to this file instead. In practice this output is not currently a true cladogram.

### ANCOMBC2 — under maintenance, currently unavailable
Output targets are commented out in the Snakefile; it does not run.

### ALDEx2 — under maintenance, currently unavailable
Output targets are commented out in the Snakefile; it does not run.

---

## Stage 6 — Functional Prediction with PICRUSt2

**Rules:** `PICRUSt2.smk`

PICRUSt2 runs as a standard part of every pipeline run.

PICRUSt2 predicts the functional potential of the microbial community from 16S marker gene data alone, without requiring shotgun metagenomics.

### 6a. PICRUSt2 Pipeline
Using the exported `.fna` representative sequences and `.biom` feature table, the full PICRUSt2 pipeline is run to predict:
- **KEGG Orthology (KO)** metagenome abundances.
- **Enzyme Commission (EC)** number abundances.
- **MetaCyc pathway** abundances.

### 6b. Add Descriptions
`add_descriptions.py` annotates each KO, EC, and pathway ID with a human-readable description.

### 6c. Visualisation
`plot_picrust2.R` generates a summary heatmap of predicted pathway abundances grouped by sample metadata. This heatmap is the one plot in the pipeline written as a `.pdf` rather than as `.svg` + `.png`.

---

## Stage 7 — Visualisations Report

**Rule:** `compile_visualisations_pdf`

After all plots are generated, the pipeline compiles every visualisation into a single PDF report (`visualisations_report.pdf`) in the study directory. The report includes taxa barplots, alpha/beta diversity plots, LEfSe outputs, and the PICRUSt2 heatmap. PERMANOVA/BetaDisper results and rarefaction depth information are embedded as summary tables.

---

## Output Summary

| Stage | Key outputs |
|---|---|
| 0 — Setup | Directory structure, validated config |
| 1 — Manifest | `manifest.tsv` |
| 2 — Denoising | `table-dada2.qza`, `rep-seqs-dada2.qza`, `dada2-stats.qzv`, `table-analysis.qza`, `rep-seqs-analysis.qza` |
| 3 — Taxonomy | `{db}-taxonomy.qza`, `{db}-taxa-bar-plots.qzv`, `taxa_barplot_*_{samples,groups}.{svg,png}` |
| 4 — Diversity | Alpha/beta plots (`.svg` + `.png`), `{db}_permanova_betadisper.tsv`; two rarefied tables: `table-analysis-rarefied.qza` (base) and `{db}-table-rarefied.qza` (per-DB) |
| 5 — Diff. Abundance | LEfSe LDA + cladogram plots (`.svg` + `.png`; cladogram falls back to LDA if it fails); ANCOMBC2 and ALDEx2 unavailable (under maintenance) |
| 6 — Function | PICRUSt2 KO/EC/pathway TSVs, `picrust2_heatmap.pdf` |
| 7 — Report | `visualisations_report.pdf` |

> **Note on plot formats:** all plots are emitted as paired `.svg` + `.png` files; the PICRUSt2 heatmap (`.pdf`) is the sole exception.