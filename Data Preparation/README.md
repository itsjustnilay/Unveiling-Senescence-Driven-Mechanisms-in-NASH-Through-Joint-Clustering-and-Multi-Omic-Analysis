# Data Preparation

## Overview
This folder contains scripts and instructions for processing raw single-cell RNA sequencing (scRNA-seq) data from the study on senescence in normal and NASH-affected livers. The data processing pipeline begins with downloading raw sequencing files, followed by quality control, adapter trimming, and alignment to the reference genome.

## Data Description
The data for this project is sourced from the Gene Expression Omnibus (GEO) under accession number [GSE155182](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155182). The raw sequencing files are associated with four samples:

1. **Normal Liver - Whole (GSM4696914)**  
   - **Source:** Hepatic non-parenchymal cells from normal mouse liver.

2. **Normal Liver - Tomato Positive (GSM4696915)**  
   - **Source:** Hepatic non-parenchymal cells enriched for p16-positive cells.

3. **NASH Liver - Whole (GSM4696916)**  
   - **Source:** Hepatic non-parenchymal cells from NASH mouse liver.

4. **NASH Liver - Tomato Positive (GSM4696917)**  
   - **Source:** Hepatic non-parenchymal cells enriched for p16-positive cells.

## Data Processing Steps

### 1. Downloading Raw Sequencing Files
The raw sequencing data is downloaded from NCBI's Short Read Archive (SRA) using the `SRA Toolkit`. The `raw_reads_processing.sh` script automates this step:
- **Prefetch:** Downloads `.sra` files for each sample.
- **Fastq-dump:** Converts `.sra` files to `.fastq.gz` format.

```bash
# Example command to download SRA file
prefetch -O sra/ SRR7073158

# Example command to convert SRA to FASTQ
fastq-dump --outdir fastq_raw --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip sra/SRR7073158/SRR7073158.sra
```

### 2. Quality Control and Adapter Trimming
The `fastp` tool is used for quality control and trimming of raw reads. It detects adapters, trims low-quality bases, and corrects read errors. The trimmed output and quality control reports are saved in the `fastq_trimmed/` and `qc_report/` directories, respectively.

```bash
# Example command for trimming with fastp
fastp --detect_adapter_for_pe --overrepresentation_analysis --correction --cut_right \
--html qc_report/SRR7073158.fastp.html --json qc_report/SRR7073158.fastp.json \
-i fastq_raw/SRR7073158_pass_1.fastq.gz -I fastq_raw/SRR7073158_pass_2.fastq.gz \
-o fastq_trimmed/SRR7073158_1.fastq.gz -O fastq_trimmed/SRR7073158_2.fastq.gz \
2> fastq_trimmed/SRR7073158.fastp.log
```

### 3. Alignment and UMI Processing
The `CellRanger v8.0.1` software is used for sequence alignment, UMI recognition, and base-calling. This step processes the trimmed `.fastq.gz` files and aligns them to the `mm10` mouse reference genome. Results include gene-cell matrices and sequencing quality metrics.

```bash
# Example CellRanger command
cellranger count --id=SampleID --transcriptome=/path/to/reference --fastqs=/path/to/fastq_trimmed --sample=SampleName
```
## Script Information

### `raw_reads_processing.sh`
- **Purpose:** Automates downloading and preprocessing of raw sequencing reads using `SRA Toolkit` and `fastp`.
- **Location:** `Data Preparation` folder.
- **Input:** SRA identifiers.
- **Output:** Trimmed FASTQ files and QC reports.

### `cellranger.sh`
- **Purpose:** Automates alignment and UMI processing using `CellRanger`.
- **Location:** `Data Preparation` folder.
- **Input:** Trimmed FASTQ files.
- **Output:** Aligned data with gene-cell matrices.

## Notes
- Ensure all dependencies (`SRA Toolkit`, `fastp`, `CellRanger`) are properly installed and configured in the environment.

## References
1. Omori, S., Wang, T. W., Johmura, Y., et al. (2020). Generation of a p16 reporter mouse and its use to characterize and target p16high cells in vivo. *Cell Metabolism, 32*(6), 814-828. [https://doi.org/10.1016/j.cmet.2020.09.006](https://doi.org/10.1016/j.cmet.2020.09.006)
2. GEO Accession: [GSE155182](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155182)
3. `SRA Toolkit`: [https://github.com/ncbi/sra-tools](https://github.com/ncbi/sra-tools)
4. `fastp`: [https://github.com/OpenGene/fastp](https://github.com/OpenGene/fastp)
5. `CellRanger`: [https://support.10xgenomics.com/single-cell-gene-expression/software/overview/latest/cell-ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/overview/latest/cell-ranger)




