LEFSE_MICROBIOMEMARKER_R_CONTAINER = str(WORKFLOW_DIR / "containers/lefse_MicrobiomeMarker-r-env.sif")
LEFSE_WALDRON_R_CONTAINER = str(WORKFLOW_DIR / "containers/lefse_Waldron-r-env.sif")

# ------------------------------
# Rules
# ------------------------------
rule lefse_MicrobiomeMarker_run:
    input:
        feature_table = DA_FEATURE_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lefse_MicrobiomeMarker_rds = TMP_DIR / "{db}/lefse_MicrobiomeMarker_results_by_{group_col}.rds"
    params:
        group_col        = "{group_col}",
        lda_cutoff       = lefse_lda_cutoff,
        kw_cutoff        = lefse_kw_cutoff,
        wilcoxon_cutoff  = lefse_wilcoxon_cutoff,
        norm             = lefse_norm,
        random_seed      = lefse_random_seed
    container:
        LEFSE_MICROBIOMEMARKER_R_CONTAINER
    resources:
        mem_mb = 4000
    script:
        f"{SCRIPTS_DIR}/run_lefse_MicrobiomeMarker.R"

rule lefse_MicrobiomeMarker_plot:
    input:
        lefse_MicrobiomeMarker_rds = TMP_DIR / "{db}/lefse_MicrobiomeMarker_results_by_{group_col}.rds",
        metadata  = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_MicrobiomeMarker_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_MicrobiomeMarker_Cladogram_by_{group_col}.svg",
        lda_png       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_MicrobiomeMarker_LDA_by_{group_col}.png",
        cladogram_png = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_MicrobiomeMarker_Cladogram_by_{group_col}.png"
    params:
        group_col = "{group_col}",
        colors = lambda wc: GROUP_COLORS[wc.group_col]
    container:
        LEFSE_MICROBIOMEMARKER_R_CONTAINER
    resources:
        mem_mb = 4000
    script:
        f"{SCRIPTS_DIR}/plot_lefse_MicrobiomeMarker.R"

rule lefse_Waldron_run:
    wildcard_constraints:
        group_col = "|".join(re.escape(a) for a in GROUPING_AXES)
    input:
        feature_table = DA_FEATURE_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = TABLES_DIR / "exported-taxonomy" / DA_TAXONOMY_SUFFIX
    output:
        lefse_Waldron_rds = TMP_DIR / "{db}/lefse_Waldron_results_by_{group_col}_{pair_label}.rds"
    params:
        group_col       = "{group_col}",
        class_a         = lambda wc: LEFSE_WALDRON_PAIR_LOOKUP[(wc.group_col, wc.pair_label)][0],
        class_b         = lambda wc: LEFSE_WALDRON_PAIR_LOOKUP[(wc.group_col, wc.pair_label)][1],
        lda_cutoff      = lefse_lda_cutoff,
        kw_cutoff       = lefse_kw_cutoff,
        wilcoxon_cutoff = lefse_wilcoxon_cutoff,
        random_seed     = lefse_random_seed
    container:
        LEFSE_WALDRON_R_CONTAINER
    resources:
        mem_mb = 4000
    script:
        f"{SCRIPTS_DIR}/run_lefse_Waldron.R"

rule lefse_Waldron_plot:
    wildcard_constraints:
        group_col = "|".join(re.escape(a) for a in GROUPING_AXES)
    input:
        lefse_Waldron_rds = TMP_DIR / "{db}/lefse_Waldron_results_by_{group_col}_{pair_label}.rds"
    output:
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Waldron_LDA_by_{group_col}_{pair_label}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Waldron_Cladogram_by_{group_col}_{pair_label}.svg",
        lda_png       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Waldron_LDA_by_{group_col}_{pair_label}.png",
        cladogram_png = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Waldron_Cladogram_by_{group_col}_{pair_label}.png"
    params:
        group_col = "{group_col}",
        colors    = lambda wc: GROUP_COLORS[wc.group_col]
    container:
        LEFSE_WALDRON_R_CONTAINER
    resources:
        mem_mb = 4000
    script:
        f"{SCRIPTS_DIR}/plot_lefse_Waldron.R"

rule lefse_Huttenhower:
    input:
        feature_table = DA_QIIME_TABLE,
        metadata      = STUDY_DIR / "metadata.tsv",
        taxonomy      = DA_QIIME_TAXA
    output:
        lefse_Huttenhower_results = TMP_DIR / "{db}/lefse_Huttenhower_results_by_{group_col}.txt",
        lda_svg       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Huttenhower_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Huttenhower_Cladogram_by_{group_col}.svg",
        lda_png       = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Huttenhower_LDA_by_{group_col}.png",
        cladogram_png = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "lefse_Huttenhower_Cladogram_by_{group_col}.png"
    params:
        group_col       = "{group_col}",
        lda_cutoff      = lefse_lda_cutoff,
        kw_cutoff       = lefse_kw_cutoff,
        wilcoxon_cutoff = lefse_wilcoxon_cutoff,
        colors          = lambda wc: GROUP_COLORS[wc.group_col]
    container:
        LEFSE_MICROBIOMEMARKER_R_CONTAINER
    resources:
        mem_mb = 6000
    script:
        f"{SCRIPTS_DIR}/run_lefse_Huttenhower.py"