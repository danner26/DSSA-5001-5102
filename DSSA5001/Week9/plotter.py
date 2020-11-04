import matplotlib, csv, sys, time
matplotlib.use("Agg")
from matplotlib import pyplot as plt
import pandas as pd

file_name = sys.argv[1]
df = pd.read_csv(sys.argv[1], names=[ "Sex", "Length", "Diameter", "Height", "Whole Weight", "Shucked Weight", "Viscera Weight", "Shell Weight", "Rings"])

fig, ax = plt.subplots(1,1)
ax.scatter(df["Length"], df["Diameter"], s=10, c='coral')
fig.suptitle("Abalone Physical Statistics")
#plt.rc('font', size=200)
plt.xlabel("Length");
plt.ylabel("Diameter");

timestr = time.strftime("%H%M")
plt.savefig("png/abalone_data_2dimensions_" + timestr + ".png")

df2 = df[["Length", "Diameter", "Whole Weight", "Shell Weight"]]

fig, ax = plt.subplots(1,1)
ax.scatter(df[["Diameter", "Shell Weight"]], df[["Length", "Whole Weight"]], s=10, c='coral')
fig.suptitle("Abalone Physical Statistics")
#plt.rc('font', size=200)
plt.ylabel("Length & Whole Wright");
plt.xlabel("Diameter & Shell Weight");

timestr = time.strftime("%H%M")
plt.savefig("png/abalone_data_4dimensions_" + timestr + ".png")
