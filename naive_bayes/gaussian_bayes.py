import logging
from sklearn import linear_model
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics
import numpy as np
from sklearn.model_selection import GridSearchCV


def make_prediction(model, x_data):
    predicted_values = model.predict(x_data)
    logging.debug("Prediction was made ")
    return predicted_values


def train_model(x_train, y_train):
    # parameters = {'n_iter': [500, 1000], 'alpha_1': [1, 1e-10, 100]}
    parameters = {'alpha_1': [10000000], 'alpha_2': [1e-10], 'lambda_1': [1e-07], 'lambda_2': [100], 'n_iter': [500]}
    # clf = linear_model.BayesianRidge(n_iter=500, tol=0.001, alpha_1=1e-06, alpha_2=1e-06, lambda_1=1e-06, lambda_2=1e-06, compute_score=False, fit_intercept=True, normalize=True, copy_X=True, verbose=False)
    # clf = linear_model.BayesianRidge(n_iter=1000, tol=0.001, alpha_1=1e-03, alpha_2=1e-06, lambda_1=1e-8,
    #                                  lambda_2=1e-10, compute_score=False, fit_intercept=True, normalize=True,
    #                                  copy_X=True, verbose=True)
    br = linear_model.BayesianRidge()
    clf = GridSearchCV(br, parameters)
    clf.fit(x_train, y_train)
    logging.debug(clf.best_estimator_.coef_)
    logging.debug(clf.best_params_)
    logging.debug("Model fitted")
    return clf


def gaussian_bayes_regressor(x_train, x_test, y_train, y_test):
    clf_bayesan = train_model(x_train=x_train, y_train=y_train)
    # logging.debug(clf_bayesan.coef_)

    x_test_array = np.squeeze(np.asarray(x_test))
    predicted_values = make_prediction(x_data=x_test_array, model=clf_bayesan)
    logging.debug("Prediction was made ")
    get_result_statistics(predicted_values, y_test, plot_title="Bayesan Ridge regression")


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='2;', buildings_present='0;1', columns_to_omit=[],
                                          use_distances=True,
                                          random_state=50, test_size=0.2)
    gaussian_bayes_regressor(x_train, x_test, y_train, y_test)
