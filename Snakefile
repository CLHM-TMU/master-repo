import os
import sys
import glob
import warnings
from pathlib import Path
import pandas as pd
from snakemake.io import directory

def log(msg):
    print(msg, file=sys.stderr, flush=True)

# Set to osx-64 for rosetta simulation on M1/M2 macs
os.environ["CONDA_SUBDIR"] = "osx-64"
# Disable CUDA, GPU acceleration causes problems with macOS
os.environ["CUDA_VISIBLE_DEVICES"] = ""
# Suppress gRPC C-level verbosity (controls gRPC's own log system)
os.environ["GRPC_VERBOSITY"] = "NONE"
# Suppress abseil (absl) logs — this covers the E0000 instrument.cc duplicate-metric
# registration messages that GRPC_VERBOSITY alone does not silence
os.environ["GLOG_minloglevel"] = "3"
# Suppress emperor's pkg_resources deprecation warning (emperor 1.0.4 uses the
# deprecated pkg_resources API; setuptools 67.5+ warns regardless of version pin)
warnings.filterwarnings("ignore", "pkg_resources is deprecated", UserWarning)
shell.prefix('export PATH="$CONDA_PREFIX/bin:$PATH"; ')


###############################
# ==============================
# Load config parameters
# ==============================

# --- Sequence type and region validation ---
sequence_type = config.get('SEQUENCE_TYPE')
if sequence_type not in ["NGS", "TGS"]:
    raise ValueError("SEQUENCE_TYPE must be 'NGS' or 'TGS'.")

region = config.get("REGION")
if region not in ['region_V3V4', 'full_length']:
    raise ValueError(f"{region} not supported. Please choose a valid region.")

study_name = config["STUDY_NAME"]

# --- Analysis mode ---
ANALYSIS_MODE = config.get("ANALYSIS_MODE", "standard")
if ANALYSIS_MODE not in ["lite", "standard"]:
    raise ValueError(f"Unknown ANALYSIS_MODE: {ANALYSIS_MODE}")

# ==============================
# Experimental design validation
# ==============================
def validate_standard_design(config):
    log("[VALIDATION] Checking experimental design (standard mode)...")
    design = config.get("DESIGN", {})

    factors_raw = design.get("FACTORS") or []
    factors = [f["column"] for f in factors_raw]
    
    covariates_raw = design.get("COVARIATES") or []
    covariates = [c["column"] for c in covariates_raw]
    
    interactions = design.get("INTERACTIONS") or []
    
    composites_raw = design.get("COMPOSITE_LABELS") or []
    composites = [c["column"] for c in composites_raw]

    # Basic sanity checks
    if not factors:
        raise ValueError("Standard mode requires at least one DESIGN.FACTOR.")

    # Check uniqueness across all columns
    all_columns = factors + covariates + composites
    if len(all_columns) != len(set(all_columns)):
        raise ValueError("Duplicate column names detected across FACTORS, COVARIATES, or COMPOSITE_LABELS.")

    # Validate interactions
    validated_interactions = []
    for interaction in interactions:
        if not isinstance(interaction, list) or len(interaction) < 2:
            raise ValueError(f"Invalid interaction {interaction}. Must be a list of ≥2 FACTORS.")
        for term in interaction:
            if term not in factors:
                raise ValueError(f"Interaction term '{term}' is not declared in DESIGN.FACTORS.")
        validated_interactions.append(tuple(sorted(interaction)))

    validated_interactions = sorted(set(validated_interactions))

    # Ensure composites are not used as model factors
    for comp in composites:
        if comp in factors or comp in covariates:
            raise ValueError(f"Composite label '{comp}' must not be used as a FACTOR or COVARIATE.")

    log(f"✓ Factors: {factors}")
    log(f"✓ Covariates: {covariates}")
    log(f"✓ Interactions: {validated_interactions}")
    log(f"✓ Composite labels (visualization only): {composites}")

    return {
        "factors": factors,
        "covariates": covariates,
        "interactions": validated_interactions,
        "composite_labels": composites,
    }
# --- Determine grouping axes based on analysis mode ---
DESIGN_INFO = config.get("DESIGN", {})

