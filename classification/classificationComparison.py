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
from utils.data_preprocessor import standardize
from sklearn.preprocessing import normalize
from sklearn.impute import SimpleImputer
import seaborn as sn
import matplotlib.pyplot as plt
import pandas as pd

h = .02  # step size in the mesh

names = [
    "Nearest Neighbors3",
    "Nearest Neighbors100",
    # "Linear SVM",
    # "RBF SVM",
    "Decision Tree",
    "Random Forest",
    "Neural Net",
    "AdaBoost",
    "Naive Bayes",
    "QDA"
]

classifiers = [
    KNeighborsClassifier(3),
    KNeighborsClassifier(10),
    # SVC(kernel="linear", C=0.025),
    # SVC(gamma=2, C=1),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=100),
    MLPClassifier(alpha=1, max_iter=1000),
    AdaBoostClassifier(),
    GaussianNB(),
    # QuadraticDiscriminantAnalysis()
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
    imp = SimpleImputer(strategy="most_frequent")  # startegy: 'mean'
    return imp.fit_transform(df)


if __name__ == '__main__':
    # confusion = [[26333/29242, 2586/11492, 323/3261], [3602/29242, 7229/11492, 661/3261], [931/29242, 1047/11492, 1283/3261]]
    # df_cm = pd.DataFrame(confusion, index=[i for i in "012"],
    #                      columns=[i for i in "012"])
    # plt.figure(figsize=(10, 7))
    # sn.heatmap(df_cm, annot=True)
    # plt.show()
    x_train, x_test, y_train, y_test = \
        get_basic_data_splited_train_test(price_groups='0;1;2;', buildings_present='0;1',
                                          random_state=50, test_size=0.2,
                                          columns_to_omit=['Sale_Amount', 'Price_Group_int'],
                                          use_distances=True, target_column="Price_Group_int_second")
    normalized_x_train = normalize(fill_nan_values(x_train))
    normalized_x_test = normalize(fill_nan_values(x_test))
    # wywala sie bo ten minmax scaler nie zwraca intow... skaluje tez price groupe ;D
    compare_classifiers(X_train=normalized_x_train, X_test=normalized_x_test, y_train=y_train, y_test=y_test)

# TODO przetestowac te klasyfikatry ze standaryzacja i minmaxscalerem

# normalized_x = preprocessing.normalize(x)
# scalerX = MinMaxScaler()
# scalerX.fit(x)
# standarded_x = scalerX.transform(x)
