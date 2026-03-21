#!/bin/bash
# Code to run Kraken-all-db

for r1 in *_R1_001.fastq.gz; do
    sample=$(basename "$r1" | sed 's/_R1_001.fastq.gz//')
    r2=${sample}_R2_001.fastq.gz

    if [[ -f $r2 ]]; then
        echo "Processing sample: $sample"
        kraken2 --db ~/Viralrecon/COVID/references/kraken2-all-db \
            --threads 4 \
            --paired $r1 $r2 \
            --report ~/Viralrecon/COVID/Waste_Water/WW_B7/API13582-152651_fastq_100724/kraken_results/${sample}_kraken_report.txt \
            --output ~/Viralrecon/COVID/Waste_Water/WW_B7/API13582-152651_fastq_100724/kraken_results/${sample}_kraken_output.txt
    else
        echo "Warning: Missing paired file for sample $sample"
    fi
done
