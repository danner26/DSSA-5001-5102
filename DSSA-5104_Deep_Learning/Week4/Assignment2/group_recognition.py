import face_recognition
import numpy as np
from PIL import Image
from os import path, listdir

IMAGES_PREPATH = path.dirname(path.realpath(__file__)) + "\\images\\"
FACE_PATH = path.dirname(path.realpath(__file__)) + "\\"
group = face_recognition.load_image_file("groupphoto.jpg")
face_locations = face_recognition.face_locations(group)

group_people = []
for i in face_locations:
    top = i[0]
    right = i[1] 
    bottom = i[2] 
    left = i[3]
    face_image = group[top:bottom, left:right]
    group_people.append(Image.fromarray(face_image))

# Helper function to compute and return the SSR
def SSR(ar1, ar2):
    return(np.sum((ar1-ar2)**2))

def find_person(face):
    spec = []
    listing = listdir(IMAGES_PREPATH)
    finalar = []
    k = 0

    print('Looking through Image Database for Matches....')
    facear = np.array(face)
    for file in listing:
        im = Image.open(IMAGES_PREPATH + file)
        im = im.resize(face.size)
        im = np.array(im)
        spec.append(im)

    for i in spec:
        k += 1
        finalar.append(SSR(facear, i))
        
    print('\nFACE FOUND AT POSITION:', finalar.index(min(finalar)), 'WITH SSR', min(finalar))
    print('Displaying Face Image')
    face = finalar.index(min(finalar))
    facepic = Image.fromarray(spec[face])
    # facepic.show()

for face in group_people:
    face.show()
    find_person(face)