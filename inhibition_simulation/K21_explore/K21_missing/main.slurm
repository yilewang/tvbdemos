#!/bin/bash


# simple SLURM script for g optimal.


#-------------------------------------------------------


#set up parameters
#SBATCH -J launcher
#SBATCH -N 24
#SBATCH -n 24
#SBATCH -p normal
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH -t 2-00:00:00



module load launcher

export LD_LIBRARY_PATH=/lib64:$LD_LIBRARY_PATH
export LAUNCHER_WORKDIR=$SCRATCH/workspaces/tvbdemos/inhibition_simulation/K21_explore/K21_missing
export LAUNCHER_JOB_FILE=jobfile
export LAUNCHER_SCHED=interleaved

$LAUNCHER_DIR/paramrun
