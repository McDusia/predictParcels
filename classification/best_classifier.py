import logging
from sklearn.neighbors import KNeighborsClassifier
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_classification_result_statistics
from sklearn.impute import SimpleImputer
from utils.get_basic_train_data import get_data_splitted_for_price_groups_int
from KNNRegression.knnRegressor import run_KNN_regression
import math

h = .02  # step size in the mesh


def myKNeighborsClassifier(X_train, X_test, y_train, y_test):
    logging.info("KNN Classifier")
    clf = KNeighborsClassifier(10)
    clf.fit(X_train, y_train)
    score = clf.score(X_test, y_test)
    y_pred = clf.predict(X_test)
    logging.info("Score: %s", score)
    get_classification_result_statistics(real_values=y_test, predicted_values=y_pred)
    return y_pred


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")  # startegy: 'mean'
    return imp.fit_transform(df)


path = "/Users/joannapalewicz/IdeaProjects/predictParcels/classification/"

if __name__ == '__main__':
    x_train, x_test_classification, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2;', buildings_present='0;1',
                                          random_state=50, test_size=0.6,
                                          columns_to_omit=['Price_Group_int'],
                                          use_distances=True, target_column="Price_Group_int_second")
    sale_amount_test = x_test_classification['Sale_Amount']
    x_train_for_classification = x_train.drop(columns=['Sale_Amount'], axis=1, inplace=False)
    x_test_for_classification = x_test_classification.drop(columns=['Sale_Amount'], axis=1, inplace=False)
    x_train_for_classification = fill_nan_values(x_train_for_classification)
    x_test_for_classification = fill_nan_values(x_test_for_classification)

    predicted_price_group_values = myKNeighborsClassifier(X_train=x_train_for_classification,
                                                          X_test=x_test_for_classification,
                                                          y_train=y_train,
                                                          y_test=y_test)
    logging.info("REGRESJA - Cale dame")
    all_len = len(x_test_classification)
    train_size = math.floor(0.7 * all_len)
    all_train = x_test_classification[:train_size]
    all_test = x_test_classification[train_size:]

    all_x_train = all_train.drop(columns=['Sale_Amount'], axis=1, inplace=False)
    all_y_train = all_train['Sale_Amount']
    all_x_test = all_test.drop(columns=['Sale_Amount'], axis=1, inplace=False)
    all_y_test = all_test['Sale_Amount']

    run_KNN_regression(x_train=fill_nan_values(all_x_train), x_test_set=fill_nan_values(all_x_test),
                       y_train=all_y_train,
                       y_test_set=all_y_test, title_part=path + "Cale", use_statistics_seperately_for_all=True)

    # Teraz chcemy ta sama regresje ale osobno na tanich, srednich i drogich
    cheap, medium, expensive = get_data_splitted_for_price_groups_int(x_data=x_test_classification,
                                                                      y_data=predicted_price_group_values)

    logging.info("REGRESJA - Cheap prediction")
    cheap_shape = cheap.shape
    cheap_len_rows, cheap_len_cols = cheap_shape
    cheap_train_size = math.floor(0.7 * cheap_len_rows)
    cheap_y = cheap['Sale_Amount']
    cheap_x = cheap.drop(columns=['Sale_Amount'], axis=1, inplace=False)

    cheap_x_train = cheap_x.head(cheap_train_size)
    cheap_y_train = cheap_y.head(cheap_train_size)

    cheap_x_test = cheap_x.tail(cheap_len_rows - cheap_train_size)
    cheap_y_test = cheap_y.tail(cheap_len_rows - cheap_train_size)

    run_KNN_regression(x_train=fill_nan_values(cheap_x_train), x_test_set=fill_nan_values(cheap_x_test),
                       y_train=cheap_y_train,
                       y_test_set=cheap_y_test, title_part=path + "KNNPoklasyfikacji_cheap",
                       use_statistics_seperately_for_all=False)
    logging.info("REGRESJA - Medium prediction")
    medium_shape = medium.shape
    medium_len_rows, medium_len_cols = medium_shape
    medium_train_size = math.floor(0.7 * medium_len_rows)
    medium_y = medium['Sale_Amount']
    medium_x = medium.drop(columns=['Sale_Amount'], axis=1, inplace=False)

    medium_x_train = medium_x.head(medium_train_size)
    medium_y_train = medium_y.head(medium_train_size)

    medium_x_test = medium_x.tail(medium_len_rows - medium_train_size)
    medium_y_test = medium_y.tail(medium_len_rows - medium_train_size)

    run_KNN_regression(x_train=fill_nan_values(medium_x_train), x_test_set=fill_nan_values(medium_x_test),
                       y_train=medium_y_train,
                       y_test_set=medium_y_test, title_part=path + "KNNPoklasyfikacji_medium",
                       use_statistics_seperately_for_all=False)

    logging.info("REGRESJA - Expensive prediction")
    expensive_shape = expensive.shape
    expensive_len_rows, expensive_len_cols = expensive_shape
    expensive_train_size = math.floor(0.7 * expensive_len_rows)
    expensive_y = expensive['Sale_Amount']
    expensive_x = expensive.drop(columns=['Sale_Amount'], axis=1, inplace=False)

    expensive_x_train = expensive_x.head(expensive_train_size)
    expensive_y_train = expensive_y.head(expensive_train_size)

    expensive_x_test = expensive_x.tail(expensive_len_rows - expensive_train_size)
    expensive_y_test = expensive_y.tail(expensive_len_rows - expensive_train_size)

    run_KNN_regression(x_train=fill_nan_values(expensive_x_train), x_test_set=fill_nan_values(expensive_x_test),
                       y_train=expensive_y_train,
                       y_test_set=expensive_y_test, title_part=path + "KNNPoklasyfikacji_expensive",
                       use_statistics_seperately_for_all=False)

    # w predicted_values mamy podzielone na grupy

    # polaczyc je z x-ami od nowa
    # potem przefiltrowac na 3 grupy cenowe bazujac po predygowanej wartosci y
