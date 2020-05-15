import logging
from sklearn import linear_model
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics
import numpy as np


def gaussian_bayes_regressor(x_train, x_test, y_train, y_test):
    clf = linear_model.BayesianRidge(compute_score=True)
    clf.fit(x_train, y_train)
    logging.debug("Model fitted")

    x_test_array = np.squeeze(np.asarray(x_test))
    predicted_values = clf.predict(x_test_array)
    logging.debug("Prediction was made ")
    get_result_statistics(predicted_values, y_test)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2;', buildings_present='0;1', basic_data_version=True,
                                          test_size=0.2)
    gaussian_bayes_regressor(x_train, x_test, y_train, y_test)
