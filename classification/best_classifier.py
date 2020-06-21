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


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2;', buildings_present='0;1',
                                          random_state=50, test_size=0.4,
                                          # columns_to_omit=['Sale_Amount', 'Price_Group_int'],
                                          columns_to_omit=['Price_Group_int'],
                                          use_distances=True, target_column="Price_Group_int_second")
    sale_amount_test = x_test['Sale_Amount']
    x_train_for_classification = x_train.drop(columns=['Sale_Amount'], axis=1, inplace=False)
    x_test_for_classification = x_test.drop(columns=['Sale_Amount'], axis=1, inplace=False)
    x_train_for_classification = fill_nan_values(x_train_for_classification)
    x_test_for_classification = fill_nan_values(x_test_for_classification)

    predicted_price_group_values = myKNeighborsClassifier(X_train=x_train_for_classification,
                                                          X_test=x_test_for_classification,
                                                          y_train=y_train,
                                                          y_test=y_test)
    regression_all_data = zip(x_test_for_classification, sale_amount_test)

    logging.info("Cale dame")
    # regression_all_data2 = list(regression_all_data)
    # all_x = list(regression_all_data2)[0]
    # all_y = list(regression_all_data2)[1]
    regresion_all_data_list = list(regression_all_data)
    all_len = len(regresion_all_data_list)
    train_size = math.floor(0.7 * all_len)
    all_train = regresion_all_data_list[:train_size]
    all_test = regresion_all_data_list[train_size:]

    all_x_train, all_y_train = list(zip(*all_train))
    all_x_test, all_y_test = list(zip(*all_test))

    # all_y_test = sale_amount_test[:train_size]
    # all_y_train = sale_amount_test[train_size:]

    run_KNN_regression(x_train=all_x_train, x_test_set=all_x_test, y_train=all_y_train,
                       y_test_set=all_y_test, title_part="Cale")

    # Teraz chcemy ta sama regresje ale osobno na tanich, srednich i drogich
    cheap, medium, expensive = get_data_splitted_for_price_groups_int(x_data=x_test,
                                                                      y_data=predicted_price_group_values)

    logging.info("Cheap prediction")
    cheap_len = len(cheap)
    train_size = math.floor(0.7 * cheap_len)
    cheap_y = cheap['Sale_Amount']
    cheap_x = cheap.drop(columns=['Sale_Amount'], axis=1, inplace=False)

    cheap_x_train = cheap_x[train_size:]
    cheap_y_train = cheap_y[train_size:]

    cheap_x_test = cheap_x[:train_size]
    cheap_y_test = cheap_y[:train_size]

    run_KNN_regression(x_train=cheap_x_train, x_test_set=cheap_x_test, y_train=cheap_y_train,
                       y_test_set=cheap_y_test, title_part="KNNPoklasyfikacji_cheap")
    logging.info("Medium prediction")
    medium_x = medium[0]
    medium_y = medium[1]
    medium_len = len(medium[0])
    train_size = math.floor(0.7 * medium_len)
    medium_x_train = medium_x[train_size:]
    medium_y_train = medium_y[train_size:]

    medium_x_test = medium_x[:train_size]
    medium_y_test = medium_y[:train_size]

    run_KNN_regression(x_train=medium_x_train, x_test_set=medium_x_test, y_train=medium_y_train,
                       y_test_set=medium_y_test, title_part="KNNPoklasyfikacji_medium")

    logging.info("Expensive prediction")
    expensive_x = expensive[0]
    expensive_y = expensive[1]
    expensive_len = len(expensive[0])
    train_size = math.floor(0.7 * expensive_len)
    expensive_x_train = expensive_x[train_size:]
    expensive_y_train = expensive_y[train_size:]

    expensive_x_test = expensive_x[:train_size]
    expensive_y_test = expensive_y[:train_size]

    run_KNN_regression(x_train=expensive_x_train, x_test_set=expensive_x_test, y_train=expensive_y_train,
                       y_test_set=expensive_y_test, title_part="KNNPoklasyfikacji_expensive")

    # w predicted_values mamy podzielone na grupy

    # polaczyc je z x-ami od nowa
    # potem przefiltrowac na 3 grupy cenowe bazujac po predygowanej wartosci y
