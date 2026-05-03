rule TGS_import:
    input:
        manifest = STUDY_DIR / "manifest.tsv",
        make_dirs_marker = STUDY_DIR / ".dirs_created"
    output:
        demux_qza = QIIME_DIR / "demux.qza"
    conda:
        QIIME_CONDA_ENV  
    shell:
        """
        echo "Demultiplexed sequences found. Importing as Qiime2 Artifact..."
        qiime tools import \
            --type 'SampleData[SequencesWithQuality]' \
            --input-format SingleEndFastqManifestPhred33V2 \
            --input-path {input.manifest} \
            --output-path {output.demux_qza}
        """

rule TGS_cutadapt:
    input:
        demux_qza = QIIME_DIR / "demux.qza"
    output:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza"
    conda:
        QIIME_CONDA_ENV
    params:
        threads = n_threads
    shell:
        """
        echo "Trimming primers using cutadapt..."
        mv {input.demux_qza} {output.trimmed_qza}
        """

        

# qiime cutadapt trim-single \
#     --i-demultiplexed-sequences {input.demux_qza} \
#     --p-cores {params.threads} \
#     --p-error-rate 0.1 \
#     --p-anywhere AGAGTTTGATCMTGGCTCAG \
#     --p-anywhere CTGAGCCAKATCAAAGCTCT \
#     --o-trimmed-sequences {output.trimmed_qza}

rule TGS_summarize_trimmed_demux:
    input:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza"
    output:
        trimmed_quality_qzv = QIIME_DIR / "trimmed-quality.qzv"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        echo "Generating summary of trimmed demultiplexed sequences..."
        qiime demux summarize \
            --i-data {input.trimmed_qza} \
            --o-visualization {output.trimmed_quality_qzv}
        """

# Base names
BASE_TABLE = "table-dada2.qza"
BASE_REP = "rep-seqs-dada2.qza"
DADA2_STATS = "dada2-stats.qza"

BASE_TABLE_QZV = BASE_TABLE.replace(".qza", ".qzv")
BASE_REP_QZV = BASE_REP.replace(".qza", ".qzv")
DADA2_STATS_QZV = DADA2_STATS.replace(".qza", ".qzv")


# Circular consensus does not need to be truncated so set length to 0
rule TGS_dada2:
    input:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza"
    output:
        table = QIIME_DIR / BASE_TABLE,
        repseqs = QIIME_DIR / BASE_REP,
        stats = QIIME_DIR / DADA2_STATS,
        base_transition = QIIME_DIR / "base-transition-stats-dada2.qza"
    params:
        threads = n_threads
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime dada2 denoise-ccs \
            --i-demultiplexed-seqs {input.trimmed_qza} \
            --p-front AGAGTTTGATCMTGGCTCAG \
            --o-table {output.table} \
            --o-representative-sequences {output.repseqs} \
            --o-denoising-stats {output.stats} \
            --o-base-transition-stats {output.base_transition} \
            --p-n-threads {params.threads} \
            --p-trunc-len 0
        """


rule TGS_visualise_dada2_outputs:
    input:
        table = QIIME_DIR / BASE_TABLE,
        repseqs = QIIME_DIR / BASE_REP,
        stats = QIIME_DIR / DADA2_STATS
    output:
        table_qzv = QIIME_DIR / BASE_TABLE_QZV,
        repseqs_qzv = QIIME_DIR / BASE_REP_QZV,
        stats_qzv = QIIME_DIR / DADA2_STATS_QZV
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime feature-table summarize \
            --i-table {input.table} \
            --o-visualization {output.table_qzv}

        qiime feature-table tabulate-seqs \
            --i-data {input.repseqs} \
            --o-visualization {output.repseqs_qzv}

        qiime metadata tabulate \
            --m-input-file {input.stats} \
            --o-visualization {output.stats_qzv}
        """

rule TGS_export_table_summary:
    input:
        table_qza = QIIME_DIR / BASE_TABLE
    output:
        summary_tsv = QIIME_DIR / "table-summary/feature-table.tsv",
        sentinel = QIIME_DIR / "table-summary/.export_complete"
    params:
        outdir = QIIME_DIR / "table-summary"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        mkdir -p {params.outdir}
        echo "Exporting table summary..."
        qiime tools export \
            --input-path {input.table_qza} \
            --output-path {params.outdir}
        biom convert \
            -i {params.outdir}/feature-table.biom \
            -o {output.summary_tsv} \
            --to-tsv
        touch {output.sentinel}
        """

rule TGS_generate_rarefy_depth:
    input:
        sentinel = QIIME_DIR / "table-summary/.export_complete",
        summary_tsv = QIIME_DIR / "table-summary/feature-table.tsv"
    output:
        rarefy_csv = TABLES_DIR / "rarefy_depth.csv"
    params:
        percentile = rarefy_depth_percentile
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        python - << EOF
import pandas as pd
import numpy as np
summary_file = "{input.summary_tsv}"
out_file = "{output.rarefy_csv}"
percentile = {params.percentile}

df = pd.read_csv(summary_file, skiprows=1, sep='\t', index_col=0)
sample_sums = df.sum(axis=0)  # sum across features for each sample
if percentile == 0:
    depth = int(sample_sums.min())
else:
    depth = int(np.percentile(sample_sums, percentile))
pd.DataFrame([{{"rarefaction_depth": depth}}]).to_csv(out_file, index=False)
EOF
        """

rule TGS_make_rarefied_version:
    input:
        table = QIIME_DIR / "table-dada2.qza",
        rarefy_csv = TABLES_DIR / "rarefy_depth.csv"
    output:
        rarefied_table = QIIME_DIR / "table-dada2-rarefied.qza"
    params:
        depth = lambda wildcards: read_rarefy_depth(wildcards)
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime feature-table rarefy \
            --i-table {input.table} \
            --p-sampling-depth {params.depth} \
            --o-rarefied-table {output.rarefied_table}
        """

def read_rarefy_depth(wildcards):
    import csv
    csv_file = TABLES_DIR / "rarefy_depth.csv"
    with open(csv_file) as f:
        reader = csv.DictReader(f)
        row = next(reader)
        return int(row["rarefaction_depth"])


rule TGS_export_feature_table:
    input:
        table_qza = QIIME_DIR / "table-dada2.qza"
    output:
        table_biom = TABLES_DIR / "study-seqs.biom"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime tools export \
            --input-path {input.table_qza} \
            --output-path exported_table_temp
        mv exported_table_temp/feature-table.biom {output.table_biom}
        rm -r exported_table_temp
        """

rule TGS_export_rep_seqs:
    input:
        rep_seqs_qza = QIIME_DIR / "rep-seqs-dada2.qza"
    output:
        rep_seqs_fna = TABLES_DIR / "study-seqs.fna"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime tools export \
            --input-path {input.rep_seqs_qza} \
            --output-path exported_seqs_temp
        mv exported_seqs_temp/dna-sequences.fasta {output.rep_seqs_fna}
        rm -r exported_seqs_temp
        """
