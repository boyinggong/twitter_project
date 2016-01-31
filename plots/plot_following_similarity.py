import json
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

def heatmap(data, names = None):
    plt.pcolor(data)
    plt.colorbar()
    plt.xticks(np.arange(data.shape[0]) + 0.5,
               names, rotation = "vertical")
    plt.yticks(np.arange(data.shape[0]) + 0.5,
               names, rotation = "horizontal")
    plt.show()


with open("data/output_data/names.json") as f:
    names = json.load(f)
    names = [n.split(".")[0] for n in names]

dot_products = np.genfromtxt("data/output_data/following_dot_products_normalized.csv", delimiter=",")

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


nominees = pd.read_csv("data/input_data/golden_globes_metadata/nominees-spreadsheet-01-29.csv")

def subset_dot_products(condition, nominees,
                        dot_products, names):
    """Subset the dot_products matrix by applying condition to
    nominees, finding the relevant screen names, and subsetting
    the dot_products matrix to include only those screen names. """

    screen_names = nominees[condition].TWITTER_SCREEN_NAME
    screen_names = screen_names[screen_names.isin(names)]
    indices = []
    for s in screen_names:
        indices.append(names.index(s))
    return screen_names, dot_products[indices][:, indices]

cond = nominees.CATEGORY.str.contains("Best Actor")
subset_names, subset_dp = subset_dot_products(cond, nominees,
                                              dot_products, names)

user_by_following = np.genfromtxt("data/output_data/user_by_following.csv", delimiter = ",")

rowsums = np.sum(user_by_following, axis = 1)
plt.bar(np.arange(rowsums.size), np.sort(rowsums)[::-1])
plt.show()
