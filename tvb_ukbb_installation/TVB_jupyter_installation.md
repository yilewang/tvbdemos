
### Set up TVB-JupyterNotebook on Ganymede at UT Dallas

We are using spack to install & manage conda, then using conda to create the working environment.
```bash
git clone -b v0.16.1 https://github.com/spack/spack.git
source spack/share/spack/setup-env.sh
spack install miniconda3
spack load miniconda3
conda init bash
# conda config --set auto_activate_base false #optional
conda create -c conda-forge -n tvbenv tvb-library notebook

conda activate tvbenv

jupyter notebook password #setup the password
```

In X2GO, we can submit jobs to the nodes and launch TVB jupyter notebook
```bash
srun -pTVB -N1 -n48 --pty /bin/bash
conda activate tvbenv
jupyter notebook --ip=*

```

If we don't want to add `--ip=*` all the time, we can edit the `jupyter_notebook_config.py` file and add `c.NotebookApp.ip = '*'`

After that, when we want to evoke jupyter notebook, we can just type in `jupyter notebook`.


