
if region == "region_V3V4":
    rule Silva138_V3V4_taxonomy:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
            silva138_nb_classifier = REF_DIR / "Silva138" / "2024.09.custom.V3V4.nb.qza"
        output:
            taxonomy = QIIME_DIR / "Silva138-taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "Silva138-taxonomy.qzv",
            sentinel = QIIME_DIR / ".Silva138_taxonomy_done"
        conda:
            QIIME_CONDA_ENV  
        shell:
            """
            echo "Classifying 16S region V3V4 sequences using Silva138 Naive Bayes Classifier..."
            qiime feature-classifier classify-sklearn \
                --i-classifier {input.silva138_nb_classifier} \
                --i-reads {input.rep_seqs} \
                --o-classification {output.taxonomy}
            echo "Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            touch {output.sentinel}
            """

elif region == "full_length":
    rule Silva138_Full_taxonomy:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
            silva138_nb_classifier = REF_DIR / "Silva138" / "2024.09.backbone.full-length.nb.qza"
        output:
            taxonomy = QIIME_DIR / "Silva138-taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "Silva138-taxonomy.qzv",
            sentinel = QIIME_DIR / ".Silva138_taxonomy_done"
        conda:
            Silva138_CONDA_ENV  
        shell:
            """
            echo "Classifying 16S Full-length sequences using Silva138 Naive Bayes Classifier..."
            qiime feature-classifier classify-sklearn \
                --i-classifier {input.silva138_nb_classifier} \
                --i-reads {input.rep_seqs} \
                --o-classification {output.taxonomy}
            echo "Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            touch {output.sentinel}
            """

rule Silva138_phylogeny:
    input:
        table = QIIME_DIR / "table-dada2.qza",
        rep_seqs = QIIME_DIR / "rep-seqs-dada2.qza",
        silva138_db = REF_DIR / "Silva138" / "2024.09.backbone.full-length.fna.qza",
        sentinel = QIIME_DIR / ".Silva138_taxonomy_done"
    output:
        phylogeny_table = QIIME_DIR / "Silva138-table.qza",
        phylogeny_rep_seqs = QIIME_DIR / "Silva138-rep-seqs.qza",
        sentinel = QIIME_DIR / ".Silva138_phylogeny_done"
    conda:
        Silva138_CONDA_ENV  
    shell:
        """
        echo "Building phylogenetic tree for 16S (V3V4 or Full-length) sequences using Silva138 database..."
        qiime Silva138 non-v4-16s \
            --i-table {input.table} \
            --i-sequences {input.rep_seqs} \
            --i-backbone {input.silva138_db} \
            --p-threads 6 \
            --o-mapped-table {output.phylogeny_table} \
            --o-representatives {output.phylogeny_rep_seqs}
        touch {output.sentinel}
        """

rule Silva138_taxa_barplot_qiime:
    input:
        table = QIIME_DIR / "table-dada2.qza",           
        taxonomy = QIIME_DIR / "Silva138-taxonomy.qza",
        metadata = metadata_path    
    output:
        barplot_qzv = QIIME_DIR / "Silva138-taxa-bar-plots.qzv",
        sentinel = QIIME_DIR / ".Silva138_taxa_barplot_done"
    conda:
        Silva138_CONDA_ENV
    shell:
        """
        echo "Generating QIIME taxa barplot visualization..."
        qiime taxa barplot \
            --i-table {input.table} \
            --i-taxonomy {input.taxonomy} \
            --m-metadata-file {input.metadata} \
            --o-visualization {output.barplot_qzv}
        touch {output.sentinel}
        """

# Below is WIP for making custom taxa barplots using exported data
rule Silva138_export_feature_table:
    input:
        table_qza = QIIME_DIR / "table-dada2.qza"
    output:
        biom = TABLES_DIR / "exported-feature-table" / "feature-table.biom"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        qiime tools export \
            --input-path {input.table_qza} \
            --output-path {TABLES_DIR}/exported-feature-table
        """

rule GG2_export_taxonomy:
    input:
        taxonomy_qza = QIIME_DIR / "Silva138-taxonomy.qza"
    output:
        taxonomy = TABLES_DIR / "exported-taxonomy" / "Silva138_taxonomy.tsv"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        # Export QIIME taxonomy directory
        qiime tools export \
            --input-path {input.taxonomy_qza} \
            --output-path {TABLES_DIR}/exported-taxonomy

        # Rename exported taxonomy file to your expected filename
        mv {TABLES_DIR}/exported-taxonomy/taxonomy.tsv \
           {output.taxonomy}
        """


rule Silva138_taxa_barplots_custom:
    input:
        feature_table_biom_dir = directory(TABLES_DIR / "exported-feature-table"),
        taxonomy_tsv = TABLES_DIR / "exported-taxonomy/Silva138_taxonomy.tsv"
    output:
        TAXA_BARPLOT_DIR / "Silva138" / "taxa_barplot_{level}_by_{factor}.png"
    params:
        db_name = "Silva138",
        top_n_taxa_shown_on_barplot = 20
    conda:
        QIIME_CONDA_ENV
    script:
        SCRIPTS_DIR / "make_taxa_barplot.py"
