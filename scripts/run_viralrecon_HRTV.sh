#!/bin/bash

# List of Influenza segment accession numbers
segments=("MZ617374.1" "MZ617375.1" "MZ617376.1")

# List of input CSV files to iterate over
input_files=("samples_input.csv" "water_input.csv")

# Base paths
base_path="/home/ubuntu/Viralrecon/COVID/references"
kraken2_db="${base_path}/kraken2-all-db"
fasta_path="${base_path}/HRTV_references"

# Iterate over each segment and run Viralrecon for each input file
for segment in "${segments[@]}"
do
    for input_file in "${input_files[@]}"
    do
        outdir="${input_file%_input.csv}_output_trim_0_${segment}"
        fasta_file="${fasta_path}/${segment}_reference.fasta"

        /home/ubuntu/nextflow run nf-core/viralrecon -r 2.6.0 \
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
