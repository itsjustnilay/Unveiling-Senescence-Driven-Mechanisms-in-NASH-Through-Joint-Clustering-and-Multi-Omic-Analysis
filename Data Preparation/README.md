# Data Preparation
This folder contains scripts and instructions for processing raw single-cell RNA sequencing (scRNA-seq) data from the study on senescence in normal and NASH-affected livers. The data processing pipeline begins with downloading raw sequencing files, followed by quality control, adapter trimming, and alignment to the reference genome.

The data for this project is sourced from the Gene Expression Omnibus (GEO) under accession number [GSE155182](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155182). The raw sequencing files are associated with four samples:

1. **Normal Liver - Whole (GSM4696914)**  
   - **Source:** Hepatic non-parenchymal cells from normal mouse liver.

2. **Normal Liver - Tomato Positive (GSM4696915)**  
   - **Source:** Hepatic non-parenchymal cells enriched for p16-positive cells.

3. **NASH Liver - Whole (GSM4696916)**  
   - **Source:** Hepatic non-parenchymal cells from NASH mouse liver.

4. **NASH Liver - Tomato Positive (GSM4696917)**  
   - **Source:** Hepatic non-parenchymal cells enriched for p16-positive cells.

## Script Information

### `data_preparation.sh`

- **Purpose:** Automates the downloading of raw sequencing reads from SRA, conversion to FASTQ format, renaming for consistency, and processing using CellRanger.
- **Inputs:**
  - **SRA Accession List:** A text file named `SRR_Acc_List_nash_w.txt` containing SRA IDs, one per line.
  - **Reference Genome**
- **Outputs:**
  - **FASTQ Files:** Stored in `fastq_raw/nash_w`, renamed for CellRanger compatibility.
  - **CellRanger Output:** filtered_feature_bc_matrix.h5 from CellRanger output.


## Notes
- Ensure all dependencies (`SRA Toolkit`, `fastp`, `CellRanger`) are properly installed and configured in the environment.

## References
1. Omori, S., Wang, T. W., Johmura, Y., et al. (2020). Generation of a p16 reporter mouse and its use to characterize and target p16high cells in vivo. *Cell Metabolism, 32*(6), 814-828. [https://doi.org/10.1016/j.cmet.2020.09.006](https://doi.org/10.1016/j.cmet.2020.09.006)
2. GEO Accession: [GSE155182](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155182)
3. `SRA Toolkit`: [https://github.com/ncbi/sra-tools](https://github.com/ncbi/sra-tools)
4. `fastp`: [https://github.com/OpenGene/fastp](https://github.com/OpenGene/fastp)
5. `CellRanger`: [https://support.10xgenomics.com/single-cell-gene-expression/software/overview/latest/cell-ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/overview/latest/cell-ranger)




