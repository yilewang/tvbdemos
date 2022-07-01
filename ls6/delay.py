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
    subjectdf = pd.DataFrame(columns=["group", "caseid", "pcg_delay"])
    for one, two in zip(group, caseid):
        print(one, two)
        ############## generate individual filename 
        filename = filename_path + one +"/"+ two+".h5"
        # create an instance
        subject = SignalToolkit(filename, fs=81920.)
        df = subject.data_reader()
        ############## indexing the pcg regions
        cutoff_low = 2.
        cutoff_high = 10.

        spikesparas = {'prominence': 1.0}
        valleysparas= {'prominence': 0.2, 'width':2000, 'height': -0.5}
        spikesparas_af= {'prominence': 0.3, 'width':2000, 'height': 0.}
        valleysparas_af = {'prominence': 0.2, 'width':2000, 'height': -0.5}

        pcgl=subject.signal_package(data=df, channel_num = 4, label='pcg_left', low=cutoff_low, high=cutoff_high, spikesparas=spikesparas, valleysparas=valleysparas, spikesparas_af=spikesparas_af, valleysparas_af = valleysparas, truncate = 10.)
        pcgr=subject.signal_package(data=df, channel_num = 5, label='pcg_right', low=cutoff_low, high=cutoff_high, spikesparas=spikesparas, valleysparas=valleysparas, spikesparas_af=spikesparas_af, valleysparas_af=valleysparas_af, truncate = 10.)


        # delay
        pcg_delay = subject.phase_delay(pcgl["after_filtered"], pcgr["after_filtered"], pcgl["spikeslist_af"], pcgl["valleyslist_af"], pcgr["spikeslist_af"], pcgr["valleyslist_af"], mode = "SI")

        # write into DataFrame
        subjectdf = pd.concat([subjectdf, pd.DataFrame.from_records([{"group": one, "caseid":two, "pcg_delay":pcg_delay}])], ignore_index = True)
        print("done")
    subjectdf.to_excel(args.path)
    end_time = time.time()
    print('Time: ', end_time - start_time)  
