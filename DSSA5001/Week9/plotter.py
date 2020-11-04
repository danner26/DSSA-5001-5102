import matplotlib, csv, sys, time
import sys, time
matplotlib.use("Agg")
from matplotlib import pyplot as plt
import pandas as pd

timestr = time.strftime("%H%M")

df = pd.read_csv(sys.argv[1], delimiter=',', header=None, names=[ "sex", "length", "diameter", "height", "whole_weight", "shucked_weight", "viscera_weight", "shell_weight", "rings"])

fig, ax = plt.subplots(1,1)
ax.scatter(df["length"], df["diameter"], s=10, c='coral')
fig.suptitle("Abalone Physical Statistics")
plt.xlabel("Length");
plt.ylabel("Diameter");

#timestr = time.strftime("%H%M")
plt.savefig("png/abalone_data_2dimensions_" + timestr + ".png")




df2 = df[["length", "diameter", "whole_weight", "shell_weight"]]

fig2, ax2 = plt.subplots(1,1)
ax2.scatter(df[["diameter", "shell_weight"]], df[["length", "whole_weight"]], s=10, c=df[["length", "whole_weight"]])
fig2.suptitle("Abalone Physical Statistics")
plt.ylabel("Length & Whole Wright");
plt.xlabel("Diameter & Shell Weight");

plt.savefig("png/abalone_data_4dimensions_" + timestr + ".png")
