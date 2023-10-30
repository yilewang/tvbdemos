import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
from os.path import join as pjoin
import scipy.signal


# Load data
## read txt file as variable
scriptdir = '/scratch/yilewang/workspaces/tvbdemos/clinical_conversion/local_inhibition_Gmax'
# scriptdir = '/Users/yilewang/workspaces/tvbdemos/clinical_conversion/local_inhibition_Gmax'
datadir = '/scratch/yilewang/K21_Gmax/'
caseid = np.loadtxt(pjoin(scriptdir, 'caseid.txt'), dtype='str')
group = np.loadtxt(pjoin(scriptdir, 'group.txt'), dtype='str')
gc = np.loadtxt(pjoin(scriptdir, 'gc.txt'), dtype='float')
K21 = np.loadtxt(pjoin(scriptdir, 'K21.txt'), dtype='str')


for gr, case, gc in zip(group, caseid, gc):
    figure = plt.figure(figsize=(10, 10))
    for G in np.arrange(gc, 0.09, 0.001):
        G = round(G, 3)
        filename = pjoin(datadir, f'{case}_' + str(G) + '.npy')
        data = np.load(filename)
        # calculate the variance across 16 channels
        var = np.var(data[:,0,:,0], axis=1)
        plt.plot(G, var, 'o', color='black')
    plt.xlabel('G')
    plt.ylabel('Variance')
    plt.title(f'{case}')
    plt.savefig(pjoin(datadir, 'pics', f'{case}.png'))
        