if ANALYSIS_MODE == "lite":
    log("[MAIN] Running in lite mode: using composite label only")
    composites = DESIGN_INFO.get("COMPOSITE_LABELS", [])
    if len(composites) != 1:
        raise ValueError("Lite mode requires exactly one COMPOSITE_LABEL.")
    
    GROUPING_AXES = [composites[0]["column"]]

    # Store minimal DESIGN_INFO for downstream use
    DESIGN_INFO = {
        "mode": "lite",
        "grouping_axes": GROUPING_AXES
    }

elif ANALYSIS_MODE == "standard":
    # Validate full design
    validated_info = validate_standard_design(config)
    GROUPING_AXES = validated_info.get("factors", [])

    if not GROUPING_AXES:
        raise ValueError("Standard mode requires at least one factor.")

    # Include grouping axes in DESIGN_INFO for downstream use
    validated_info["mode"] = "standard"
    validated_info["grouping_axes"] = GROUPING_AXES
    DESIGN_INFO = validated_info

else:
    raise ValueError(f"Unknown ANALYSIS_MODE: {ANALYSIS_MODE}")

log(f"[MAIN] Grouping axes for outputs: {GROUPING_AXES}")

# ==============================
# Reference DB validation
# ==============================
allowed_reference_dbs = ["Greengenes2", "SILVA138"]
reference_db = config.get("REFERENCE_DB", [])
for db in reference_db:
    if db not in allowed_reference_dbs:
        raise ValueError(f"Invalid REFERENCE_DB '{db}'. Allowed: {allowed_reference_dbs}")

# ==============================
# PICRUSt2 flag
# ==============================
run_picrust2 = config.get('RUN_PICRUST2', 'true').lower()
if run_picrust2 not in ['true', 'false']:
    raise ValueError("RUN_PICRUST2 must be 'true' or 'false'.")

# ==============================
# Infer differential abundance method
# ==============================
DA_METHODS = []
if ANALYSIS_MODE == "lite":
    DA_METHODS.append("LEfSe")  # exploratory
elif ANALYSIS_MODE == "standard":
    GROUPING_AXES = validated_info.get("factors", [])
    validated_info["mode"] = "standard"
    validated_info["grouping_axes"] = GROUPING_AXES
    DESIGN_INFO = validated_info

    # --- UPDATED DA LOGIC ---
    if DESIGN_INFO.get("factors"):
        DA_METHODS.append("ANCOMBC2")
        DA_METHODS.append("ALDEX2")
        # Automatically add LEfSe for each factor if desired
        DA_METHODS.append("LEfSe_per_factor")
        
    if DESIGN_INFO.get("composite_labels"):
        DA_METHODS.append("LEfSe_per_composite")

log(f"[MAIN] Differential abundance methods to be run: Lefse")

# ==============================
# Other parameters
# ==============================
n_threads = config.get("N_THREADS", 12)

# ==============================
# Advanced parameters 
# ==============================
cutadapt_error_rate          = config.get("CUTADAPT_ERROR_RATE", 0.1)
dada2_trim_left_f            = config.get("DADA2_TRIM_LEFT_F", 0)
dada2_trim_left_r            = config.get("DADA2_TRIM_LEFT_R", 0)
trunc_len_q_threshold        = config.get("TRUNC_LEN_Q_THRESHOLD", 20)
tgs_dada2_trunc_len          = config.get("TGS_DADA2_TRUNC_LEN", 0)
rarefy_depth_percentile      = config.get("RAREFY_DEPTH_PERCENTILE", 0)
top_n_taxa                   = config.get("TOP_N_TAXA", 20)
top_n_picrust                = config.get("TOP_N_PICRUST", 30)
lefse_lda_cutoff             = config.get("LEFSE_LDA_CUTOFF", 3.0)
lefse_kw_cutoff              = config.get("LEFSE_KW_CUTOFF", 0.05)
lefse_wilcoxon_cutoff        = config.get("LEFSE_WILCOXON_CUTOFF", 0.05)
lefse_norm                   = config.get("LEFSE_NORM", "CPM")
lefse_random_seed            = config.get("LEFSE_RANDOM_SEED", 42)
ancombc2_min_sample_presence = config.get("ANCOMBC2_MIN_SAMPLE_PRESENCE", 3)
ancombc2_prv_cut             = config.get("ANCOMBC2_PRV_CUT", 0.28)
ancombc2_lib_cut             = config.get("ANCOMBC2_LIB_CUT", 5000)
ancombc2_p_adj_method        = config.get("ANCOMBC2_P_ADJ_METHOD", "BH")
ancombc2_alpha               = config.get("ANCOMBC2_ALPHA", 0.05)
ancombc2_pseudo_sens         = config.get("ANCOMBC2_PSEUDO_SENS", True)
ancombc2_struc_zero          = config.get("ANCOMBC2_STRUC_ZERO", True)
ancombc2_neg_lb              = config.get("ANCOMBC2_NEG_LB", True)
ancombc2_volcano_sig_threshold = config.get("ANCOMBC2_VOLCANO_SIG_THRESHOLD", 0.05)
ancombc2_heatmap_top_n       = config.get("ANCOMBC2_HEATMAP_TOP_N", 30)
aldex2_p_adj_method          = config.get("ALDEX2_P_ADJ_METHOD", "BH")
aldex2_pvalue_cutoff         = config.get("ALDEX2_PVALUE_CUTOFF", 0.05)
aldex2_mc_samples            = config.get("ALDEX2_MC_SAMPLES", 128)
aldex2_denom                 = config.get("ALDEX2_DENOM", "all")
aldex2_paired_test           = config.get("ALDEX2_PAIRED_TEST", False)
aldex2_heatmap_top_n         = config.get("ALDEX2_HEATMAP_TOP_N", 30)

