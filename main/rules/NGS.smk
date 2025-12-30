
rule NGS_import:
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
            --type 'SampleData[PairedEndSequencesWithQuality]' \
            --input-format PairedEndFastqManifestPhred33V2 \
            --input-path {input.manifest} \
            --output-path {output.demux_qza}
        """

rule NGS_cutadapt:
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
        qiime cutadapt trim-paired \
            --i-demultiplexed-sequences {input.demux_qza} \
            --p-cores {params.threads} \
            --p-error-rate 0.1 \
            --p-front-f TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCTACGGGNGGCWGCAG \
            --p-front-r GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGACTACHVGGGTATCTAATCC \
            --o-trimmed-sequences {output.trimmed_qza}
        """

rule NGS_summarize_trimmed_demux:
    input:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza"
    output:
        trimmed_quality_qza = QIIME_DIR / "trimmed-quality.qzv"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        echo "Generating summary of trimmed demultiplexed sequences..."
        qiime demux summarize \
            --i-data {input.trimmed_qza} \
            --o-visualization {output.trimmed_quality_qza}
        """

rule NGS_export_trimmed_quality:
    input:
        trimmed_quality_qza = QIIME_DIR / "trimmed-quality.qzv"
    output:
        sentinel = QIIME_DIR / "trimmed-quality-tsv/.export_complete"  # Add this!
    conda:
        QIIME_CONDA_ENV
    params:
        quality_tsv_dir = QIIME_DIR / "trimmed-quality-tsv"
    shell:
        """
        echo "Exporting quality summary TSV..."
        mkdir -p {params.quality_tsv_dir}
        qiime tools export \
            --input-path {input.trimmed_quality_qza} \
            --output-path {params.quality_tsv_dir}
        touch {output.sentinel}  
        """

rule NGS_generate_trunc_len:
    input:
        sentinel = QIIME_DIR / "trimmed-quality-tsv/.export_complete",
        quality_json = QIIME_DIR / "trimmed-quality-tsv/data.jsonp"
    output:
        trunc_len_csv = TABLES_DIR / "trunc_len.csv"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        python scripts/generate_trunc_length.py {input.quality_json} {output.trunc_len_csv} 20
        """

def read_trunc_len(wildcards):
    import csv
    csv_file = TABLES_DIR / "trunc_len.csv"  # uses Snakemake variable
    with open(csv_file) as f:
        reader = csv.DictReader(f)
        row = next(reader)
        return {"trunc_len_f": int(row["trunc_len_f"]),
                "trunc_len_r": int(row["trunc_len_r"])}

# Base names
BASE_TABLE = "table-dada2.qza"
BASE_REP = "rep-seqs-dada2.qza"
DADA2_STATS = "dada2-stats.qza"

BASE_TABLE_QZV = BASE_TABLE.replace(".qza", ".qzv")
BASE_REP_QZV = BASE_REP.replace(".qza", ".qzv")
DADA2_STATS_QZV = DADA2_STATS.replace(".qza", ".qzv")

if ignore_samples:
    # Unfiltered gets the prefix
    TABLE_UNFILTERED = QIIME_DIR / f"unfiltered-{BASE_TABLE}"
    REP_SEQS_UNFILTERED = QIIME_DIR / f"unfiltered-{BASE_REP}"
    TABLE_UNFILTERED_QZV = QIIME_DIR / f"unfiltered-{BASE_TABLE_QZV}"
    REP_SEQS_UNFILTERED_QZV = QIIME_DIR / f"unfiltered-{BASE_REP_QZV}"
    # Filtered outputs keep the main names
    TABLE_MAIN = QIIME_DIR / BASE_TABLE
    REP_SEQS_MAIN = QIIME_DIR / BASE_REP
    TABLE_MAIN_QZV = QIIME_DIR / BASE_TABLE_QZV
    REP_SEQS_MAIN_QZV = QIIME_DIR / BASE_REP_QZV
else:
    # No filtering: only main outputs exist
    TABLE_MAIN = QIIME_DIR / BASE_TABLE
    REP_SEQS_MAIN = QIIME_DIR / BASE_REP
    TABLE_MAIN_QZV = QIIME_DIR / BASE_TABLE_QZV
    REP_SEQS_MAIN_QZV = QIIME_DIR / BASE_REP_QZV
    # Unfiltered variables are None
    TABLE_UNFILTERED = REP_SEQS_UNFILTERED = None
    TABLE_UNFILTERED_QZV = REP_SEQS_UNFILTERED_QZV = None


