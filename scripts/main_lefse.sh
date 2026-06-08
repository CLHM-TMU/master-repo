#!/bin/bash
# Created on 04/10/2025
# @author: Joseph, PetSci, petsci.tw
# version: EN2.0
    
ROOT_PATH="/data/data/TMU_workshop"
DATE_OF_FOLDER="251011"
OUTPUT_PATH="${ROOT_PATH}/${DATE_OF_FOLDER}/04-FunctionAndBiomarker"
COLUMN_OF_GROUP_NAME=("group")
COLORS=("#19456e" "#8f3339") 

mkdir -p "${OUTPUT_PATH}"

python ${ROOT_PATH}/lefse/plugin_lefse_input.py \
    --table_file "${ROOT_PATH}/4_table.qza" \
    --taxonomy_file "${ROOT_PATH}/5_taxonomy.qza" \
    --metadata_file "${ROOT_PATH}/0_sample_metadata_lefse.txt" \
    --output_file "${ROOT_PATH}/8_lefse_input_table.tsv" \
    --class_col "${COLUMN_OF_GROUP_NAME}" 

python ${ROOT_PATH}/lefse/plugin_lefse_format.py \
    "${ROOT_PATH}/8_lefse_input_table.tsv" \
    "${ROOT_PATH}/8_lefse_input_table.in" \
    -c 1 -o 1000000    

python ${ROOT_PATH}/lefse/plugin_lefse_run.py \
   "${ROOT_PATH}/8_lefse_input_table.in" \
   "${ROOT_PATH}/8_lefse_input_table.res" \
    -l 2.0

python ${ROOT_PATH}/lefse/plugin_lefse_barplot.py \
    "${ROOT_PATH}/8_lefse_input_table.res" \
    "${OUTPUT_PATH}/LEfSe LDA.png" \
    --format png \
    --dpi 300 \
    --colors "${COLORS[@]}"

python ${ROOT_PATH}/lefse/plugin_lefse_treeplot.py \
    "${ROOT_PATH}/8_lefse_input_table.res" \
    "${OUTPUT_PATH}/LEfSe Cladogram.png" \
    --format png  \
    --dpi 300 \
    --colors "${COLORS[@]}"