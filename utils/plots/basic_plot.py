import matplotlib.pyplot as plt


def basic_plot(x, y, x_label, y_label, title):
    plt.plot(x, y)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title)
    plt.grid(True)
    plt.show()


def values_one_plot(y_part_1, y_part_2, y1_label, y2_label, title, x_label="", y_label=""):
    x = range(len(y_part_1))
    plt.plot(x, y_part_1, '.', color='red')
    plt.plot(x, y_part_2, '.', color='blue')
    plt.legend([y1_label, y2_label], loc='upper left')
    plt.title(title)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.grid(True)
    plt.show()


def values_one_plot_with_linear_and_dots(y_part_1, y_part_2, y1_label, y2_label, title, x_label="", y_label=""):
    x = range(len(y_part_1))
    plt.plot(x, y_part_1, color='red')
    plt.plot(x, y_part_2, '.', color='blue')
    plt.legend([y1_label, y2_label], loc='upper left')
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title)
    plt.grid(True)
    plt.show()
