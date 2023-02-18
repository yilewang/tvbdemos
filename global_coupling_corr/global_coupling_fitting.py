from tvb.simulator.models.stefanescu_jirsa import ReducedSetHindmarshRose
from tvb.simulator.lab import *
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import os
from pathlib import Path
import argparse

parser = argparse.ArgumentParser(description='pass parameters')
parser.add_argument('--Group',type=str, required=True, help='group')
parser.add_argument('--Caseid',type=str, required=True, help='caseid')
parser.add_argument('--G',type=float, required=True, help='G')

args = parser.parse_args()



def tvb_simulation(file, g):
    # file path of tvb connectome zip file
    # conduction velocity
    connectivity.speed = np.array([10.])
    # simulation parameters
    sim = simulator.Simulator(
        model=ReducedSetHindmarshRose(),
        connectivity=connectivity.Connectivity.from_file(file),
        coupling=coupling.Linear(a=np.array([g])),
        simulation_length=1e3 * 416,
        integrator=integrators.HeunStochastic(dt=0.01220703125, noise=noise.Additive(nsig=np.array([0.00001]), ntau=0.0,
                                                                                    random_stream=np.random.RandomState(seed=42))),
        monitors=(
        monitors.TemporalAverage(period=1.),
        monitors.Bold(hrf_kernel = equations.Gamma(), period=2000.),
        monitors.ProgressLogger(period=1e2))
    ).configure()

    sim.configure()

    # run the 
    (tavg_time, tavg_data), (raw_time, raw_data),_ = sim.run()

    # write it into the csv file
    # df = pd.DataFrame(raw_data[:, 0, :, 0], columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
    df = pd.DataFrame(raw_data[:, 0, :, 0], columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
    
    return df

input_path = '/scratch/yilewang/workspaces/data4project/lateralization/connectome/zip/'+ args.Group + '/'+ args.Caseid+'.zip'

output_path = '/scratch/yilewang/Goptimal/' + args.Group + '/' + args.Caseid
Path(output_path).mkdir(parents=True, exist_ok=True)

df = tvb_simulation(input_path, args.G)