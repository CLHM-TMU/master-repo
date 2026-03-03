import pandas as pd
import seaborn as sns
from matplotlib.colors import to_hex
# ------------------------------
# Color mapping for a given group_col (from wildcard)
# ------------------------------
def get_colors(metadata_file, group_col="Group", palette_name="tab10"):
    """
    Generate a color for each unique group in metadata.

    Args:
        metadata_file (str or Path): Path to metadata.tsv.
        group_col (str): Column name for grouping.
        palette_name (str): Name of seaborn/matplotlib palette.

    Returns:
        dict: Mapping of group name -> hex color.
        list: List of colors in the same order as groups.
    """
    df = pd.read_csv(metadata_file, sep="\t")
    groups = df[group_col].unique()
    
    # Generate a palette with as many colors as groups
    palette = sns.color_palette(palette_name, n_colors=len(groups))
    hex_colors = [to_hex(c) for c in palette]
    
    # Map group to color
    color_map = dict(zip(groups, hex_colors))
    
    return color_map, hex_colors
    
# ------------------------------
# Rules
# ------------------------------
rule plugin_lefse_input:
    input:
        table_qza = QIIME_DIR / "table-dada2.qza",
        taxonomy_qza = QIIME_DIR / "{db}-taxonomy.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        lefse_tsv = TMP_DIR / "lefse_tmp_table_{db}_{group_col}.tsv"
    params:
        class_col = "{group_col}"
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        mkdir -p {TMP_DIR}
        python {WORKFLOW_DIR}/scripts/lefse/plugin_lefse_input.py \
            --table_file {input.table_qza} \
            --taxonomy_file {input.taxonomy_qza} \
            --metadata_file {input.metadata} \
            --output_file {output.lefse_tsv} \
            --class_col {wildcards.group_col}
        """

rule lefse_format:
    input:
        lefse_tsv = TMP_DIR / "lefse_tmp_table_{db}_{group_col}.tsv"
    output:
        lefse_in = TMP_DIR / "lefse_tmp_table_{db}_{group_col}.in"
    conda:
        QIIME_CONDA_ENV
    shell:
        "python {WORKFLOW_DIR}/scripts/lefse/plugin_lefse_format.py {input.lefse_tsv} {output.lefse_in} -c 1 -o 1000000"

rule lefse_run:
    input:
        lefse_in = TMP_DIR / "lefse_tmp_table_{db}_{group_col}.in"
    output:
        lefse_res = TMP_DIR / "lefse_tmp_table_{db}_{group_col}.res"
    conda:
        QIIME_CONDA_ENV
    shell:
        "python {WORKFLOW_DIR}/scripts/lefse/plugin_lefse_run.py {input.lefse_in} {output.lefse_res} -a 0.05 -w 0.05 -l 3.0"

rule lefse_barplot_cladogram:
    input:
        lefse_res = TMP_DIR / "lefse_tmp_table_{db}_{group_col}.res"
    output:
        lda_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_LDA_by_{group_col}.svg",
        cladogram_svg = DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_Cladogram_by_{group_col}.svg"
    params:
        colors=lambda wildcards: " ".join(
            f"'{c}'" for c in get_colors(STUDY_DIR / "metadata.tsv", wildcards.group_col)[1]
        )
    conda:
        QIIME_CONDA_ENV
    shell:
        """
        mkdir -p {DIFFERENTIAL_ABUNDANCE_DIR}/{wildcards.db}
        python {WORKFLOW_DIR}/scripts/lefse/plugin_lefse_barplot.py \
            {input.lefse_res} {output.lda_svg} \
            --format svg --dpi 600 \
            --colors {params.colors}

        python {WORKFLOW_DIR}/scripts/lefse/plugin_lefse_treeplot.py \
            {input.lefse_res} {output.cladogram_svg} \
            --format svg --dpi 300 \
            --right_space_prop 0.95 --left_space_prop 0.05 \
            --colors {params.colors}
        """
