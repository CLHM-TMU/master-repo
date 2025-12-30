rule export_qiime_artefacts_for_picrust2:
    input:
        seqs=str(QIIME_DIR / "rep-seqs-dada2.qza") ,
        table=str(QIIME_DIR / "table-dada2.qza")
    output:
        seqs_fna=str(TABLES_DIR / "study-seqs.fna"),
        table_biom=str(TABLES_DIR / "study-seqs.biom")
    conda: QIIME_CONDA_ENV
    shell:
        """
        qiime tools export \
            --input-path {input.seqs} \
            --output-path exported_seqs_temp
        mv exported_seqs_temp/dna-sequences.fasta {output.seqs_fna}
        rm -r exported_seqs_temp

        qiime tools export \
            --input-path {input.table} \
            --output-path exported_table_temp
        mv exported_table_temp/feature-table.biom {output.table_biom}
        rm -r exported_table_temp
        """

rule run_picrust2_pipeline:
    input:
        seqs_fna=str(TABLES_DIR / "study-seqs.fna"),
        table_biom=str(TABLES_DIR / "study-seqs.biom")
    output:
        directory(STUDY_DIR / "picrust2_output")
    params: threads = 12
    conda: PICRUST2_CONDA_ENV
    shell:
        """
        picrust2_pipeline.py \
            -s {input.seqs_fna} \
            -i {input.table_biom} \
            -o {output} \
            -p {params.threads}
        """
rule picrust_add_descriptions:
    input:
        EC_raw = STUDY_DIR / "picrust2_output" / 
        KO_raw = STUDY_DIR / "picrust2_output" / 
        pathway_raw = STUDY_DIR / "picrust2_output" / 
    output:
        
    params: threads = 12
    conda: PICRUST2_CONDA_ENV
    shell:
        """
        add_descriptions.py \
            -s {input.seqs_fna} \
            -i {input.table_biom} \
            -o {output} \
            -p {params.threads}
        """
    