import logging
from configuration.configuration_constants import excluded_values, \
    target_column_name, \
    limit_date, values_to_omit_in_basic_data_version
from utils.DataSplitter import DataSplitter
from utils.database_handler import DatabaseHandler


def get_basic_splitted_train_data(test_size=0.25, price_groups='0;1;2', buildings_present='0;1', basic_data_version=False):
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "EXEC GetDateToTrainModel @LimitDate = {}, @ExcludedList ='{}', @PriceGroupInt = '{}', @BuildingsPresent = '{}'".format(
        limit_date,
        excluded_values, price_groups, buildings_present)
    data = database_handler.execute_query(query)

    if basic_data_version:
        data.drop(values_to_omit_in_basic_data_version, axis=1)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    [x_train_set, x_test_set, y_train_set, y_test_set] \
        = DataSplitter(data, target_column_name=target_column_name, test_size=test_size).get_x_y_data_train_test()

    return x_train_set, x_test_set, y_train_set, y_test_set


def get_basic_train_data(price_groups='0;1;2', buildings_present='0;1'):
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "EXEC GetDateToTrainModel @LimitDate = {}, @ExcludedList ='{}', @PriceGroupInt = '{}', @BuildingsPresent = '{}'".format(
        limit_date,
        excluded_values,
        price_groups,
        buildings_present)
    data = database_handler.execute_query(query)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    data_splitter = DataSplitter(data, target_column_name=target_column_name)

    x_data = data_splitter.get_x_data()
    y_data = data_splitter.get_y_data()

    return x_data, y_data
