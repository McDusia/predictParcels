import logging
import numpy as np

# import matplotlib.pyplot as plt

logging.basicConfig(level=logging.DEBUG)

# TODO fix this implementation with out dataset
def run_linear_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    lin = LinearRegression(x_train_set, y_train_set, 0.01, 1500)
    initial_cost = lin.compute_cost()
    logging.debug("Initial cost is: %s", initial_cost)
    lin.fit()
    logging.info("Optimal parameters are: %s ", lin.params)
    logging.info("Final cost is: %s", lin.J_history[-1])
    # plt.plot(range(len(lin.J_history)), lin.J_history, 'r')
    #
    # plt.title("Convergence Graph of Cost Function")
    # plt.xlabel("Number of Iterations")
    # plt.ylabel("Cost")
    # plt.show()
    #
    our_train_accuracy = lin.score()
    our_test_accuracy = lin.score(x_test_set, y_test_set)
    return our_train_accuracy, our_test_accuracy


class LinearRegression:
    def __init__(self, _x, _y, learning_rate=0.01, n_iters=1500):
        self.learning_rate = learning_rate
        self.n_iters = n_iters
        self.n_samples = len(_y)
        self.X = self.normalization(_x)
        self.n_features = np.size(self.X, 1)
        self.y = _y
        self.params = np.zeros((self.n_features, 1))
        self.J_history = np.zeros((n_iters, 1))

    def fit(self):
        for i in range(self.n_iters):
            self.params = self.params - (self.learning_rate / self.n_samples) * self.X.T @ (
                    self.X @ self.params - self.y)
            self.J_history[i] = self.compute_cost()
        return self

    def score(self, X=None, y=None):
        if X is None:
            X = self.X
        else:
            n_samples = np.size(X, 0)
            X = np.hstack((np.ones(
                (n_samples, 1)), (X - np.mean(X, 0)) / np.std(X, 0)))

        if y is None:
            y = self.y
        else:
            y = y[:, np.newaxis]

        y_pred = X @ self.params
        score = 1 - (((y - y_pred) ** 2).sum() / ((y - y.mean()) ** 2).sum())
        return score

    # (1/2) x Mean Squared Error (MSE)
    # h - hypothesis function, candidate function for mapping from input X to outputs y
    def compute_cost(self):
        h = self.X @ self.params
        return (1 / (2 * self.n_samples)) * np.sum((h - self.y) ** 2)

    def predict(self, X):
        n_samples = np.size(X, 0)
        y = np.hstack((np.ones((n_samples, 1)), (X - np.mean(X, 0)) \
                       / np.std(X, 0))) @ self.params
        return y

    def get_params(self):
        return self.params

    # normalization, rescaling the values into a range of [0,1]
    # to boost our accuracy while lowering the cost (error).
    def normalization(self, x):
        mu = np.mean(x, 0)
        sigma = np.std(x, 0)
        x_tmp = (x - mu) / sigma
        return np.hstack((np.ones((self.n_samples, 1)), x_tmp))
