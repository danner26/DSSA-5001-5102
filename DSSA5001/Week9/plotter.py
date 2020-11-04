import matplotlib, csv, sys
matplotlib.use("Agg")
from matplotlib import pyplot as plt

length = []
diameter = []

with open(sys.argv[1], 'r') as file:
    reader = csv.reader(file)
    for row in reader:
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
#plt.savefig('example.png')

ax.scatter(length, diameter, s=100)
fig.suptitle('testing')
plt.xlabel("Length");
plt.ylabel("Diameter");
#ax.set_xlabel('Length')
#ax.set_ylabel('Diameter')

plt.savefig('figure.png')
