import logging
import os

from sklearn.impute import SimpleImputer

from utils.data_preprocessor import standardize
from utils.file_names_builder import get_neural_network_model_filename, get_model_filename_b
from configuration.configuration_constants import validation_split_value, verbose_value, epochs_value, model_overwrite, \
    values_to_omit_in_basic_data_version
from neural_network.neural_network_model import Model
from utils.get_basic_train_data import  get_basic_data, split_data_x_y, get_basic_data_splited_train_test

import matplotlib.pyplot as plt
from sklearn import preprocessing
from sklearn.preprocessing import MinMaxScaler
from utils.result_stats import get_result_statistics
import pandas as pd


def create_model_decorator():
    def decorator(func):
        def func_wrapper(*args, **kwargs):
            model_filename = get_neural_network_model_filename()
            if os.path.exists(model_filename) and not model_overwrite:
                logging.error('Model exists. To overwrite set model_overwrite constant to True '
                              'in configuration_constants.py')
                return 0
            trained_model = func(*args, **kwargs)
            return trained_model
        return func_wrapper
    return decorator


@create_model_decorator()
def create_model(x, y):
    logging.info('Creation of model.')
    neural_network_model = Model()
    neural_network_model.create_model(x.shape[1])
    neural_network_model.save_callback()
    neural_network_model.fit_model(training_x_values=x, training_y_values=y,
                                   batch_size=len(x), epochs=epochs_value,
                                   validation_split=validation_split_value, verbose=verbose_value)
    return neural_network_model


def log_statistics(neural_network_model):
    logging.info('Model summary:')
    neural_network_model.model.summary()


def make_prediction(model, x_test_set):
    predicted_values = model.predict(x_test_set)
    logging.info("Prediction made")
    return predicted_values


def normalize(x):
    normalized_x = preprocessing.normalize(x)
    return normalized_x


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")
    return pd.DataFrame(data=imp.fit_transform(df), columns=df.columns)


def main():
    mpl_logger = logging.getLogger('matplotlib')
    mpl_logger.setLevel(logging.WARNING)
    x, x_test, y, y_test = \
        get_basic_data_splited_train_test(price_groups='1', buildings_present='0;1',
                                          columns_to_omit=values_to_omit_in_basic_data_version,
                                          random_state=50, test_size=0.01)
    x = fill_nan_values(x)
    print(x.columns)
    x = x.values
    y = y.values

    normalized_x = preprocessing.normalize(x)

    neural_network_model = create_model(standardize(x), y)

    x_test = x_test.values
    y_test = y_test.values
    #x_test = preprocessing.normalize(x_test)
    #y_test = y_test # preprocessing.normalize(y_test)

    normalized_x = normalized_x[0:10000, :]
    normalized_y = y[0:10000]
    predictions = make_prediction(neural_network_model.model, normalized_x)
    get_result_statistics(predictions, normalized_y)

    log_statistics(neural_network_model)
    neural_network_model.save_model()


if __name__ == '__main__':
    main()
