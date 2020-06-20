from sklearn.metrics import mean_squared_error, mean_absolute_error, explained_variance_score, r2_score, max_error
import logging
import numpy as np
from utils.plots.basic_plot import values_one_plot_with_linear_and_dots, values_one_plot
from sklearn.metrics import accuracy_score, cohen_kappa_score, classification_report, hamming_loss, confusion_matrix
import seaborn as sn
import matplotlib.pyplot as plt
import pandas as pd


def mean_absolute_percentage_error(y_true, y_pred):
    y_true = pd.DataFrame(y_true)
    y_pred = pd.DataFrame(y_pred)
    # y_true = np.array(y_true)
    # y_pred = np.array(y_pred)
    y_true = y_true + 1
    y_pred = y_pred + 1
    return np.mean(np.abs((y_true - y_pred) / y_true)) * 100


def rmse(predictions, targets):
    predictions = pd.DataFrame(predictions)
    targets = pd.DataFrame(targets)
    return np.sqrt(((predictions - targets) ** 2).mean())


# def plots(real_values, predicted_values, plot_title, x_label="Kolejne numery działek", y_label="cena za działkę [$]"):
def plots(real_values, predicted_values, plot_title, x_label="Kolejne numery działek", y_label="cena po normalizacji",
          title=""):
    values_one_plot_with_linear_and_dots(real_values[:100], predicted_values[:100], "Rzeczywiste wartości",
                                         "Predygowane wartości",
                                         plot_title + "0", x_label=x_label, y_label=y_label, plot_title=title)
    values_one_plot(real_values[:100], predicted_values[:100], "Rzeczywiste wartości",
                    "Predygowane wartości",
                    plot_title + "1", x_label=x_label, y_label=y_label, plot_title=title)
    values_one_plot(real_values[:1000], predicted_values[:1000], "Rzeczywiste wartości",
                    "Predygowane wartości",
                    plot_title + "2", x_label=x_label, y_label=y_label, plot_title=title)
    values_one_plot(real_values[:5000], predicted_values[:5000], "Rzeczywiste wartości",
                    "Predygowane wartości",
                    plot_title + "3", x_label=x_label, y_label=y_label, plot_title=title)
    values_one_plot(real_values, predicted_values, "Rzeczywiste wartości", "Predygowane wartości", plot_title + "4",
                    x_label=x_label, y_label=y_label)
    values_one_plot_with_linear_and_dots(real_values, predicted_values, "Rzeczywiste wartości", "Predygowane wartości",
                                         plot_title + "5", x_label=x_label, y_label=y_label, plot_title=title)


def get_result_statistics(predicted_values, real_values, file_title, title):
    mse = mean_squared_error(real_values, predicted_values)
    rms = rmse(predicted_values, real_values)
    mean_absolute_percentage_e = mean_absolute_percentage_error(real_values, predicted_values)
    mae = mean_absolute_error(real_values, predicted_values)

    max_error_val = max_error(real_values, predicted_values)

    logging.info('Max error: %s', round(max_error_val, 6))
    # mean_absolute_percentage_error = np.mean(np.abs(predicted_values - real_values) / real_values) * 100
    # Calculate and log accuracy
    # accuracy = 100 - np.mean(mean_absolute_percentage_error)
    # logging.info('Accuracy: %s percentage', round(accuracy, 6))

    # Best result: 1.0 [explained_variance_score_result, r2_score_result]

    explained_variance_score_result = explained_variance_score(real_values, predicted_values)
    r2_score_result = r2_score(real_values, predicted_values)
    logging.info("Mean squared error: %s", mse)
    logging.info("Root mean squared error: %s", rms)
    logging.info("Mean absolute percentage error: %s", mean_absolute_percentage_e)
    logging.info('Explained variance score: %s', round(explained_variance_score_result, 6))
    logging.info('r2 score: %s', round(r2_score_result, 6))
    logging.info("Mean Absolute Error: %s", mae)
    logging.info("Overleaf: %s & %s & %s  & %s & %s  & %s  &  %s",
                 round(max_error_val, 3),
                 round(r2_score_result, 3),
                 round(explained_variance_score_result, 3),
                 round(mse, 3),
                 round(rms, 3),
                 round(mae, 3),
                 round(mean_absolute_percentage_e, 3),
                 )
    plots(real_values, predicted_values, plot_title=file_title, title=title)


def get_classification_result_statistics(predicted_values, real_values, plot_title="", target_names=['1', '2', '3']):
    cheap_prices_amount = len([x for x in real_values if x == 0])
    medium_prices_amount = len([x for x in real_values if x == 1])
    expensive_prices_amount = len([x for x in real_values if x == 2])

    pcheap_prices_amount = len([x for x in predicted_values if x == 0])
    pmedium_prices_amount = len([x for x in predicted_values if x == 1])
    pexpensive_prices_amount = len([x for x in predicted_values if x == 2])

    logging.info('Cheap amount: %s predicdted: %s', cheap_prices_amount, pcheap_prices_amount)
    logging.info('Medium amount: %s predicdted: %s', medium_prices_amount, pmedium_prices_amount)
    logging.info('Expensive amount: %s predicdted: %s', expensive_prices_amount, pexpensive_prices_amount)
    accuracy = accuracy_score(real_values, predicted_values)
    accuracy_not_normalised = accuracy_score(real_values, predicted_values, normalize=False)

    kappa_score = cohen_kappa_score(real_values, predicted_values)

    logging.info('Accuracy: %s', accuracy)
    logging.info('Accuracy not normalised: %s, Count of test set: %s', accuracy_not_normalised, len(real_values))

    logging.info('Cohen Kappa score: %s', kappa_score)
    logging.info(classification_report(real_values, predicted_values, target_names=target_names))

    haming_loss_score = hamming_loss(real_values, predicted_values)
    logging.info('Haming loss score: %s', haming_loss_score)

    #     TODO confusion matrix & plot of confusion matrix
    conf_matrix = confusion_matrix(real_values, predicted_values)
    print(conf_matrix)
    df_cm = pd.DataFrame(conf_matrix, index=[i for i in "012"],
                         columns=[i for i in "012"])
    plt.figure(figsize=(10, 7))
    sn.heatmap(df_cm, annot=True)
    plt.title(plot_title)
    plt.show()

    # df_cm = pd.DataFrame(conf_matrix, index=[i for i in "123"],
    #                      columns=[i for i in "123"])
    # plt.figure(figsize=(10,7))
    # sn.heatmap(df_cm, annot=True)
