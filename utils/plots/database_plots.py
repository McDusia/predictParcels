import matplotlib.pyplot as plt
import logging
import pandas as pd
from utils.database_handler import DatabaseHandler


def plot_land_types_statistics():
    # select count(*) from PARCEL_VECTORS
    # -- WHERE Residential = 1  -> 115519
    # -- WHERE Special_Purposes_Plan = 1 --  -> 3856
    # -- WHERE Agricultural = 1 --  -> 13849
    # -- WHERE Commercial = 1 --9672
    # -- WHERE Manufacturing = 1 --4026
    # AND LS1_Sale_Date > 20150000
    # AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT('0;9;999999999', ';'))
    plt.bar(x=['Residential', 'Agricultural', 'Commercial', 'Manufacturing', 'Special \nPurposes \nPlan'],
            height=[115519, 13849, 9672, 4026, 3856])

    plt.xlabel('Typ działki')
    plt.ylabel('Ilość')
    plt.savefig("statystyki_typ_dzialek.png")


def plot_transaction_amount_per_year():
    logging.basicConfig(level=logging.DEBUG)
    database_handler = DatabaseHandler()
    query = "select LS1_Sale_Date/10000 as 'YearSold', count(*) as 'Amount' from PARCEL p where LS1_Sale_Date is not null and LS1_Sale_Date != 0 and LS1_Sale_Date/10000 > 1950 group by LS1_Sale_Date/10000 order by LS1_Sale_Date/10000 asc"
    data = database_handler.execute_query(query)

    plt.bar(x=data['YearSold'],
            height=data['Amount'])

    plt.xlabel('Rok sprzedaży')
    plt.ylabel('Ilość transakcji')
    plt.show()


def plot_transaction_amount_per_year_and_price_group():
    logging.basicConfig(level=logging.DEBUG)
    # select LS1_Sale_Date/10000 as 'YearSold', count(*) as 'Amount', Price_Group_int
    # from PARCEL_VECTORS pv
    # where
    # LS1_Sale_Date is not null and LS1_Sale_Date != 0 and
    # LS1_Sale_Date/10000 >= 2014 and LS1_Sale_Date/10000 != 2017
    # group by LS1_Sale_Date/10000 , Price_Group_int
    # order by LS1_Sale_Date/10000 asc , Price_Group_int
    cheap_parcels = [57830, 61194, 55302]
    medium_parcels = [19377, 25363, 31274]
    expensive_parcels = [13564, 17774, 19295]
    index = ['2014', '2015', '2016']
    labels_df = pd.DataFrame({'tanie': cheap_parcels,
                       'średnio-drogie': medium_parcels,
                       'drogie': expensive_parcels
                       }, index=index)
    plt.xlabel('Rok sprzedaży')
    plt.ylabel('Ilość transakcji')
    ax = labels_df.plot.bar(rot=0)
    plt.title("Ilość transakcji z podziałem na lata")
    plt.show()


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    plot_transaction_amount_per_year_and_price_group()
