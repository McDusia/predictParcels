import logging
from configuration.configuration_constants import excluded_values, \
    target_column_name, \
    limit_date, id_to_omit_from_data
from utils.DataSplitter import DataSplitter
from utils.database_handler import DatabaseHandler
from utils.data_preprocessor import standardize
import pandas as pd


def omit_columns(data, columns_to_omit):
    data.drop(columns=id_to_omit_from_data, axis=1, inplace=True)

    if len(columns_to_omit) > 0:
        data.drop(columns=columns_to_omit, axis=1, inplace=True)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    return data


def get_data_with_distances(price_groups='0;1;2', buildings_present='0;1', columns_to_omit=[]):
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "EXEC GetDataToTrainModelWithDistances @LimitDate = {}, @ExcludedList ='{}', @PriceGroupList = '{}', @BuildingsPresent = '{}'" \
        .format(
        limit_date,
        excluded_values,
        price_groups,
        buildings_present
    )
    data = database_handler.execute_query(query)

    data = omit_columns(data, columns_to_omit)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    return data


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
    data = omit_columns(data, columns_to_omit)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    return data


def get_basic_data_splited_x_y(price_groups='0;1;2', buildings_present='0;1', columns_to_omit=[], use_distances=False):
    if use_distances:
        data = get_data_with_distances(price_groups, buildings_present, columns_to_omit)
    else:
        data = get_basic_data(price_groups, buildings_present, columns_to_omit)
    return split_data_x_y(data)


def get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1', columns_to_omit=[],
                                      random_state=0, test_size=0.2, use_distances=False,
                                      target_column=target_column_name):
    if use_distances:
        data = get_data_with_distances(price_groups, buildings_present, columns_to_omit)
    else:
        data = get_basic_data(price_groups, buildings_present, columns_to_omit)
    return split_data_train_test(data, random_state, test_size, target_column)


def split_data_x_y(data):
    data_splitter = DataSplitter(data, target_column_name=target_column_name)
    x_data = data_splitter.get_x_data()
    y_data = data_splitter.get_y_data()
    return x_data, y_data


def split_data_train_test(data, random_state, test_size, target_column=target_column_name):
    # data = pd.DataFrame(data=standardize(data), columns=data.columns)
    [x_train_set, x_test_set, y_train_set, y_test_set] \
        = DataSplitter(data, target_column_name=target_column, random_state=random_state, test_size=test_size) \
        .get_x_y_data_train_test()
    return x_train_set, x_test_set, y_train_set, y_test_set


def log_shape(train_features, train_labels, test_features, test_labels):
    logging.info('Training Features Shape: %s', train_features.shape)
    logging.info('Training Labels Shape: %s', train_labels.shape)
    logging.info('Testing Features Shape: %s', test_features.shape)
    logging.info('Testing Labels Shape: %s', test_labels.shape)


#
# UPDATE PARCEL_VECTORS
# SET Price_Group_int = 0
# WHERE LS1_Sale_Amount <= 500000
# UPDATE PARCEL_VECTORS
# SET Price_Group_int = 1
# WHERE ( LS1_Sale_Amount > 500000 and LS1_Sale_Amount < 1000000 )
# UPDATE PARCEL_VECTORS
# SET Price_Group_int = 2
# WHERE LS1_Sale_Amount >= 1000000

#  to dziala, ale nie uwzgl
def filterCheap(input):
    x, y = input
    if y <= 0.1000143121264603:
        # if y < 700000:
        return True
    else:
        return False


def filterMedium(input):
    x, y = input
    if y > 0.1000143121264603 and y < 0.28588794305575194:
        # if y >= 700000 and y < 2000000:
        return True
    else:
        return False


def filterExpensive(input):
    x, y = input
    if y >= 0.28588794305575194:
        # if y >= 2000000:
        return True
    else:
        return False


def get_data_splitted_for_price_groups(x_data, y_data):
    all = list(zip(x_data, y_data))
    # expensive_parcels = list(filter(filterExpensive, all))
    # cheap_parcels = list(filter(filterCheap, all))
    # medium_parcels = list(filter(filterMedium, all))

    cheap_parcels = list([i for i in all if filterCheap(i)])
    medium_parcels = list([i for i in all if filterMedium(i)])
    expensive_parcels = list([i for i in all if filterExpensive(i)])

    a = list(zip(*cheap_parcels))
    b = list(zip(*medium_parcels))
    c = list(zip(*expensive_parcels))

    return a, b, c


def get_data_splitted_for_price_groups_int(x_data, y_data):
    x_data['Price_group_int'] = y_data

    cheap_parcels = x_data[x_data['Price_group_int'] == 0]
    medium_parcels = x_data[x_data['Price_group_int'] == 1]
    expensive_parcels = x_data[x_data['Price_group_int'] == 2]

    cheap_parcels.drop(columns=['Price_group_int'], axis=1, inplace=True)
    medium_parcels.drop(columns=['Price_group_int'], axis=1, inplace=True)
    expensive_parcels.drop(columns=['Price_group_int'], axis=1, inplace=True)

    return cheap_parcels, medium_parcels, expensive_parcels
