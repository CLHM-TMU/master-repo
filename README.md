# Core Laboratory of Human Microbiome @ Taipei Medical University

Our lab provides end-to-end services from storing biological samples to publication-ready reports. This includes step like DNA extraction, artefact creation, taxa classification, diversity + phylogenetic analysis, and functional metabolomics prediction. Currently we handle:
* Next Generation Sequencing (16S V3-V4 rRNA)
* Third Generation Sequencing (16S Full Length)
* Shotgun Metagenomics
* Anaerobic Bacterium Cultivation


For more details, please visit [our landing page](https://microbiome-in-tmu.mystrikingly.com).

## Table of Contents

This repository consists of three branches.
* __'main'__: This holds the analysis pipeline. This also holds 'config.yaml' which you will need to edit to fit the details of your project scope. Data provenance is tracked via Snakemake.
* __'work'__: This is the staging directory for both your raw data and your expected output plots, artefacts, tables. 
* __'references'__: This holds reference genomic/phylogenetic databases used by the analysis pipeline. Version control of this must be maintained by the user themselves. 

## Current Supported Databass
* Greengenes2
Coming (Silva128)

## Naming Convention Guide
It is suggested to keep your naming convention simple: use hyphens for QIIME2 artefacts(.qza, .qzv) and underscores for everything else (.tsv, .csv) so you know which files are meant to be only processed via QIIME2.

## Local Environment Guide
If you are using this pipeline locally on MacOS without root access, set the ENVIRONMENT_TYPE variable in config.yaml to 'conda'.
If you are using this pipeline locally on Windows, you have two options:
* Use Docker -> set the ENVIRONMENT_TYPE variable in config.yaml to 'docker'
* Install [WSL2](https://learn.microsoft.com/en-us/windows/wsl/about) -> if it's compatible with your machine, you can run the pipeline with the 'conda' ENVIRONMENT_TYPE.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
