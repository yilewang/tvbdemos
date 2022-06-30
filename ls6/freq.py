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
    subjectdf = pd.DataFrame(columns=["group", "caseid", "freq_gamma_left", "freq_gamma_right", "freq_theta_left", "freq_theta_right"])
    start_time = time.tim()
    for one, two in zip(group, caseid):
        print(one, two)
        ############## generate individual filename 
        filename = filename_path + one +"/"+ two+".h5"
        # create an instance
        subject = SignalToolkit(filename, fs=81920.)
        df = subject.data_reader()
        ############## indexing the pcg regions

        # define the parameters used for `find_speaks` algorithm.
        spikesparas = {'prominence': 0.5, 'height': .5}
        valleysparas= {'prominence': 0.2, 'width':2000, 'height': -0.5}
        spikesparas_af= {'prominence': 0.2, 'width':2000, 'height': 0.}
        valleysparas_af = {'prominence': 0.2, 'width':2000, 'height': -0.5}

        # to generate raw and filtered data, including the spikes and valleys
        pcg_left = subject.signal_package(df, 4, 'pcg_left', 2.0, 10.0, True, spikesparas, valleysparas,spikesparas_af, valleysparas_af, truncate = 10.)
        pcg_right = subject.signal_package(df, 5, 'pcg_right', 2.0, 10.0, True, spikesparas, valleysparas,spikesparas_af, valleysparas_af, truncate = 10.)


        # to calculate the frequency
        freq_gamma_left = subject.freq_count(spikeslist=pcg_left["spikeslist"])
        freq_theta_left = subject.freq_count(spikeslist=pcg_left["spikeslist_af"])
        freq_gamma_right = subject.freq_count(spikeslist=pcg_right["spikeslist"])
        freq_theta_right = subject.freq_count(spikeslist=pcg_right["spikeslist_af"])

        # write into DataFrame
        subjectdf = pd.concat([subjectdf, pd.DataFrame.from_records([{"group": one, "caseid":two, "freq_gamma_left":freq_gamma_left, "freq_gamma_right":freq_gamma_right, "freq_theta_left":freq_theta_left, "freq_theta_right":freq_theta_right}])], ignore_index = True)
        subjectdf.to_excel(args.path)
        print("done")
    end_time = time.time()
    print('Time: ', end_time - start_time)  
