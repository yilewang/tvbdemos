#!/bin/bash


# simple SLURM script for tvb simulation


#-------------------------------------------------------


#set up parameters

#SBATCH -J TVB
#SBATCH -N 74
#SBATCH -n 74
#SBATCH -p normal
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH -t 2-00:00:00


#LD_LIBRARY_PATH=/home/yxw190015/local/gsl-2.6/lib:$LD_LIBRARY_PATH ldd /opt/ohpc/pub/unpackaged/apps/afnibinary/21.0.06/3dROIMaker
#source ~/tvb-pipeline2/tvb-ukbb/init_vars && python ~/tvb-pipeline2/tvb-ukbb/bb_pipeline_tools/bb_pipeline.py s123366_output

source activate tvbenv
module load launcher
export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH
export LAUNCHER_WORKDIR=$SCRATCH/github/tvbdemos/tvb_slurm
export LAUNCHER_JOB_FILE=jobfile_go

$LAUNCHER_DIR/paramrun
