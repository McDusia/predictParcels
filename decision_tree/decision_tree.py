import os
import logging
from sklearn.tree import DecisionTreeRegressor
import matplotlib.pyplot as plt
from utils.getBasicTrainData import get_basic_splitted_train_data
from utils.result_stats import get_result_stats

# https://stackoverflow.com/questions/35064304/runtimeerror-make-sure-the-graphviz-executables-are-on-your-systems-path-aft
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'


def run_decision_tree(x_train_set, x_test_set, y_train_set, y_test_set, max_depth):
    log_shape(y_train_set, y_test_set, x_train_set, x_test_set)

    # Fit regression model
    model = DecisionTreeRegressor(max_depth=max_depth)
    model.fit(x_train_set, y_train_set)
    logging.info("Model fitted")

    # Prediction
    predicted_values = model.predict(x_test_set)
    logging.info("Prediction made")

    get_result_stats(predicted_values, y_test_set)
    return predicted_values


def compare_results(x, y, test_features, predictions_1, predictions_2):
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
    logging.debug('Training Features Shape: %s', train_features.shape)
    logging.debug('Training Labels Shape: %s', train_labels.shape)
    logging.debug('Testing Features Shape: %s', test_features.shape)
    logging.debug('Testing Labels Shape: %s', test_labels.shape)


def main():
    x_train_set, x_test_set, y_train_set, y_test_set = get_basic_splitted_train_data(test_size=0.45,
                                                                                     basic_data_version=True)
    predictions_1 = run_decision_tree(x_train_set, x_test_set, y_train_set, y_test_set, max_depth=3)
    predictions_2 = run_decision_tree(x_train_set, x_test_set, y_train_set, y_test_set, max_depth=5)

    # TODO fix comparing results ( wykres )
    # compare_results(x_train_set, y_train_set, predictions_1=predictions_1, predictions_2=predictions_2,
    #                 test_features=y_test_set)


if __name__ == '__main__':
    main()
