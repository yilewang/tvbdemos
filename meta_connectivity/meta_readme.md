### Meta connectivity documentation

This documentation will be used to calculate the meta-connectivity metrics, includeing homotopical meta-connectivity and participation coefficient.

#### Import Toolbox

Firstly we need to download the meta-connectivity toolbox from github: [link](https://github.com/unbekanntt/Network-science-Toolbox)

After downloading the toolbox, we need to import it in our python script
```python
sys.path.append('YOUR_PATH/Network-science-Toolbox/Python')
from TS2dFCstream import TS2dFCstream
from dFCstream2Trimers import dFCstream2Trimers
from dFCstream2MC import dFCstream2MC
```

#### Main Functions

There are several functions we need to use to calculate the meta-connectivity, `TSdFCstream` is used to calculate the functional connectivity dynamics matrix, which contains temporal information of the time-series data. 

Another function called `dFCstream2MC`, which is a function to calculate meta connectivity matrix in 2D form. And each cell of the matrix represents the edge information, i.e. the connection between `pCNG left` and `pCNG right`.

The third function is used to calculate the Trimers output, the stability of the dFC. We can understand it as the `3D` version of the meta-connectivity.

```python
# calculate the meta-connectivity, using existing script:
dFCstream = TS2dFCstream(FMRI_TIME_SERIES, 5, None, '2D')
# Calculate MC
MC_MC = dFCstream2MC(dFCstream)
# Calculate Trimers results, with nxnxn information
MC_all[:,:,:,ind] = dFCstream2Trimers(dFCstream)
```

Further description could be seen from [link](https://github.com/unbekanntt/Network-science-Toolbox).
