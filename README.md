```
 ____       _   _                            ____        _
|  _ \ __ _| |_| |__   ___   __ _  ___ _ __ |  _ \ _   _| |___  ___
| |_) / _` | __| '_ \ / _ \ / _` |/ _ \ '_ \| |_) | | | | / __|/ _ \
|  __/ (_| | |_| | | | (_) | (_| |  __/ | | |  __/| |_| | \__ \  __/
|_|   \__,_|\__|_| |_|\___/ \__, |\___|_| |_|_|    \__,_|_|___/\___|
                             |___/
```

# PathogenPulse

> **Real-time viral genomics pipeline orchestration on AWS**

[![Python 3.x](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![nf-core](https://img.shields.io/badge/nf--core-viralrecon-brightgreen.svg)](https://nf-co.re/viralrecon)
[![AWS](https://img.shields.io/badge/AWS-S3-orange.svg)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview

**PathogenPulse** is a comprehensive framework for automated viral variant calling and genomic surveillance using [nf-core/viralrecon](https://nf-co.re/viralrecon). Built for deployment on AWS infrastructure, it streamlines the entire workflow from raw sequencing data to analyzed results stored in S3 -- supporting both amplicon-based and metagenomic sequencing protocols across multiple respiratory and emerging pathogens.

Whether you're tracking SARS-CoV-2 variants, surveilling RSV and Influenza seasons, or investigating novel pathogens like Heartland virus (HRTV), PathogenPulse provides a unified orchestration layer that handles data download, input preparation, pipeline execution, and results management.

---

## Architecture

```
 ┌──────────────────────────────────────────────────────────────────────┐
 │                        PathogenPulse Pipeline                       │
 ├──────────────────────────────────────────────────────────────────────┤
 │                                                                      │
 │   ┌────────────┐    ┌────────────┐    ┌──────────────┐    ┌───────┐ │
 │   │  DOWNLOAD   │───>│ INPUT PREP │───>│  VIRALRECON  │───>│  S3   │ │
 │   │             │    │            │    │              │    │UPLOAD │ │
 │   │ BaseSpace/  │    │ Generate   │    │ nf-core/     │    │       │ │
 │   │ Local FASTQ │    │ sample CSV │    │ viralrecon   │    │ aws   │ │
 │   │             │    │ files      │    │ v2.6.0       │    │ s3 cp │ │
 │   │ download.py │    │inputFile.py│    │runViralrecon │    │result │ │
 │   │             │    │MergeInput  │    │   .py        │    │2S3.py │ │
 │   └────────────┘    └────────────┘    └──────────────┘    └───────┘ │
 │                                                                      │
 │   Protocols:  amplicon | metagenomic                                 │
 │   Callers:    iVar                                                   │
 │   Profiles:   Docker                                                 │
 └──────────────────────────────────────────────────────────────────────┘
```

---

## Supported Pathogens

| Pathogen | Protocol | Reference | Primer Set | Status |
|----------|----------|-----------|------------|--------|
| **COVID-19 (SARS-CoV-2)** | Amplicon | MN908947.3 | Swift v3 | Production |
| **RSV** | Metagenomic | Multiple segments | N/A | Production |
| **Influenza A/B** | Metagenomic | CY121686, CY003687, etc. | N/A | Production |
| **HRTV (Heartland virus)** | Metagenomic | MZ617374.1, MZ617375.1, MZ617376.1 | N/A | Production |
| **Oropouche** | Metagenomic | Multiple segments | N/A | In Development |

---

## Features

- **End-to-end automation** -- from BaseSpace download to S3 results upload in a single command
- **Multi-pathogen support** -- unified framework for COVID-19, RSV, Influenza, HRTV, and Oropouche
- **Amplicon & metagenomic protocols** -- supports both sequencing strategies with appropriate configurations
- **AWS-native** -- designed for high-memory AWS EC2 instances (up to 94 CPUs, 370 GB RAM)
- **Flexible input handling** -- automatic sample sheet generation with support for regular, water control, and wastewater samples
- **Custom container overrides** -- pinned versions for Pangolin, Nextclade, and Kraken2
- **Kraken2 integration** -- taxonomic classification with human and comprehensive databases
- **Coverage analysis** -- per-amplicon coverage calculation for quality control
- **Batch processing** -- iterate across multiple reference segments and input files automatically

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/PiantadosiLab/PathogenPulse.git
cd PathogenPulse

# 2. Place your FASTQ files in the working directory
#    - Regular samples in: fastqs/
#    - Water controls in:   water_fastqs/
#    - Wastewater in:       ww_fastqs/

# 3. Run the full pipeline (COVID-19 amplicon protocol)
python pipeline/runAll.py

# 4. Or run individual steps
python pipeline/download.py       # Download from BaseSpace
python pipeline/inputFile.py      # Generate input CSVs
python pipeline/runViralrecon.py  # Execute viralrecon
python pipeline/results2S3.py    # Upload results to S3
```

---

## Pipeline Steps

### Core Pipeline (`pipeline/`)

| Script | Description |
|--------|-------------|
| `runAll.py` | Master orchestrator that runs the full pipeline end-to-end |
| `download.py` | Downloads sequencing data from Illumina BaseSpace using the CLI |
| `inputFile.py` | Generates nf-core/viralrecon-compatible sample sheet CSVs from FASTQ directories |
| `MergeInput.py` | Merges multi-lane samples by stripping lane identifiers (L001, L002, etc.) |
| `runViralrecon.py` | Executes nf-core/viralrecon with amplicon protocol settings for COVID-19 |
| `results2S3.py` | Recursively uploads all output directories to an S3 bucket |

### Shell Scripts (`scripts/`)

| Script | Description |
|--------|-------------|
| `run_viralrecon_HRTV.sh` | Runs viralrecon against Heartland virus reference segments |
| `run_viralrecon_all.sh` | Runs viralrecon against all supported pathogen reference segments |
| `kraken2_run.sh` | Standalone Kraken2 taxonomic classification for paired-end reads |
| `coverage_per_amplicon.sh` | Calculates per-amplicon coverage from sorted BAM files |
| `metagenomics_runViralrecon.py` | Metagenomic protocol variant of the viralrecon runner |

---

## Configuration

### `configs/custom.config`

Custom Nextflow configuration that pins container versions for reproducibility:
- **Pangolin** `4.3.1-pdata-1.25.1` -- SARS-CoV-2 lineage assignment
- **Nextclade** `2.14.0` -- viral genome clade assignment and mutation calling

### `configs/metagenomics_custom.config`

Extended configuration for metagenomic workflows, adding:
- **Kraken2** `2.1.2` -- taxonomic classification with custom database paths
- Custom Kraken2 parameters for comprehensive pathogen detection

---

## Requirements

| Dependency | Version | Purpose |
|------------|---------|---------|
| Python | 3.x | Pipeline orchestration |
| Nextflow | Latest | Workflow engine |
| Docker | Latest | Container runtime |
| AWS CLI | v2 | S3 uploads |
| nf-core/viralrecon | 2.6.0 | Core analysis pipeline |
| BaseSpace CLI | Latest | Data download (optional) |
| pandas | Latest | Input file generation |
| samtools | Latest | BAM processing |
| Kraken2 | 2.1.2 | Taxonomic classification |

---

## Project Structure

```
PathogenPulse/
├── README.md                              # This file
├── .gitignore                             # Git ignore rules
├── LICENSE                                # MIT License
├── pipeline/
│   ├── runAll.py                          # Master pipeline orchestrator
│   ├── runViralrecon.py                   # Viralrecon execution (amplicon)
│   ├── inputFile.py                       # Sample sheet generator
│   ├── download.py                        # BaseSpace downloader
│   ├── MergeInput.py                      # Multi-lane sample merger
│   └── results2S3.py                      # S3 upload utility
├── configs/
│   ├── custom.config                      # Nextflow container overrides
│   └── metagenomics_custom.config         # Metagenomic workflow config
├── scripts/
│   ├── run_viralrecon_HRTV.sh             # HRTV analysis script
│   ├── run_viralrecon_all.sh              # Multi-pathogen analysis script
│   ├── kraken2_run.sh                     # Kraken2 classification
│   ├── coverage_per_amplicon.sh           # Amplicon coverage analysis
│   └── metagenomics_runViralrecon.py      # Metagenomic viralrecon runner
└── docs/
    ├── kraken2_database_setup.md          # Kraken2 DB build instructions
    └── metagenomics_filtering.md          # Metagenomic filtering guide
```

---

## Authors

**Itika Arora**
Piantadosi Lab, Emory University

---

## License

This project is licensed under the MIT License -- see the [LICENSE](LICENSE) file for details.
