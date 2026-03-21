#!/bin/bash

# List of segment accession numbers including original Influenza segments and Batch 9 & 10 references
segments=(
    "CY121686" "NC_026435" \
    "CY003687" "CY003681" "CY003686" "MN055355" \
    "KX058884" "KC866605" "KC866604" \
    "MH594442" "OQ171937" "MH685715" "OM857267" "MT107528" "KJ939919" \
    "NC_045512"
)

# List of input CSV files to iterate over
input_files=("samples_input.csv" "water_input.csv" "undetermined_input.csv")

# Base paths
base_path="/home/ubuntu/Viralrecon/COVID/references"
kraken2_db="${base_path}/Kraken2"
fasta_path="${base_path}/RSV_INF_references"

# Iterate over each segment and run Viralrecon for each input file
for segment in "${segments[@]}"; do
    base_acc=$(echo "$segment" | cut -d'.' -f1)
    fasta_file="${fasta_path}/${base_acc}.fasta"

    for input_file in "${input_files[@]}"; do
        outdir="${input_file%_input.csv}_output_trim_0_${segment}"

        nextflow run nf-core/viralrecon -r 2.6.0 \
            --max_cpus 94 \
            --max_memory '370.GB' \
            --input "$input_file" \
            --outdir "$outdir" \
            --platform illumina \
            --protocol metagenomic \
            --fasta "$fasta_file" \
            --kraken2_db "$kraken2_db" \
            --save_reference false \
            --variant_caller 'ivar' \
            --ivar_trim_offset 5 \
            --skip_assembly \
            --skip_nextclade \
            -profile docker \
            -with-docker nfcore/virarecon
    done
done
