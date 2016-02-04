import json
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import pandas as pd
#import seaborn as sns
import global_vars

COMPUTED_DIR = global_vars.COMPUTED_FOLLOWING + "/"
SPREADSHEET = global_vars.INPUT_GG_DATA_CSV

def heatmap(data, names = None):
    plt.pcolormesh(data)
    plt.colorbar()
    if names is not None:
        plt.xticks(np.arange(data.shape[0]) + 0.5,
                   names, rotation = "vertical")
        plt.yticks(np.arange(data.shape[0]) + 0.5,
                   names, rotation = "horizontal")
    plt.tight_layout()
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
## need to filter out half of them due to
## the symmetry of the matrix
similar = [similar[0][sorted_indices], similar[1][sorted_indices]]
similar_values = similar_values[sorted_indices]

pairs = [(names[similar[0][i]], names[similar[1][i]], similar_values[i])
         for i in range(len(similar[0]))]


for pair in pairs:
    print(pair)

def plot_pairs(num = 10):
    n = len(similar[0])
    plot_names = [names[similar[0][i]] + ", " + names[similar[1][i]]
                  for i in range(n)][::2]
    plot_values = [similar_values[i] for i in range(n)][::2]
    plt.barh(range(len(plot_names[0:num])), plot_values[0:num][::-1],
             tick_label = plot_names[0:num][::-1], align = "center")
    plt.xlabel("Similarity")
    plt.tight_layout()
    plt.show()


nominees = pd.read_csv(SPREADSHEET)

def subset_indices(condition, nominees, names):
    """Find the indices of users based on condition.
    """

    screen_names = nominees[condition].TWITTER_SCREEN_NAME
    screen_names = screen_names[screen_names.isin(names)]
    indices = []
    for s in screen_names:
        indices.append(names.index(s))
    
    return screen_names, indices

cond = nominees.CATEGORY.str.contains("Best TV Series")
subset_names, indices = subset_indices(cond, nominees, names)
subset_dp = dot_products[indices][:, indices]

#user_by_following = np.genfromtxt(COMPUTED_DIR + "user_by_following.csv", delimiter = ",")

rowsums = np.sum(user_by_following, axis = 1)[indices]
sorted_indices = np.argsort(rowsums) # [::-1]
D = pd.DataFrame({"name": np.array(nominees.NOMINEE[cond])[sorted_indices],
                 "count": rowsums[sorted_indices].astype(int),
                  "winner": np.array(nominees.WINNER_FLAG[cond])[sorted_indices]})



plt.legend(handles=[mpatches.Patch(color="blue", label="Loser"),
                    mpatches.Patch(color="green", label="Winner")],
           loc = "center right")
plt.barh(range(len(rowsums)), D["count"],
            tick_label = D["name"],
            color = np.array(["blue", "green"])[D["winner"]],
            align = "center")
plt.show()



plt.hist(dot_products, bins = 30)
plt.xlabel("Similarity")
plt.ylabel("Frequency")
plt.show()



# ax = sns.barplot(y = np.array(nominees.NOMINEE[cond])[sorted_indices],
#                 x = rowsums[sorted_indices],
#                 hue = np.array(nominees.WINNER_FLAG[cond])[sorted_indices])

#ax = sns.barplot(x = D["count"], y = D["name"], hue = np.array()[D["winner"]])
#ax = sns.barplot(x = "count", y = "name", hue = "winner", data = D)
#sns.plt.show()

## TODO: add coloring by winner to above plot




#from ggplot import *


#ggplot(aes(x = "name",
