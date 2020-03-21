from sklearn import svm
import logging


def run_svm_regression(x_train_set, x_test_set, y_train_set, y_test_set):
    # Currently best results with:
    # kernel='poly', degree=5, C=1, epsilon=.1, max_iter=1000000
    # test: 0.58; train: 0.67
    # increasing max iterations doesn't change final results, degree 10 gives bad results
    regressor = svm.SVR(kernel='poly', degree=5, C=1, epsilon=.1, max_iter=3000000)
    logging.debug("Model created")

    regressor.fit(x_train_set, y_train_set)

    logging.debug("Fitted")
    train_accuracy = regressor.score(x_train_set, y_train_set)
    test_accuracy = regressor.score(x_test_set, y_test_set)
    results = regressor.predict(x_test_set)

    logging.info("Train accuracy: %s, Test accuracy: %s", train_accuracy, test_accuracy)

    return train_accuracy, test_accuracy
