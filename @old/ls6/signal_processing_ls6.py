#!/usr/bin/python

import pandas as pd
import h5py
import numpy as np
import matplotlib.pyplot as plt
import sys
from scipy.signal import hilbert, chirp
#sys.path.append("/mnt/w/github/tvbtools")
from tools.signaltools import SignalToolkit
import ipywidgets as widgets
my_layout = widgets.Layout()
plt.style.use('ggplot')
import argparse


with open('/work/08008/yilewang/tvbsim3mins/group.txt') as f:
    group = f.read().splitlines()
f.close()

with open('/work/08008/yilewang/tvbsim3mins/caseid.txt') as f:
    caseid = f.read().splitlines()
f.close()


# import example data
# filename = "/mnt/c/Users/wayne/tvb/gc3mins/SNC/2820A.h5"
filename_path = "/work/08008/yilewang/tvbsim3mins/gc3mins/"

parser = argparse.ArgumentParser(description='pass a float')
parser.add_argument('--path',type=str, required=True, help='the path we put our final signal processing results')
args = parser.parse_args()


if __name__ == "__main__":
    subjectdf = pd.DataFrame(columns=["group", "caseid", "freq", "amp", "delay"])
    for one, two in zip(group, caseid):
        ############## generate individual filename 
        filename = filename_path + one +"/"+ two+".h5"
        # create an instance
        subject = SignalToolkit(filename, fs=81920.)
        dset = subject.hdf5_reader()
        ############## indexing the pcg regions

        # define the parameters used for `find_speaks` algorithm.
        spikesparas = {'prominence': 0.5, 'height': .5}
        valleysparas= {'prominence': 1., 'width':3000, 'height': 0.}
        spikesparas_af= {'prominence': 0.5, 'width':3000, 'height': 0.}

        # to generate raw and filtered data, including the spikes and valleys
        pcg_left = subject.signal_package(dset, 4, 'pcg_left', True, spikesparas, valleysparas,spikesparas_af)
        pcg_right = subject.signal_package(dset, 5, 'pcg_right', True, spikesparas, valleysparas,spikesparas_af)

        # visualization of two signals
        # subject.signal_af(**pcg_left)
        # subject.signal_af(**pcg_right)

        # to calculate the frequency
        freq_num = subject.freq_count(spikeslist=pcg_left["spikeslist"])

        # to calculate the amplitude
        amp_dergee = subject.amp_count(data=pcg_left["data"], spikeslist=pcg_left['spikeslist'], valleyslist=pcg_left["valleyslist"], mode="p2v")

        # to calculate the delay between 2 signals
        delay_time = subject.phase_delay(data1=pcg_left["data"], data2=pcg_right["data"], spikeslist1=pcg_left["spikeslist"], spikeslist2=pcg_right["spikeslist"], valleyslist1=pcg_left['valleyslist'], valleyslist2=pcg_right["valleyslist"], mode = "SI")

        subjectdf = pd.concat([subjectdf, pd.DataFrame.from_records([{"group": one, "caseid":two, "freq":freq_num, "amp":amp_dergee, "delay":delay_time}])], ignore_index = True)
        subjectdf.to_excel(args.path)

