from PIL import Image
import numpy as np
from os import listdir, path

IMAGES_PREPATH = path.dirname(path.realpath(__file__)) + "\\images\\"
SPY_PATH = path.dirname(path.realpath(__file__)) + "\\"

# Helper function to compute and return the SSR
def SSR(ar1, ar2):
    return(np.sum((ar1-ar2)**2))

def find_spy(spy):
    spec = []
    listing = listdir(IMAGES_PREPATH)
    finalar = []
    k = 0
    spy_file_name, spy_file_extension = path.splitext(spy)

    print('Looking through Image Database for Matches....')
    spyar = Image.open(spy)
    spyar = np.array(spyar)

    for file in listing:
        if file.endswith(spy_file_extension):
            print('found file.... comparing')
            im = Image.open(IMAGES_PREPATH + file)
            im = np.array(im)
            spec.append(im)

    for i in spec:
        k += 1
        finalar.append(SSR(spyar, i))
        
    print('\nSPY FOUND AT POSITION:', finalar.index(min(finalar)), 'WITH SSR', min(finalar))
    print('Displaying Spy Image')
    spy = finalar.index(min(finalar))
    spypic = Image.fromarray(spec[spy])
    spypic.show()

spy = SPY_PATH + 'DC.png'
find_spy(spy)
