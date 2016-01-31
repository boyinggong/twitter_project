import json
import numpy as np
import matplotlib.pyplot as plt

with open("data/names.json") as f:
    names = json.load(f)

dot_products = np.genfromtxt("data/following_dot_products_normalized.csv", delimiter=",")

lower = 0.1
upper = 0.9
similar = np.nonzero(np.logical_and(dot_products > lower,
                                    dot_products < upper))
similar_values = dot_products[similar]
sorted_indices = np.argsort(similar_values)[::-1]
similar = [similar[0][sorted_indices], similar[1][sorted_indices]]
similar_values = similar_values[sorted_indices]

pairs = [(names[similar[0][i]], names[similar[1][i]], similar_values[i])
         for i in range(len(similar[0]))]

## need to filter out half of them due to
## the symmetry of the matrix
for pair in pairs[0::2]:
    print(pair)

def heatmap(data):
    plt.pcolor(data)
    plt.colorbar()
    plt.show()


