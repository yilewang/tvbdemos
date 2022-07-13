#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $DIR

echo "Installing pipeline"

#create directories
mkdir -p ./software
mkdir -p ./software/env


echo "Creating conda environment..."
#create env from file and put it in software/env
conda env create -f env_sing.yml --prefix ./software/env
conda activate software/env

git lfs install
# conda install -c anaconda gfortran_linux-64
echo `which python`

# Rscript r_packages.R

echo "Environment created."

# echo "Downloading and installing MCR..."
# move MCR files to software
# cp setup_MCR.sh software

#install MCR 
# cd software
# chmod +x setup_MCR.sh
# ./setup_MCR.sh

# echo "MCR installed."

# echo "Downloading and configuring pipeline..."
# cd ..

# rm MCR_R2017b_glnxa64_installer.zip
#download pipeline
# git clone https://github.com/McIntosh-Lab-RRI/tvb-ukbb.git

# cd tvb-ukbb

# wget https://www.fmrib.ox.ac.uk/ukbiobank/fbp/bianca_class_data --directory=./bb_data
# wget https://www.fmrib.ox.ac.uk/ukbiobank/fbp/bianca_class_data_labels --directory=./bb_data

# wget https://www.fmrib.ox.ac.uk/ukbiobank/fbp/UKBiobank.RData --directory=./bb_functional_pipeline/bb_fix_dir/training_files

# cd bb_python/python_installation

# tar -zxvf gradunwarp_FMRIB.tar.gz
# cd gradunwarp_FMRIB

# for elem in `find . -name "*.py"` ; do 2to3 -w $elem ; done

# python setup.py install

conda deactivate

cd $DIR

echo "Pipeline installed. Be sure to modify init_vars with the correct user/system-specific directories and make any other needed changes as specified in the README. When running the pipeline, be sure to execute '. init_vars' before starting."

# command to create zip:
# find ./tvb-pipeline -maxdepth 1 | zip -@ tvb-pipeline_installer_1.0.zip --exclude "*software*" "*tvb-ukbb*"
