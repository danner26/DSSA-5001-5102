import matplotlib.pyplot as plt

fig, ax = plt.subplots(1,1)

feature1 = [1,2,3,4,5,6]
feature2 = [3,4,5,6,5,3]
ax.scatter(feature1,feature2)
ax.set_ylabel('feature 1')
ax.set_ylabel('feature 2')

plt.savefig('figure.png')
	
