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
