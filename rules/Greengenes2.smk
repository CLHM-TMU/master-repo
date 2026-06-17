GREENGENES2_CONDA_ENV = WORKFLOW_DIR / "envs/qiime2-2025.10-amplicon-Greengenes2.yaml"


if region == "region_V3V4":
    rule GG2_V3V4_taxonomy:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs-analysis.qza",
            greengenes_nb_classifier = REF_DIR / "Greengenes2" / "2024.09.custom.V3V4.nb.qza"
        output:
            taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "Greengenes2-taxonomy.qzv",
            sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
        conda:
            GREENGENES2_CONDA_ENV
        message:
            "[GG2] Classifying 16S region V3V4 sequences using Greengenes2 Naive Bayes Classifier..."
        shell:
            """
            qiime feature-classifier classify-sklearn \
                --i-classifier {input.greengenes_nb_classifier} \
                --i-reads {input.rep_seqs} \
                --o-classification {output.taxonomy}
            echo "[GG2] Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            touch {output.sentinel}
            """

    rule GG2_collapse_to_genus:
        input:
            table    = QIIME_DIR / "table-analysis.qza",
            taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
            sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
        output:
            genus_table = QIIME_DIR / "Greengenes2-genus-table-collapsed.qza",
            sentinel    = QIIME_DIR / ".Greengenes2_genus_collapsed_done"
        conda:
            QIIME_CONDA_ENV
        message:
            "[GG2] Collapsing NGS ASV table to genus level (Greengenes2 rank 6)..."
        shell:
            """
            qiime taxa collapse \
                --i-table {input.table} \
                --i-taxonomy {input.taxonomy} \
                --p-level 6 \
                --o-collapsed-table {output.genus_table}
            touch {output.sentinel}
            """

    rule GG2_export_genus_biom:
        input:
            genus_table_qza = QIIME_DIR / "Greengenes2-genus-table-collapsed.qza",
            sentinel        = QIIME_DIR / ".Greengenes2_genus_collapsed_done"
        output:
            genus_biom = TABLES_DIR / "study-seqs-genus.biom"
        conda:
            QIIME_CONDA_ENV
        message:
            "[GG2] Exporting NGS genus-collapsed feature table BIOM format..."
        shell:
            """
            qiime tools export \
                --input-path {input.genus_table_qza} \
                --output-path {TABLES_DIR}/exported_genus_temp
            mv {TABLES_DIR}/exported_genus_temp/feature-table.biom {output.genus_biom}
            rm -r {TABLES_DIR}/exported_genus_temp
            """

    rule GG2_export_genus_taxonomy_as_tsv:
        input:
            taxonomy_qza = QIIME_DIR / "Greengenes2-taxonomy.qza",       # Fixed: was using genus_biom
            sentinel     = QIIME_DIR / ".Greengenes2_taxonomy_done"
        output:
            genus_taxonomy_tsv = TABLES_DIR / "exported-taxonomy" / "Greengenes2_genus_taxonomy.tsv"
        conda:
            QIIME_CONDA_ENV
        message:
            "[GG2] Exporting genus-collapsed taxonomy BIOM to TSV..."
        shell:
            """
            qiime tools export \
                --input-path {input.taxonomy_qza} \
                --output-path {TABLES_DIR}/exported-taxonomy-genus-temp
            mv {TABLES_DIR}/exported-taxonomy-genus-temp/taxonomy.tsv \
               {output.genus_taxonomy_tsv}
            rm -r {TABLES_DIR}/exported-taxonomy-genus-temp
            """

    rule GG2_export_genus_rep_seqs_to_fna:
        input:
            rep_seqs_qza = QIIME_DIR / "rep-seqs-analysis.qza"
        output:
            genus_rep_seqs_fna = TABLES_DIR / "study-seqs-genus.fna"
        conda:
            QIIME_CONDA_ENV
        message:
            "[GG2] Exporting genus-collapsed representative sequences to FASTA..."
        shell:
            """
            qiime tools export \
                --input-path {input.rep_seqs_qza} \
                --output-path {TABLES_DIR}/exported_genus_seqs_temp
            mv {TABLES_DIR}/exported_genus_seqs_temp/dna-sequences.fasta {output.genus_rep_seqs_fna}
            rm -r {TABLES_DIR}/exported_genus_seqs_temp
            """

