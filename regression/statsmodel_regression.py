import logging
import statsmodels.api as sm
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics


def run_statsmodels_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    model = sm.OLS(y_train_set, x_train_set.astype(int))
    results = model.fit()
    logging.info(results.summary())

    predicted_values = results.predict(x_test_set.astype(int))

    get_result_statistics(predicted_values=predicted_values, real_values=y_test_set)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1', basic_data_version=True,
                                          random_state=50, test_size=0.2)
    run_statsmodels_regression( x_train, x_test, y_train, y_test)
