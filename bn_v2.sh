#!/bin/bash
#SBATCH --job-name=bn_v2
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --partition=intel_q
#SBATCH --account=birdnet
#SBATCH --time=4-00:00:00
#SBATCH --output=/projects/birdnet/chemours/Data_2024_sb_output/%x_%j.out

# Load pre-requisite module
module load apps  site/tinkercliffs/easybuild/setup

# Load Anaconda3 module
module load Anaconda3/2024.02-1

# Export the path for the conda environment that contains the updated BirdNET-Analyzer
export BNENV=/projects/birdnet/env/tc/bna2.4-intel

# Activate the conda environment
source activate $BNENV

# Ensure necessary packages are installed
conda install -y numpy tensorflow librosa resampy

# Remove local packages to avoid conflicts with the conda environment
rm -rf ~/.local/lib/python3.11/site-packages

# Set directories for input and output in a /projects/birdnet/ directory
IN_DIR=/projects/birdnet/chemours/Data_2024/ # Where the recordings (.wav, .flac, .mp3) are located
OUT_DIR=/projects/birdnet/chemours/Data_2024_bn_out/ # For the .txt files that will be generated by BirdNET
# Not to be confused with the output directory in the sbatch script that just provide info on the sbatch job

# Run BirdNET analysis and specify the location for recordings in latitude and longitude
date
python $BNENV/BirdNET-Analyzer/analyze.py --i $IN_DIR --o $OUT_DIR --lat 31.0429 --lon -81.9687 # Chemours
date

# Deactivate the environment
conda deactivate
