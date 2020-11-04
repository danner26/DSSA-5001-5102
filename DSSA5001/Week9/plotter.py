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
        length.append(float(row[1].strip('"')))
        diameter.append(float(row[2].strip('"')))

fig, ax = plt.subplots(1,1)
print(max(length))
print(min(length))
print(max(diameter))
print(min(diameter))

#feature1 = [1,2,3,4,5,6]
#feature2 = [3,4,5,6,5,3]
#ax.scatter(feature1, feature2)
#plt.xlim(0,1)
#plt.ylim(0,1)
ax.scatter(length, diameter)
ax.set_xlabel('Length')
ax.set_ylabel('Diameter')

#plt.savefig('example.png')
plt.savefig('figure.png')
