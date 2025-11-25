if len(grouping_column) > 1:
    original_columns = grouping_column.copy()
    grouping_column = [grouping_column[0]]  # keep only the first one
    print(
        f"WARNING: LEfSe only allows one class column. "
        f"Using '{grouping_column[0]}' and dropping the other columns: {original_columns[1:]}"
    )

# Function to generate colors dynamically
def get_colors(metadata_file, group_col="Group"):
    df = pd.read_csv(metadata_file, sep="\t")
    unique_groups = df[group_col].unique()
    palette = sns.color_palette("tab10", len(unique_groups))
    return [sns.utils.rgb2hex(c) for c in palette]

LEFSE_COLORS = get_colors(STUDY_DIR / "metadata.tsv", grouping_column)

# LEfSe intermediate files parameterized by database
def lefse_files(db):
    base = Path(STUDY_DIR) / f"lefse_tmp_files_{db}"
    return {
        "input_tsv": base.with_suffix(".tsv"),
        "lefse_in": base.with_suffix(".in"),
        "lefse_res": base.with_suffix(".res")
    }

# ------------------------------
# Rules
# ------------------------------

rule lefse_input:
    input:
        table_qza = lambda wildcards: f"{STUDY_DIR}/qiime2_artifacts/{wildcards.db}_table.qza",
        taxonomy_qza = lambda wildcards: f"{STUDY_DIR}/qiime2_artifacts/taxonomy_{wildcards.db}.qza",
        metadata = STUDY_DIR / "metadata.tsv"
    output:
        lambda wildcards: lefse_files(wildcards.db)["input_tsv"]
    params:
        class_col = grouping_column
    shell:
        """
        python {WORK_DIR}/scripts/lefse/plugin_lefse_input.py \
            --table_file {input.table_qza} \
            --taxonomy_file {input.taxonomy_qza} \
            --metadata_file {input.metadata} \
            --output_file {output} \
            --class_col {params.class_col}
        """

rule lefse_format:
    input:
        lambda wildcards: lefse_files(wildcards.db)["input_tsv"]
    output:
        lambda wildcards: lefse_files(wildcards.db)["lefse_in"]
    shell:
        f"python {WORK_DIR}/scripts/lefse/plugin_lefse_format.py {{input}} {{output}} -c 1 -o 1000000"

rule lefse_run:
    input:
        lambda wildcards: lefse_files(wildcards.db)["lefse_in"]
    output:
        lambda wildcards: lefse_files(wildcards.db)["lefse_res"]
    shell:
        f"python {WORK_DIR}/scripts/lefse/plugin_lefse_run.py {{input}} {{output}} -l 1.0"

rule lefse_all:
    input:
        lambda wildcards: lefse_files(wildcards.db)["lefse_res"]
    output:
        lda_png=DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_LDA.png",
        cladogram_svg=DIFFERENTIAL_ABUNDANCE_DIR / "{db}" / "LEfSe_Cladogram.svg"
    shell:
        f"""
        mkdir -p {DIFFERENTIAL_ABUNDANCE_DIR}/{wildcards.db}
        python {WORK_DIR}/scripts/lefse/plugin_lefse_barplot.py {input} {output.lda_png} \
            --format png --dpi 300 --colors {' '.join(LEFSE_COLORS)}
        python {WORK_DIR}/scripts/lefse/plugin_lefse_treeplot.py {input} {output.cladogram_svg} \
            --format svg --dpi 300 --right_space_prop 0.95 --left_space_prop 0.05 \
            --colors {' '.join(LEFSE_COLORS)}
        """
