import logging
import statsmodels.api as sm
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_result_statistics
from sklearn.impute import SimpleImputer


def run_statsmodels_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    model = sm.OLS(y_train_set, x_train_set.astype(int))
    results = model.fit()
    logging.info(results.summary())

    predicted_values = results.predict(x_test_set.astype(int))
    get_result_statistics(predicted_values=predicted_values, real_values=y_test_set)


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")  # startegy: 'mean'
    return imp.fit_transform(df)


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
    logging.info("Z Wszystkimi danymi")
    run_statsmodels_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test)
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
    run_statsmodels_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test)
