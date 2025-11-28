
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
        qiime cutadapt trim-single \
            --i-demultiplexed-sequences {input.demux_qza} \
            --p-cores {params.n_threads} \
            --p-error-rate 0.1 \
            --p-front AGAGTTTGATCMTGGCTCAG \
            --o-trimmed-sequences {output.trimmed_qza}
        """

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

rule TGS_dada2:
    input:
        trimmed_qza = QIIME_DIR / "trimmed-demux.qza"
    output:
        table = QIIME_DIR / "table-dada2.qza",
        rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
        stats = QIIME_DIR / "stats-dada2.qza",
        base_transition_stats = QIIME_DIR / "base-transition-stats-dada2.qza"
    params:
        threads = n_threads
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        echo "Running DADA2 denoising..."
        qiime dada2 denoise-single \
            --i-demultiplexed-seqs {input.trimmed_qza} \
            --o-table {output.table} \
            --o-representative-sequences {output.rep_seqs} \
            --o-denoising-stats {output.stats} \
            --o-base-transition-stats {output.base_transition_stats} \
            --p-n-threads {params.threads} \
            --p-trunc-len 0
        """

rule TGS_summarize_dada2_outputs:
    input:
        table = QIIME_DIR / "table-dada2.qza",
        rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
        stats = QIIME_DIR / "stats-dada2.qza",
        metadata = STUDY_DIR / "metadata.tsv",
        manifest = STUDY_DIR / "manifest.tsv" 
    output:
        table_qzv = QIIME_DIR / "table-dada2.qzv",
        rep_seqs_qzv = QIIME_DIR / "rep-seqs-dada2.qzv",
        stats_qzv = QIIME_DIR / "stats-dada2.qzv"
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

rule filter_dada2_samples:
    input:
        table = QIIME_DIR / "table-dada2.qza",
        rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
        stats = QIIME_DIR / "stats-dada2.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        table_filtered = QIIME_DIR / "table-dada2-filtered.qza",
        rep_seqs_filtered = QIIME_DIR / "rep-seqs-dada2-filtered.qza",
        table_filtered_qzv = QIIME_DIR / "table-dada2-filtered.qzv",
        rep_seqs_filtered_qzv = QIIME_DIR / "rep-seqs-dada2-filtered.qzv",
        stats_filtered_qzv = QIIME_DIR / "stats-dada2-filtered.qzv"
    params:
        ignore = config.get("IGNORE_SAMPLES", [])
    conda:
        QIIME_CONDA_ENV
    run:
        if not params.ignore:
            print("No samples to ignore, skipping filtered outputs.")
            # Optionally touch outputs so Snakemake thinks the rule ran
            for f in output:
                shell(f"touch {f}")
        else:
            print("Ignoring the following samples:", ", ".join(params.ignore))
            ignore_list = ",".join(params.ignore)
            
            # Filter table
            shell(f"""
            qiime feature-table filter-samples \
                --i-table {input.table} \
                --m-metadata-file {input.metadata} \
                --p-exclude-ids {ignore_list} \
                --o-filtered-table {output.table_filtered}
            """)

            # Filter rep-seqs
            shell(f"""
            qiime feature-table filter-seqs \
                --i-data {input.rep_seqs} \
                --i-table {output.table_filtered} \
                --o-filtered-data {output.rep_seqs_filtered}
            """)

            # Filter stats table
            shell(f"""
            qiime feature-table filter-samples \
                --i-table {input.stats} \
                --m-metadata-file {input.metadata} \
                --p-exclude-ids {ignore_list} \
                --o-filtered-table {output.stats_filtered_qzv}
            """)

            # Summarize filtered outputs
            shell(f"""
            qiime feature-table summarize \
                --i-table {output.table_filtered} \
                --o-visualization {output.table_filtered_qzv} \
                --m-sample-metadata-file {input.metadata}

            qiime feature-table tabulate-seqs \
                --i-data {output.rep_seqs_filtered} \
                --o-visualization {output.rep_seqs_filtered_qzv}
            """)


rule TGS_export_table_summary:
    input:
        table_qzv = QIIME_DIR / "table-dada2.qzv"
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
            --input-path {input.table_qzv} \
            --output-path {params.outdir}
        # Move exported TSV to a standard name
        mv {params.outdir}/feature-table.tsv {output.summary_tsv}
        touch {output.sentinel}
        """

rule TGS_generate_rarefy_depth:
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

# Read exported feature table
df = pd.read_csv(summary_file, sep='\t', index_col=0)

# Conservative: use minimum sequences per sample
depth = int(df.iloc[:,0].min())

# Save to CSV
df_out = pd.DataFrame([{"rarefaction_depth": depth}])
df_out.to_csv(out_file, index=False)
EOF
        """

