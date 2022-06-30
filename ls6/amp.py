#!/usr/bin/python

import pandas as pd
import h5py
import numpy as np
import matplotlib.pyplot as plt
import sys
from scipy.signal import hilbert, chirp
sys.path.append("HERE") # **put your tvbtools path inside
from tvbtools.signaltools import SignalToolkit
import ipywidgets as widgets
my_layout = widgets.Layout()
plt.style.use('ggplot')
import argparse
import time

with open('/work/08008/yilewang/tvbsim3mins/group.txt') as f:
    group = f.read().splitlines()
f.close()

with open('/work/08008/yilewang/tvbsim3mins/caseid.txt') as f:
    caseid = f.read().splitlines()
f.close()




# import example data

filename_path = "/work/08008/yilewang/tvbsim3mins/gc3mins/"

parser = argparse.ArgumentParser(description='pass a str')
parser.add_argument('--path',type=str, required=True, help='the path we put our final signal processing results')
args = parser.parse_args()



if __name__ == "__main__":
    start_time = time.time()
    subjectdf = pd.DataFrame(columns=["group", "caseid", "freq_gamma_left", "freq_gamma_right", "freq_theta_left", "freq_theta_right"])
    for one, two in zip(group, caseid):
        print(one, two)
        ############## generate individual filename 
        filename = filename_path + one +"/"+ two+".h5"
        # create an instance
        subject = SignalToolkit(filename, fs=81920.)
        df = subject.data_reader()
        ############## indexing the pcg regions

        spikesparas = {'prominence': 0.5, 'height': .5}
        valleysparas= {'prominence': 0.2, 'width':2000, 'height': -0.5}
        spikesparas_af= {'prominence': 0.2, 'width':2000, 'height': 0.}
        valleysparas_af = {'prominence': 0.2, 'width':2000, 'height': -0.5}

        pcgl=subject.signal_package(data=df, channel_num = 4, label='pcg_left', low=cutoff_low, high=cutoff_high, spikesparas=spikesparas, valleysparas=valleysparas, spikesparas_af=spikesparas_af, valleysparas_af = valleysparas, truncate = 10.)
        pcgr=subject.signal_package(data=df, channel_num = 5, label='pcg_right', low=cutoff_low, high=cutoff_high, spikesparas=spikesparas, valleysparas=valleysparas, spikesparas_af=spikesparas_af, valleysparas_af=valleysparas_af, truncate = 10.)

        # define the parameters used for `find_speaks` algorithm.
        spikesparas = {'prominence': 0.5, 'height': .5}
        valleysparas= {'prominence': 0.2, 'width':2000, 'height': -0.5}
        spikesparas_af= {'prominence': 0.2, 'width':2000, 'height': 0.}
        valleysparas_af = {'prominence': 0.2, 'width':2000, 'height': -0.5}

        # to generate raw and filtered data, including the spikes and valleys
        pcg_left = subject.signal_package(df, 4, 'pcg_left', 2.0, 10.0, True, spikesparas, valleysparas,spikesparas_af, valleysparas_af, truncate = 10.)
        pcg_right = subject.signal_package(df, 5, 'pcg_right', 2.0, 10.0, True, spikesparas, valleysparas,spikesparas_af, valleysparas_af, truncate = 10.)


        # amp
        amp = 'p2v'
        if amp in ['p2v']:
            amp_gamma_left = subject.amp_count(**pcgl, mode="p2v")
            amp_gamma_right = subject.amp_count(**pcgr, mode="p2v")
            amp_theta_left = subject.amp_count(data=pcgl["after_filtered"], spikeslist=pcgl["spikeslist_af"], valleyslist=pcgl["valleyslist_af"], mode="p2v")
            amp_theta_right = subject.amp_count(data=pcgr["after_filtered"], spikeslist=pcgr["spikeslist_af"], valleyslist=pcgr["valleyslist_af"], mode="p2v")
        elif amp in ['ap']:
            # another version of amp
            amp_gamma_left, amp_theta_left = subject.amp_count(**pcgl, mode="ap")
            amp_gamma_right, amp_theta_right = subject.amp_count(**pcgr, mode="ap")

        # write into DataFrame
        subjectdf = pd.concat([subjectdf, pd.DataFrame.from_records([{"group": one, "caseid":two, "amp_gamma_left":amp_gamma_left, "amp_gamma_right":amp_gamma_right, "amop_theta_left":amp_theta_left, "amp_theta_right":amp_theta_right}])], ignore_index = True)
        print("done")
    subjectdf.to_excel(args.path)
    end_time = time.time()
    print('Time: ', end_time - start_time)  
