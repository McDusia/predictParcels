import matplotlib.pyplot as plt
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler
import pandas as pd
import seaborn as sb
from configuration.configuration_constants import values_to_omit_in_basic_data_version
from utils.get_basic_train_data import get_basic_data, split_data_x_y, get_basic_data_splited_train_test
from sklearn import preprocessing
import logging

X_LABEL = 'Powierzchnia działki'
Y_LABEL = 'Częstotliwość występowania'


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")
    return pd.DataFrame(data=imp.fit_transform(df), columns=df.columns)


def draw_heatmap(df):

    C_mat = df.corr()
    fig = plt.figure(figsize=(15, 15))
    sb.heatmap(C_mat, vmax=1, square=True, cmap="Blues")
    plt.show()


mpl_logger = logging.getLogger('matplotlib')
mpl_logger.setLevel(logging.WARNING)

# 0 bez budynków, 0 - tanie
x, x_test, y, y_test = \
        get_basic_data_splited_train_test(price_groups='0', buildings_present='0',
                                          columns_to_omit=values_to_omit_in_basic_data_version,
                                          random_state=50, test_size=0.01)

data_df = get_basic_data(price_groups='0', buildings_present='0',
                         columns_to_omit=values_to_omit_in_basic_data_version)

#data_df = fill_nan_values(data_df)

x = fill_nan_values(x)
data_df.describe()

q_low = data_df["Sale_Amount"].quantile(0.01)
q_hi = data_df["Sale_Amount"].quantile(0.99)

q_low2 = data_df["Sale_Amount"].quantile(0.01)
q_hi2 = data_df["Sale_Amount"].quantile(0.99)

data_df = data_df[(data_df["Sale_Amount"] < q_hi) & (data_df["Sale_Amount"] > q_low)]

draw_heatmap(data_df)
original_x = x
columns = x.columns

print(x.columns)
print(x.shape)

parcel_area = x['Parcel_Area']
parcel_area.plot.hist(bins=2000, alpha=1)

plt.xlabel(X_LABEL)
plt.ylabel(Y_LABEL)
plt.title('Histogram - rozkład powierzchni działek')

plt.show()

# STANDARDIZATION
scalerX = MinMaxScaler()
scalerX.fit(x)
standardized_x = scalerX.transform(x)
standardized_x = pd.DataFrame(data=standardized_x, columns=columns)

standardized_parcel_area = standardized_x['Parcel_Area']
standardized_parcel_area.plot.hist(bins=2000, alpha=1)

plt.xlabel(X_LABEL)
plt.ylabel(Y_LABEL)
plt.title('Histogram - rozkład powierzchni działek - po standaryzacji danych')
plt.show()

# NORMALIZATION
normalized_x = preprocessing.normalize(original_x)
normalized_x = pd.DataFrame(data=normalized_x, columns=columns)
normalized_parcel_area = normalized_x['Parcel_Area']

normalized_parcel_area.plot.hist(bins=2000, alpha=1)

plt.xlabel(X_LABEL)
plt.ylabel(Y_LABEL)
plt.title('Histogram - rozkład powierzchni działek - po normalizacji danych')
plt.show()


