import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
from os.path import join as pjoin
import scipy.signal


# Load data
## read txt file as variable
# scriptdir = '/scratch/yilewang/workspaces/tvbdemos/clinical_conversion/local_inhibition_Gmax'
scriptdir = '/Users/yilewang/workspaces/tvbdemos/clinical_conversion/local_inhibition_Gmax'
# datadir = '/scratch/yilewang/K21_Gmax/'
datadir = '/Volumes/lab4data/K21_Gmax/'
caseid = np.loadtxt(pjoin(scriptdir, 'caseid.txt'), dtype='str')
group = np.loadtxt(pjoin(scriptdir, 'group.txt'), dtype='str')
gc = np.loadtxt(pjoin(scriptdir, 'gc.txt'), dtype='float')
K21 = np.loadtxt(pjoin(scriptdir, 'K21.txt'), dtype='str')


db = pd.DataFrame(columns=['group', 'case', 'Gc', 'K21', 'Gmax', 'Gmax-Gc'])
for gr, case, gc, k21 in zip(group, caseid, gc, K21):
    # figure = plt.figure(figsize=(10, 5))
    for G in np.arange(gc, 0.09, 0.001):
        G = round(G, 3)
        filename = pjoin(datadir, gr, f'{case}_' + str(G) + '.npy')
        data = np.load(filename)

        df = data[8192:,0,:,0]
        avg = np.average(df, axis = 1)
        var = np.var(df, axis=1)
        y = avg + var
        y_ = avg - var
        peaks, _ = scipy.signal.find_peaks(y, prominence= 1.96*np.std(y))
        # ax1 = figure.add_subplot(211)
        # ax1.plot(G, var, 'o', color='black')
        # ax2 = figure.add_subplot(122)
        # ax2.plot(data[:,0,5,0])
        # plt.title(f'{case}')
        if  len(peaks) == 0:
            Gmax = G
            break
    db = pd.concat([db, pd.DataFrame({'group': [gr], 'case': [case], 'Gc': [gc], 'K21': [k21], 'Gmax': [Gmax], 'Gmax-Gc': [Gmax-gc]})])
    db.to_excel(pjoin(scriptdir, 'Gmax.xlsx'), index=False)
    print(db)
    print(f'{case} done')
        




