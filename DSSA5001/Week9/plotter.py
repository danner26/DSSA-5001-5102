import matplotlib, csv, sys, time
matplotlib.use("Agg")
from matplotlib import pyplot as plt
import pandas as pd

file_name = sys.argv[1]
df = pd.read_csv(sys.argv[1], names=[ "Sex", "Length", "Diameter", "Height", "Whole Weight", "Shucked Weight", "Viscera Weight", "Shell Weight", "Rings"])

fig, ax = plt.subplots(1,1)
ax.scatter(df["Length"], df["Diameter"], s=10, c='coral', zorder=1)
fig.suptitle("Abalone Physical Statistics")
#plt.rc('font', size=200)
plt.xlabel("Length");
plt.ylabel("Diameter");

timestr = time.strftime("%H%M")
plt.savefig("abalone_data_2dimensions_" + timestr + ".png")
