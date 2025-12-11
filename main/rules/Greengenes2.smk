
if region == "region_V3V4":
    rule GG2_V3V4_taxonomy:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
            greengenes_nb_classifier = REF_DIR / "Greengenes2" / "2024.09.custom.V3V4.nb.qza"
        output:
            taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "Greengenes2-taxonomy.qzv",
            sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
        conda:
            GREENGENES2_CONDA_ENV  
        shell:
            """
            echo "Classifying 16S region V3V4 sequences using Greengenes2 Naive Bayes Classifier..."
            qiime feature-classifier classify-sklearn \
                --i-classifier {input.greengenes_nb_classifier} \
                --i-reads {input.rep_seqs} \
                --o-classification {output.taxonomy}
            echo "Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            touch {output.sentinel}
            """

elif region == "full_length":
    rule GG2_Full_taxonomy:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
            greengenes_nb_classifier = REF_DIR / "Greengenes2" / "2024.09.backbone.full-length.nb.qza"
        output:
            taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "Greengenes2-taxonomy.qzv",
            sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
        conda:
            GREENGENES2_CONDA_ENV  
        shell:
            """
            echo "Classifying 16S Full-length sequences using Greengenes2 Naive Bayes Classifier..."
            qiime feature-classifier classify-sklearn \
                --i-classifier {input.greengenes_nb_classifier} \
                --i-reads {input.rep_seqs} \
                --o-classification {output.taxonomy}
            echo "Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            touch {output.sentinel}
            """

rule GG2_phylogeny:
    input:
        table = QIIME_DIR / "table-dada2.qza",
        rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
        greengenes_db = REF_DIR / "Greengenes2" / "2024.09.backbone.full-length.fna.qza",
        sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
    output:
        phylogeny_table = QIIME_DIR / "Greengenes2-table.qza",
        phylogeny_rep_seqs = QIIME_DIR / "Greengenes2-rep-seqs.qza",
        sentinel = QIIME_DIR / ".Greengenes2_phylogeny_done"
    conda:
        GREENGENES2_CONDA_ENV  
    shell:
        """
        echo "Building phylogenetic tree for 16S (V3V4 or Full-length) sequences using Greengenes2 database..."
        qiime greengenes2 non-v4-16s \
            --i-table {input.table} \
            --i-sequences {input.rep_seqs} \
            --i-backbone {input.greengenes_db} \
            --p-threads 6 \
            --o-mapped-table {output.phylogeny_table} \
            --o-representatives {output.phylogeny_rep_seqs}
        touch {output.sentinel}
        """

rule GG2_Taxa_Barplot:
    input:
        table = QIIME_DIR / "table-dada2.qza",           
        taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
        metadata = metadata_path    
    output:
        barplot_qzv = QIIME_DIR / "Greengenes2-taxa-bar-plots.qzv",
        sentinel = QIIME_DIR / ".Greengenes2_taxa_barplot_done"
    conda:
        GREENGENES2_CONDA_ENV
    shell:
        """
        echo "Generating taxa barplot visualization..."
        qiime taxa barplot \
            --i-table {input.table} \
            --i-taxonomy {input.taxonomy} \
            --m-metadata-file {input.metadata} \
            --o-visualization {output.barplot_qzv}
        touch {output.sentinel}
        """

## Below is WIP for making custom taxa barplots using exported data

# rule GG2_export_feature_table:
#     input:
#         table_qza = QIIME_DIR /"table-dada2.qza"
#     output:
#         feature_table_dir = TABLES_DIR / "exported-feature-table/Greengenes2-feature-table.biom"
#     conda:
#         QIIME_CONDA_ENV
#     shell:
#         """
#         qiime tools export \
#             --input-path {input.table_qza} \
#             --output-path {output.feature_table_dir} 
#         """

# rule GG2_export_taxonomy:
#     input:
#         taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza"
#     output:
#         taxonomy_dir = TABLES_DIR + "/exported-taxonomy"
#     conda:
#         QIIME_CONDA_ENV
#     shell:
#         """
#         qiime tools export \
#             --input-path {input.taxonomy_qza} \
#             --output-path {TABLES_DIR}/exported-taxonomy
#         """

# rule GG2_biom_to_tsv:
#     input:
#         biom_file = TABLES_DIR / "exported-feature-table/feature-table.biom"
#     output:
#         tsv_file = TABLES_DIR / "exported-feature-table/table.from_biom.tsv"
#     conda:
#         QIIME_CONDA_ENV
#     shell:
#         """
#         biom convert \
#             -i {input.biom_file} \
#             -o {output.tsv_file} \
#             --to-tsv
#         """

# rule GG2_taxa_barplots:
#     input:
#         feature_table_biom = TABLES_DIR / "exported-feature-table/Greengenes2-feature-table.biom",
#         taxonomy_tsv = TABLES_DIR / "exported-taxonomy/Greengenes2_taxonomy.tsv"
#     output:
#         output_dir = TAXA_BARPLOT_DIR / "Greengenes2_taxa_barplots"
#     params:
#         db_name = "Greengenes2"
#     conda:
#         QIIME_CONDA_ENV
#     script:
#         "scripts/make_taxa_barplot.py"