# Kraken2 Database Setup

## Overview

This guide covers setting up Kraken2 databases for use with the PathogenPulse pipeline.

## Human Database (kraken2-human-db)

Used for filtering human reads from amplicon sequencing data.

```bash
kraken2-build --download-taxonomy --db kraken2-human-db
kraken2-build --download-library human --db kraken2-human-db
kraken2-build --build --db kraken2-human-db
```

## Comprehensive Database (kraken2-all-db)

Used for metagenomic classification across all pathogen types.

```bash
kraken2-build --download-taxonomy --db kraken2-all-db
kraken2-build --download-library archaea --db kraken2-all-db
kraken2-build --download-library bacteria --db kraken2-all-db
kraken2-build --download-library viral --db kraken2-all-db
kraken2-build --download-library human --db kraken2-all-db
kraken2-build --build --db kraken2-all-db
```

## Storage Requirements

- Human-only database: ~50 GB
- Comprehensive database: ~100+ GB

## Database Location

Databases should be placed at:
```
/home/ubuntu/Viralrecon/COVID/references/kraken2-human-db
/home/ubuntu/Viralrecon/COVID/references/kraken2-all-db
```
