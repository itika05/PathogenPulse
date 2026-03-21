# Metagenomics Filtering Guide

## Overview

When running the metagenomic protocol, additional filtering and classification steps are used to identify and characterize viral reads from complex samples.

## Workflow

1. **Kraken2 Classification** -- Classify all reads against a comprehensive database
2. **Read Filtering** -- Extract reads matching target pathogens
3. **Viralrecon Analysis** -- Run variant calling on filtered reads

## Running Kraken2

Use `scripts/kraken2_run.sh` to classify paired-end reads:

```bash
cd /path/to/fastqs
bash scripts/kraken2_run.sh
```

## Interpreting Results

Kraken2 reports contain taxonomic classification at multiple levels. Key columns:
- Percentage of reads classified at this taxon
- Number of reads classified at this taxon
- Number of reads classified directly to this taxon
- Taxonomic rank
- NCBI taxonomy ID
- Scientific name

## Metagenomic Viralrecon

For metagenomic samples, use the metagenomic protocol configuration:

```bash
python scripts/metagenomics_runViralrecon.py
```

This uses `configs/metagenomics_custom.config` which includes Kraken2 container and parameter settings.
