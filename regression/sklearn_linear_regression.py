from sklearn.datasets import load_boston
import linear_regression as lr
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
import pandas as pd

dataset = load_boston()

X = dataset.data
y = dataset.target

X_train, X_test, y_train, y_test = train_test_split( \
    X, y, test_size=0.3, random_state=42)

our_regressor = lr.LinearRegression(X_train, y_train).fit()
sklearn_regressor = LinearRegression().fit(X_train, y_train)

our_train_accuracy = our_regressor.score()
sklearn_train_accuracy = sklearn_regressor.score(X_train, y_train)

our_test_accuracy = our_regressor.score(X_test, y_test)
sklearn_test_accuracy = sklearn_regressor.score(X_test, y_test)

pd.DataFrame([[our_train_accuracy, sklearn_train_accuracy],
              [our_test_accuracy, sklearn_test_accuracy]],
             ['Training Accuracy', 'Test Accuracy'],
             ['Our Implementation', 'Sklearn\'s Implementation'])
