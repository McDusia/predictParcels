import logging
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from utils.get_basic_train_data import get_basic_data_splited_train_test
from utils.result_stats import get_classification_result_statistics
from sklearn.preprocessing import normalize
from sklearn.impute import SimpleImputer

h = .02  # step size in the mesh

names = [
    "Nearest Neighbors",
    #      "Linear SVM",
    #      "RBF SVM",
    #      "Decision Tree",
    #      "Random Forest",
    #      "Neural Net",
    #      "AdaBoost",
    #      "Naive Bayes",
         "QDA"
]

classifiers = [
    KNeighborsClassifier(3),
    # SVC(kernel="linear", C=0.025),
    # SVC(gamma=2, C=1),
    # DecisionTreeClassifier(max_depth=5),
    # RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    # MLPClassifier(alpha=1, max_iter=1000),
    # AdaBoostClassifier(),
    # GaussianNB(),
    QuadraticDiscriminantAnalysis()
]


def compare_classifiers(X_train, X_test, y_train, y_test):
    for name, clf in zip(names, classifiers):
        logging.info('Name: %s', name)
        clf.fit(X_train, y_train)
        score = clf.score(X_test, y_test)
        y_pred = clf.predict(X_test)
        logging.info("Score: %s", score)
        get_classification_result_statistics(real_values=y_test, predicted_values=y_pred)


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent") # startegy: 'mean'
    return imp.fit_transform(df)


if __name__ == '__main__':
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2;', buildings_present='0;1',
                                          random_state=50, test_size=0.2, columns_to_omit=['Sale_Amount'],
                                          use_distances=True, target_column="Price_Group_int")
    normalized_x_train = normalize(fill_nan_values(x_train))
    normalized_x_test = normalize(fill_nan_values(x_test))
    compare_classifiers(X_train=normalized_x_train, X_test=normalized_x_test, y_train=y_train, y_test=y_test)
    # compare_classifiers(X_train=x_train, X_test=x_test, y_train=y_train, y_test=y_test)

# normalized_x = preprocessing.normalize(x)
# scalerX = MinMaxScaler()
# scalerX.fit(x)
# standarded_x = scalerX.transform(x)
