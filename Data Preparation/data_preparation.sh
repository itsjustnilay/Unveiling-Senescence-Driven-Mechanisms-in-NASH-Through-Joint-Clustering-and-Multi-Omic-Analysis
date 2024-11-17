#!/bin/bash

# Load required modules
module load SRA-Toolkit/3.1.1-gompi-2022b

# Define directories and files
SRA_LIST="SRR_Acc_List.txt"               # Text file containing SRA accession IDs (one per line)
SRA_DIR="sra_files"                       # Directory for downloaded .sra files
FASTQ_DIR="fastq_files"                   # Directory for generated FASTQ files
OUTPUT_DIR="cellranger_output"            # Directory to store CellRanger results
REFERENCE_PATH="/path/to/reference"       # Path to reference genome for CellRanger
CELLRANGER_PATH="/path/to/cellranger"     # Path to CellRanger installation
SAMPLE_PREFIX="sample"                    # Prefix for renaming FASTQ files
CORES=<cores>                                  # Number of cores for CellRanger
MEMORY=<memory>                                # Memory (GB) for CellRanger

# Create necessary directories
mkdir -p $SRA_DIR $FASTQ_DIR $OUTPUT_DIR

# Initialize sample index for renaming
SAMPLE_INDEX=1

# Loop through each SRA ID and process
while read -r SRA_ID; do
    echo "Processing $SRA_ID..."

    # Download SRA file
    prefetch -O $SRA_DIR $SRA_ID
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download $SRA_ID. Skipping."
        continue
    fi

    # Convert SRA to FASTQ
    fastq-dump --outdir $FASTQ_DIR --gzip --split-files $SRA_DIR/$SRA_ID/$SRA_ID.sra
    if [ $? -ne 0 ]; then
        echo "Error: Failed to convert $SRA_ID to FASTQ. Skipping."
        continue
    fi

    # Clean up SRA file to save space
    rm -f $SRA_DIR/$SRA_ID/$SRA_ID.sra

    # Rename FASTQ files for CellRanger
    mv ${FASTQ_DIR}/${SRA_ID}_1.fastq.gz ${FASTQ_DIR}/${SAMPLE_PREFIX}_S${SAMPLE_INDEX}_L001_R1_001.fastq.gz
    mv ${FASTQ_DIR}/${SRA_ID}_2.fastq.gz ${FASTQ_DIR}/${SAMPLE_PREFIX}_S${SAMPLE_INDEX}_L001_R2_001.fastq.gz
    echo "Renamed FASTQ files for $SRA_ID."

    # Increment sample index
    SAMPLE_INDEX=$((SAMPLE_INDEX + 1))
done < $SRA_LIST

# Run CellRanger
export PATH=$CELLRANGER_PATH:$PATH
cellranger count \
    --id=cellranger_run \
    --transcriptome=$REFERENCE_PATH \
    --fastqs=$FASTQ_DIR \
    --sample=$SAMPLE_PREFIX \
    --localcores=$CORES \
    --localmem=$MEMORY \
    --create-bam true

# Move CellRanger results to the output directory
mv cellranger_run $OUTPUT_DIR
echo "CellRanger pipeline completed. Results saved to $OUTPUT_DIR."