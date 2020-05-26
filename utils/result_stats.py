from sklearn.metrics import mean_squared_error, mean_absolute_error, explained_variance_score, r2_score
import logging
import numpy as np
from utils.plots.basic_plot import values_one_plot_with_linear_and_dots, values_one_plot


def get_result_statistics(predicted_values, real_values):
    test_mse = mean_squared_error(real_values, predicted_values)
    test_rmse = np.sqrt(test_mse)
    test_mae = mean_absolute_error(real_values, predicted_values)

    mean_absolute_percentage_error = np.mean(np.abs(predicted_values - real_values) / real_values) * 100
    # Calculate and log accuracy
    accuracy = 100 - np.mean(mean_absolute_percentage_error)

    # Best result: 1.0
    explained_variance_score_result = explained_variance_score(real_values, predicted_values)
    r2_score_result = r2_score(real_values, predicted_values)
    logging.info('Accuracy: %s percentage', round(accuracy, 6))
    logging.info('Explained variance score: %s', round(explained_variance_score_result, 6))
    logging.info('r2 score: %s', round(r2_score_result, 6))
    logging.info("Squared Mean Error: %s, Mean Absolute Error: %s, Mean Absolute Percentage Error: %s", test_rmse,
                 test_mae, mean_absolute_percentage_error)

    values_one_plot(real_values, predicted_values, "Real values", "Estimated values", "Linear regression")
    values_one_plot_with_linear_and_dots(real_values, predicted_values, "Real values", "Estimated values", "Linear regression")

    return test_rmse, test_mae
