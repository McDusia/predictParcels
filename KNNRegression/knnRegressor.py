import logging
import statsmodels.api as sm
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics
from sklearn.impute import SimpleImputer
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import GridSearchCV


# Grid Search - too slow
def run_KNN_regression(x_train, x_test_set, y_train, y_test_set):
    # logging.info("Evaluation started")
    # parameters = {'n_neighbors': [8, 9, 10, 11]}
    # knn = KNeighborsRegressor()
    # clf = GridSearchCV(knn, parameters)
    # clf.fit(x_train, y_train)
    # logging.debug(clf.best_estimator_.coef_)
    # logging.debug(clf.best_params_)
    # logging.debug("Model fitted")

    neigh = KNeighborsRegressor(n_neighbors=9)
    neigh.fit(x_train, y_train)
    predicted_values = neigh.predict(x_test_set)
    get_result_statistics(predicted_values=predicted_values, real_values=y_test_set)


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")  # startegy: 'mean'
    return imp.fit_transform(df)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1',
                                          random_state=50, test_size=0.2,
                                          use_distances=True,
                                          columns_to_omit=['Price_Group_int', 'Price_Group_int_second'])
    run_KNN_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test)
