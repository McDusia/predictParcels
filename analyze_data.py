import logging
from utils.database_handler import DatabaseHandler
from configuration.configuration_constants import limit_date, excluded_values, \
    current_bucket, train_model_with_price_parameters
from utils.prices_mapping import parcel_prices_mapping
import matplotlib.pyplot as plt


def get_data(database_handler):
    logging.info('Get data')
    if train_model_with_price_parameters:
        procedure = 'GetDateToTrainModel'
    else:
        procedure = 'GetDateToTrainModelWithoutPriceParameters'
    # Type: dataframe
    # analyze data only fom one bucket for 3 last years, only with valuable prices
    data_to_train_model = database_handler.execute_query("EXEC dbo.{} "
                                                         "@LimitDate = {}, "
                                                         "@BucketType={}, "
                                                         "@ExcludedList='{}'"
                                                         .format(procedure,
                                                                 limit_date,
                                                                 parcel_prices_mapping[current_bucket],
                                                                 excluded_values))

    # SYNTAX: data_to_train_model.plot(x='column name for x axis', y='column name for y axis',
    # kind='scatter or line or bar')

    # How many parcels are for each parcel type .groupby('LS2_Sale_Date')
    data_to_train_model.groupby('PARCEL_TYP').plot(y='PARCEL_TYP', kind='bar')

    # TODO How Sale_Amount has changed across the years
    # data_to_train_model.plot(x='LS2_Sale_Date', y='Sale_Amount', kind='line')

    # TODO Count how many parcels for each year are in dataset
    # data_to_train_model.groupby(['LS1_Sale_Date']).count()['LS1_Sale_Date'].plot()

    # TODO What is the relation between Parcel Area and Sale_Amount

    plt.show()
    # Pandas DataFrame.shape return a tuple representing the dimensionality of the DataFrame
    data_size = data_to_train_model.shape[1]
    print('The shape of features is:', data_to_train_model.shape)

    f = open("DescribeDataToTrainModel.txt", "a")
    data_description = data_to_train_model.describe()
    f.write(data_description.to_string())
    f.close()

    # Split into X set and Y set
    # Take all columns except the first one - OBJECID and the last one - Sale_Amount
    x = data_to_train_model.iloc[:, 1: data_size - 1]
    y = data_to_train_model.iloc[:, data_size - 1]


def main():
    database_handler = DatabaseHandler()
    try:
        get_data(database_handler=database_handler)
    finally:
        database_handler.close_connection()


if __name__ == '__main__':
    main()
