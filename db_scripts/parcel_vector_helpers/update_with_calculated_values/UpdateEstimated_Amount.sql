-- =============================================
-- Author:  Magdalena Nowak
-- Create date: 18.11.2018
-- Description: Procedures to update estimated price
-- =============================================


CREATE TABLE ESTIMATED_PRICES
(
	ID INT,
	Estimated_Amount INT
)
GO


BULK INSERT ESTIMATED_PRICES
    FROM '[path]\Estimation\estimated_prices.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '[path]\Estimation\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

BULK INSERT ESTIMATED_PRICES
    FROM '[path]\Estimation\estimated_prices_based_on_no_price_parameters.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '[path]\Estimation\ep_based_on_no_price_parameters_errors.txt',	-- Here change path
    TABLOCK
    )
GO

UPDATE PARCEL_VECTORS SET Estimated_Amount = null
FROM PARCEL_VECTORS P
GO

UPDATE PARCEL_VECTORS SET PARCEL_VECTORS.Estimated_Amount = E.Estimated_Amount, Row_Version_Stamp = Row_Version_Stamp + 1
FROM PARCEL_VECTORS P
INNER JOIN ESTIMATED_PRICES E
ON P.OBJECTID = E.ID;
GO

UPDATE PARCEL_VECTORS SET Estimated_Amount = P.Sale_Amount, Row_Version_Stamp = Row_Version_Stamp + 1
FROM PARCEL_VECTORS P
WHERE Estimated_Amount is null
GO

select * from Estimated_Prices_and_Simple_Zone_Code_int_VIEW