# ==============================
# Summary
# ==============================
log("="*50)
log("[MAIN] Config loaded successfully")
log(f"[MAIN] sequence_type = '{sequence_type}'")
log(f"[MAIN] reference_db = {reference_db}")
log(f"[MAIN] study_name = '{study_name}'")
log(f"[MAIN] Analysis mode = '{ANALYSIS_MODE}'")
log(f"[MAIN] Using grouping: {DESIGN_INFO.get('grouping_column', DESIGN_INFO.get('factors', []))}")
log(f"[MAIN] About to include: rules/{sequence_type}.smk")
log("="*50)

# Global directories
SNAKEFILE_DIR = Path.cwd()  # current working directory
REPO_ROOT = SNAKEFILE_DIR
WORKFLOW_DIR = SNAKEFILE_DIR
MAIN_DIR = REPO_ROOT / "main"
SCRIPTS_DIR = WORKFLOW_DIR / "scripts"
REF_DIR = REPO_ROOT / "reference"

# Define study-specific directories
STUDY_DIR = MAIN_DIR / study_name
RAW_DIR = STUDY_DIR / "raw_data"
QIIME_DIR = STUDY_DIR / "qiime2_artifacts"
PLOTS_DIR = STUDY_DIR / "plots"
TABLES_DIR = STUDY_DIR / "tables"
TMP_DIR = STUDY_DIR / 'tmp'

# In your main Snakefile, after defining directories:
log(f"[MAIN] SNAKEFILE_DIR = {SNAKEFILE_DIR}")
log(f"[MAIN] REPO_ROOT = {REPO_ROOT}")
log(f"[MAIN] STUDY_DIR = {STUDY_DIR}")

taxa_levels = ["Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"]

# Define metadata
metadata_path = STUDY_DIR / "metadata.tsv"
metadata_tsv = pd.read_csv(metadata_path, sep="\t", index_col=0)
log(f"[MAIN] Expected metadata path = {STUDY_DIR / 'metadata.tsv'}")
log(f"[MAIN] metadata.tsv exists? {os.path.exists(metadata_path)}")
log(f"[MAIN] Reading in .tsv from absolute path: {metadata_path.absolute()}...")



# ==============================
# Colorblind-friendly palette (Okabe-Ito)
# ==============================
OKABE_ITO = [
    "#E69F00", "#56B4E9", "#009E73", "#F0E442",
    "#0072B2", "#D55E00", "#CC79A7", "#000000",
    "#999999", "#332288",
]

# Build group_colors from the 'Group' column in metadata
if "Group" not in metadata_tsv.columns:
    raise ValueError("Expected a 'Group' column in metadata.tsv but none was found.")

_unique_groups = list(metadata_tsv["Group"].dropna().unique())
if len(_unique_groups) > len(OKABE_ITO):
    log(f"[WARNING] 'Group' has {len(_unique_groups)} unique values but only {len(OKABE_ITO)} palette colors — colors will cycle.")

