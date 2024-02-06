#!/bin/bash


# simple SLURM script for g optimal.


#-------------------------------------------------------


#set up parameters
#SBATCH -J launcher
#SBATCH -N 43
#SBATCH -n 686
#SBATCH -p normal
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH -t 2-00:00:00



module load launcher

export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH
export LAUNCHER_WORKDIR=/home/yxw190015/scratch/workspaces/tvbdemos/clinical_conversion/local_inhibition_fc_ganymede
export LAUNCHER_JOB_FILE=jobfile
export LAUNCHER_SCHED=interleaved

$LAUNCHER_DIR/paramrun
