import h5py
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

filename = "/mnt/c/Users/wayne/Desktop/0506A.h5"

with h5py.File(filename, "r") as f:
    # List all groups
    print("Keys: %s" % f.keys())
    
    time = np.arange(0,180,1/81920)
    plt.figure(figsize=(300, 5))
    plt.plot(time, f['raw'][:,5])
    plt.savefig("/mnt/c/Users/wayne/Desktop/0506AR.png")

    plt.figure(figsize=(300, 5))
    plt.plot(time, f['raw'][:,5])
    plt.savefig("/mnt/c/Users/wayne/Desktop/0506AL.png")