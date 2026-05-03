# rule ancombc2_run:
#     input:
#         feature_table = DA_FEATURE_TABLE,
#         metadata = STUDY_DIR / "metadata.tsv",
#         taxonomy = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
#     output:
#         output_file = TMP_DIR / "{db}/ANCOMBC2_results_by_{group_col}.tsv"
#     conda:
#         QIIME_CONDA_ENV
#     params:
#         group_col            = "{group_col}",
#         covariates           = lambda wildcards: DESIGN_INFO.get("covariates", []),
#         interactions         = lambda wildcards: DESIGN_INFO.get("interactions", []),
#         min_sample_presence  = ancombc2_min_sample_presence,
#         prv_cut              = ancombc2_prv_cut,
#         lib_cut              = ancombc2_lib_cut,
#         p_adj_method         = ancombc2_p_adj_method,
#         alpha                = ancombc2_alpha,
#         pseudo_sens          = ancombc2_pseudo_sens,
#         struc_zero           = ancombc2_struc_zero,
#         neg_lb               = ancombc2_neg_lb
#     script:
#         f"{SCRIPTS_DIR}/run_ancombc2.R"

# rule ancombc2_plot:
#     input:
#         ancombc2_table = TMP_DIR / "{db}/ANCOMBC2_results_by_{group_col}.tsv"
#     output:
#         volcano_plot = DIFFERENTIAL_ABUNDANCE_DIR / "{db}/ANCOMBC2_{group_col}_volcano.png",
#         heatmap_plot = DIFFERENTIAL_ABUNDANCE_DIR / "{db}/ANCOMBC2_{group_col}_heatmap.png",
#         heatmap_legend = TMP_DIR / "{db}/ANCOMBC2_{group_col}_heatmap_taxa_legend.tsv"
#     conda:
#         QIIME_CONDA_ENV
#     params:
#         group_col             = "{group_col}",
#         volcano_sig_threshold = ancombc2_volcano_sig_threshold,
#         heatmap_top_n         = ancombc2_heatmap_top_n
#     script:
#         f"{SCRIPTS_DIR}/plot_ancombc2.R"