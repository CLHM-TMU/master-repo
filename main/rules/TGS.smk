print("=====TGS 16S Full Length  PIPELINE INITIATING=====")

rule TGS:
    input:
        manifest = os.path.join(STUDY_DIR / "manifest.tsv")
    output:
        qza = QIIME_DIR / "TGS_demux.qza"
    conda:
        QIIME_CONDA_ENV  
    shell:
        """
        echo "Demultiplexing sequences..."
        qiime tools import \
            --type 'SampleData[PairedEndSequencesWithQuality]' \
            --input-format PairedEndFastqManifestPhred33V2 \
            --input-path {input.manifest} \
            --output-path {output.qza}
        """
rule TGS_summarize:
    input:
        qza = QIIME_DIR / "demux.qza"
    output:
        qzv = QIIME_DIR / "demux.qzv"
    conda:
        QIIME_CONDA_ENV  
    shell:
        """
        echo "Generating summary of demultiplexed sequences..."
        qiime demux summarize \
            --i-data {input.qza} \
            --o-visualization {output.qzv}
        """

rule TGS_cutadapt:
    input:
        qza = QIIME_DIR / "demux.qza"
    output:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza"
    params:
        forward_primer = "AGAGTTTGATCMTGGCTCAG",
        reverse_primer = "GNTACCTTGTTACGACTT"
    conda:
        QIIME_CONDA_ENV  
    shell:
        """
        echo "Trimming primers using cutadapt..."
        qiime cutadapt trim-paired \
            --i-demultiplexed-sequences {input.qza} \
            --p-front-f {params.forward_primer} \
            --p-front-r {params.reverse_primer} \
            --o-trimmed-sequences {output.trimmed_qza}
        """

rule TGS_dada2:
    input:
        qza = QIIME_DIR / "demux.qza"
    output:
        table = QIIME_DIR / "table.qza",
        rep_seqs = QIIME_DIR / "rep-seqs.qza",
        stats = QIIME_DIR / "stats.qza"
    params:
        trim_left_f = 10,
        trim_left_r = 10,
        trunc_len_f = 260,
        trunc_len_r = 220,
        threads = 0
    conda:
        QIIME_CONDA_ENV  
    shell:
        """
        echo "Running DADA2 denoising..."
        qiime dada2 denoise-paired \
            --i-demultiplexed-seqs {input.qza} \
            --p-trim-left-f {params.trim_left_f} \
            --p-trim-left-r {params.trim_left_r} \
            --p-trunc-len-f {params.trunc_len_f} \
            --p-trunc-len-r {params.trunc_len_r} \
            --o-table {output.table} \
            --o-representative-sequences {output.rep_seqs} \
            --o-denoising-stats {output.stats} \
            --p-n-threads {params.threads}
        """

rule TGS_summarize_dada2_outputs:
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