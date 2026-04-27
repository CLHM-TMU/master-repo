ALDEX2_R_CONDA_ENV = WORKFLOW_DIR / "envs/aldex2-r-env.yaml"

# ------------------------------
# Rules
# ------------------------------
rule aldex2_run:
    input:
        feature_table = DA_FEATURE_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        aldex2_rds   = TMP_DIR / "{db}/ALDEX2_results_by_{group_col}.rds",
        aldex2_table = TMP_DIR / "{db}/ALDEX2_results_by_{group_col}.tsv"
    params:
        group_col     = "{group_col}",
        p_adj_method  = aldex2_p_adj_method,
        pvalue_cutoff = aldex2_pvalue_cutoff,
        mc_samples    = aldex2_mc_samples,
        denom         = aldex2_denom,
        paired_test   = aldex2_paired_test
    conda:
        ALDEX2_R_CONDA_ENV
    script:
        f"{SCRIPTS_DIR}/run_aldex2.R"

rule aldex2_plot:
    input:
        aldex2_rds = TMP_DIR / "{db}/ALDEX2_results_by_{group_col}.rds",
        metadata   = STUDY_DIR / "metadata.tsv"
    output:
        heatmap_png   = DIFFERENTIAL_ABUNDANCE_DIR / "{db}/ALDEX2_{group_col}_heatmap.png",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}/ALDEX2_{group_col}_cladogram.svg"
    params:
        group_col     = "{group_col}",
        heatmap_top_n = aldex2_heatmap_top_n
    conda:
        ALDEX2_R_CONDA_ENV
    script:
        f"{SCRIPTS_DIR}/plot_aldex2.R"
