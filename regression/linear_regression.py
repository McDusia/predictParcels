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
# funkcja kosztu, y - oczekiwana etykieta, X - dane wejściowe, params - paramtery modelu,
# h - oszacowana wartość, h-y - różnica pomiedzy wartością oszacowaną, a oczekiwaną
def compute_cost(X, y, params):
    n_samples = len(y)
    h = X @ params
    return (1/(2*n_samples))*np.sum((h-y)**2)


# (1/n_samples) * X.T @ (X @ params - y) - pochodna cząstkowa funkcji kosztu
# params holds the updated parameter values according to the update rule.

def gradient_descent(X, y, params, learning_rate, n_iters):
    n_samples = len(y)
    J_history = np.zeros((n_iters,1))

    for i in range(n_iters):
        params = params - (learning_rate/n_samples) * X.T @ (X @ params - y)
        J_history[i] = compute_cost(X, y, params)

    return (J_history, params)


n_samples = len(y)

# normalization, rescaling the values into a range of [0,1]
# to boost our accuracy while lowering the cost (error).
mu = np.mean(X, 0)
sigma = np.std(X, 0)

X = (X-mu) / sigma

X = np.hstack((np.ones((n_samples,1)),X))
n_features = np.size(X, 1)
params = np.zeros((n_features, 1))

n_iters = 1500
learning_rate = 0.01


initial_cost = compute_cost(X, y, params)

print("Initial cost is: ", initial_cost, "\n")

(J_history, optimal_params) = gradient_descent(X, y, params, learning_rate, n_iters)

print("Optimal parameters are: \n", optimal_params, "\n")

print("Final cost is: ", J_history[-1])

plt.plot(range(len(J_history)), J_history, 'r')

plt.title("Convergence Graph of Cost Function")
plt.xlabel("Number of Iterations")
plt.ylabel("Cost")
plt.show()