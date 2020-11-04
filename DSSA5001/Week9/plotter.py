import matplotlib, csv, sys, time
import sys, time
matplotlib.use("Agg")
from matplotlib import pyplot as plt
import pandas as pd

timestr = time.strftime("%H%M")

df = pd.read_csv(sys.argv[1], delimiter=',', header=None, names=[ "sex", "length", "diameter", "height", "whole_weight", "shucked_weight", "viscera_weight", "shell_weight", "rings"])

df1 = df[["length", "diameter"]]
color_dict = {'diameter': '#FF7F50', 'length': '#50FFD7'}

fig, ax = plt.subplots(1,1)
ax.scatter(df1["diameter"], df1["length"], s=10, c=[color_dict.get(x, '#333333') for x in df1.columns], label=[color_dict.get(x, '#333333') for x in df1.columns])
fig.suptitle("Abalone Physical Statistics")
plt.xlabel("Diameter");
plt.ylabel("Length");
plt.legend()

#timestr = time.strftime("%H%M")
plt.savefig("png/abalone_data_2dimensions_" + timestr + ".png")




#df2 = df[["length", "diameter", "whole_weight", "shell_weight"]]
color_dict = {'diameter': '#FF7F50', 'shell_weight': '#50FFD7', 'length': '#FFD750', 'whole_weight': '#50FF7F'}

#fig2, ax2 = plt.subplots(1,1)
#ax2.scatter(df[["diameter", "shell_weight"]], df[["length", "whole_weight"]], s=10, c=[color_dict.get(x, '#333333') for x in df2.columns], label=df2.)
#fig2.suptitle("Abalone Physical Statistics")
ax.scatter(df["whole_weight"], df["shell_weight"], c=[color_dict.get(x, '#333333') for x in df.columns])

#ax2.legend()
plt.ylabel("Length & Whole Wright");
plt.xlabel("Diameter & Shell Weight");

plt.savefig("png/abalone_data_4dimensions_" + timestr + ".png")
