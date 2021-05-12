

### environment setup and package installation:

```bash
# environment setup
spack load miniconda3 #using spack to manage packages
conda init bash
conda create -c conda-forge -n tvbenv tvb-library tvb-framework numpy pandas #installing commonly used packages
conda activate tvbenv #working environment

# package installation
conda install scipy
```



