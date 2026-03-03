rule calc_alpha_diversity:
    input:
        table = str(QIIME_DIR / "{db}-table.qza"),
        sentinel = str(QIIME_DIR / ".{db}_phylogeny_done")
    output:
        shannon  = str(CORE_METRICS_DIR / "{db}-shannon-vector.qza"),
        chao1    = str(CORE_METRICS_DIR / "{db}-chao1-vector.qza"),
        simpson  = str(CORE_METRICS_DIR / "{db}-simpson-vector.qza"),
        evenness = str(CORE_METRICS_DIR / "{db}-evenness-vector.qza")
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime diversity alpha --i-table {input.table} --p-metric shannon --o-alpha-diversity {output.shannon}
        qiime diversity alpha --i-table {input.table} --p-metric chao1 --o-alpha-diversity {output.chao1}
        qiime diversity alpha --i-table {input.table} --p-metric simpson --o-alpha-diversity {output.simpson}
        qiime diversity alpha --i-table {input.table} --p-metric pielou_e --o-alpha-diversity {output.evenness}
        """

def find_phylogeny(wildcards):
    pattern = os.path.join(REF_DIR, wildcards.db, "*.nwk.qza")
    matches = glob.glob(pattern)
    if len(matches) == 0:
        raise ValueError(f"No .nwk.qza phylogeny found for db: {wildcards.db}")
    if len(matches) > 1:
        raise ValueError(f"Multiple .nwk.qza phylogenies found for db: {wildcards.db}: {matches}")
    return matches[0]

rule calc_beta_diversity:
    input:
        table = str(QIIME_DIR / "{db}-table.qza"),
        phylogeny = find_phylogeny
    output:
        jaccard    = str(CORE_METRICS_DIR / "{db}-jaccard-distance-matrix.qza"),
        braycurtis = str(CORE_METRICS_DIR / "{db}-bray-curtis-distance-matrix.qza"),
        unweighted = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-distance-matrix.qza"),
        weighted   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-distance-matrix.qza")
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime diversity beta --i-table {input.table} --p-metric jaccard --o-distance-matrix {output.jaccard}
        qiime diversity beta --i-table {input.table} --p-metric braycurtis --o-distance-matrix {output.braycurtis}
        qiime diversity beta-phylogenetic --i-table {input.table} --i-phylogeny {input.phylogeny} --p-metric unweighted_unifrac --o-distance-matrix {output.unweighted}
        qiime diversity beta-phylogenetic --i-table {input.table} --i-phylogeny {input.phylogeny} --p-metric weighted_unifrac --o-distance-matrix {output.weighted}
        """

rule pcoa_beta_diversity:
    input:
        jaccard    = str(CORE_METRICS_DIR / "{db}-jaccard-distance-matrix.qza"),
        braycurtis = str(CORE_METRICS_DIR / "{db}-bray-curtis-distance-matrix.qza"),
        unweighted = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-distance-matrix.qza"),
        weighted   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-distance-matrix.qza")
    output:
        jaccard_pcoa    = str(CORE_METRICS_DIR / "{db}-jaccard-pcoa-results.qza"),
        braycurtis_pcoa = str(CORE_METRICS_DIR / "{db}-bray-curtis-pcoa-results.qza"),
        unweighted_pcoa = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-pcoa-results.qza"),
        weighted_pcoa   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-pcoa-results.qza")
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime diversity pcoa \
            --i-distance-matrix {input.braycurtis} \
            --o-pcoa {output.braycurtis_pcoa}

        qiime diversity pcoa \
            --i-distance-matrix {input.jaccard} \
            --o-pcoa {output.jaccard_pcoa}

        qiime diversity pcoa \
            --i-distance-matrix {input.unweighted} \
            --o-pcoa {output.unweighted_pcoa}

        qiime diversity pcoa \
            --i-distance-matrix {input.weighted} \
            --o-pcoa {output.weighted_pcoa}
        """

rule plot_alpha_diversity:
    input:
        shannon  = CORE_METRICS_DIR / "{db}-shannon-vector.qza",
        chao1    = CORE_METRICS_DIR / "{db}-chao1-vector.qza",
        simpson  = CORE_METRICS_DIR / "{db}-simpson-vector.qza",
        evenness = CORE_METRICS_DIR / "{db}-evenness-vector.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        alpha_plot = ALPHA_DIR / "{db}_alpha_{group_col}.png",
        sentinel   = DIVERSITY_DIR / ".{db}_alpha_{group_col}_done"
    params:
        group_by = "{group_col}",
        output_dir = ALPHA_DIR,
        database = "{db}",
        dropped_sampleid = ignore_samples
    conda:
        QIIME_CONDA_ENV
    script:
        SCRIPTS_DIR / "plot_alpha_diversity.py"


rule plot_beta_diversity:
    input:
        jaccard_pcoa    = CORE_METRICS_DIR / "{db}-jaccard-pcoa-results.qza",
        braycurtis_pcoa = CORE_METRICS_DIR / "{db}-bray-curtis-pcoa-results.qza",
        unweighted_pcoa = CORE_METRICS_DIR / "{db}-unweighted-unifrac-pcoa-results.qza",
        weighted_pcoa   = CORE_METRICS_DIR / "{db}-weighted-unifrac-pcoa-results.qza",
        metadata_path   = STUDY_DIR / "metadata.tsv",
    output:
        beta_diversity_plot = BETA_DIR / "{db}_beta_{group_col}.svg",
        sentinel            = DIVERSITY_DIR / ".{db}_beta_{group_col}_done"
    params:
        group_by = "{group_col}"
    conda:
        QIIME_CONDA_ENV
    script:
        SCRIPTS_DIR / "plot_beta_diversity.py"

rule run_permanova_betadisper:
    input:
        dist=[
            f"{CORE_METRICS_DIR}/{db}-jaccard-distance-matrix.qza",
            f"{CORE_METRICS_DIR}/{db}-bray-curtis-distance-matrix.qza",
            f"{CORE_METRICS_DIR}/{db}-unweighted-unifrac-distance-matrix.qza",
            f"{CORE_METRICS_DIR}/{db}-weighted-unifrac-distance-matrix.qza"
        ],
        meta = STUDY_DIR / "metadata.tsv"
    output: TABLES_DIR / "permanova_betadisper.tsv"
    conda:
        QIIME_CONDA_ENV
    script:
        str(SCRIPTS_DIR / "permanova_betadisper.py")