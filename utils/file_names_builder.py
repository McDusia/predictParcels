from configuration.configuration_constants \
    import model_target_folder,\
    file_names_convention, \
    checkpoint_file_target_folder,\
    limit_date,\
    predict_prices_using_price_parameters


def get_model_filename():
    if predict_prices_using_price_parameters:
        return model_target_folder + file_names_convention + '.h5'
    else:
        return model_target_folder + file_names_convention \
               + '_no_price_parameters' + '.h5'


def get_model_filename_b(bucket):
    if predict_prices_using_price_parameters:
        return model_target_folder + 'model_' + str(limit_date) \
               + '_' + bucket + '.h5'
    else:
        return model_target_folder + 'model_' + str(limit_date) \
               + '_' + bucket + '_no_price_parameters' + '.h5'


def get_checkpoints_filename():
    return checkpoint_file_target_folder + file_names_convention + '.hdf5'


def make_file_name(base_name, _limit_date='', bucket='', extension='.h5'):
    return base_name + str(_limit_date) + '_' + bucket + extension
