import logging
from sklearn import linear_model
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics
import numpy as np
from sklearn.model_selection import GridSearchCV
from sklearn.impute import SimpleImputer


def make_prediction(model, x_data):
    predicted_values = model.predict(x_data)
    logging.debug("Prediction was made ")
    return predicted_values


def train_model(x_train, y_train):
    # parameters = {'n_iter': [500, 1000], 'alpha_1': [1, 1e-10, 100]}
    parameters = {'alpha_1': [1e-10, 1e-5], 'alpha_2': [1e-10, 1e-5], 'lambda_1': [1e-07, 1e-05], 'lambda_2': [1e-07, 1e-05], 'n_iter': [500]}
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
    get_result_statistics(predicted_values, y_test)


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")  # startegy: 'mean'
    return imp.fit_transform(df)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2;', buildings_present='0;1',
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
    logging.info("Z Wszystkimi danymi")
    gaussian_bayes_regressor(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test)
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
    gaussian_bayes_regressor(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test)

