from utils.get_basic_train_data import get_basic_data
from utils.plots.basic_plot import basic_plot
import logging
from configuration.configuration_constants import excluded_values, \
    limit_date
from utils.database_handler import DatabaseHandler

if __name__ == '__main__':
    database_handler = DatabaseHandler()
    query = "select Sale_Amount from Fun_GetDataToTrainModel(20140000,'0;1;9;999999999', '0;1;2', '0;1') where Sale_Amount < 7000070 order by Sale_Amount asc"
    data = database_handler.execute_query(query)
    x = range(len(data))
    y_label = "Cena sprzedaży [$]"
    x_label = "Numer sekwencyjny"
    title = "Ceny sprzedaży rosnąco"
    basic_plot(title=title, x_label=x_label, y_label=y_label, y=data['Sale_Amount'], x=x)
    basic_plot(title=title, x_label=x_label, y_label=y_label, y=data['Sale_Amount'][:150000],
               x=x[:150000])
    basic_plot(title=title, x_label=x_label, y_label=y_label, y=data['Sale_Amount'][100000:200000],
               x=x[100000:200000])
    basic_plot(title=title, x_label=x_label, y_label=y_label, y=data['Sale_Amount'][200000:],
               x=x[200000:])
