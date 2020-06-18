from sklearn import svm
import logging
from utils.get_basic_train_data import get_basic_data_splited_train_test, log_shape
from utils.data_preprocessor import fill_nan_values
from utils.result_stats import get_result_statistics
from sklearn.model_selection import GridSearchCV
import numpy as np


def run_svm_regression(x_train_set, x_test_set, y_train_set, y_test_set, degree=1, kernel='poly'):
    logging.info("Evaluation started")
    # parameters = {'kernel': ['rbf', 'poly'], 'degree': [3, 5, 10], 'epsilon': [0.1, 1, 10]}
    # svr = svm.SVR()
    # clf = GridSearchCV(svr, parameters)
    # clf.fit(x_train, y_train)

    # logging.debug(clf.best_estimator_.coef_)
    # logging.debug(clf.best_params_)

    # Currently best results with:
    # kernel='poly', degree=5, C=1, epsilon=.1, max_iter=1000000
    # test: 0.58; train: 0.67
    # increasing max iterations doesn't change final results, degree 10 gives bad results
    # regressor = svm.SVR(kernel='poly', degree=5, C=1, epsilon=.1, max_iter=1000000)

    regressor = svm.SVR(kernel=kernel, degree=degree, C=1, epsilon=.1)
    #  wyniki na to juz sa ale jeszcze raz bo nie bylo mean_square_error poprawnego

    # START
    # regressor = svm.SVR(kernel='poly', degree=1, C=1, epsilon=.1)
    # DEBUG:root:Reading data from database
    # DEBUG:root:Total samples in our dataset is: 57824
    # DEBUG:root:Total samples in our dataset is: 57824
    # INFO:root:Evaluation started
    # DEBUG:root:Model created
    # /Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/sklearn/svm/base.py:193: FutureWarning: The default value of gamma will change from 'auto' to 'scale' in version 0.22 to account better for unscaled features. Set gamma explicitly to 'auto' or 'scale' to avoid this warning.
    # "avoid this warning.", FutureWarning)
    # DEBUG:root:Fitted
    # INFO:root:Train accuracy: 0.6799642381781055, Test accuracy: 0.6722154418265698
    # INFO:root:Max error: 0.541011
    # INFO:root:Mean squared error: 0.02255345139414139
    # INFO:root:Root mean squared error: 0.15017806562258482
    # INFO:root:Mean absolute percentage error: inf
    # INFO:root:Explained variance score: 0.672734
    # INFO:root:r2 score: 0.672215
    # INFO:root:Mean Absolute Error: 0.1111857807535532
    # DEBUG:matplotlib.font_manager:findfont: Matching :family=sans-serif:style=normal:variant=normal:weight=normal:stretch=normal:size=10.0 to DejaVu Sans ('/Library/Frameworks/Python.framework/Versions/3.6/lib/python3.6/site-packages/matplotlib/mpl-data/fonts/ttf/DejaVuSans.ttf') with score of 0.050000
    # END

    # regressor = svm.SVR(kernel='rbf', degree=5, C=1, epsilon=.1, max_iter=1000000)
    # DEBUG:root:Fitted
    # INFO:root:Train accuracy: -0.013520538759235867, Test accuracy: -0.01556982325510048
    # INFO:root:Train accuracy: -0.013520538759235867, Test accuracy: -0.01556982325510048
    # INFO:root:-0.013520538759235867
    # INFO:root:-0.01556982325510048

    # regressor = svm.SVR(kernel='linear', max_iter=1000000)
    # DEBUG:root:Fitted
    # INFO:root:Train accuracy: -18658074601.005157, Test accuracy: -17215071540.50551
    # INFO:root:Train accuracy: -18658074601.005157, Test accuracy: -17215071540.50551
    # INFO:root:-18658074601.005157
    # INFO:root:-17215071540.50551

    # regressor = svm.SVR(kernel='precomputed', max_iter=10)
    # regressor = svm.SVR(kernel='poly', max_iter=1000)
    # INFO:root:Train accuracy: -9.416961286588589e+79, Test accuracy: -1.0148852463254762e+80
    # INFO:root:Train accuracy: -9.416961286588589e+79, Test accuracy: -1.0148852463254762e+80
    # INFO:root:-9.416961286588589e+79
    # INFO:root:-1.0148852463254762e+80
    logging.debug("Model created")

    regressor.fit(x_train_set, y_train_set)

    logging.debug("Fitted")
    # train_accuracy = regressor.score(x_train_set, y_train_set)
    # test_accuracy = regressor.score(x_test_set, y_test_set)
    # logging.info("Train accuracy: %s, Test accuracy: %s", train_accuracy, test_accuracy)
    results = regressor.predict(x_test_set)
    get_result_statistics(predicted_values=results, real_values=y_test_set)

    for num, value in enumerate(results, start=0):
        if num > 1:
            results[num] = 1
        else:
            if num < 0:
                results[num] = 0
    logging.debug("Drugie statystyki\n")
    get_result_statistics(predicted_values=results, real_values=y_test_set)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0', buildings_present='0;1',
                                          use_distances=True,
                                          random_state=50, test_size=0.2,
                                          columns_to_omit=[
                                              # 'BD_LINE_1_Year_Changed',
                                              # 'BD_LINE_1_Unit_Cost_Main',
                                              # 'BD_LINE_1_RCN_Main',
                                              # 'BD_LINE_2_Year_Changed',
                                              # 'BD_LINE_2_Unit_Cost_Main',
                                              # 'BD_LINE_2_RCN_Main',
                                              # 'BD_LINE_3_Year_Changed',
                                              # 'BD_LINE_3_Unit_Cost_Main',
                                              # 'BD_LINE_3_RCN_Main',
                                              # 'BD_LINE_4_Year_Changed',
                                              # 'BD_LINE_1_Yr_Built',
                                              # 'BD_LINE_1_No_of_Units',
                                              # 'BD_LINE_1_No_of_Bedrooms',
                                              # 'BD_LINE_1_No_of_Baths',
                                              # 'BD_LINE_2_Subpart',
                                              # 'BD_LINE_2_Yr_Built',
                                              # 'BD_LINE_2_No_of_Units',
                                              # 'BD_LINE_2_No_of_Bedrooms',
                                              # 'BD_LINE_2_No_of_Baths',
                                              # 'BD_LINE_2_Sq_Ft_of_Main_Improve',
                                              # 'BD_LINE_3_Subpart',
                                              # 'BD_LINE_3_Yr_Built',
                                              # 'BD_LINE_3_No_of_Units',
                                              # 'BD_LINE_3_No_of_Bedrooms',
                                              # 'BD_LINE_3_No_of_Baths',
                                              # 'BD_LINE_3_Sq_Ft_of_Main_Improve',
                                              'Price_Group_int',
                                              'Price_Group_int_second'])
    logging.info("Z Wszystkimi danymi ")
    logging.info("Poly degree 1")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='poly', degree=1)
    logging.info("Poly degree 3")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='poly', degree=3)

    logging.info("RBF degree 1")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='rbf', degree=1)

    logging.info("RBF degree 3")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='rbf', degree=3)
    logging.info("RBF degree 5")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='rbf', degree=5)
    logging.info("Z use idstances false")
    distances = [
        'DistanceToElementarySchool',
        'DistanceToMiddleSchool',
        'DistanceToHighSchool',
        'DistanceToShopping_Centers',
        'DistanceToHealth_Centers',
        'DistanceToStreet_Maintenance',
        'DistanceToPools',
        'DistanceToManufacturing',
        'DistanceToEconomic_Development',
        'DistanceToBusiness_Centers',
        'DistanceToAgriculture_and_Food',
        'DistanceToHealth_Clinics',
        'DistanceToNatural_Areas_and_Wildlife_Sanctuaries',
        'DistanceToChild_Care',
        'DistanceToCrime_Prevention_and_Support',
        'DistanceToWater',
        'DistanceToAirport',
        'DistanceToRiver',
        'DistanceToRailroads'
    ]
    x_train.drop(columns=distances, axis=1, inplace=True)
    x_test.drop(columns=distances, axis=1, inplace=True)
    logging.info("Poly degree 1")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='poly', degree=1)
    logging.info("Poly degree 3")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='poly', degree=3)

    logging.info("RBF degree 1")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='rbf', degree=1)

    logging.info("RBF degree 3")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='rbf', degree=3)
    logging.info("RBF degree 5")
    run_svm_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, kernel='rbf', degree=5)
