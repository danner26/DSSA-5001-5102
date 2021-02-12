import numpy as np
import sys
import matplotlib.pyplot as plt
from matplotlib import style
style.use("ggplot")

filename = "abalone.data.txt"
# x and y coordinates, whitespace-separated
X = np.loadtxt( filename, delimiter=',', usecols=(2,4) )
model = 5.1 * X[:,0] ** 2

plt.scatter(X[:, 0],X[:, 1], marker = 'o', s=150, alpha = 0.5,label='Observed')
plt.scatter(X[:, 0],model,marker='.',color='blue',label=r'Model: W=5.1D$^2$ ')
plt.xlabel('D')
plt.ylabel('W')
plt.legend()

plt.savefig("abalone.png")