elif region == "full_length":
    rule GG2_Full_taxonomy:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs-analysis.qza",
            greengenes_nb_classifier = REF_DIR / "Greengenes2" / "2024.09.backbone.full-length.nb.qza"
        output:
            taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "Greengenes2-taxonomy.qzv",
            sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
        conda:
            GREENGENES2_CONDA_ENV
        message:
            "[GG2] Classifying 16S Full-length sequences using Greengenes2 Naive Bayes Classifier..."
        shell:
            """
            qiime feature-classifier classify-sklearn \
                --i-classifier {input.greengenes_nb_classifier} \
                --i-reads {input.rep_seqs} \
                --o-classification {output.taxonomy}
            echo "[GG2] Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            touch {output.sentinel}
            """


rule GG2_phylogeny:
    input:
        table = QIIME_DIR / "table-analysis.qza",
        rep_seqs = QIIME_DIR / "rep-seqs-analysis.qza",
        greengenes_db = REF_DIR / "Greengenes2" / "2024.09.backbone.full-length.fna.qza",
        sentinel = QIIME_DIR / ".Greengenes2_taxonomy_done"
    output:
        phylogeny_table = QIIME_DIR / "Greengenes2-table.qza",
        phylogeny_rep_seqs = QIIME_DIR / "Greengenes2-rep-seqs.qza",
        sentinel = QIIME_DIR / ".Greengenes2_phylogeny_done"
    conda:
        GREENGENES2_CONDA_ENV
    message:
        "[GG2] Building phylogenetic tree for 16S (V3V4/Full-length) sequences using default Greengenes2 SEPP method..."
    shell:
        """
        qiime greengenes2 non-v4-16s \
            --i-table {input.table} \
            --i-sequences {input.rep_seqs} \
            --i-backbone {input.greengenes_db} \
            --o-mapped-table {output.phylogeny_table} \
            --o-representatives {output.phylogeny_rep_seqs}
        touch {output.sentinel}
        """

rule GG2_generate_taxa_barplot_qiime:
    input:
        table = QIIME_DIR / "table-analysis.qza",
        taxonomy = QIIME_DIR / "Greengenes2-taxonomy.qza",
        metadata = metadata_path
    output:
        barplot_qzv = QIIME_DIR / "Greengenes2-taxa-bar-plots.qzv",
        sentinel = QIIME_DIR / ".Greengenes2_taxa_barplot_done"
    conda:
        GREENGENES2_CONDA_ENV
    message:
        "[GG2] Generating Greengenes2 QIIME taxa barplot visualization..."
    shell:
        """
        qiime taxa barplot \
            --i-table {input.table} \
            --i-taxonomy {input.taxonomy} \
            --m-metadata-file {input.metadata} \
            --o-visualization {output.barplot_qzv}
        touch {output.sentinel}
        """


rule GG2_export_taxonomy_as_tsv:
    input:
        taxonomy_qza = QIIME_DIR / "Greengenes2-taxonomy.qza"
    output:
        taxonomy = TABLES_DIR / "exported-taxonomy" / "Greengenes2_taxonomy.tsv"
    conda:
        QIIME_CONDA_ENV
    message:
        "[GG2] Exporting Greengenes2 taxonomy as TSV..."
    shell:
        """
        qiime tools export \
            --input-path {input.taxonomy_qza} \
            --output-path {TABLES_DIR}/exported-taxonomy

        # Rename exported taxonomy file to your expected filename
        mv {TABLES_DIR}/exported-taxonomy/taxonomy.tsv \
           {output.taxonomy}
        """

rule GG2_plot_taxa_barplot:
    input:
        table_biom = TABLES_DIR / "study-seqs.biom",
        taxonomy_tsv = TABLES_DIR / "exported-taxonomy/Greengenes2_taxonomy.tsv"
    output:
        plot_samples     = str(TAXA_BARPLOT_DIR / "{db}" / "taxa_barplot_{taxa_level}_by_{factor}_samples.svg"),
        plot_groups      = str(TAXA_BARPLOT_DIR / "{db}" / "taxa_barplot_{taxa_level}_by_{factor}_groups.svg"),
        plot_samples_png = str(TAXA_BARPLOT_DIR / "{db}" / "taxa_barplot_{taxa_level}_by_{factor}_samples.png"),
        plot_groups_png  = str(TAXA_BARPLOT_DIR / "{db}" / "taxa_barplot_{taxa_level}_by_{factor}_groups.png")
    message:
        "Plotting taxa barplot for level={wildcards.taxa_level}, factor={wildcards.factor}, db={wildcards.db}"
    params:
        group_by = "{factor}",
        taxa_level = "{taxa_level}",
        database = "{db}",
        top_n_taxa_shown_on_barplot = top_n_taxa,
        metadata_tsv = metadata_path,
    conda:
        QIIME_CONDA_ENV
    script:
        SCRIPTS_DIR / "plot_taxa_barplot_levels.py"