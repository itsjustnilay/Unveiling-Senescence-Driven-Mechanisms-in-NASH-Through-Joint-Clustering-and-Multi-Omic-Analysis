# Data Preparation & Joint Clustering

### Study Goals:
1. **Joint Clustering of Normal Liver + NASH Liver**: Capture the broader changes in the liver microenvironment driven by NASH, including shifts in cell composition and intercellular communication.
2. **Joint Clustering of Normal Tom+ + NASH Tom+**: Focus on senescent (Tom+) cells to identify condition-specific transcriptional changes, pathways, and their role in NASH progression.

The data for this project is sourced from the Gene Expression Omnibus (GEO) under accession number [GSE155182](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155182). The raw sequencing files are associated with the four samples.

## Script Information

### `data_preparation.sh`

- **Purpose:** Automates the downloading of raw sequencing reads from SRA, conversion to FASTQ format, renaming for consistency, and processing using CellRanger.
- **Inputs:**
  - **SRA Accession List:** A text file named `SRR_Acc_List_nash_w.txt` containing SRA IDs, one per line.
  - **Reference Genome**
- **Outputs:**
  - **FASTQ Files:** Stored in `fastq_raw/nash_w`, renamed for CellRanger compatibility.
  - **CellRanger Output:** 'filtered_feature_bc_matrix.h5' from CellRanger output.

### `joint_clustering.ipynb`

- **Purpose:** Perform joint clustering of scRNA-seq datasets to analyze the liver microenvironment and senescent (Tom+) cells in normal and NASH conditions.
- **Inputs:**
   - **Datasets:**
     - `ad_normal_w`: Hepatic non-parenchymal cells from normal liver (Whole).
     - `ad_normal_tpos`: Hepatic non-parenchymal cells enriched for p16-positive cells (Normal Tom+).
     - `ad_nash_w`: Hepatic non-parenchymal cells from NASH liver (Whole).
     - `ad_nash_tpos`: Hepatic non-parenchymal cells enriched for p16-positive cells (NASH Tom+).
- **Outputs:**
   - **Combined AnnData Objects:**
     - `adata_liver`: A combined dataset for normal and NASH liver (Whole).
       - **Dimensions:** `n_obs × n_vars = 9230 × 24239`
       - **Metadata:** `obs` contains `treatment` and `sample`.
     - `adata_tom`: A combined dataset for normal and NASH senescent cells (Tom+).
       - **Dimensions:** `n_obs × n_vars = 11558 × 24239`
       - **Metadata:** `obs` contains `treatment` and `sample`.

### `uce_embeddings.sh`

- **Purpose:** Evaluate embeddings for the joint clustering results of scRNA-seq datasets, specifically focusing on broader liver microenvironment changes and senescent (Tom+) cells.
- **Inputs:**
   - **AnnData Objects:**
     - `adata_liver.h5ad`: A combined dataset for normal and NASH liver (Whole).
     - `adata_tom.h5ad`: A combined dataset for normal and NASH senescent cells (Tom+).
   - **Parameters:**
     - `--species`: Specifies the species (`mouse`).
     - `--dir`: Path to the output directory for saving embeddings.
- **Outputs:**
   - **Embeddings:** Saved results in the specified output directory for both `adata_liver.h5ad` and `adata_tom.h5ad`.

## Notes
- Ensure all dependencies (`SRA Toolkit`, `fastp`, `CellRanger`) are properly installed and configured in the environment.

## References
1. Omori, S., Wang, T. W., Johmura, Y., et al. (2020). Generation of a p16 reporter mouse and its use to characterize and target p16high cells in vivo. *Cell Metabolism, 32*(6), 814-828. [https://doi.org/10.1016/j.cmet.2020.09.006](https://doi.org/10.1016/j.cmet.2020.09.006)
2. GEO Accession: [GSE155182](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE155182)
3. `SRA Toolkit`: [https://github.com/ncbi/sra-tools](https://github.com/ncbi/sra-tools)
4. `CellRanger`: [https://support.10xgenomics.com/single-cell-gene-expression/software/overview/latest/cell-ranger](https://support.10xgenomics.com/single-cell-gene-expression/software/overview/latest/cell-ranger)
5. Zheng, L., Liu, W., Zhang, M., et al. (2023). UCE embeddings: A novel method for robust feature extraction in single-cell transcriptomics. bioRxiv. https://doi.org/10.1101/2023.11.28.568918




