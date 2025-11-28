def select_table(wildcards):
    """
    Returns the appropriate table QZA for a given database.
    Uses the filtered table if IGNORE_SAMPLES is non-empty.
    """
    ignore_samples = config.get("IGNORE_SAMPLES", [])
    
    if ignore_samples:
        return str(QIIME_DIR / f"{wildcards.db}-table-filtered.qza")
    else:
        return str(QIIME_DIR / f"{wildcards.db}-table.qza")


rule calc_alpha_diversity:
    input:
        table = select_table,
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
        table = select_table,
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

# rule plot_alpha_diversity:
#     input:
#         shannon  = str(CORE_METRICS_DIR / "{db}-shannon-vector.qza"),
#         chao1    = str(CORE_METRICS_DIR / "{db}-chao1-vector.qza"),
#         simpson  = str(CORE_METRICS_DIR / "{db}-simpson-vector.qza"),
#         evenness = str(CORE_METRICS_DIR / "{db}-evenness-vector.qza"),
#         metadata_path = STUDY_DIR / "metadata.tsv",
#         diversity_dir = DIVERSITY_DIR
#     output:
#         alpha_diversity_plot = 
#         sentinel = str(DIVERSITY_DIR / ".{db}_alpha_diversity_done")
#     params:
#         group_columns = group_columns
#         database = {db}
#     conda:
#         QIIME_CONDA_ENV
#     shell:
#         """
#         python scripts/plot_alpha_diversity.py
#         touch {output.sentinel}
#         """


# rule plot_beta_diversity:
#     input:
#         jaccard_pcoa    = str(CORE_METRICS_DIR / "{db}-jaccard-pcoa-results.qza"),
#         braycurtis_pcoa = str(CORE_METRICS_DIR / "{db}-bray-curtis-pcoa-results.qza"),
#         unweighted_pcoa = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-pcoa-results.qza"),
#         weighted_pcoa   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-pcoa-results.qza"),
#         metadata_path = STUDY_DIR / "metadata.tsv",
#         diversity_dir = DIVERSITY_DIR
#     output:
#         beta_diversity_plot = 
#         sentinel = str(DIVERSITY_DIR / ".{db}_beta_diversity_done")
#     conda:
#         QIIME_CONDA_ENV
#     params:
#         group_by = group_columns[0]
#     shell:
#         """
#         mkdir -p {input.diversity_dir}/beta_diversity_plots
#         python scripts/plot_beta_diversity.py
#         touch {output.sentinel}
#         """