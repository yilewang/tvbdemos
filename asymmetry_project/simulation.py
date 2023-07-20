import os
from tvb.simulator.lab import *
import numpy as np
import matplotlib.pyplot as plt
LOG = get_logger('demo')
import pickle as cPickle
from tvb.simulator.models.stefanescu_jirsa import ReducedSetHindmarshRose
import pandas as pd

regions = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R']
df_info = pd.read_excel('/Users/yilewang/workspaces/data4project/mega_table.xlsx', sheet_name='tvb_parameters')


def sj3d_sim(input_path, G):
    connectivity.speed = np.array([10.])
    length = 1e4
    sim = simulator.Simulator(
        model=ReducedSetHindmarshRose(variables_of_interest=["xi", "eta", "tau", "alpha", "beta", "gamma"]), 
        connectivity=connectivity.Connectivity.from_file(input_path),
        coupling=coupling.Linear(a=np.array([G])),
        simulation_length=length,
        integrator=integrators.HeunStochastic(dt=0.01220703125, noise=noise.Additive(nsig=np.array([0.00001]), ntau=0.0,
                                                                                    random_stream=np.random.RandomState(seed=42))),
        monitors=(
        monitors.TemporalAverage(period=1.),
        monitors.Raw(),
        monitors.ProgressLogger(period=1e2))).configure()
    sim.configure()
    (tavg_time, tavg_data), (raw_time, raw_data),_ = sim.run()
    return raw_data


for i in range(len(df_info)):
    Group = df_info['group'][i]
    Caseid = df_info['caseid'][i]
    G = df_info['Gc'][i]
    input_path = '/Users/yilewang/workspaces/data4project/lateralization/connectome/zip/'+ Group + '/'+ Caseid+'.zip'
    raw_data = sj3d_sim(input_path, G)
    # avg_sv = np.mean(np.array(raw_data), axis=1)
    # avg_sv_modes = np.mean(avg_sv, axis=2)
    np.save(f"/Volumes/lab4data/LFP6vars/{Group}/{Caseid}_{G}.npy",raw_data)