import json
import os
from functools import reduce
import numpy as np
import matplotlib.pyplot as plt

data_folder = 'data/output_data/following/'
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


computed = "data/output_data/following_computed_data/"
with open(computed + "all_followed.json") as f:
    json.dump(all_followed, f, indent = 4)

np.savetxt(computed + "user_by_following.csv",
           user_by_following, delimiter = ",")


dot_products = np.dot(user_by_following,
                      user_by_following.transpose())

np.savetxt(computed + "following_dot_products.csv",
           dot_products, delimiter = ",")

def normalize_row(a):
    norm = np.linalg.norm(a)
    return a / norm if norm > 0 else a

user_by_following = np.apply_along_axis(normalize_row,
                                        1, user_by_following)

# dot_products = np.apply_along_axis(normalize_row, 1,
#                                    dot_products)

dot_products = np.dot(user_by_following,
                      user_by_following.transpose())
np.savetxt(computed + "following_dot_products_normalized.csv",
           dot_products, delimiter = ",")

with open(computed + "names.json", "w") as f:
    json.dump(names, f, indent = 4)



# plt.hist(dot_products, bins = 20, normed = True)
# plt.show()
