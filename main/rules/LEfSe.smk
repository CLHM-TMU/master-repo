import pandas as pd
import seaborn as sns
from matplotlib.colors import to_hex

# Function to generate colors dynamically
def get_colors(metadata_file, group_col="Group"):
    df = pd.read_csv(metadata_file, sep="\t")
    unique_groups = df[group_col].unique()
    palette = sns.color_palette("tab10", len(unique_groups))
    return [to_hex(c) for c in palette]

# List of hex colors
LEFSE_COLORS = get_colors(STUDY_DIR / "metadata.tsv", group_columns[0])
print("LEFSE_COLORS =", LEFSE_COLORS)

# ------------------------------
# Rules
# ------------------------------


rule plugin_lefse_input:
    input:
        table_qza = select_table,
        taxonomy_qza = QIIME_DIR / "{db}-taxonomy.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        lefse_tsv = TMP_DIR / "lefse_tmp_table_{db}.tsv"  
    conda:
        QIIME_CONDA_ENV
    params:
        class_col = group_columns[0]
    shell:
        """
        echo "Using {input.metadata} with class column '{params.class_col}' for LEfSe analysis."
        echo "Using {input.table_qza} and {input.taxonomy_qza} to generate LEfSe input table..."
        python {MAIN_DIR}/scripts/lefse/plugin_lefse_input.py \
            --table_file {input.table_qza} \
            --taxonomy_file {input.taxonomy_qza} \
            --metadata_file {input.metadata} \
            --output_file {output} \
            --class_col {params.class_col}
        """


rule lefse_format:
    input:
        lefse_tsv = TMP_DIR / "lefse_tmp_table_{db}.tsv" 
    output:
        lefse_in = TMP_DIR / "lefse_tmp_table_{db}.in"
    conda:
        QIIME_CONDA_ENV
    shell:
        "python {MAIN_DIR}/scripts/lefse/plugin_lefse_format.py {input.lefse_tsv} {output.lefse_in} -c 1 -o 1000000"

rule lefse_run:
    input:
        lefse_in = TMP_DIR / "lefse_tmp_table_{db}.in"
    output:
        lefse_res = TMP_DIR / "lefse_tmp_table_{db}.res"
    conda:
        QIIME_CONDA_ENV
    shell:
        "python {MAIN_DIR}/scripts/lefse/plugin_lefse_run.py {input.lefse_in} {output.lefse_res} -l 1.0"

rule lefse_barplot_cladogram:
    input:
        lefse_res = TMP_DIR / "lefse_tmp_table_{db}.res"
    output:
        lda_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_LDA.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_Cladogram.svg"
    params:
        colors = " ".join(f"'{c}'" for c in LEFSE_COLORS)
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        mkdir -p {DIFFERENTIAL_ABUNDANCE_DIR}/{wildcards.db}
        python {MAIN_DIR}/scripts/lefse/plugin_lefse_barplot.py \
            {input.lefse_res} {output.lda_svg} \
            --format png --dpi 300 \
            --colors {params.colors}

        python {MAIN_DIR}/scripts/lefse/plugin_lefse_treeplot.py \
            {input.lefse_res} {output.cladogram_svg} \
            --format svg --dpi 300 \
            --right_space_prop 0.95 --left_space_prop 0.05 \
            --colors {params.colors}
        """
