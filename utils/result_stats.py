from sklearn.metrics import mean_squared_error, mean_absolute_error
import logging
import numpy as np


def get_result_stats(predicted_values, real_values):
    test_mse = mean_squared_error(real_values, predicted_values)
    test_rmse = np.sqrt(test_mse)
    test_mae = mean_absolute_error(real_values, predicted_values)

    mean_absolute_percentage_error = np.mean(np.abs((real_values - predicted_values) / real_values)) * 100
    # Calculate and display accuracy
    accuracy = 100 - np.mean(mean_absolute_percentage_error)
    logging.info('Accuracy: %s', round(accuracy, 6))
    logging.info("Squared Mean Error: %s, Mean Absolute Error: %s, Mean Absolute Percentage Error: %s", test_rmse, test_mae, mean_absolute_percentage_error)

    return test_rmse, test_mae
