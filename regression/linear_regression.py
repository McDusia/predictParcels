import numpy as np
from sklearn.datasets import load_boston
import matplotlib.pyplot as plt


class LinearRegression:
    def __init__(self, X, y, learning_rate=0.01, n_iters=1500):
        self.learning_rate = learning_rate
        self.n_iters = n_iters
        self.n_samples = len(y)
        self.n_features = np.size(X, 1)
        self.X = normalization(X, len(y))
        self.y = y[:, np.newaxis]
        self.params = np.zeros((self.n_features + 1, 1))
        self.J_history = np.zeros((n_iters, 1))
        self.coef_ = None
        self.intercept_ = None

    def fit(self):
        for i in range(self.n_iters):
            self.params = self.params - (self.learning_rate/self.n_samples) * self.X.T @ (self.X @ self.params - self.y)
            self.J_history[i] = self.compute_cost()
        self.intercept_ = self.params[0]
        self.coef_ = self.params[1:]
        return self

    def score(self):
        y = self.y
        X = self.X
        X = normalization(X)
        y_pred = X @ self.params
        score = 1 - (((y - y_pred) ** 2).sum() / ((y - y.mean()) ** 2).sum())

        return score

    # (1/2) x Mean Squared Error (MSE)
    # h - hypothesis function, candidate function for mapping from input X to outputs y
    # funkcja kosztu, y - oczekiwana etykieta, X - dane wejściowe, params - paramtery modelu,
    # h - oszacowana wartość, h-y - różnica pomiedzy wartością oszacowaną, a oczekiwaną
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


# (1/n_samples) * X.T @ (X @ params - y) - pochodna cząstkowa funkcji kosztu
# params holds the updated parameter values according to the update rule.
#def gradient_descent(X, y, params, learning_rate, n_iters, n_samples, J_history):
    #n_samples = len(y)
    #J_history = np.zeros((n_iters, 1))

#    for i in range(n_iters):
 #       params = params - (learning_rate/n_samples) * X.T @ (X @ params - y)
  #      J_history[i] = compute_cost(X, y, params)

   # return J_history, params

# normalization, rescaling the values into a range of [0,1]
    # to boost our accuracy while lowering the cost (error).
def normalization(x, _n_samples):
    mu = np.mean(x, 0)
    sigma = np.std(x, 0)
    print('sigma')
    print(sigma)
    x_tmp = (x - mu) / sigma
    return np.hstack((np.ones((_n_samples, 1)), x_tmp))


def compute_cost(_x, _y, _params):
    h = _x @ _params
    return (1 / (2 * len(_y))) * np.sum((h - _y) ** 2)


dataset = load_boston()

X = dataset.data    # feature samples
y = dataset.target[:, np.newaxis]    # target values, labels,
# np.newaxis function - increase the dimension of an array by one more dimension

print("Total samples in our dataset is: {}".format(X.shape[0]))
#n_samples = len(y)

#mu = np.mean(X, 0)
#sigma = np.std(X, 0)
#X = (X - mu) / sigma
#X = np.hstack((np.ones((n_samples, 1)), X))
#X = normalization(X, n_samples)
n_features = np.size(X, 1)
params = np.zeros((n_features, 1))

lin = LinearRegression(X, y, 0.01, 1500)

initial_cost = compute_cost(X, y, params)
print("Initial cost is: ", initial_cost, "\n")

#(J_history, optimal_params) = gradient_descent(X, y, params, 0.01, 1500)

lin.fit()

#print("Optimal parameters are: \n", lin.params, "\n")
print("Final cost is: ", lin.J_history[-1])
plt.plot(range(len(lin.J_history)), lin.J_history, 'r')

plt.title("Convergence Graph of Cost Function")
plt.xlabel("Number of Iterations")
plt.ylabel("Cost")
plt.show()
