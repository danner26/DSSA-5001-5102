import numpy as np 
import matplotlib.pyplot as plt 

def func(b, x): # y = 2 + e^(-bx)sin(x)
    return 2 + np.exp(-b * x) * np.sin(x)

def graph(formula, x, filename):
    plt.plot(x, formula)
    plt.savefig(filename)
    plt.clf()

x = np.linspace(0, 30, num=100)
graph(func(0.05, x), x, "lochness_b005.png")
graph(func(0.1, x), x, "lochness_b01.png")