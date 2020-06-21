import logging
from utils.get_basic_train_data import get_data_splitted_for_price_groups
from utils.result_stats import get_result_statistics


def runner(fitted_model, x_test_set, y_test_set, title_part):
    logging.info("Statystki dla calosci")
    predicted_all = fitted_model.predict(x_test_set)
    get_result_statistics(predicted_values=predicted_all, real_values=y_test_set,
                          file_title=title_part + "cale", title="cale")
    cheap, medium, expensive = get_data_splitted_for_price_groups(x_data=x_test_set, y_data=y_test_set)
    if cheap:
        logging.info("Statystki dla tanich")
        cheap_x, cheap_y = cheap
        predicted_values_cheap = fitted_model.predict(list(cheap_x))
        # predicted_values_cheap = fitted_model.predict(list(cheap_x))
        get_result_statistics(predicted_values=predicted_values_cheap, real_values=cheap_y,
                              file_title=title_part + "tanie", title="Działki tanie")
    if medium:
        logging.info("Statystki dla srednich")
        medium_x, medium_y = medium
        predicted_values_medium = fitted_model.predict(medium_x)
        get_result_statistics(predicted_values=predicted_values_medium, real_values=medium_y,
                              file_title=title_part + "srednie", title="Działki średnio-drogie")
    if expensive:
        logging.info("Statystki dla drogich")
        expensive_x, expensive_y = expensive
        # predicted_values_expensive = fitted_model.predict(list(expensive_x))
        predicted_values_expensive = fitted_model.predict(expensive_x)
        get_result_statistics(predicted_values=predicted_values_expensive, real_values=expensive_y,
                              file_title=title_part + "drogie", title="Działki drogie")

    # if cheap and medium and expensive:
    #     logging.info("Statystki dla calosci")
    #     all = list(predicted_values_cheap) + list(predicted_values_medium) + list(predicted_values_expensive)
    #     real_all = list(cheap_y) + list(medium_y) + list(expensive_y)
    #     get_result_statistics(
    #         predicted_values=all,
    #         real_values=real_all, file_title=title_part + "cale")
