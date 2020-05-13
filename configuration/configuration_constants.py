"""
    Price classification module configuration constants
"""
target_column_name = 'Sale_Amount'

"""
    Lower limit date to filter data in order to train the model
    provided in format 'YYYYMMDD'.
    
    Upper limit date is in SQL script
"""
limit_date = 20140000


"""
    Price values excluded from training the model.
"""
excluded_values = '0;1;9;999999999'

"""
 Name of bucket currently using to train neural network model.
"""
current_bucket = 'cheap'

"""
  Variable to set if the model will be training using price parameters or without it. 
  Depends on it, program will call different procedure, which return data with different amount of columns. 
"""
train_model_with_price_parameters = False

"""
  Variable to set if overwrite file with neural network model or not. 
  Warning! If set to True, previous model would be lost. 
"""
model_overwrite = False

"""
  Using in parcel_valuation.py.
  Variable to set if predict prices using price parameters or not.
"""
predict_prices_using_price_parameters = True

"""
check if all below variables are using:
   Paths to:
    - initial weights for neural network before start training the model
    - folder to save trained models files
    - folder to save files with best results from one training iteration
    - names convention for trained models and checkpoints files
"""
weights_file_path = './../resources/init_weights.hdf5'
model_target_folder = './trained_models/'
checkpoint_file_target_folder = './../resources/best_results/checkpoint_'
file_names_convention = 'model_' + str(limit_date) + '_' + current_bucket
checkpoint_file_path = './../resources/'
path_to_trained_models = './trained_models/'

# TODO uzupelnic kolumnami ktore maja byc ominiete w podstawiwej wersji danych
values_to_omit_in_basic_data_version = ['Zoning_Code_int', 'Hmownr_Exempt_Number', 'Hmownr_Exempt_Value',
                                        'BD_LINE_2_Subpart', 'BD_LINE_2_Subpart', 'BD_LINE_1_RCN_Main',
                                        'BD_LINE_2_RCN_Main', 'BD_LINE_3_RCN_Main','BD_LINE_4_Year_Changed',
                                        'Landlord_Reappraisal_Year', 'Landlord_Number_of_Units']
