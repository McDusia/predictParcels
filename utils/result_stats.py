from sklearn.metrics import mean_squared_error, mean_absolute_error, explained_variance_score, r2_score, max_error
from sklearn.utils import check_array
import logging
import numpy as np
from utils.plots.basic_plot import values_one_plot_with_linear_and_dots, values_one_plot


def mean_absolute_percentage_error(y_true, y_pred):
    # y_true = check_array(y_true)
    # y_pred = check_array(y_pred)

    # Note: does not handle mix 1d representation
    # if _is_1d(y_true):
    #    y_true, y_pred = _check_1d_array(y_true, y_pred)

    return np.mean(np.abs((y_true - y_pred) / y_true)) * 100


def rmse(predictions, targets):
    return np.sqrt(((predictions - targets) ** 2).mean())


def get_result_statistics(predicted_values, real_values):
    mse = mean_squared_error(real_values, predicted_values)
    rms = rmse(predicted_values, real_values)
    mean_absolute_percentage_e = mean_absolute_percentage_error(real_values, predicted_values)
    mae = mean_absolute_error(real_values, predicted_values)

    max_error_val = max_error(real_values, predicted_values)

    logging.info('Max error: %s', round(max_error_val, 6))
    # mean_absolute_percentage_error = np.mean(np.abs(predicted_values - real_values) / real_values) * 100
    # Calculate and log accuracy
    # accuracy = 100 - np.mean(mean_absolute_percentage_error)
    # logging.info('Accuracy: %s percentage', round(accuracy, 6))

    # Best result: 1.0 [explained_variance_score_result, r2_score_result]

    explained_variance_score_result = explained_variance_score(real_values, predicted_values)
    r2_score_result = r2_score(real_values, predicted_values)
    logging.info("Mean squared error: %s", mse)
    logging.info("Root mean squared error: %s", rms)
    logging.info("Mean absolute percentage error: %s", mean_absolute_percentage_e)
    logging.info('Explained variance score: %s', round(explained_variance_score_result, 6))
    logging.info('r2 score: %s', round(r2_score_result, 6))
    logging.info("Mean Absolute Error: %s", mae)

    values_one_plot(real_values, predicted_values, "Real values", "Estimated values", "Linear regression")
    values_one_plot_with_linear_and_dots(real_values, predicted_values, "Real values", "Estimated values",
                                         "Linear regression")