group_colors = {
    grp: OKABE_ITO[i % len(OKABE_ITO)]
    for i, grp in enumerate(_unique_groups)
}

log(f"[MAIN] group_colors = {group_colors}")


# Define second level of directories
TAXA_BARPLOT_DIR = PLOTS_DIR / "taxa_barplots"
DIVERSITY_DIR = PLOTS_DIR / "diversity"
ALPHA_DIR = DIVERSITY_DIR / "alpha_diversity"
BETA_DIR = DIVERSITY_DIR / "beta_diversity"
DIFFERENTIAL_ABUNDANCE_DIR = PLOTS_DIR / "differential_abundance"
CORE_METRICS_DIR = QIIME_DIR / "core-metrics-results"

# Define main conda env
QIIME_CONDA_ENV = WORKFLOW_DIR / "envs/qiime2-2025.10-amplicon-core.yaml"

##############################################
# FINAL TARGETS
##############################################
# Define standard base qiime artifacts
dada2_outputs = [
    str(QIIME_DIR / "table-dada2.qzv"),
    str(QIIME_DIR / "rep-seqs-dada2.qzv"),
    str(QIIME_DIR / "dada2-stats.qzv"),
]

analysis_candidates_outputs = [
    str(QIIME_DIR / "table-analysis.qzv"),
    str(QIIME_DIR / "rep-seqs-analysis.qzv"),
    str(QIIME_DIR / "table-analysis.qzv"),
    str(QIIME_DIR / "rep-seqs-analysis.qzv")
]


taxa_barplot_outputs = [
    str(TAXA_BARPLOT_DIR / f"{db}" / f"taxa_barplot_{taxa_level}_by_{group}_{suffix}.svg")
    for db in reference_db
    for group in GROUPING_AXES
    for taxa_level in taxa_levels
    for suffix in ("samples", "groups")
]


# Alpha diversity outputs using wildcards
alpha_outputs = expand(
    ALPHA_DIR / "{db}_alpha_{group}.svg",
    db=reference_db,
    group=GROUPING_AXES
)

alpha_sentinels = expand(
    DIVERSITY_DIR / ".{db}_alpha_{group}_done",
    db=reference_db,
    group=GROUPING_AXES
)

# ------------------------------
# Build list of differential abundance outputs
# ------------------------------
differential_abundance_outputs = []
for db in reference_db:
    for method in DA_METHODS:
        
        # Check for any variation of LEfSe
        if "LEfSe" in method:
            # Determine which axes to use based on the method name
            if method == "LEfSe_per_factor":
                axes = DESIGN_INFO.get("factors", [])
            elif method == "LEfSe_per_composite":
                # Extract the 'column' string if it's a list of dicts from config
                raw_composites = DESIGN_INFO.get("composite_labels", [])
                axes = [c["column"] if isinstance(c, dict) else c for c in raw_composites]
            else: # fallback for "lite" mode
                axes = DESIGN_INFO.get("grouping_axes", [])

            for group in axes:
                differential_abundance_outputs.extend([
                    str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/LEfSe_LDA_by_{group}.svg"),
                    str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/LEfSe_Cladogram_by_{group}.svg"),
                    str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/old_LEfSe_LDA_by_{group}.svg"),
                    str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/old_LEfSe_Cladogram_by_{group}.svg")
                ])

        # elif method == "ANCOMBC2":
        #     grouping_axes = DESIGN_INFO.get("factors", [])
        #     for group in grouping_axes:
        #         differential_abundance_outputs.append(str(TMP_DIR / f"{db}/ANCOMBC2_results_by_{group}.tsv"))
        #         differential_abundance_outputs.extend([
        #             str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/ANCOMBC2_{group}_volcano.png"),
        #             str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/ANCOMBC2_{group}_heatmap.png"),
        #             str(TMP_DIR / f"{db}/ANCOMBC2_{group}_heatmap_taxa_legend.tsv"),
        #         ])

        # elif method == "ALDEX2":
        #     for group in DESIGN_INFO.get("factors", []):
        #         differential_abundance_outputs.extend([
        #             str(TMP_DIR / f"{db}/ALDEX2_results_by_{group}.rds"),
        #             str(TMP_DIR / f"{db}/ALDEX2_results_by_{group}.tsv"),
        #             str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/ALDEX2_{group}_heatmap.png"),
        #             str(DIFFERENTIAL_ABUNDANCE_DIR / f"{db}/ALDEX2_{group}_cladogram.svg"),
        #         ])


