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


#### participation coefficient

This is a method from graph theory. The basic idea is to calculate how strong this node is belonged to this cluster. It could be calculated by the `bctpy` toolbox in python. You can use `pip install python-louvain` and `pip install bctpy` to install them. 

The workflow is that, we need to use the meta-connectivity matrix as the input, and specify a path to save your participation coefficient value as output.

```python
import community as community_louvain
from bct.algorithms import community_louvain
from bct.algorithms.centrality import participation_coef_sign

overall_df = pd.DataFrame()
def participation_pipe(MC_MC, gamma=1, your_path)
    MC_MC = np.triu(MC_MC, k=1)
    mat = pd.Dataframe(MC_MC)
    ci, Q = community_louvain(mat.to_numpy(), gamma = gamma, B='negative_asym', seed=None)
    pos,_ = participation_coef_sign(mat.to_numpy())
    ci_name_list = ["cluster_" + str(i) for i in ci]
    cluster_info = pd.DataFrame(ci_name_list)
    cluster_info.columns = ["cluster"]
    part_coe = pd.DataFrame(pos)
    part_coe.columns = ["participation_coef"]
    _tmp = pd.concat([part_coe, cluster_info],axis=1, ignore_index=True)
    overall_df = pd.concat([overall_df, _tmp], ignore_index=True)
    overall_df.columns = ["participation_coef", "cluster"]
    prefix = your_path
    overall_df.to_excel(f"{your_path}/participation_coef.xlsx")
    return overall_df

df = participation_pipe(MC_MC, 'C:/YOUR_PATH')
print(df)
```