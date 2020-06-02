import csv
import logging
import numpy as np
import os
import sys
from keras.engine.saving import load_model
from configuration.configuration_constants import *
from utils.file_names_builder import get_neural_network_model_filename, get_model_filename_b
from utils.database_handler import DatabaseHandler
from utils.prices_mapping import parcel_prices_mapping


def keras_load_model(file_name):
    if os.path.exists(get_neural_network_model_filename()):
        logging.info('Loading model from {}.'.format(file_name))
        return load_model(file_name)
    else:
        logging.error('The model can not be found. Firstly run neural_network_model_trainer.py')
        sys.exit(1)


def main():
    database_handler = DatabaseHandler()
    if predict_prices_using_price_parameters:
        filename = 'estimated_prices.csv'
    else:
        filename = 'estimated_prices_based_on_no_price_parameters.csv'
    try:
        with open(filename, mode='a') as estimated_prices_file:
            estimated_prices_writer = csv.writer(estimated_prices_file, delimiter=',', quotechar='"',
                                                 quoting=csv.QUOTE_MINIMAL)
            for bucket in classification_buckets:
                model_filename = get_model_filename_b(bucket)
                model = keras_load_model(model_filename)
                if predict_prices_using_price_parameters:
                    procedure = 'GetDataToParcelsValuation'
                else:
                    procedure = 'GetDataToParcelsValuationWithoutPriceParameters'
                df_parcels_to_valuation = database_handler.execute_query("EXEC dbo.{} "
                                                                         "@LimitDate = {}, "
                                                                         "@BucketType={}, "
                                                                         "@ExcludedList='{}'"
                                                                         .format(procedure,
                                                                                 limit_date,
                                                                                 parcel_prices_mapping[bucket],
                                                                                 excluded_values))
                data_size = df_parcels_to_valuation.shape[1]
                # skip the first attribute - OBJECTID and the last attribute - Sale_Amount, which will be predicted
                x = df_parcels_to_valuation.iloc[:, 1:data_size - 1]
                prediction = model.predict(x)

                for (prediction_value, object_id) in zip(prediction, df_parcels_to_valuation['OBJECTID']):

                    if prediction_value[0] < 0:
                        prediction_value[0] = 0

                    estimated_prices_writer.writerow([object_id, np.uint64(round(prediction_value[0], 0))])
    finally:
        database_handler.close_connection()


if __name__ == '__main__':
    main()
