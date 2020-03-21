import logging
import pandas as pd
from configuration.configuration_constants import excluded_values, \
    target_column_name, \
    limit_date
from utils.DataSplitter import DataSplitter
from utils.database_handler import DatabaseHandler
from regression.sklearn_regression import run_sklearn_linear_regression
from support_vector_machine.support_vector_machine import run_svm_regression
from regression.linear_regression import run_linear_regression


def compare_implementations():
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "EXEC GetDateToTrainModel @LimitDate = {}, @ExcludedList ='{}'".format(limit_date,
                                                                                                 excluded_values)
    data = database_handler.execute_query(query)

    logging.debug("Total samples in our dataset is: {}".format(data.shape[0]))

    [x_train_set, x_test_set, y_train_set, y_test_set] \
        = DataSplitter(data, target_column_name=target_column_name).get_x_y_data()
    # [sklearn_train_accuracy, sklearn_test_accuracy] = run_sklearn_linear_regression(x_train_set, x_test_set,
    #                                                                                 y_train_set, y_test_set)
    [svm_train_accuracy, svm_test_accuracy] = run_svm_regression(x_train_set, x_test_set,
                                                                                    y_train_set, y_test_set)
    print(svm_train_accuracy)
    print(svm_test_accuracy)
    # [our_train_accuracy, our_test_accuracy] = run_linear_regression(x_test_set, x_test_set,
    #                                                                 y_test_set, y_test_set)

    # pd.DataFrame(
    #     [[our_train_accuracy, sklearn_train_accuracy],
    #      [our_test_accuracy, sklearn_test_accuracy]],
    #     [our_test_accuracy, sklearn_test_accuracy],
    #     ['Training Accuracy', 'Test Accuracy'],
    #     ['Our Implementation', 'Sklearn\'s Implementation']
    # )


if __name__ == '__main__':
    compare_implementations()