picrust2_outputs = [
    str(STUDY_DIR / "picrust2_described" / "KO_metagenome_unstrat_described.tsv.gz"),
    str(STUDY_DIR / "picrust2_described" / "EC_metagenome_unstrat_described.tsv.gz"),
    str(STUDY_DIR / "picrust2_described" / "pathway_abun_unstrat_described.tsv.gz"),
    str(STUDY_DIR / "plots" / "picrust2_heatmap.pdf")]

# Taxonomy artifacts (per DB)
taxonomy_outputs = expand(
    str(QIIME_DIR / "{db}-taxonomy.qza"),
    db=reference_db
) + expand(
    str(QIIME_DIR / "{db}-taxonomy.qzv"),
    db=reference_db
) + expand(
    str(QIIME_DIR / "{db}-taxa-bar-plots.qzv"),
    db=reference_db
)

# Alpha diversity vectors (computed once, DB-agnostic)
alpha_core_metrics_outputs = expand(
    str(CORE_METRICS_DIR / "{metric}-vector.qza"),
    metric=["shannon", "simpson", "evenness"]
)

# Phylogenetic alpha diversity (per DB)
alpha_phylogenetic_outputs = expand(
    str(CORE_METRICS_DIR / "{db}-faith-pd-vector.qza"),
    db=reference_db
)

# Non-phylogenetic PCoA (computed once, DB-agnostic)
pcoa_outputs = [
    str(CORE_METRICS_DIR / "jaccard-pcoa-results.qza"),
    str(CORE_METRICS_DIR / "bray-curtis-pcoa-results.qza"),
]

# Phylogenetic PCoA (per DB)
pcoa_phylogenetic_outputs = expand(
    str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-pcoa-results.qza"),
    db=reference_db
) + expand(
    str(CORE_METRICS_DIR / "{db}-weighted-unifrac-pcoa-results.qza"),
    db=reference_db
)

# Beta diversity distance matrices (non-phylogenetic, computed once)
beta_distance_outputs = [
    str(CORE_METRICS_DIR / "jaccard-distance-matrix.qza"),
    str(CORE_METRICS_DIR / "bray-curtis-distance-matrix.qza"),
]

# Beta diversity distance matrices (phylogenetic, per DB)
beta_distance_phylogenetic_outputs = expand(
    str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-distance-matrix.qza"),
    db=reference_db
) + expand(
    str(CORE_METRICS_DIR / "{db}-weighted-unifrac-distance-matrix.qza"),
    db=reference_db
)

# Beta diversity plots (per DB and grouping axis)
beta_outputs = expand(
    str(BETA_DIR / "{db}_beta_{group}.svg"),
    db=reference_db,
    group=GROUPING_AXES
)

beta_sentinels = expand(
    str(DIVERSITY_DIR / ".{db}_beta_{group}_done"),
    db=reference_db,
    group=GROUPING_AXES
)

# PERMANOVA (per DB)
permanova_outputs = expand(
    str(TABLES_DIR / "{db}_permanova_permdisp.tsv"),
    db=reference_db
)

# Report PDF: all visualisation plots collected into one document
report_plot_inputs = (
    taxa_barplot_outputs
    + list(alpha_outputs)
    + list(beta_outputs)
    + differential_abundance_outputs
)
if run_picrust2 == 'true':
    report_plot_inputs.append(str(PLOTS_DIR / "picrust2_heatmap.pdf"))

visualisations_pdf_output = str(STUDY_DIR / "visualisations_report.pdf")

