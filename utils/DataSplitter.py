from sklearn.model_selection import train_test_split


class DataSplitter:
    def __init__(self, input_data, target_column_name, random_state=None, test_size=0.2):
        self.data = input_data
        self.target_column = target_column_name
        self.y_column = [target_column_name]
        self.X_columns = [i for i in input_data if i not in self.y_column]
        self.test_size = test_size
        self.random_state = random_state

    def get_x_y_data_train_test(self):
        x_train_set, x_test_set, y_train_set, y_test_set = train_test_split(self.get_x_data(),
                                                                            self.get_y_data(),
                                                                            test_size=self.test_size)
        return x_train_set, x_test_set, y_train_set, y_test_set

    def get_y_data(self):
        return self.data[self.target_column]

    def get_x_data(self):
        return self.data[self.X_columns]
