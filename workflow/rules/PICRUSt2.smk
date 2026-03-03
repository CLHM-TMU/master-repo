rule run_picrust2_pipeline:
    input:
        seqs_fna = TABLES_DIR / "study-seqs.fna",
        table_biom = TABLES_DIR / "study-seqs.biom"
    output:
        picrust2_dir = directory(STUDY_DIR / "picrust2_output")
    threads: 12
    conda: PICRUST2_CONDA_ENV
    shell:
        """
        picrust2_pipeline.py \
            -s {input.seqs_fna} \
            -i {input.table_biom} \
            -o {output.picrust2_dir} \
            -p {threads}
        """

rule picrust2_add_descriptions:
    input:
        picrust2_dir = STUDY_DIR / "picrust2_output"
    output:
        ko_described = STUDY_DIR / "picrust2_described" / "KO_metagenome_unstrat_described.tsv.gz",
        ec_described = STUDY_DIR / "picrust2_described" / "EC_metagenome_unstrat_described.tsv.gz",
        pathway_described = STUDY_DIR / "picrust2_described" / "pathway_abun_unstrat_described.tsv.gz"
    threads: 12
    conda: PICRUST2_CONDA_ENV
    shell:
        """
        mkdir -p $(dirname {output.ko_described})

        add_descriptions.py \
            -i {input.picrust2_dir}/KO_metagenome_out/pred_metagenome_unstrat.tsv.gz \
            -o {output.ko_described} \
            -m KO

        add_descriptions.py \
            -i {input.picrust2_dir}/EC_metagenome_out/pred_metagenome_unstrat.tsv.gz \
            -o {output.ec_described} \
            -m EC

        add_descriptions.py \
            -i {input.picrust2_dir}/pathways_out/path_abun_unstrat.tsv.gz \
            -o {output.pathway_described} \
            -m METACYC
        """

rule visualize_picrust2:
    input:
        ec = f"{STUDY_DIR}/picrust2_described/EC_metagenome_unstrat_described.tsv.gz",
        ko = f"{STUDY_DIR}/picrust2_described/KO_metagenome_unstrat_described.tsv.gz",
        pathway = f"{STUDY_DIR}/picrust2_described/pathway_abun_unstrat_described.tsv.gz",
        metadata = f"{STUDY_DIR}/metadata.tsv"
    output:
        heatmap_pdf = f"{STUDY_DIR}/plots/picrust2_heatmap.pdf"
    conda: 
        QIIME_CONDA_ENV
    script:
        f"{SCRIPTS_DIR}/plot_picrust_heatmap.R"