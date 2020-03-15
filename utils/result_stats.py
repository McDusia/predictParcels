from sklearn.metrics import mean_squared_error, mean_absolute_error
import logging
import numpy as np


def get_result_stats(predicted_values, real_values):
    test_mse = mean_squared_error(real_values, predicted_values)
    test_rmse = np.sqrt(test_mse)
    test_mae = mean_absolute_error(real_values, predicted_values)

    logging.info("Squared Mean Error: %s, Mean Absolute Error: %s", test_rmse, test_mae)

    return test_rmse, test_mae
