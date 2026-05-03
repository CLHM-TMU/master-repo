# Core Laboratory of Human Microbiome @ Taipei Medical University

Our lab provides end-to-end services from storing biological samples to publication-ready reports. This includes step like DNA extraction, artefact creation, taxa classification, diversity + phylogenetic analysis, and functional metabolomics prediction. Currently we handle:
* Next Generation Sequencing (16S V3-V4 rRNA)
* Third Generation Sequencing (16S Full Length)
* Shotgun Metagenomics
* Anaerobic Bacterium Cultivation


For more details, please visit [our landing page](https://microbiome-in-tmu.mystrikingly.com).

## Table of Contents

* __main__: Store your project specific data here by folder
* __reference__: Store your taxonomy or phylogenetic reference db here
* __config__: Store your project specific analysis configuration file (.yaml) here. Match name with project folder in __main__


## Currently Supported Taxonomic Database
* Greengenes2

## Currently Supported Functional Prediction Database
* PICRUST2

## Currently Supported Differential Analysis Methods
* LEfSe
(Note that at this time ANCOMBC2 and ALDEX2 are under maintenance, outputs it generate might not be statistically robust)

## Upcoming Features
* Silva138 Database

## Naming Convention Guide
It is suggested to keep your naming convention simple, i.e. use hyphens for QIIME2 artefacts(.qza, .qzv) and underscores for everything else (.tsv, .csv) so you know which files are meant to be only processed via QIIME2.

## Environment Guide
This is the MacOS repository, run via Rosetta simulation to cater to QIIME2's quirks. Additionally, if using Snakemake to produce environments via yaml files, specify the __--conda-frontend conda__ flag to avoid Mamba specific bugs.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
