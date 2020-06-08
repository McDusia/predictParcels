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
    basic_plot(title="Ceny rosnoco2", x_label="Numer porzadkowy", y_label="Cena sprzedazy", y=data['Sale_Amount'], x=x)
    basic_plot(title="Ceny rosnoco2", x_label="Numer porzadkowy", y_label="Cena sprzedazy", y=data['Sale_Amount'][:150000], x=x[:150000])
    basic_plot(title="Ceny rosnoco2", x_label="Numer porzadkowy", y_label="Cena sprzedazy", y=data['Sale_Amount'][100000:200000], x=x[100000:200000])
    basic_plot(title="Ceny rosnoco2", x_label="Numer porzadkowy", y_label="Cena sprzedazy", y=data['Sale_Amount'][200000:], x=x[200000:])
