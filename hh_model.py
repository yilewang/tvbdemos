#!/usr/bin/python

from scipy import *
import matplotlib.pyplot as plt
import matplotlib as mpl
from scipy.integrate import odeint
import numpy as np

def hodgkinHuxley(yy,t, p):

	#Name the variables
	V = yy[0]
	n = yy[1]
	m = yy[2]
	h = yy[3]
	
	#Name the parameters
	C_m = p[0]
	V_Na = p[1]
	V_K = p[2]
	V_l = p[3]
	g_Na = p[4]
	g_K = p[5]
	g_l = p[6]
	
	#The injected current? ? ? ? 
	I = p[7]
	
	#Auxiliary quantities	
	alpha_n = (0.01*(V+10)) / (np.exp((V+10)/10) -1 ) 
	beta_n = 0.125 * np.exp(V/80)	
	alpha_m = (0.1 *(V+25)) / (np.exp((V+25)/10) -1 ) 
	beta_m  = 4 * np.exp(V/18)
	alpha_h = 0.07 * np.exp( V/ 20)
	beta_h = 1 / (np.exp((V+30)/10) +1 ) 
	
	# HH model
	V_dot = (-1/C_m) * ( g_K*n*n*n*n*(V-V_K) + g_Na*m*m*m*h*(V-V_Na)+g_l*(V-V_l)-I)
	n_dot = alpha_n * (1-n) - beta_n *n 
	m_dot = alpha_m * (1-m) - beta_m * m 
	h_dot = alpha_h * (1-h) - beta_h * h
	
	
	return [V_dot, n_dot, m_dot, h_dot]


#Define initial conditions for the state variables
y0 = [0,0,0,0]

#Define time interval and spacing for the solutions
t = np.arange(0,100,0.01)

#Define fixed parameters pp. 520 (HH1952 paper)
C_m = 1
V_Na = -115
V_K = 12
V_l = -10.613
g_Na = 120
g_K = 36
g_l = 0.3


#plt is the alias for matplotlib.pyplot (see imports) 
#Repeat the same thing for different values of I and plot

#subplot2grid allows for placement of subplots in canvas

plt.figure(figsize=(15,10))
ax1 = plt.subplot2grid((4,1),(0,0))

plt.ylabel("Volts (mV)")

#no current? 
I = -0

#Pack the parameters in a single vector
p = [C_m,V_Na, V_K,V_l,g_Na,g_K,g_l,I] 

#Call the integrator 
y = odeint(hodgkinHuxley, y0, t, args=(p,)) 
ax1.set_title(f"I = {I}")
plt.plot(t, -y[:,0])

ax2 = plt.subplot2grid((4,1),(1,0))
#since all plots share the same xlabel, we want to skip the first 2 labels.
plt.ylabel("Volts (mV)")
I = -8.75
p = [C_m,V_Na, V_K,V_l,g_Na,g_K,g_l,I] 
y1 = odeint(hodgkinHuxley, y0, t, args=(p,)) 
plt.plot(t,-y1[:,0])
ax2.set_title(f"I = {I}")

ax3 = plt.subplot2grid((4,1),(2,0))
plt.ylabel("Volts (mV)")
I = -10
p = [C_m,V_Na, V_K,V_l,g_Na,g_K,g_l,I] 
y2 = odeint(hodgkinHuxley, y0, t, args=(p,)) 
ax3.set_title(f"I = {I}")
plt.plot(t,-y2[:,0])


ax4 = plt.subplot2grid((4,1),(3,0))
plt.xlabel("Time (msec)")
plt.ylabel("Volts (mV)")
I = -20
ax4.set_title(f"I = {I}")
p = [C_m,V_Na, V_K,V_l,g_Na,g_K,g_l,I] 
y3 = odeint(hodgkinHuxley, y0, t, args=(p,)) 
plt.plot(t,-y3[:,0])

# plt.savefig("HodgkinHuxley.png")
plt.show()