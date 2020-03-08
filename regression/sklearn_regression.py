from sklearn.linear_model import LinearRegression
import logging


def run_sklearn_linear_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    sklearn_regressor = LinearRegression().fit(x_train_set, y_train_set)

    sklearn_train_accuracy = sklearn_regressor.score(x_train_set, y_train_set)
    sklearn_test_accuracy = sklearn_regressor.score(x_test_set, y_test_set)

    logging.info("Train accuracy: %s, Test accuracy: %s", sklearn_train_accuracy, sklearn_test_accuracy)
    logging.debug("coefficient: %s", sklearn_regressor.coef_)

    return sklearn_train_accuracy, sklearn_test_accuracy
