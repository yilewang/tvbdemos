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

```

we need to use conda to create a new environment

```python
# create a conda environment

conda create -n tvbenv python=3.8 tvb-library tvb-data pandas numpy matplotlib
```

If you want to activate the env, just `source activate tvbenv`

How to submit job? use `sbatch tvb_long_sim.slurm`

How to monitor the progress? `watch -n 1 queue -u$USER`. press 'ctrl+z' to exit
