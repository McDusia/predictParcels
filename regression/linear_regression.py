import numpy as np
from sklearn.datasets import load_boston
import matplotlib.pyplot as plt


dataset = load_boston()

X = dataset.data    # feature samples
y = dataset.target[:, np.newaxis]    # target values, labels,
# np.newaxis function - increase the dimension of an array by one more dimension

print("Total samples in our dataset is: {}".format(X.shape[0]))


# (1/2) x Mean Squared Error (MSE)
# h - hypothesis function, candidate function for mapping from input X to outputs y
def compute_cost(X, y, params):
    n_samples = len(y)
    h = X @ params
    return (1/(2*n_samples))*np.sum((h-y)**2)