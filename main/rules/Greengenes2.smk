if region == "V3V4":
    rule GG2_V3V4:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs.qza"
            greengenes_db = REF_DIR / "Greengenes2" / "2024.09.backbone.full-length.fna.qza"
        output:
            taxonomy = QIIME_DIR / "taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "taxonomy.qzv"
        conda:
            GREENGENES2_CONDA_ENV  
        shell:
            """
            echo "Classifying sequences using Greengenes 2 V3V4 database..."
            qiime greengenes non-v4-16S \
                --i-table QIIME_DIR / "table.qza" \
                --i-sequences {input.rep_seqs} \
                --i-backbone {input.greengenes_db} \
                --p-threads 6 \
                --o-taxonomy {output.taxonomy}
            
            echo "Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}
            """
elif region == "Full":
    rule GG2_Full:
        input:
            rep_seqs = QIIME_DIR / "rep-seqs.qza"
            greengenes_db = REF_DIR / "Greengenes2" / "2024.09.backbone.full-length.fna.qza"
        output:
            taxonomy = QIIME_DIR / "taxonomy.qza",
            taxonomy_qzv = QIIME_DIR / "taxonomy.qzv"
        conda:
            GREENGENES2_CONDA_ENV  
        shell:
            """
            echo "Classifying sequences using Greengenes 2 V3V4 database..."
            qiime greengenes non-v4-16S \
                --i-table QIIME_DIR / "table.qza" \
                --i-sequences {input.rep_seqs} \
                --i-backbone {input.greengenes_db} \
                --p-threads 6 \
                --o-taxonomy {output.taxonomy}
            
            echo "Generating taxonomy visualization..."
            qiime metadata tabulate \
                --m-input-file {output.taxonomy} \
                --o-visualization {output.taxonomy_qzv}