print("taxa_barplot_outputs:", taxa_barplot_outputs)
print("dada2_outputs:", dada2_outputs)
print("analysis_candidates_outputs:", analysis_candidates_outputs)
print("taxonomy_outputs:", taxonomy_outputs)
print("alpha_core_metrics_outputs:", alpha_core_metrics_outputs)
print("beta_distance_outputs:", beta_distance_outputs)
print("pcoa_outputs:", pcoa_outputs)
print("alpha_outputs:", alpha_outputs)
print("beta_outputs:", beta_outputs)
print("permanova_outputs:", permanova_outputs)
print("picrust2_outputs:", picrust2_outputs)
print("differential_abundance_outputs:", differential_abundance_outputs)
print("alpha_phylogenetic_outputs:", alpha_phylogenetic_outputs)
print("beta_distance_phylogenetic_outputs:", beta_distance_phylogenetic_outputs)
print("pcoa_phylogenetic_outputs:", pcoa_phylogenetic_outputs)
print("alpha_sentinels:", alpha_sentinels)
print("beta_sentinels:", beta_sentinels)
print("visualisations_pdf_output:", visualisations_pdf_output)

rule all:
    input:
        *dada2_outputs,
        *analysis_candidates_outputs,
        *taxonomy_outputs,
        *taxa_barplot_outputs,
        *alpha_core_metrics_outputs,
        *alpha_phylogenetic_outputs,
        *beta_distance_outputs,
        *beta_distance_phylogenetic_outputs,
        *pcoa_outputs,
        *pcoa_phylogenetic_outputs,
        *alpha_outputs,
        *alpha_sentinels,
        *beta_outputs,
        *beta_sentinels,
        *permanova_outputs,
        *picrust2_outputs,
        *differential_abundance_outputs,
        visualisations_pdf_output,


rule pipeline_complete:
    input:
        *dada2_outputs,
        *analysis_candidates_outputs,
        *taxonomy_outputs,
        *taxa_barplot_outputs,
        *alpha_core_metrics_outputs,
        *alpha_phylogenetic_outputs,
        *beta_distance_outputs,
        *beta_distance_phylogenetic_outputs,
        *pcoa_outputs,
        *pcoa_phylogenetic_outputs,
        *alpha_outputs,
        *alpha_sentinels,
        *beta_outputs,
        *beta_sentinels,
        *permanova_outputs,
        *picrust2_outputs,
        *differential_abundance_outputs,
        visualisations_pdf_output,
    output:
        sentinel = str(STUDY_DIR / ".pipeline_complete")
    message:
        """
        [MAIN] Pipeline complete! All outputs have been generated successfully.
        """
    shell:
        """
        touch {output.sentinel}
        """

###############################################
# STEP 0 - Create directories
###############################################

rule make_dirs:
    output:
        marker = str(STUDY_DIR / ".dirs_created")
    run:
        STUDY_DIR.mkdir(parents=True, exist_ok=True)
        RAW_DIR.mkdir(parents=True, exist_ok=True)
        TMP_DIR.mkdir(parents=True, exist_ok=True)
        QIIME_DIR.mkdir(parents=True, exist_ok=True)
        PLOTS_DIR.mkdir(parents=True, exist_ok=True)
        TABLES_DIR.mkdir(parents=True, exist_ok=True)
        TAXA_BARPLOT_DIR.mkdir(parents=True, exist_ok=True)
        DIVERSITY_DIR.mkdir(parents=True, exist_ok=True)
        ALPHA_DIR.mkdir(parents=True, exist_ok=True)
        BETA_DIR.mkdir(parents=True, exist_ok=True)
        DIFFERENTIAL_ABUNDANCE_DIR.mkdir(parents=True, exist_ok=True)
        CORE_METRICS_DIR.mkdir(parents=True, exist_ok=True)
        #  make dummy file to mark completion
        with open(output.marker, "w") as f:
            f.write("done")

###############################################
# STEP 1 — Build Manifest
###############################################

rule generate_manifest:
    input:
        make_dirs_marker = STUDY_DIR / ".dirs_created"
    output:
        manifest_file = STUDY_DIR / "manifest.tsv"
    params:
        raw_dir = RAW_DIR,
        sequence_type = sequence_type,
        region = region,
        study_dir = STUDY_DIR
    conda:
        QIIME_CONDA_ENV
    script:
        "scripts/build_manifest.py"
        

###############################################
# STEP 2 - Trimming (Cutadapt) and Denoising (DADA2)
###############################################

include: f"rules/{sequence_type}.smk"

###############################################
# STEP 2.5 - Filter feature table to metadata samples
###############################################

