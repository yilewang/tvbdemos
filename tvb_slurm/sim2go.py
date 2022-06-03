
from tvb.simulator.models.stefanescu_jirsa import ReducedSetBase, ReducedSetHindmarshRose
from tvb.simulator.lab import *
import warnings
import matplotlib.pyplot as plt
import numpy as np
import argparse
import pandas as pd
import time
import logging
import sys
import h5py

netid="yxw190015"

def tvb_simulation(file, gc, simTime):
    connectivity.speed = np.array([10.])
    sim_time = simTime
    #ReducedSetBase.number_of_modes = 1
    sim = simulator.Simulator(
       model=ReducedSetHindmarshRose(variables_of_interest=['xi']),
       connectivity=connectivity.Connectivity.from_file(file),             
       coupling=coupling.Linear(a=np.array([gc])),
       simulation_length=sim_time,
       integrator=integrators.HeunStochastic(dt=0.01220703125, noise=noise.Additive(nsig=np.array([0.00001]), ntau=0.0, random_stream=np.random.RandomState(seed=42))),
       monitors=(
          monitors.TemporalAverage(period=1.),
          monitors.Raw(),
          monitors.ProgressLogger(period=1e2))).configure()
    sim.configure()
    (tavg_time, tavg_data), (raw_time, raw_data), _ = sim.run()
    return raw_time, raw_data


#bash obtain the input
parser = argparse.ArgumentParser(description='pass a float')
parser.add_argument('--grp',type=str, required=True, help='group info')
parser.add_argument('--caseid', type=str, required=True, help='case id')
parser.add_argument('--gc', type=float, required=True, help='global coupling' )
parser.add_argument('--time', type=float, required=True, help='simulation time')
args = parser.parse_args()

if __name__ == "__main__":
    the_file = '/scratch/'+netid+'/'+args.grp+'/'+args.caseid+'.zip'
    start_time = time.time()
    raw_time, raw_data = tvb_simulation(the_file, np.array([args.gc]), args.time)
    end_time = time.time()
    logging.warning('Duration: {}'.format(end_time - start_time))

    # save_as_output
    # df = pd.DataFrame(raw_data[:, 0, :, 0], columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
    # save_path='/scratch/'+netid+'/output/'+args.grp+'/'+args.caseid+'_'+str(args.gc)+'.h5'
    # df.to_hdf(save_path, key='raw', mode='w')

    # save as hdf5
    filename = '/scratch/'+netid+'/go/'+args.grp+'/'+args.caseid + '.h5'
    with h5py.File(filename, 'w') as hdf:
        hdf.create_dataset('raw', data = raw_data[:,0,:,0], shape=(14745600, 16))




