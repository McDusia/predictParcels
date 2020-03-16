import logging
import numpy as np
from sklearn.model_selection import train_test_split

from utils.database_handler import DatabaseHandler
from configuration.configuration_constants import limit_date, excluded_values, \
    current_bucket, train_model_with_price_parameters
from utils.prices_mapping import parcel_prices_mapping
from sklearn.ensemble import RandomForestRegressor
from sklearn.tree import export_graphviz
import pydot

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
    print('The shape of our features is:', data_to_train_model.shape)
    data_to_train_model.describe()
    # Split into X set and Y set
    # Take all columns except the first one - OBJECID and the last one - Sale_Amount
    x = data_to_train_model.iloc[:, 1: data_size - 1]
    y = data_to_train_model.iloc[:, data_size - 1]

    labels = np.array(y)
    features = np.array(x)
    feature_list = list(x.columns)

    train_features, test_features, train_labels, test_labels = train_test_split(features, labels, test_size=0.25,
                                                                                random_state=1)

    print('Training Features Shape:', train_features.shape)
    print('Training Labels Shape:', train_labels.shape)
    print('Testing Features Shape:', test_features.shape)
    print('Testing Labels Shape:', test_labels.shape)

    # Instantiate model with 100 decision trees
    rf = RandomForestRegressor(n_estimators=10, random_state=1, max_depth=12, n_jobs=10, verbose=True)
    rf.fit(train_features, train_labels)

    # Use the forest's predict method on the test data
    predictions = rf.predict(test_features)
    # Calculate the absolute errors
    errors = abs(predictions - test_labels)
    # Print out the mean absolute error (mae)
    print('Mean Absolute Error:', round(np.mean(errors), 2), 'Sale_Amount.')
    mean_errors = np.mean(errors)
    print('Mean Absolute Error:', round(mean_errors, 6), 'Sale_Amount.')

    # Calculate mean absolute percentage error (MAPE)
    mape = 100 * (errors / test_labels)
    # Calculate and display accuracy
    accuracy = 100 - np.mean(mape)
    print('Accuracy:', round(accuracy, 2), '%.')

    # Pull out one tree from the forest
    tree = rf.estimators_[0]
    # Export the image to a dot file
    export_graphviz(tree, out_file='random_forest/tree.dot', feature_names=feature_list, rounded=True, precision=1)
    # Use dot file to create a graph
    (graph,) = pydot.graph_from_dot_file('random_forest/tree.dot')
    # Write graph to a png file
    graph.write_png('random_forest/tree.png')
    print('Accuracy:', round(accuracy, 6), '%.')

    # TODO draw more trees
    logging.info('Getting the first tree from the forest')
    tree = rf.estimators_[0]
    logging.info("Export the image to a dot file")
    export_graphviz(tree, out_file='tree.dot', feature_names=feature_list, rounded=True, precision=1)
    logging.info('Use dot file to create a graph')
    (graph,) = pydot.graph_from_dot_file('tree.dot')
    logging.info("Write graph to a png file")
    graph.write_png('tree.png')


def main():
    database_handler = DatabaseHandler()
    try:
        get_data(database_handler=database_handler)
    finally:
        database_handler.close_connection()


if __name__ == '__main__':
    main()
