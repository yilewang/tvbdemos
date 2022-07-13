#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR

echo "Installing pipeline - no repo configuration."

#create directories
mkdir -p ./software
mkdir -p ./software/env


echo "Creating conda environment..."
#create env from file and put it in software/env
conda env create -f env.yml --prefix ./software/env
conda init bash
eval "$(conda shell.bash hook)"
conda activate software/env

conda clean -y --all

git lfs install
# conda install -c anaconda gfortran_linux-64
echo `which python`

Rscript r_packages.R

echo "Environment created."

echo "Downloading and installing MCR..."
# move MCR files to software
cp setup_MCR.sh software

#install MCR 
cd software
chmod +x setup_MCR.sh
./setup_MCR.sh

echo "MCR installed."

conda deactivate

cd $DIR

echo "Pipeline installed without repo configuration. Please copy repo in afterwards if you haven't done so already. Be sure to modify init_vars with the correct user/system-specific directories and make any other needed changes as specified in the README. When running the pipeline, be sure to execute '. init_vars' before starting."

# command to create zip:
# find ./tvb-pipeline -maxdepth 1 | zip -@ tvb-pipeline_installer_1.0.zip --exclude "*software*" "*tvb-ukbb*"
