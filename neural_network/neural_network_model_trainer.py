import logging
import os
from utils.file_names_builder import get_neural_network_model_filename
from configuration.configuration_constants import validation_split_value, verbose_value, epochs_value, model_overwrite
from neural_network.neural_network_model import Model
from utils.get_basic_train_data import  get_basic_data, split_data_x_y


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
    neural_network_model.create_model()
    neural_network_model.save_callback()
    neural_network_model.fit_model(training_x_values=x.values, training_y_values=y.values,
                                   batch_size=len(x.values), epochs=epochs_value,
                                   validation_split=validation_split_value, verbose=verbose_value)
    return neural_network_model


def log_statistics(neural_network_model):
    logging.info('Model summary:')
    neural_network_model.model.summary()


def main():
    data_to_train_model_df = get_basic_data(price_groups='0', buildings_present='0;1', columns_to_omit=[])
    data_to_train_model_df.describe()
    x, y = split_data_x_y(data_to_train_model_df)

    neural_network_model = create_model(x, y)
    log_statistics(neural_network_model)
    neural_network_model.save_model()


if __name__ == '__main__':
    main()
