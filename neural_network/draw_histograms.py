import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler
import pandas as pd
from utils.get_basic_train_data import get_basic_data, split_data_x_y, get_basic_data_splited_train_test
from sklearn import preprocessing

import logging
mpl_logger = logging.getLogger('matplotlib')
mpl_logger.setLevel(logging.WARNING)


x, x_test, y, y_test = \
    get_basic_data_splited_train_test(price_groups='0', buildings_present='0;1',

                                      random_state=50, test_size=0.15)
x.describe()
original_x = x
columns = x.columns

print(x.columns)
print(x.shape)
parcel_area = x['Parcel_Area']
parcel_area.plot.hist(bins=1000, alpha=1, title='Histogram prezentujący rozkład powierzchni działek',
                      y='Częstotliwość występowania', x='Powierzchnia działki')
plt.show()

# STANDARDIZATION
scalerX = MinMaxScaler()
scalerX.fit(x)
standardized_x = scalerX.transform(x)
standardized_x = pd.DataFrame(data=standardized_x, columns=columns)
print(standardized_x.columns)

standardized_parcel_area = standardized_x['Parcel_Area']

standardized_parcel_area.plot.hist(bins=1000, alpha=1,
                                   title='Histogram prezentujący rozkład powierzchni działek - po standaryzacji danych',
                                   y='Częstotliwość występowania', x='Powierzchnia działki')

plt.show()

# NORMALIZATION
normalized_x = preprocessing.normalize(original_x)
normalized_x = pd.DataFrame(data=normalized_x, columns=columns)
normalized_parcel_area = normalized_x['Parcel_Area']

normalized_parcel_area.plot.hist(bins=1000, alpha=1,
                                 title='Histogram prezentujący rozkład powierzchni działek - po normalizacji danych',
                                 y='Częstotliwość występowania', x='Powierzchnia działki')

plt.show()


