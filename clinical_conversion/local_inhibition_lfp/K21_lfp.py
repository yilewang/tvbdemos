import os
from tvb.simulator.lab import *
import numpy as np
import seaborn
import matplotlib.pyplot as plt
LOG = get_logger('demo')
import pickle as cPickle
from tvb.simulator.models.stefanescu_jirsa import ReducedSetHindmarshRose
import argparse
from os.path import join as pjoin
import pandas as pd
import scipy.io



parser = argparse.ArgumentParser(description='pass parameters')
parser.add_argument('--Group',type=str, required=True, help='group')
parser.add_argument('--Caseid',type=str, required=True, help='caseid')
parser.add_argument('--Go',type=float, required=True, help='Gc')
parser.add_argument('--K21',type=float, required=True, help='K21')


args = parser.parse_args()

data_dir = '/scratch/yilewang/workspaces/data4project/'
connectome_dir = pjoin(data_dir, 'lateralization/connectome/zip')
ts_dir = pjoin(data_dir, 'lateralization/ts_fmri/fmri_AAL_16/')


file = pjoin(connectome_dir, args.Group, args.Caseid+'.zip')


def tvb_lfp_sj3d(k21, Gc, file):
    connectivity.speed = np.array([10.])
    length = 1e4
    sim = simulator.Simulator(
        model=ReducedSetHindmarshRose(K21=np.array([k21])), 
        connectivity=connectivity.Connectivity.from_file(),                      
        coupling=coupling.Linear(a=np.array([0.015])),
        simulation_length=length,
        integrator=integrators.HeunStochastic(dt=0.01220703125, noise=noise.Additive(nsig=np.array([0.00001]), ntau=0.0,
                                                                                    random_stream=np.random.RandomState(seed=42))),
        monitors=(
        monitors.TemporalAverage(period=1.),
        monitors.Raw(),
        monitors.ProgressLogger(period=1e2)
        )
    ).configure()


    (tavg_time, tavg_data), (raw_time, raw_data),_ = sim.run()
    # write it into the csv file
    df = pd.DataFrame(raw_data[:, 0, :, 0], columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
    return df


df = tvb_lfp_sj3d(args.K21, args.Gc, file)
df.to_csv(pjoin('/scratch/yilewang/local_inhibition/',args.Group,args.Caseid+"_"+str(args.K21)+".csv"), index=False)

