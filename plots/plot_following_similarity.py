import json
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import global_vars

COMPUTED_DIR = global_vars.COMPUTED_FOLLOWING + "/"

def heatmap(data, names = None):
    plt.pcolor(data)
    plt.colorbar()
    plt.xticks(np.arange(data.shape[0]) + 0.5,
               names, rotation = "vertical")
    plt.yticks(np.arange(data.shape[0]) + 0.5,
               names, rotation = "horizontal")
    plt.show()


with open(COMPUTED_DIR + "names.json") as f:
    names = json.load(f)
    names = [n.split(".")[0] for n in names]

dot_products = np.genfromtxt(COMPUTED_DIR + "following_dot_products_normalized.csv", delimiter=",")

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

def subset_indices(condition, nominees, names):
    """Find the indices of users based on condition.
    """

    screen_names = nominees[condition].TWITTER_SCREEN_NAME
    screen_names = screen_names[screen_names.isin(names)]
    indices = []
    for s in screen_names:
        indices.append(names.index(s))
    
    return screen_names, indices

cond = nominees.CATEGORY.str.contains("Best Actor")
subset_names, indices = subset_indices(cond, nominees, names)
subset_dp = dot_products[indices][:, indices]

user_by_following = np.genfromtxt(COMPUTED_DIR + "user_by_following.csv", delimiter = ",")

rowsums = np.sum(user_by_following, axis = 1)
#plt.bar(np.arange(rowsums.size), np.sort(rowsums)[::-1])
#plt.show()

## TODO: add coloring by winner to above plot
