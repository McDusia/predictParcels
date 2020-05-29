import logging
from configuration.configuration_constants import excluded_values, \
    target_column_name, \
    limit_date, id_to_omit_from_data
from utils.DataSplitter import DataSplitter
from utils.database_handler import DatabaseHandler


def get_basic_data(price_groups='0;1;2', buildings_present='0;1', columns_to_omit=[]):
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "EXEC GetDataToTrainModel @LimitDate = {}, @ExcludedList ='{}', @PriceGroupList = '{}', @BuildingsPresent = '{}'" \
            .format(
            limit_date,
            excluded_values,
            price_groups,
            buildings_present
    )
    data = database_handler.execute_query(query)

    # Drop ObjectID column
    data.drop(id_to_omit_from_data, axis=1)

    if len(columns_to_omit) > 0:
        data.drop(columns_to_omit, axis=1)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    return data


def get_basic_data_splited_x_y(price_groups='0;1;2', buildings_present='0;1', columns_to_omit=[]):
    data = get_basic_data(price_groups, buildings_present, columns_to_omit)
    return split_data_x_y(data)


def get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1', columns_to_omit=[],
                                      random_state=0, test_size=0.2):
    data = get_basic_data(price_groups, buildings_present, columns_to_omit)
    return split_data_train_test(data, random_state, test_size)


def split_data_x_y(data):
    data_splitter = DataSplitter(data, target_column_name=target_column_name)
    x_data = data_splitter.get_x_data()
    y_data = data_splitter.get_y_data()
    return x_data, y_data


def split_data_train_test(data, random_state, test_size):
    [x_train_set, x_test_set, y_train_set, y_test_set] \
        = DataSplitter(data, target_column_name=target_column_name, random_state=random_state, test_size=test_size) \
        .get_x_y_data_train_test()
    return x_train_set, x_test_set, y_train_set, y_test_set


def log_shape(train_features, train_labels, test_features, test_labels):
    logging.info('Training Features Shape: %s', train_features.shape)
    logging.info('Training Labels Shape: %s', train_labels.shape)
    logging.info('Testing Features Shape: %s', test_features.shape)
    logging.info('Testing Labels Shape: %s', test_labels.shape)
