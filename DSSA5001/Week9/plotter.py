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

ax.scatter(length, diameter, s=10, c='coral')
fig.suptitle("Abalone Physical Statistics")
#plt.rc('font', size=200)
plt.xlabel("Length");
plt.ylabel("Diameter");

plt.savefig('abalone_data_2dimensions.png')
