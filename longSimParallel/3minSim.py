#!/bin/usr/python

from tvb.simulator.models.stefanescu_jirsa import ReducedSetBase, ReducedSetHindmarshRose
from tvb.simulator.lab import *
import warnings
import matplotlib.pyplot as plt
import numpy as np
import time
import logging
import h5py
import multiprocessing

def tvb_simulation(grp, cid, gc):
    start_time = time.time()
    file = 'C:/Users/wayne/tvb/zip/' + grp + '/' + cid + '.zip'
    connectivity.speed = np.array([10.])
    sim_time = 180000.0
    #ReducedSetBase.number_of_modes = 3
    sim = simulator.Simulator(
       model=ReducedSetHindmarshRose(variables_of_interest=['xi']),
       connectivity=connectivity.Connectivity.from_file(file),             
       coupling=coupling.Linear(a=np.array([float(gc)])),
       simulation_length=sim_time,
       integrator=integrators.HeunStochastic(dt=0.01220703125, noise=noise.Additive(nsig=np.array([0.00001]), ntau=0.0, random_stream=np.random.RandomState(seed=42))),
       monitors=(
          monitors.TemporalAverage(period=1.),
          monitors.Raw(),
          monitors.ProgressLogger(period=1e2))).configure()
    sim.configure()
    (tavg_time, tavg_data), (raw_time, raw_data), _ = sim.run()
    # save as hdf5
    filename = 'C:/Users/wayne/tvb/gc3mins/'+grp+'/'+cid+'.h5'
    with h5py.File(filename, 'w') as hdf:
        hdf.create_dataset('raw', data = raw_data[:,0,:,0], shape=(14745600, 16))
    
    end_time = time.time()
    logging.warning('Duration: {}'.format(end_time - start_time))


if __name__ == "__main__":

    with open('C:/Users/wayne/tvb/tvbdemos/tvb_slurm/gc.txt') as f:
        gc = f.read().splitlines()
        f.close()

    with open('C:/Users/wayne/tvb/tvbdemos/tvb_slurm/group.txt') as f:
        group = f.read().splitlines()
        f.close()

    with open('C:/Users/wayne/tvb/tvbdemos/tvb_slurm/caseid.txt') as f:
        caseid = f.read().splitlines()
        f.close()

    for grp, cid, g in zip(group[60:], caseid[60:], gc[60:]):
        tvb_simulation(grp, cid, g)
    
    # Get all worker processes
    # cores = multiprocessing.cpu_count()

    # # Start all worker processes
    # pool = multiprocessing.Pool(processes=cores)
    # tasks = [(grp, cid, g) for grp, cid, g in zip(group, caseid, gc)]
    # print(pool.starmap(tvb_simulation,tasks))





    # save_as_output
    # df = pd.DataFrame(raw_data[:, 0, :, 0], columns = ['aCNG-L', 'aCNG-R','mCNG-L','mCNG-R','pCNG-L','pCNG-R', 'HIP-L','HIP-R','PHG-L','PHG-R','AMY-L','AMY-R', 'sTEMp-L','sTEMP-R','mTEMp-L','mTEMp-R'])
    # save_path='/scratch/'+netid+'/output/'+args.grp+'/'+args.caseid+'_'+str(args.gc)+'.h5'
    # df.to_hdf(save_path, key='raw', mode='w')





