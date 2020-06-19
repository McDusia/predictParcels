import logging
import statsmodels.api as sm
from utils.get_basic_train_data import get_basic_data_splited_train_test, get_data_splitted_for_price_groups
from utils.result_stats import get_result_statistics
from sklearn.impute import SimpleImputer


def run_statsmodels_regression(x_train_set, x_test_set, y_train_set, y_test_set, title_part):
    model = sm.OLS(y_train_set, x_train_set.astype(int))
    results = model.fit()
    logging.info(results.summary())

    cheap, medium, expensive = get_data_splitted_for_price_groups(x_data=x_test_set, y_data=y_test_set)
    if cheap:
        logging.info("Statystki dla tanich")
        cheap_x, cheap_y = cheap
        predicted_values_cheap = results.predict(list(cheap_x))
        get_result_statistics(predicted_values=predicted_values_cheap, real_values=cheap_y, file_title=title_part + "tanie")
    if medium:
        logging.info("Statystki dla srednich")
        medium_x, medium_y = medium
        predicted_values_medium = results.predict(list(medium_x))
        get_result_statistics(predicted_values=predicted_values_medium, real_values=medium_y, file_title=title_part + "srednie")
    if expensive:
        logging.info("Statystki dla drogich")
        expensive_x, expensive_y = expensive
        predicted_values_expensive = results.predict(list(expensive_x))
        get_result_statistics(predicted_values=predicted_values_expensive, real_values=expensive_y, file_title=title_part + "drogie")

    if cheap and medium and expensive:
        logging.info("Statystki dla calosci")
        all = list(predicted_values_cheap) + list(predicted_values_medium) + list(predicted_values_expensive)
        real_all = list(cheap_y) + list(medium_y) + list(expensive_y)
        get_result_statistics(
            predicted_values=all,
            real_values=real_all, file_title=title_part+"cale")


# TODO sprawdzic czy bedzie ok gdy puszczamy tylko dla jednej grupy cenowej
# TODO przetestowac tez jak mamy kilka grup na raz


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")  # startegy: 'mean'
    return imp.fit_transform(df)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1',
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
    run_statsmodels_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, "caleDane")
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
    run_statsmodels_regression(fill_nan_values(x_train), fill_nan_values(x_test), y_train, y_test, title_part="bezDanych")
