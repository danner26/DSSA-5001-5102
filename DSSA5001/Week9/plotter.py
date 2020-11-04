import matplotlib, csv, sys
matplotlib.use("Agg")
from matplotlib import pyplot as plt

length = []
diameter = []

with open(sys.argv[1], 'r') as file:
    reader = csv.reader(file)
    for row in reader:
#        if(len(row) != 9):
#            print("abnormal")
        length.append(row[1])
        diameter.append(row[2])

fig, ax = plt.subplots(1,1)

#feature1 = [1,2,3,4,5,6]
#feature2 = [3,4,5,6,5,3]
ax.scatter(length, diameter)
ax.set_ylabel('Length')
ax.set_ylabel('Diameter')

plt.savefig('figure.png')
