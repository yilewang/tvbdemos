# steps to do the simulation in europa

```bash
ssh netid@europa.circ.utdallas.edu

# cd means change directory. We will do all the operations in $SCRATCH space.
cd $SCRATCH
```


use Git to download the repo in your europa

```bash
git clone https://github.com/yilewang/tvbdemos.git

# ls means to show all the files in the current directory
ls

cd ./tvbdemos/tvb_slurm

# cat means print out the content of this file
cat tutorial.md

rm # delete

# vim helps us to check and edit the files
vim tvb_longxxx

# press i to edit in vim mode
i

# how to exit vim mode and save your edits.
esc 
:x

```

we need to use conda to create a new environment
```python
# create a conda environment
# if conda not found: 
# ml load miniconda

conda create -n tvbenv -c conda-forge python=3.8 tvb-library tvb-data pandas numpy matplotlib
```

If you want to activate the env, just `source activate tvbenv`

How to submit job? use `sbatch tvb_long_sim.slurm` or `sbatch /scratch/netid/tvbdemos/tvb_slurm/tvb_long_sim.slurm`

How to monitor the progress? `watch -n 1 squeue -u$USER`. press 'ctrl+z' to exit

when it's finished, you go to `cd /scratch/netid/AD/` to check your results

if you want to pull the csv file and pic png file into **your local computer** (not europa, just click start new terminal in mobaxterm) for visualization

```bash
scp netid@europa.circ.utdallas.edu:/scratch/netid/AD/file_name1 filename2 /home/Username/Desktop
```
## steps to use different connectome to run simulation


first we need to put zip files into right path

```bash
mkdir MCI NC SNC
cd .. # back to the previous dir
. # means current dir

cp /opt/ohpc/pub/groups/tvb/connectome/AD_conn/* /scratch
```

how to update the script by using git 

```bash
git fetch && git merge
```


then, change the parameters in tvb_long_sim.slurm file. i.e., in here, we change it to 0578A instead of 0306A.
```bash
python sim2.py --grp 'AD' --caseid '0578A' --gc '0.015' --time '10000.0'
```
then we can run the simulation.

