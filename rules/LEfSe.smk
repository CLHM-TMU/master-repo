LEFSE_R_CONDA_ENV = WORKFLOW_DIR / "envs/lefse-r-env.yaml"

# ------------------------------
# Rules
# ------------------------------
rule lefse_run:
    input:
        feature_table = DA_FEATURE_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lefse_rds = TMP_DIR / "{db}/LEfSe_results_by_{group_col}.rds"
    params:
        group_col        = "{group_col}",
        lda_cutoff       = 3,
        kw_cutoff        = lefse_kw_cutoff,
        wilcoxon_cutoff  = lefse_wilcoxon_cutoff,
        norm             = lefse_norm,
        random_seed      = lefse_random_seed
    conda:
        LEFSE_R_CONDA_ENV
    script:
        f"{SCRIPTS_DIR}/run_lefse.R"

rule lefse_plot:
    input:
        lefse_rds = TMP_DIR / "{db}/LEfSe_results_by_{group_col}.rds",
        metadata  = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_Cladogram_by_{group_col}.svg"
    params:
        group_col = "{group_col}",
        colors = group_colors
    conda:
        LEFSE_R_CONDA_ENV
    script:
        f"{SCRIPTS_DIR}/plot_lefse.R"

rule lefse_old_version:
    input:
        feature_table = DA_QIIME_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = DA_QIIME_TAXA
    output:
        lefse_results = TMP_DIR / "{db}/old_LEfSe_results_by_{group_col}.txt",
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "old_LEfSe_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "old_LEfSe_Cladogram_by_{group_col}.svg"
    params:
        group_col       = "{group_col}",
        lda_cutoff      = 3,
        kw_cutoff       = lefse_kw_cutoff,
        wilcoxon_cutoff = lefse_wilcoxon_cutoff,
        colors          = group_colors
    conda:
        LEFSE_R_CONDA_ENV
    script:
        f"{SCRIPTS_DIR}/run_lefse_old_version.py"