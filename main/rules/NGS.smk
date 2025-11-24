print("=====NGS 16S V3V4 PIPELINE INITIATING=====")

rule NGS_import:
    input:
        manifest = STUDY_DIR / "manifest.tsv"
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
    shell:
        """
        echo "Trimming primers using cutadapt..."
        qiime cutadapt trim-paired \
            --i-demultiplexed-sequences {input.demux_qza} \
            --p-cores 0 \
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
        quality_tsv = QIIME_DIR / "trimmed-quality-tsv/per-sample-fastq-counts.tsv",
        sentinel = QIIME_DIR / "trimmed-quality-tsv/.export_complete"
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
        trunc_len_csv = QIIME_DIR / "trunc_len.csv"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        python scripts/generate_trunc_length.py {input.quality_json} {output.trunc_len_csv} 20
        """

def read_trunc_len(wildcards):
    import csv
    csv_file = QIIME_DIR / "trunc_len.csv"  # uses Snakemake variable
    with open(csv_file) as f:
        reader = csv.DictReader(f)
        row = next(reader)
        return {"trunc_len_f": int(row["trunc_len_f"]),
                "trunc_len_r": int(row["trunc_len_r"])}

rule NGS_dada2:
    input:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza",
        trunc_len_csv = QIIME_DIR / "trunc_len.csv"
    output:
        table = QIIME_DIR / "table.qza",
        rep_seqs = QIIME_DIR / "rep-seqs.qza",
        stats = QIIME_DIR / "stats.qza",
        base_transition_stats = QIIME_DIR / "base-transition-stats.qza"
    params:
        trim_left_f = 0,
        trim_left_r = 0,
        threads = 8,
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
            --o-base-transition-stats {output.base_transition_stats} \
            --p-n-threads {params.threads}
        """

rule NGS_summarize_dada2_outputs:
    input:
        table = QIIME_DIR / "table.qza",
        rep_seqs = QIIME_DIR / "rep-seqs.qza",
        stats = QIIME_DIR / "stats.qza",
        metadata = STUDY_DIR / "metadata.tsv",
        manifest = STUDY_DIR / "manifest.tsv" 
    output:
        table_qzv = QIIME_DIR / "table.qzv",
        rep_seqs_qzv = QIIME_DIR / "rep-seqs.qzv",
        stats_qzv = QIIME_DIR / "stats.qzv"
    conda:
        QIIME_CONDA_ENV  
    shell:
        """
        echo "Summarizing DADA2 outputs into QZV files..."
        qiime feature-table summarize \
            --i-table {input.table} \
            --o-visualization {output.table_qzv} \
            --m-sample-metadata-file {input.metadata}

        qiime feature-table tabulate-seqs \
            --i-data {input.rep_seqs} \
            --o-visualization {output.rep_seqs_qzv}

        qiime metadata tabulate \
            --m-input-file {input.stats} \
            --o-visualization {output.stats_qzv}
        """
