import logging

from configuration.configuration_constants import values_to_omit_in_basic_data_version
from utils.data_preprocessor import remove_sale_amount_anomalies, fill_nan_values, standardize
from utils.get_basic_train_data import get_basic_data, split_data_train_test, log_shape
from sklearn.ensemble import RandomForestRegressor
from utils.result_stats import get_result_statistics
from utils.export_decision_tree import export_decision_tree


def create_random_forest(x_train, y_train, n_estimators, random_state, max_depth):

    model = RandomForestRegressor(n_estimators=n_estimators, random_state=random_state, max_depth=max_depth, n_jobs=10,
                                  verbose=True)
    model.fit(x_train, y_train)
    logging.info("Model fitted")
    return model


def make_prediction(model, x_test_set):
    predicted_values = model.predict(x_test_set)
    logging.info("Prediction made")
    return predicted_values


def main():
    mpl_logger = logging.getLogger('matplotlib')
    mpl_logger.setLevel(logging.WARNING)

    # Accuracy around 80%, model trained only for cheap parcels
    data_to_train_model_df = get_basic_data(price_groups='2', buildings_present='0;1',
                                            columns_to_omit=values_to_omit_in_basic_data_version)
    print(data_to_train_model_df.columns)

    # Data preprocessing
    data_to_train_model_df = fill_nan_values(data_to_train_model_df)
    #data_to_train_model_df = remove_sale_amount_anomalies(data_to_train_model_df, 0.05, 0.95)
    data_to_train_model_df = standardize(data_to_train_model_df)

    x_train, x_test, y_train, y_test = split_data_train_test(data_to_train_model_df, random_state=1, test_size=0.3)
    log_shape(x_train, y_train, x_test, y_test)
    random_forest = create_random_forest(x_train, y_train, n_estimators=100, random_state=1, max_depth=50)

    predictions = make_prediction(random_forest, x_test)
    get_result_statistics(predictions, y_test)
    # drawing only the first tree, if needed draw more
    #export_decision_tree(random_forest.estimators_[0], feature_names=list(x_train.columns))


if __name__ == '__main__':
    main()
