# from .common import get_mf
"""
python prepare_lefse.py \
    --table_file "/web/data/TMU_All/final/table-dada2_mn.qza" \
    --taxonomy_file "/web/data/TMU_All/final/taxonomy.qza" \
    --metadata_file "/web/data/TMU_All/final/sample_metadata_mn.tsv" \
    --output_file "./input_table_mn.tsv" \
    --class_col "group"
"""
import pandas as pd
from qiime2 import Artifact
from qiime2 import Metadata
from qiime2.plugins import feature_table
from qiime2.plugins import taxa
import argparse


def get_mf(metadata):
    """
    Convert a Metadata file or object to a dataframe.

    This method automatically detects the type of input metadata and
    then converts it to a :class:`pandas.DataFrame` object.

    Parameters
    ----------
    metadata : str or qiime2.Metadata
        Metadata file or object.

    Returns
    -------
    pandas.DataFrame
        DataFrame object containing metadata.

    Examples
    --------
    This is a simple example.

    .. code:: python3

        mf = dokdo.get_mf('/Users/sbslee/Desktop/dokdo/data/moving-pictures-tutorial/sample-metadata.tsv')
        mf.head()
        # Will print:
        #           barcode-sequence  body-site  ...  reported-antibiotic-usage  days-since-experiment-start
        # sample-id                              ...
        # L1S8          AGCTGACTAGTC        gut  ...                        Yes                          0.0
        # L1S57         ACACACTATGGC        gut  ...                         No                         84.0
        # L1S76         ACTACGTGTGGT        gut  ...                         No                        112.0
        # L1S105        AGTGCGATGCGT        gut  ...                         No                        140.0
        # L2S155        ACGATGCGACCA  left palm  ...                         No                         84.0
    """
    if isinstance(metadata, str):
        mf = Metadata.load(metadata).to_dataframe()
    elif isinstance(metadata, Metadata):
        mf = metadata.to_dataframe()
    else:
        raise TypeError(f"Incorrect metadata type: {type(metadata)}")
    return mf

def prepare_lefse(
    table_file,
    taxonomy_file,
    metadata_file,
    output_file,
    class_col,
    subclass_col=None,
    subject_col=None,
    where=None,
    level=6,
):
    """Create a TSV file which can be used as input for the LEfSe tool.

    This command
    1) collapses the input feature table at the given taxonomic `level`
       (QIIME 2 rank index: 6 = genus, 7 = species),
    2) computes relative frequency of the features,
    3) performs sample filtration if requested,
    4) changes the format of feature names,
    5) adds the relevant metadata as 'Class', 'Subclass', and 'Subject', and
    6) writes a text file which can be used as input for LEfSe.

    Parameters
    ----------
    table_file : str
        Path to the table file with the 'FeatureTable[Frequency]' type.
    taxonomy_file : str
        Path to the taxonomy file with the 'FeatureData[Taxonomy]' type.
    metadata_file : str
        Path to the metadata file.
    output_file : str
        Path to the output file.
    class_col : str
        Metadata column used as 'Class' by LEfSe.
    subclass_col : str, optional
        Metadata column used as 'Subclass' by LEfSe.
    subject_col : str, optional
        Metadata column used as 'Subject' by LEfSe.
    where : str, optional
        SQLite 'WHERE' clause specifying sample metadata criteria.
    """
    _ = taxa.methods.collapse(
        table=Artifact.load(table_file), taxonomy=Artifact.load(taxonomy_file), level=level
    )

    _ = feature_table.methods.relative_frequency(table=_.collapsed_table)

    if where is None:
        df = _.relative_frequency_table.view(pd.DataFrame)
    else:
        _ = feature_table.methods.filter_samples(
            table=_.relative_frequency_table,
            metadata=Metadata.load(metadata_file),
            where=where,
        )
        df = _.filtered_table.view(pd.DataFrame)

    def f(x):
        for c in ["-", "[", "]", "(", ")", " "]:
            x = x.replace(c, "_")

        ranks = x.split(";")
        base = ranks[0]
        result = [base]

        for i, rank in enumerate(ranks[1:], start=2):
            if rank == "__":
                result.append(f"{base}_x__L{i}")
            elif rank.split("__")[1] == "":
                result.append(f"{base}_{rank}L{i}")
            else:
                result.append(rank)
                base = rank

        return "|".join(result)

    df.columns = [f(x) for x in df.columns.to_list()]

    mf = get_mf(metadata_file)
    mf = mf.replace(" ", "_", regex=True)
    cols = mf.columns.to_list()
    df = pd.concat([df, mf], axis=1, join="inner")
    df.insert(0, class_col, df.pop(class_col))
    cols.remove(class_col)

    if subclass_col is None and subject_col is None:
        pass
    elif subclass_col is not None and subject_col is None:
        df.insert(1, subclass_col, df.pop(subclass_col))
        cols.remove(subclass_col)
    elif subclass_col is None and subject_col is not None:
        df.insert(1, subject_col, df.pop(subject_col))
        cols.remove(subject_col)
    else:
        df.insert(1, subclass_col, df.pop(subclass_col))
        df.insert(2, subject_col, df.pop(subject_col))
        cols.remove(subclass_col)
        cols.remove(subject_col)

    df.drop(columns=cols, inplace=True)
    df.T.to_csv(output_file, header=False, sep="\t")


def main():
    parser = argparse.ArgumentParser(description="Prepare LEfSe input")
    parser.add_argument(
        "--table_file", type=str, required=True, help="Path to the table file"
    )
    parser.add_argument(
        "--taxonomy_file", type=str, required=True, help="Path to the taxonomy file"
    )
    parser.add_argument(
        "--metadata_file", type=str, required=True, help="Path to the metadata file"
    )
    parser.add_argument(
        "--output_file", type=str, required=True, help="Path to the output file"
    )
    parser.add_argument(
        "--class_col", type=str, required=True, help="Column name for class grouping"
    )
    parser.add_argument(
        "--level",
        type=int,
        default=6,
        help="QIIME 2 taxa collapse level (6 = genus, 7 = species)",
    )

    args = parser.parse_args()

    prepare_lefse(
        args.table_file,
        args.taxonomy_file,
        args.metadata_file,
        args.output_file,
        args.class_col,
        level=args.level,
    )
    print("LEfSe input preparation completed.")


if __name__ == "__main__":
    main()
