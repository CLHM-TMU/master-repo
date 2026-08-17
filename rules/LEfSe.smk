LEFSE_R_CONTAINER = str(WORKFLOW_DIR / "containers/lefse-r-env.sif")
LEFSER_R_CONTAINER = str(WORKFLOW_DIR / "containers/lefser-r-env.sif")

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
        lda_cutoff       = lefse_lda_cutoff,
        kw_cutoff        = lefse_kw_cutoff,
        wilcoxon_cutoff  = lefse_wilcoxon_cutoff,
        norm             = lefse_norm,
        random_seed      = lefse_random_seed
    container:
        LEFSE_R_CONTAINER
    script:
        f"{SCRIPTS_DIR}/run_lefse.R"

rule lefse_plot:
    input:
        lefse_rds = TMP_DIR / "{db}/LEfSe_results_by_{group_col}.rds",
        metadata  = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_Cladogram_by_{group_col}.svg",
        lda_png       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_LDA_by_{group_col}.png",
        cladogram_png = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_Cladogram_by_{group_col}.png"
    params:
        group_col = "{group_col}",
        colors = lambda wc: GROUP_COLORS[wc.group_col]
    container:
        LEFSE_R_CONTAINER
    script:
        f"{SCRIPTS_DIR}/plot_lefse.R"

rule lefser_run:
    wildcard_constraints:
        group_col = "|".join(re.escape(a) for a in GROUPING_AXES)
    input:
        feature_table = DA_FEATURE_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lefser_rds = TMP_DIR / "{db}/lefseR_results_by_{group_col}_{pair_label}.rds"
    params:
        group_col       = "{group_col}",
        class_a         = lambda wc: LEFSER_PAIR_LOOKUP[(wc.group_col, wc.pair_label)][0],
        class_b         = lambda wc: LEFSER_PAIR_LOOKUP[(wc.group_col, wc.pair_label)][1],
        lda_cutoff      = lefse_lda_cutoff,
        kw_cutoff       = lefse_kw_cutoff,
        wilcoxon_cutoff = lefse_wilcoxon_cutoff,
        random_seed     = lefse_random_seed
    container:
        LEFSER_R_CONTAINER
    script:
        f"{SCRIPTS_DIR}/run_lefser.R"

rule lefser_plot:
    wildcard_constraints:
        group_col = "|".join(re.escape(a) for a in GROUPING_AXES)
    input:
        lefser_rds = TMP_DIR / "{db}/lefseR_results_by_{group_col}_{pair_label}.rds"
    output:
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefseR_LDA_by_{group_col}_{pair_label}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefseR_Cladogram_by_{group_col}_{pair_label}.svg",
        lda_png       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefseR_LDA_by_{group_col}_{pair_label}.png",
        cladogram_png = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefseR_Cladogram_by_{group_col}_{pair_label}.png"
    params:
        group_col = "{group_col}",
        colors    = lambda wc: GROUP_COLORS[wc.group_col]
    container:
        LEFSER_R_CONTAINER
    script:
        f"{SCRIPTS_DIR}/plot_lefser.R"

rule lefse_old_version:
    input:
        feature_table = DA_QIIME_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = DA_QIIME_TAXA
    output:
        lefse_results = TMP_DIR / "{db}/old_LEfSe_results_by_{group_col}.txt",
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "old_LEfSe_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "old_LEfSe_Cladogram_by_{group_col}.svg",
        lda_png       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "old_LEfSe_LDA_by_{group_col}.png",
        cladogram_png = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "old_LEfSe_Cladogram_by_{group_col}.png"
    params:
        group_col       = "{group_col}",
        lda_cutoff      = lefse_lda_cutoff,
        kw_cutoff       = lefse_kw_cutoff,
        wilcoxon_cutoff = lefse_wilcoxon_cutoff,
        colors          = lambda wc: GROUP_COLORS[wc.group_col]
    container:
        LEFSE_R_CONTAINER
    script:
        f"{SCRIPTS_DIR}/run_lefse_old_version.py"