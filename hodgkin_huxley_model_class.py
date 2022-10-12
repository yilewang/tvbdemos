#!/usr/bin/python


import numpy as np
import matplotlib.pyplot as plt
plt.style.use('ggplot')

class neuron(object):
    def __init__(self) -> None:
        self.t = 0
        self.axon = []
    
    def slope(self):
        return 0.
    
    def step(self, dt):
        raise NotImplemented
    
    def send_spike(self, n=1):
        for a in self.axon:
            a.transmit(n)


class hodgkin_huxley_model(neuron):
    '''
    This script is to help me understand hodgkin huxley model.

    Cm: a capacitance per unit area representing the membrane lipid-bilayer (adopted value: 1 µF/cm²)

    gNa: voltage-controlled conductance per unit area associated with the Sodium (Na) ion-channel (adopted value: 120 µS/cm²)

    gK: voltage-controlled conductance per unit area associated with the Potassium (K) ion-channel (adopted value: 36 µS/cm²)

    gl: conductance per unit area associated with the leak channels (adopted value: 0.3 36 µS/cm²)

    VNa: voltage source representing the electrochemical gradient for Sodium ions (adopted value: 115 mV)

    VK: voltage source representing the electrochemical gradient for Potassium ions (adopted value: -12 mV)

    Vl: voltage source that determines the leakage current density together with gl (adopted value: 10.613 mV)    

    '''

    def __init__(self) -> None:
        super().__init__()
        self.v = 0.
        self.m = 0.
        self.h = 0.
        self.n = 0.

        # derivatives
        self.dV = 0.
        self.dm = 0.
        self.dh = 0.
        self.dn = 0.

        self.cm = 0.02

        # set maximal channel conductances
        self.gL = 0.003
        self.gK = 0.36
        self.gNa = 1.2

        # set reverse potentials
        self.EL = -54.387
        self.Ek = -77
        self.ENa = 50

        self.input_current = (lambda t: 0.)

    @classmethod
    def nGate(cls, V):
        '''
        Input:
            Voltage
        Output:
            n_inf
            tau_n
        '''
        if (abs(V+55) > 1e-5):
            alpha = (0.01*(V+55)) / (1-np.exp(-0.1*(V+55)))
        else:
            alpha = 0.1
        
        beta = 0.125*np.exp(-0.0125*(V+65))
        tau_n = 1 / (alpha+beta)
        n_inf = alpha*tau_n
        return [n_inf, tau_n]

    @classmethod
    def mGate(cls, V):
        if (abs(V+40) > 1e-5):
            alpha = (0.1*(V+40)) / (1-np.exp(-0.1*(V+40)))
        else:
            alpha = 1.0
        
        beta = 4*np.exp(-0.0556*(V+65))
        tau_m = 1 / (alpha+beta)
        m_inf = alpha*tau_m
        return [m_inf, tau_m]

    @classmethod
    def hGate(cls, V):
        alpha = 0.07*np.exp(-0.05*(V+65))
        beta = 1. / (1+ np.exp(-0.1*(V+35)))
        tau_h = 1 / (alpha+beta)
        h_inf = alpha*tau_h
        return [h_inf, tau_h]

    def axon(self):
        output = max(0, self.v-self.EL)
        return output

    def simulate(self, tspan, dt):
        s = 1000.
        start_ms = tspan[0]*s
        end_ms = tspan[1]*s
        dt_ms = dt*s
        t_ms = start_ms
        y = np.array([self.v, self.m, self.h, self.n])

        sol = dict(t=[], y=[])
        sol["y"].append(y)
        sol["t"].append(t_ms/s)

        while t_ms < end_ms:
            self.slope(t_ms)
            self.step(dt_ms)
            t_ms += dt_ms
            sol['t'].append(t_ms/s)
            sol['y'].append(np.array([self.v, self.m, self.h, self.n]))
        sol['t'] = np.array(sol['t'])
        sol['y'] = np.array(sol['y'])
        return sol
    
    def slope(self,t):
        s = 1000.
        V = self.v
        ninf, taun = hodgkin_huxley_model.nGate(V)
        minf, taum = hodgkin_huxley_model.mGate(V)
        hinf, tauh = hodgkin_huxley_model.hGate(V)

        Ie = self.input_current(t/s)
        I = (self.gL * (V-self.EL) + self.gK * self.n**4*(V-self.Ek) + self.gNa*self.m**3*self.h*(V-self.ENa))

        self.dV = (-I+Ie) / self.cm
        self.dn = (ninf-self.n)/taun
        self.dm = (minf-self.m)/taum
        self.dh = (hinf-self.h)/tauh

    def step(self, dt):
        self.v += dt*self.dV
        self.m += dt*self.dm
        self.h += dt*self.dh
        self.n += dt*self.dn
        return [self.v, self.m, self.h, self.n]


dt = 0.00001
t = np.arange(0.0, 1.0, dt)

z0 = [-52, 0.18, 0.21, 0.5] # initial value of V, m, h, n

def InjectedCurrent(t):
    '''
    current changes with time
    '''
    return 0.2
    # if t>0.0 and t<0.3:
    #     return -0.2
    # elif t<0.5:
    #     return 0.1
    # elif t <0.8:
    #     return 0.3
    # else:
    #     return 0.6

J = [InjectedCurrent(tt) for tt in t]

# simulation
hh = hodgkin_huxley_model()
tspan = [0,1.0]
hh.input_current = InjectedCurrent
sol=hh.simulate(tspan, dt)


plt.plot(sol['t'], sol['y'][:,0])
plt.show()