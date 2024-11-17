#!/bin/bash
module load miniconda
conda activate CellBenderEnv

python eval_single_anndata.py --adata_path /path/to/adata_liver.h5ad --dir path/to/output/dir --species mouse
python eval_single_anndata.py --adata_path /path/to/adata_tom.h5ad --dir path/to/output/dir --species mouse

conda deactivate