#!/bin/bash
# Script name: coverage_per_amplicon_all_water.sh

# Define the output file for combined coverage data
combined_output="water_output_trim_0_MZ617374.1.txt"

# Ensure the combined output file is empty before starting
> "$combined_output"

# Path to your amplicon BED file
bed_file="/home/ubuntu/Viralrecon/COVID/references/HRTV_references/MZ617374.1_primer_edit.bed"

# Loop through each BAM file and calculate coverage per amplicon
for bam_file in *.sorted.bam; do
    sample_name=$(basename "$bam_file" .sorted.bam)
    echo "Coverage for $sample_name" >> "$combined_output"
    samtools bedcov "$bed_file" "$bam_file" | awk -v sample="$sample_name" '{print sample, $0}' >> "$combined_output"
    echo "" >> "$combined_output"
done
