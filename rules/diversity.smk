
rule calc_alpha_diversity_non_phylogenetic:
    input:
        table = QIIME_DIR / "table-analysis-rarefied.qza"
    output:
        shannon  = str(CORE_METRICS_DIR / "shannon-vector.qza"),
        simpson  = str(CORE_METRICS_DIR / "simpson-vector.qza"),
        evenness = str(CORE_METRICS_DIR / "evenness-vector.qza")
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating non-phylogenetic alpha diversity metrics (Shannon, Simpson, Pielou's Evenness) from rarefied feature table...
        """
    shell:
        """
        qiime diversity alpha --i-table {input.table} --p-metric shannon --o-alpha-diversity {output.shannon}
        qiime diversity alpha --i-table {input.table} --p-metric simpson --o-alpha-diversity {output.simpson}
        qiime diversity alpha --i-table {input.table} --p-metric pielou_e --o-alpha-diversity {output.evenness}
        """

rule calc_beta_diversity_non_phylogenetic:
    input:
        table_rarefied = QIIME_DIR / "table-analysis-rarefied.qza",
    output:
        jaccard    = str(CORE_METRICS_DIR / "jaccard-distance-matrix.qza"),
        braycurtis = str(CORE_METRICS_DIR / "bray-curtis-distance-matrix.qza"),
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating non-phylogenetic beta diversity distance matrices (Jaccard, Bray-Curtis) from rarefied feature table..."""
    shell:
        """
        qiime diversity beta \
            --i-table {input.table_rarefied} \
            --p-metric jaccard \
            --o-distance-matrix {output.jaccard}
        qiime diversity beta \
            --i-table {input.table_rarefied} \
            --p-metric braycurtis \
            --o-distance-matrix {output.braycurtis}
        """



def find_phylogeny(wildcards):
    pattern = os.path.join(REF_DIR, wildcards.db, "*.nwk.qza")
    matches = glob.glob(pattern)
    if len(matches) == 0:
        raise ValueError(f"No .nwk.qza phylogeny found for db: {wildcards.db}")
    if len(matches) > 1:
        raise ValueError(f"Multiple .nwk.qza phylogenies found for db: {wildcards.db}: {matches}")
    return matches[0]



def read_db_rarefy_depth(wildcards):
    import csv
    csv_file = TABLES_DIR / f"{wildcards.db}_rarefy_depth.csv"
    with open(csv_file) as f:
        reader = csv.DictReader(f)
        row = next(reader)
        return int(row["rarefaction_depth"])


rule export_db_table_for_summary_tsv:
    input:
        table = QIIME_DIR / "{db}-table.qza"
    output:
        summary_tsv = temp(TABLES_DIR / "{db}-table-summary" / "feature-table.tsv")
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Exporting {wildcards.db} feature table to TSV for summary statistics calculation...
        """
    shell:
        """
        tmpdir=$(mktemp -d)
        qiime tools export \
            --input-path {input.table} \
            --output-path $tmpdir
        biom convert \
            -i $tmpdir/feature-table.biom \
            -o {output.summary_tsv} \
            --to-tsv
        rm -rf $tmpdir
        """


rule generate_db_rarefy_depth:
    input:
        summary_tsv = TABLES_DIR / "{db}-table-summary" / "feature-table.tsv"
    output:
        rarefy_csv = TABLES_DIR / "{db}_rarefy_depth.csv"
    params:
        percentile = rarefy_depth_percentile
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating rarefaction depth for {wildcards.db} feature table based on {params.percentile} percentile of sample sums...
        """
    shell:
        """
        python - << 'EOF'
import pandas as pd
import numpy as np

df = pd.read_csv("{input.summary_tsv}", skiprows=1, sep='\t', index_col=0)
sample_sums = df.sum(axis=0)
percentile = {params.percentile}
depth = int(sample_sums.min()) if percentile == 0 else int(np.percentile(sample_sums, percentile))
pd.DataFrame([{{"rarefaction_depth": depth}}]).to_csv("{output.rarefy_csv}", index=False)
EOF
        """


rule rarefy_phylogenetic_table:
    input:
        table      = QIIME_DIR / "{db}-table.qza",
        rarefy_csv = TABLES_DIR / "{db}_rarefy_depth.csv"
    output:
        rarefied = QIIME_DIR / "{db}-table-rarefied.qza"
    params:
        depth = lambda wildcards: read_db_rarefy_depth(wildcards)
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Rarefying {wildcards.db} feature table to depth {params.depth}...
        """
    shell:
        """
        qiime feature-table rarefy \
            --i-table {input.table} \
            --p-sampling-depth {params.depth} \
            --o-rarefied-table {output.rarefied}
        """

rule calc_alpha_diversity_phylogenetic:
    input:
        table     = QIIME_DIR / "{db}-table-rarefied.qza",
        phylogeny = find_phylogeny
    output:
        faith_pd = str(CORE_METRICS_DIR / "{db}-faith-pd-vector.qza")
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating phylogenetic alpha diversity metric (Faith's PD) from rarefied phylogenetic feature table...
        """
    shell:
        """
        qiime diversity alpha-phylogenetic \
            --i-table {input.table} \
            --i-phylogeny {input.phylogeny} \
            --p-metric faith_pd \
            --o-alpha-diversity {output.faith_pd}
        """


rule calc_beta_diversity_phylogenetic:
    input:
        table_rarefied = QIIME_DIR / "{db}-table-rarefied.qza",
        phylogeny      = find_phylogeny
    output:
        unweighted = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-distance-matrix.qza"),
        weighted   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-distance-matrix.qza")
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating phylogenetic beta diversity distance matrices (Unweighted and Weighted UniFrac) from rarefied phylogenetic feature table...
        """
    shell:
        """
        qiime diversity beta-phylogenetic \
            --i-table {input.table_rarefied} \
            --i-phylogeny {input.phylogeny} \
            --p-metric unweighted_unifrac \
            --o-distance-matrix {output.unweighted}
        qiime diversity beta-phylogenetic \
            --i-table {input.table_rarefied} \
            --i-phylogeny {input.phylogeny} \
            --p-metric weighted_unifrac \
            --o-distance-matrix {output.weighted}
        """
rule pcoa_beta_diversity_non_phylogenetic:
    input:
        jaccard    = str(CORE_METRICS_DIR / "jaccard-distance-matrix.qza"),
        braycurtis = str(CORE_METRICS_DIR / "bray-curtis-distance-matrix.qza"),
    output:
        jaccard_pcoa    = str(CORE_METRICS_DIR / "jaccard-pcoa-results.qza"),
        braycurtis_pcoa = str(CORE_METRICS_DIR / "bray-curtis-pcoa-results.qza"),
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating non-phylogenetic beta diversity distance matrices (Jaccard, Bray-Curtis) from distance matrices..."""
    shell:
        """
        qiime diversity pcoa \
            --i-distance-matrix {input.braycurtis} \
            --o-pcoa {output.braycurtis_pcoa}
        qiime diversity pcoa \
            --i-distance-matrix {input.jaccard} \
            --o-pcoa {output.jaccard_pcoa}
        """

rule pcoa_beta_diversity_phylogenetic:
    input:
        unweighted = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-distance-matrix.qza"),
        weighted   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-distance-matrix.qza"),
    output:
        unweighted_pcoa = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-pcoa-results.qza"),
        weighted_pcoa   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-pcoa-results.qza"),
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Calculating phylogenetic beta diversity distance matrices (Unweighted and Weighted UniFrac) from distance matrices...
        """
    shell:
        """
        qiime diversity pcoa \
            --i-distance-matrix {input.unweighted} \
            --o-pcoa {output.unweighted_pcoa}
        qiime diversity pcoa \
            --i-distance-matrix {input.weighted} \
            --o-pcoa {output.weighted_pcoa}
        """

rule plot_alpha_diversity:
    input:
        shannon  = CORE_METRICS_DIR / "shannon-vector.qza",
        faith_pd = CORE_METRICS_DIR / "{db}-faith-pd-vector.qza",
        simpson  = CORE_METRICS_DIR / "simpson-vector.qza",
        evenness = CORE_METRICS_DIR / "evenness-vector.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        alpha_plot = ALPHA_DIR / "{db}_alpha_{group_col}.svg",
        sentinel   = DIVERSITY_DIR / ".{db}_alpha_{group_col}_done"
    params:
        group_by = "{group_col}",
        db = "{db}",
        output_dir = ALPHA_DIR,
        color_palette = group_colors
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Plotting alpha diversity metrics (Shannon, Faith's PD, Simpson, Evenness) for {wildcards.db} grouped by {params.group_by}...
        """
    script:
        SCRIPTS_DIR / "plot_alpha_diversity.py"

rule plot_beta_diversity:
    input:
        jaccard_pcoa    = str(CORE_METRICS_DIR / "jaccard-pcoa-results.qza"),
        braycurtis_pcoa = str(CORE_METRICS_DIR / "bray-curtis-pcoa-results.qza"),
        unweighted_pcoa = str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-pcoa-results.qza"),
        weighted_pcoa   = str(CORE_METRICS_DIR / "{db}-weighted-unifrac-pcoa-results.qza"),
        metadata_path   = STUDY_DIR / "metadata.tsv",
    output:
        beta_diversity_plot = BETA_DIR / "{db}_beta_{group_col}.svg",
        sentinel            = DIVERSITY_DIR / ".{db}_beta_{group_col}_done"
    params:
        group_by = "{group_col}",
        color_palette = group_colors
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Plotting beta diversity PCoA results for {wildcards.db} grouped by {params.group_by}...
        """
    script:
        SCRIPTS_DIR / "plot_beta_diversity.py"

rule run_permanova_permdisp:
    input:
        dist=[
            str(CORE_METRICS_DIR / "jaccard-distance-matrix.qza"),
            str(CORE_METRICS_DIR / "bray-curtis-distance-matrix.qza"),
            str(CORE_METRICS_DIR / "{db}-unweighted-unifrac-distance-matrix.qza"),
            str(CORE_METRICS_DIR / "{db}-weighted-unifrac-distance-matrix.qza"),
        ],
        meta = STUDY_DIR / "metadata.tsv"
    output:
        TABLES_DIR / "{db}_permanova_permdisp.tsv"
    conda:
        QIIME_CONDA_ENV
    message:
        """
        [QIIME] Running PERMANOVA and PERMDISP tests for {wildcards.db} beta diversity distance matrices...
        """
    script:
        str(SCRIPTS_DIR / "run_permanova_permdisp.py")