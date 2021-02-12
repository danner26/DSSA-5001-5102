import numpy as np

A = np.matrix([                 # 3x3 matrix
    [130, 120, 105], 
    [4, 3, 1], 
    [2, 5, 1]
    ])
B = np.matrix([                 # 2x3 matrix
    [6, 7], 
    [4, 5], 
    [8, 9]
    ])
C = np.matrix([                 # 3x3 matrix
    [5, 2, 7], 
    [3, 5, 1], 
    [7, 2, 1]
    ])
D = np.matrix([                 # 1x3 matrix
    [245], 
    [6], 
    [7]
    ]) 

aplusc = np.add(A, C)           # add matrices
aminusc = np.subtract(A, C)     # subtract matrices
atimesc = np.matmul(A, C)       # multiply matrices
ctimesd = np.matmul(C, D)       # multiply matrices

print("A + C: \n%s" % aplusc)
print("A - C: \n%s" % aminusc)
print("AC: \n%s" % atimesc)
print("CD: \n%s" % ctimesd)