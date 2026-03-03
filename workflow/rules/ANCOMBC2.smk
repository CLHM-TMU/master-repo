rule ancombc2:
    input:
        feature_table = TABLES_DIR / "study-seqs.biom",
        metadata = STUDY_DIR / "metadata.tsv",
        taxonomy = TABLES_DIR / "exported-taxonomy" / "{db}_taxonomy.tsv"
    output:
        output_file = DIFFERENTIAL_ABUNDANCE_DIR / "{db}/ANCOMBC2_results_by_{group_col}.tsv"
    conda:
        QIIME_CONDA_ENV
    params:
        group_col = "{group_col}",
        interactions = lambda wildcards: DESIGN_INFO.get("interactions", [])
    script:
        f"{SCRIPTS_DIR}/run_ancombc2.R"
