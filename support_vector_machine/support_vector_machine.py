from sklearn import svm
import logging
from utils.get_basic_train_data import get_basic_data_splited_train_test, log_shape


def run_svm_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    # Currently best results with:
    # kernel='poly', degree=5, C=1, epsilon=.1, max_iter=1000000
    # test: 0.58; train: 0.67
    # increasing max iterations doesn't change final results, degree 10 gives bad results
    # regressor = svm.SVR(kernel='poly', degree=5, C=1, epsilon=.1, max_iter=1000000)

    regressor = svm.SVR(kernel='rbf', degree=5, C=1, epsilon=.1)
    # regressor = svm.SVR(kernel='rbf', degree=5, C=1, epsilon=.1, max_iter=1000000)
    # DEBUG:root:Fitted
    # INFO:root:Train accuracy: -0.013520538759235867, Test accuracy: -0.01556982325510048
    # INFO:root:Train accuracy: -0.013520538759235867, Test accuracy: -0.01556982325510048
    # INFO:root:-0.013520538759235867
    # INFO:root:-0.01556982325510048

    # regressor = svm.SVR(kernel='linear', max_iter=1000000)
    # DEBUG:root:Fitted
    # INFO:root:Train accuracy: -18658074601.005157, Test accuracy: -17215071540.50551
    # INFO:root:Train accuracy: -18658074601.005157, Test accuracy: -17215071540.50551
    # INFO:root:-18658074601.005157
    # INFO:root:-17215071540.50551

    x_train_set.fillna(0)
    y_train_set.fillna(0)
    x_test_set.fillna(0)
    y_test_set.fillna(0)
    # regressor = svm.SVR(kernel='precomputed', max_iter=10)
    # regressor = svm.SVR(kernel='poly', max_iter=1000)
    # INFO:root:Train accuracy: -9.416961286588589e+79, Test accuracy: -1.0148852463254762e+80
    # INFO:root:Train accuracy: -9.416961286588589e+79, Test accuracy: -1.0148852463254762e+80
    # INFO:root:-9.416961286588589e+79
    # INFO:root:-1.0148852463254762e+80
    logging.debug("Model created")

    regressor.fit(x_train_set, y_train_set)

    logging.debug("Fitted")
    train_accuracy = regressor.score(x_train_set, y_train_set)
    test_accuracy = regressor.score(x_test_set, y_test_set)
    logging.info("Train accuracy: %s, Test accuracy: %s", train_accuracy, test_accuracy)
    results = regressor.predict(x_test_set)

    return train_accuracy, test_accuracy


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2', buildings_present='0;1', basic_data_version=True,
                                          random_state=50, test_size=0.2)
    run_svm_regression(x_train, x_test, y_train, y_test)
