import numpy as np
import matplotlib.pyplot as plt



# sigmoid activation function
# Implementacja sigmoidalnej funkcji aktywacji. 1/(1+e do -Bx)


def sigmoid(matrix):
    return 1.0 / (1.0 + np.exp(-matrix))


# one layer feed forward
# model sieci, w którym nie ma rekurencji, idziemy do przodu, małe wagi początkowe każdy node
def feed_forward(W, dataset, activation_fun):
    mul = np.dot(dataset, W) #np.dot - mnożenie macierzowe
    return activation_fun(mul)


class Rbm:
    def __init__(self, visible_size, hidden_size, learning_rate):
        self.visible_size = visible_size
        self.hidden_size = hidden_size
        self.learning_rate = learning_rate
        self.W = np.random.normal(scale=0.01, size=(visible_size+1, hidden_size+1)).astype(np.float32)
        self.W[:, -1] = 0.0
        self.W[-1, :] = 0.0
