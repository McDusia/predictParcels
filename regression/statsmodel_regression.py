import logging
import statsmodels.api as sm
from utils.getBasicTrainData import get_basic_splitted_train_data
from utils.result_stats import get_result_stats


def run_statsmodels_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    model = sm.OLS(y_train_set, x_train_set.astype(int))
    results = model.fit()
    logging.info(results.summary())

    predicted_values = results.predict(x_test_set.astype(int))

    get_result_stats(predicted_values=predicted_values, real_values=y_test_set)


if __name__ == '__main__':
    x_train_set, x_test_set, y_train_set, y_test_set = get_basic_splitted_train_data()
    run_statsmodels_regression(x_train_set, x_test_set, y_train_set, y_test_set)
