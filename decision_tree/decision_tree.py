import logging
from sklearn.tree import DecisionTreeRegressor
from utils.get_basic_train_data import get_basic_data_splited_train_test, log_shape
from utils.result_stats import get_result_statistics
from utils.export_decision_tree import export_decision_tree


def create_decision_tree(x_train, x_test, y_train, y_test, max_depth):
    log_shape(y_train, y_test, x_train, x_test)
    model = DecisionTreeRegressor(random_state=50, max_depth=max_depth)
    model.fit(x_train, y_train)
    logging.info("Model fitted")
    return model


def make_prediction(model, x_test_set):
    predicted_values = model.predict(x_test_set)
    logging.info("Prediction made")
    return predicted_values


def main():
    # Accuracy around 80%, model trained only for cheap parcels
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0', buildings_present='0;1',
                                          random_state=50, test_size=0.2)

    decision_tree = create_decision_tree(x_train, x_test, y_train, y_test, max_depth=10)
    predictions = make_prediction(decision_tree, x_test)
    get_result_statistics(predictions, y_test)
    export_decision_tree(decision_tree, list(x_train.columns))


if __name__ == '__main__':
    main()