rule filter_table_to_metadata:
    input:
        table    = QIIME_DIR / "table-dada2.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        filtered = QIIME_DIR / "table-analysis.qza"
    conda:
        QIIME_CONDA_ENV
    message:
        """[QIIME] Filtering feature table to analysis candidates...
        """
    shell:
        """
        qiime feature-table filter-samples \
            --i-table {input.table} \
            --m-metadata-file {input.metadata} \
            --o-filtered-table {output.filtered}
        """

rule visualise_table_for_analysis:
    input:
        table = QIIME_DIR / "table-analysis.qza"
    output:
        viz = QIIME_DIR / "table-analysis.qzv"
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Visualizing feature table of analysis candidates...
        """
    shell:
        """
        qiime feature-table summarize \
            --i-table {input.table} \
            --o-visualization {output.viz}
        """

rule filter_seqs_to_table:
    input:
        seqs  = QIIME_DIR / "rep-seqs-dada2.qza",
        table = QIIME_DIR / "table-analysis.qza"
    output:
        filtered = QIIME_DIR / "rep-seqs-analysis.qza"
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Filtering representative sequences to analysis candidates...
        """
    shell:
        """
        qiime feature-table filter-seqs \
            --i-data {input.seqs} \
            --i-table {input.table} \
            --o-filtered-data {output.filtered}
        """

rule visualise_seqs_for_analysis:
    input:
        seqs = QIIME_DIR / "rep-seqs-analysis.qza"
    output:
        viz = QIIME_DIR / "rep-seqs-analysis.qzv"
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Visualizing representative sequences of analysis candidates...
        """
    shell:
        """
        qiime feature-table tabulate-seqs \
            --i-data {input.seqs} \
            --o-visualization {output.viz}
        """
###############################################
# STEP 3 - Taxonomy Classification and Phylogeny Construction
###############################################

for db in reference_db:
    include: f"rules/{db}.smk"

##############################################
# STEP 4 - Alpha and Beta Diversity Analyses
##############################################

include: "rules/diversity.smk"

##############################################
# STEP 5 - Differential Abundance Analyses
##############################################

# For V3V4 NGS, DA tools receive the genus-collapsed table so that analysis is
# performed at genus level (the finest reliable taxonomic resolution for this region).
# Diversity analyses and PICRUSt2 are unaffected — they continue to use ASV-level data.
if region == "region_V3V4":
    DA_FEATURE_TABLE = TABLES_DIR / "study-seqs-genus.biom"
    DA_TAXONOMY_SUFFIX = "{db}_genus_taxonomy.tsv"
    DA_QIIME_TABLE = QIIME_DIR / "table-analysis.qza"       # ASV table
    DA_QIIME_TAXA  = QIIME_DIR / "Greengenes2-taxonomy.qza"             # taxonomy (FeatureData[Taxonomy])
else:
    DA_FEATURE_TABLE = TABLES_DIR / "study-seqs.biom"
    DA_TAXONOMY_SUFFIX = "{db}_taxonomy.tsv"
    DA_QIIME_TABLE = QIIME_DIR / "table-analysis.qza"
    DA_QIIME_TAXA  = QIIME_DIR / "Greengenes2-taxonomy.qza"

include: "rules/LEfSe.smk"
include: "rules/ANCOMBC2.smk"
include: "rules/ALDEX2.smk"

# ##############################################
# #STEP 6 - Functional Prediction with PICRUSt2
# ##############################################

include: "rules/PICRUSt2.smk"

##############################################
# STEP 7 - Compile visualisations report PDF
##############################################

rule compile_visualisations_pdf:
    input:
        plots       = report_plot_inputs,
        metadata    = str(STUDY_DIR / "metadata.tsv"),
        permanova   = permanova_outputs,
        rarefy_base = str(TABLES_DIR / "rarefy_depth.csv"),
        rarefy_dbs  = expand(str(TABLES_DIR / "{db}_rarefy_depth.csv"), db=reference_db),
    output:
        pdf = visualisations_pdf_output
    params:
        reference_dbs = reference_db,
        trunc_len_csv = str(TABLES_DIR / "trunc_len.csv") if sequence_type == "NGS" else None,
    conda:
        WORKFLOW_DIR / "envs/report-env.yaml"
    script:
        "scripts/compile_visualisations_pdf.py"
