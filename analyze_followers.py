import json
import os
from functools import reduce
import numpy as np
import matplotlib.pyplot as plt

data_folder = 'data/following/'
following = []
names = []
for filename in os.listdir(data_folder):
    names.append(filename)
    with open(data_folder + filename) as f:
        try:
            following.append(json.load(f))
        except json.JSONDecodeError:
            following.append([])


all_followed = sorted(reduce(set.union, map(set, following)))
user_by_following = np.zeros((len(names), len(all_followed)),
                             dtype = int)

for i in range(len(following)):
    for user in following[i]:
        column = all_followed.index(user)
        user_by_following[i, column] = 1

dot_products = np.dot(user_by_following,
                      user_by_following.transpose())

def normalize_row(a):
    norm = np.linalg.norm(a)
    return a / norm if norm > 0 else a

dot_products = np.apply_along_axis(normalize_row, 1,
                                   dot_products)

plt.hist(dot_products, bins = 20, normed = True)
plt.show()
