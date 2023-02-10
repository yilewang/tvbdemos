#!/usr/bin/python

from re import S
from sys import hash_info
from matplotlib import projections
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import odeint
from mpl_toolkits.mplot3d import Axes3D
plt.style.use('ggplot')

def lorenz(state, t, sigma, beta, rho):
    x,y,z = state
    dx = sigma * (y-x)
    dy = x * (rho -z) -y
    dz = x * y - beta * z

    return [dx, dy, dz]


sigma = 10.0
beta = 8.0/3.0
rho = 28.0

p = (sigma, beta, rho)

init_y = [10.0, 0.0, 0.0]

t = np.arange(0.0, 40.0, 0.01)

result = odeint(lorenz, init_y, t, p)

fig = plt.figure()
#ax = fig.gca(projection="3d")
ax = fig.add_subplot(projection="3d")
ax.plot(result[:,0], result[:,1], result[:,2])
plt.show()