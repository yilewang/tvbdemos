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
parser.add_argument('--Go',type=float, required=True, help='Go')
parser.add_argument('--K21',type=float, required=True, help='K21')


args = parser.parse_args()


data_dir = '/scratch/yilewang/workspaces/data4project/'
connectome_dir = pjoin(data_dir, 'lateralization/connectome/zip')
ts_dir = pjoin(data_dir, 'lateralization/ts_fmri/fmri_AAL_16/')


file = pjoin(connectome_dir+args.group, args.caseid, '.zip')


def tvb_K21_fitting(K21, Go, file):
    connectivity.speed = np.array([10.])
    sim = simulator.Simulator(
        model=ReducedSetHindmarshRose(K21=np.array([K21])), 
        connectivity=connectivity.Connectivity.from_file(file),                      
        coupling=coupling.Linear(a=np.array([Go])),
        simulation_length=1e3*416,
        integrator=integrators.HeunStochastic(dt=0.01220703125, noise=noise.Additive(nsig=np.array([1.0]), ntau=0.0,
                                                                                    random_stream=np.random.RandomState(seed=42))),
        monitors=(
        monitors.TemporalAverage(period=1.),
        monitors.Bold(hrf_kernel = equations.Gamma(), period=2000.),
        monitors.ProgressLogger(period=1e2)
        ))
    sim.configure()
    (tavg_time, tavg_data), (raw_time, raw_data),_ = sim.run()

    # write it into the csv file
    df = pd.DataFrame(raw_data[:, 0, :, 0], columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
    return df


df = tvb_K21_fitting(args.K21, args.Go, file)
df.to_csv(pjoin('/scratch/yilewang/local_inhibition/',args.group,args.caseid,'.csv'), index=False)
# # calculate correlation of the matrix
# corr = df.corr()

# # read mat file
# mat = scipy.io.loadmat(pjoin(ts_dir,args.group,args.caseid,'.mat'))
# roi_signal = mat['ROISignal']
# df_roi = pd.DataFrame(roi_signal, columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
# corr_roi = df.corr()

# # take the top triangle of the matrix using triu
# corr_roi = np.triu(corr_roi, k=1)
# corr = np.triu(corr, k=1)

# # calculate the correlation of the two matrices
# corr = corr.flatten()
# corr_roi = corr_roi.flatten()
# # pearson correlation of two flattened matrices
# corr_pearson = np.corrcoef(corr, corr_roi)[0,1]




