# Core Laboratory of Human Microbiome @ Taipei Medical University

Our lab provides end-to-end services from storing biological samples to publication-ready reports. This includes step like DNA extraction, artefact creation, taxa classification, diversity + phylogenetic analysis, and functional metabolomics prediction. Currently we handle:
* Next Generation Sequencing (16S V3-V4 rRNA)
* Third Generation Sequencing (16S Full Length)
* Shotgun Metagenomics
* Anaerobic Bacterium Cultivation


For more details, please visit [our landing page](https://microbiome-in-tmu.mystrikingly.com).

## Table of Contents

This repository consists of three branches.
* __'workflow'__: This holds the analysis pipeline. This also holds 'config.yaml' which you will need to edit to fit the details of your project scope. Data provenance is tracked via Snakemake.
* __'main'__: This is the storing directory for both your raw data and your expected output plots, artefacts, tables. 
* __'references'__: This holds reference genomic/phylogenetic databases used by the analysis pipeline. Version control of this must be maintained by the user themselves. 

## Currently Supported Taxonomic Database
* Greengenes2

## Currently Supported Functional Prediction Database
* PICRUST2

## Upcoming Features
* Silva138 Database

## Naming Convention Guide
It is suggested to keep your naming convention simple, i.e. use hyphens for QIIME2 artefacts(.qza, .qzv) and underscores for everything else (.tsv, .csv) so you know which files are meant to be only processed via QIIME2.

## Environment Guide
This is the MacOS repository, run via Rosetta simulation to cater to QIIME2's quirks. When creating a conda env from the yaml, make sure it is not in anything but osx-64.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
