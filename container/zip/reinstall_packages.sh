#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR

echo "Removing current environment and MCR runtime"

rm -rf ./software/env
# rm -rf ./software/MCR_2017b_glnxa64

#recreate directory
mkdir -p ./software/env


echo "Creating conda environment..."
#create env from file and put it in software/env
conda env create -f env.yml --prefix ./software/env
conda init bash
eval "$(conda shell.bash hook)"
conda activate software/env
git lfs install
# conda install -c anaconda gfortran_linux-64
echo `which python`

Rscript r_packages.R

echo "Environment created."

echo "Downloading and installing MCR..."
# # move MCR files to software
cp setup_MCR.sh software

# #install MCR 
cd software
chmod +x setup_MCR.sh
./setup_MCR.sh

echo "MCR installed."