rule NGS_dada2:
    input:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza",
        trunc_len_csv = TABLES_DIR / "trunc_len.csv"
    output:
        table = TABLE_UNFILTERED if ignore_samples else TABLE_MAIN,
        rep_seqs = REP_SEQS_UNFILTERED if ignore_samples else REP_SEQS_MAIN,
        stats = QIIME_DIR / DADA2_STATS,
        base_transition = QIIME_DIR / "base-transition-stats-dada2.qza"
    params:
        trim_left_f = 0,
        trim_left_r = 0,
        threads = n_threads,
        trunc_len_f = lambda wildcards: read_trunc_len(wildcards)["trunc_len_f"],
        trunc_len_r = lambda wildcards: read_trunc_len(wildcards)["trunc_len_r"]
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        echo "Running DADA2 denoising..."
        qiime dada2 denoise-paired \
            --i-demultiplexed-seqs {input.trimmed_qza} \
            --p-trim-left-f {params.trim_left_f} \
            --p-trim-left-r {params.trim_left_r} \
            --p-trunc-len-f {params.trunc_len_f} \
            --p-trunc-len-r {params.trunc_len_r} \
            --o-table {output.table} \
            --o-representative-sequences {output.rep_seqs} \
            --o-denoising-stats {output.stats} \
            --o-base-transition-stats {output.base_transition} \
            --p-n-threads {params.threads}
        """



if ignore_samples:
    rule NGS_visualise_unfiltered_dada2_outputs:
        input:
            table = TABLE_UNFILTERED,
            repseqs = REP_SEQS_UNFILTERED,
            stats = QIIME_DIR / DADA2_STATS
        output:
            table_qzv = TABLE_UNFILTERED_QZV,
            repseqs_qzv = REP_SEQS_UNFILTERED_QZV,
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
    rule NGS_filter_dada2_table_rep_seqs:
        input:
            table = TABLE_UNFILTERED,
            repseqs = REP_SEQS_UNFILTERED,
            metadata = metadata_path
        output:
            table = TABLE_MAIN,
            repseqs = REP_SEQS_MAIN
        conda:
            QIIME_CONDA_ENV
        shell:
            """
            # Filter table using sample metadata
            qiime feature-table filter-samples \
                --i-table {input.table} \
                --m-metadata-file {input.metadata} \
                --o-filtered-table {output.table}

            # Filter sequences using the filtered table (NOT metadata!)
            qiime feature-table filter-seqs \
                --i-data {input.repseqs} \
                --i-table {output.table} \
                --o-filtered-data {output.repseqs}
            """

    rule NGS_visualise_filtered_dada2_table_rep_seqs:
        input:
            table = TABLE_MAIN,
            repseqs = REP_SEQS_MAIN
        output:
            table_qzv = TABLE_MAIN_QZV,
            repseqs_qzv = REP_SEQS_MAIN_QZV
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
            """
else:
    rule NGS_visualise_dada2_outputs:
        input:
            table = TABLE_MAIN,
            repseqs = REP_SEQS_MAIN,
            stats = QIIME_DIR / DADA2_STATS
        output:
            table_qzv = TABLE_MAIN_QZV,
            repseqs_qzv = REP_SEQS_MAIN_QZV,
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

rule NGS_export_table_summary:
    input:
        table_qza = TABLE_MAIN
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
        mv {params.outdir}/feature-table.tsv {output.summary_tsv}
        touch {output.sentinel}
        """


rule NGS_generate_rarefy_depth:
    input:
        sentinel = QIIME_DIR / "table-summary/.export_complete",
        summary_tsv = QIIME_DIR / "table-summary/feature-table.tsv"
    output:
        rarefy_csv = TABLES_DIR / "rarefy_depth.csv"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        python - << EOF
import pandas as pd
summary_file = "{input.summary_tsv}"
out_file = "{output.rarefy_csv}"

df = pd.read_csv(summary_file, sep='\t', index_col=0)
depth = int(df.iloc[:,0].min())
pd.DataFrame([{"rarefaction_depth": depth}]).to_csv(out_file, index=False)
EOF
        """
