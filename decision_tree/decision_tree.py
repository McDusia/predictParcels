import logging
import numpy as np
from sklearn.model_selection import train_test_split
from utils.database_handler import DatabaseHandler
from configuration.configuration_constants import limit_date, excluded_values, \
    current_bucket, train_model_with_price_parameters
from utils.prices_mapping import parcel_prices_mapping
from sklearn.tree import DecisionTreeRegressor
import matplotlib.pyplot as plt

import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'


def get_data(database_handler):
    logging.info('Get data')
    if train_model_with_price_parameters:
        procedure = 'GetDateToTrainModel'
    else:
        procedure = 'GetDateToTrainModelWithoutPriceParametersImportantAttributes'
    # Type: dataframe
    data_to_train_model = database_handler.execute_query("EXEC dbo.{} "
                                                         "@LimitDate = {}, "
                                                         "@BucketType={}, "
                                                         "@ExcludedList='{}'"
                                                         .format(procedure,
                                                                 limit_date,
                                                                 parcel_prices_mapping[current_bucket],
                                                                 excluded_values))

    # Pandas DataFrame.shape return a tuple representing the dimensionality of the DataFrame
    data_size = data_to_train_model.shape[1]

    # Split into X set and Y set
    # Take all columns except the first one - OBJECID and the last one - Sale_Amount
    x = data_to_train_model.iloc[:, 1: data_size - 1]
    y = data_to_train_model.iloc[:, data_size - 1]

    labels = np.array(y)
    features = np.array(x)
    feature_list = list(x.columns)

    # training data - 55% of data, test data - 45 % of data
    train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size=0.3,
                                                                                random_state=1)
    log_shape(train_features, train_labels, test_features, test_labels)

    # Fit regression model
    regr_1 = DecisionTreeRegressor(max_depth=2)
    regr_2 = DecisionTreeRegressor(max_depth=5)
    regr_1.fit(x, y)
    regr_2.fit(x, y)

    # Predict
    predictions_1 = regr_1.predict(test_features)
    predictions_2 = regr_2.predict(test_features)

    log_errors(predictions_1, test_labels)
    log_errors(predictions_2, test_labels)

    # Plot the results TODO error x and y must be the same size
    plt.figure()
    plt.scatter(x, y, s=20, edgecolor="black",
                c="darkorange", label="data")
    plt.plot(test_features, predictions_1, color="cornflowerblue",
             label="max_depth=2", linewidth=2)
    plt.plot(test_features, predictions_2, color="yellowgreen", label="max_depth=5", linewidth=2)
    plt.xlabel("data")
    plt.ylabel("target")
    plt.title("Decision Tree Regression")
    plt.legend()
    plt.show()


def log_shape(train_features, train_labels, test_features, test_labels):
    logging.info('Training Features Shape:', train_features.shape)
    logging.info('Training Labels Shape:', train_labels.shape)
    logging.info('Testing Features Shape:', test_features.shape)
    logging.info('Testing Labels Shape:', test_labels.shape)


def log_errors(predictions, test_labels):
    # Calculate the absolute errors
    errors = abs(predictions - test_labels)
    # Print out the mean absolute error (mae)
    mean_errors = np.mean(errors)
    logging.info('Mean Absolute Error:', round(mean_errors, 6), 'Sale_Amount.')

    # Calculate mean absolute percentage error (MAPE)
    mape = 100 * (errors / test_labels)
    # Calculate and display accuracy
    accuracy = 100 - np.mean(mape)
    logging.info('Accuracy:', round(accuracy, 6), '%.')


def main():
    database_handler = DatabaseHandler()
    try:
        get_data(database_handler=database_handler)
    finally:
        database_handler.close_connection()


if __name__ == '__main__':
    main()
