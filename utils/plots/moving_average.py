import matplotlib.pyplot as plt
import logging
from utils.database_handler import DatabaseHandler


def plot_moving_average(data, target_column, years_resolution=[5, 10]):
    moving_average_symbol = 'Srednia krocząca: '
    standard_deviation_symbol_plus = '+SD'
    standard_deviation_symbol_minus = '-SD'
    mean_symbol = 'mean'

    keys = []

    for year in years_resolution:
        key = moving_average_symbol + str(year)
        mean_key = mean_symbol + str(year)

        data[key] = data[target_column].rolling(year).mean()
        data[mean_key] = data[[key]].mean(axis=1)

        data[standard_deviation_symbol_plus + str(year)] = data[mean_key] + data[[key]].std(axis=1)
        data[standard_deviation_symbol_minus + str(year)] = data[mean_key] - data[[key]].std(axis=1)

        # keys.extend([standard_deviation_symbol_plus + str(year), standard_deviation_symbol_minus + str(year), key])
        keys.extend([key])
    keys.append('YearSold')
    ax = data[keys].plot(x='YearSold')
    ax.set_xlabel('Rok')
    plt.title("Średnia krocząca")
    plt.show()


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "SELECT * FROM Price_Averages WHERE BuildingsPresent = 0 ORDER BY YearSold"
    data = database_handler.execute_query(query)
    plot_moving_average(data, "AveragePrice", years_resolution=[5, 10])
