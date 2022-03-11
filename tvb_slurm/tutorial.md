# steps to do the simulation in europa

```bash
ssh netid@europa.circ.utdallas.edu

cd $SCRATCH
```


use Git to download the repo in your europa

```bash
git clone https://github.com/yilewang/tvbdemos.git

ls

cd tvbdemos

ls

cd tvb_slurm

cat tutorial.md

rm # delete

vim tvb_longxxx

i

esc 

:x

```

we need to use conda to create a new environment
<!-- 
```python
# create a conda environment
# if conda not found: 
# ml load miniconda

conda create -n tvbenv -c conda-forge python=3.8 tvb-library tvb-data pandas numpy matplotlib
```

If you want to activate the env, just `source activate tvbenv` -->

How to submit job? use `sbatch tvb_long_sim.slurm`

How to monitor the progress? `watch -n 1 squeue -u$USER`. press 'ctrl+z' to exit

when it's finished, you go to `cd /scratch/netid/AD/` to check your results

if you want to pull the csv file and pic png file into your local computer for visualization

```bash
scp netid@europa.circ.utdallas.edu:/scratch/netid/AD/file_name1 filename2 /home/Username/Desktop
```
