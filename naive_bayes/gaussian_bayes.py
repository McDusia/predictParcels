import logging
from sklearn import linear_model
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics
import numpy as np


def make_prediction(model, x_data):
    predicted_values = model.predict(x_data)
    logging.debug("Prediction was made ")
    return predicted_values


def train_model(x_train, y_train):
    # clf = linear_model.BayesianRidge(n_iter=500, tol=0.001, alpha_1=1e-06, alpha_2=1e-06, lambda_1=1e-06, lambda_2=1e-06, compute_score=False, fit_intercept=True, normalize=True, copy_X=True, verbose=False)
    clf = linear_model.BayesianRidge(n_iter=1000, tol=0.001, alpha_1=1e-03, alpha_2=1e-06, lambda_1=1e-8,
                                     lambda_2=1e-10, compute_score=False, fit_intercept=True, normalize=True,
                                     copy_X=True, verbose=False)
    clf.fit(x_train, y_train)
    logging.debug("Model fitted")
    return clf


def gaussian_bayes_regressor(x_train, x_test, y_train, y_test):
    clf_bayesan = train_model(x_train=x_train, y_train=y_train)
    logging.debug(clf_bayesan.coef_)

    x_test_array = np.squeeze(np.asarray(x_test))
    predicted_values = make_prediction(x_data=x_test_array, model=clf_bayesan)
    logging.debug("Prediction was made ")
    get_result_statistics(predicted_values, y_test)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1', basic_data_version=True,
                                          test_size=0.2)
    gaussian_bayes_regressor(x_train, x_test, y_train, y_test)
