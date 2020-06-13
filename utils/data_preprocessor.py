import pandas as pd

from sklearn.impute import SimpleImputer
from sklearn.preprocessing import MinMaxScaler


def fill_nan_values(df):
    imp = SimpleImputer(strategy="most_frequent")
    return pd.DataFrame(data=imp.fit_transform(df), columns=df.columns)


def standardize(data_to_train_model_df):
    scaler = MinMaxScaler()
    scaler.fit(data_to_train_model_df)
    standardized_data_to_train_model = scaler.transform(data_to_train_model_df)
    return pd.DataFrame(data=standardized_data_to_train_model,
                        columns=data_to_train_model_df.columns)


def remove_sale_amount_anomalies(data_to_train_model_df, low=0.05, high=0.95):
    q_low = data_to_train_model_df["Sale_Amount"].quantile(low)
    q_hi = data_to_train_model_df["Sale_Amount"].quantile(high)
    return data_to_train_model_df[(data_to_train_model_df["Sale_Amount"] < q_hi) &
                                                (data_to_train_model_df["Sale_Amount"] > q_low)]

