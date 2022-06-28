
#!/bin/bash


# simple SLURM script for tvb data analysis


#-------------------------------------------------------


#set up parameters

#SBATCH -J TVB
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p normal
#SBATCH -o job.%j.out
#SBATCH -e job.%j.err
#SBATCH -t 4:00:00


#LD_LIBRARY_PATH=/home/yxw190015/local/gsl-2.6/lib:$LD_LIBRARY_PATH ldd /opt/ohpc/pub/unpackaged/apps/afnibinary/21.0.06/3dROIMaker
#source ~/tvb-pipeline2/tvb-ukbb/init_vars && python ~/tvb-pipeline2/tvb-ukbb/bb_pipeline_tools/bb_pipeline.py s123366_output

source activate tvbenv
python gamma_freq.py --path $WORK
