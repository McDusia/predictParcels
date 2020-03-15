import logging
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import cross_val_score
from utils.getBasicTrainData import get_basic_splitted_train_data
from utils.plots.basic_plot import basic_plot, values_one_plot
from utils.result_stats import get_result_stats


def run_sklearn_linear_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    sklearn_regressor = LinearRegression().fit(x_train_set, y_train_set)

    sklearn_train_accuracy = sklearn_regressor.score(x_train_set, y_train_set)
    sklearn_test_accuracy = sklearn_regressor.score(x_test_set, y_test_set)

    cross_validation_results = cross_val_score(sklearn_regressor, x_train_set, y_train_set, cv=50,
                                               scoring="neg_mean_squared_error")

    logging.info("Train accuracy: %s, Test accuracy: %s", sklearn_train_accuracy, sklearn_test_accuracy)
    logging.info("Cross Validation score: %s", cross_validation_results)
    # logging.debug("coefficient: %s", sklearn_regressor.coef_)

    predicted_values = sklearn_regressor.predict(x_test_set)

    get_result_stats(predicted_values=predicted_values, real_values=y_test_set)

    basic_plot(y_test_set, predicted_values, "Real values", "Estimated values", "Linear regression")
    values_one_plot(y_test_set, predicted_values, "Real values", "Estimated values", "Linear regression")

    return sklearn_train_accuracy, sklearn_test_accuracy


if __name__ == '__main__':
    x_train_set, x_test_set, y_train_set, y_test_set = get_basic_splitted_train_data()
    run_sklearn_linear_regression(x_train_set, x_test_set, y_train_set, y_test_set)
