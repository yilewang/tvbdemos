import os
from tvb.simulator.lab import *
import numpy as np
import matplotlib.pyplot as plt
LOG = get_logger('demo')
from tvb.simulator.models.stefanescu_jirsa import ReducedSetHindmarshRose
import argparse
from os.path import join as pjoin



parser = argparse.ArgumentParser(description='pass parameters')
parser.add_argument('--Group',type=str, required=True, help='group')
parser.add_argument('--Caseid',type=str, required=True, help='caseid')
parser.add_argument('--G',type=float, required=True, help='G')
parser.add_argument('--K21',type=float, required=True, help='K21')


args = parser.parse_args()

data_dir = '/scratch/yilewang/workspaces/data4project/'
connectome_dir = pjoin(data_dir, 'lateralization/connectome/zip')


file = pjoin(connectome_dir, args.Group, args.Caseid+'.zip')

def tvb_lfp_sj3d(k21, G, file):
    connectivity.speed = np.array([10.])
    length = 1e3*10
    sim = simulator.Simulator(
        model=ReducedSetHindmarshRose(K21=np.array([k21])), 
        connectivity=connectivity.Connectivity.from_file(file),                      
        coupling=coupling.Linear(a=np.array([G])),
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
    return raw_data

for G in np.arange(args.G, 0.09, 0.001):
    raw_data = tvb_lfp_sj3d(args.K21, G, file)
    np.save(pjoin('/scratch/yilewang/K21_Gmax/',args.Group,args.Caseid+"_"+str(args.G)+".npy"), raw_data)
