-- Declarations
DECLARE @ExcludedList VARCHAR(MAX);
DECLARE @PriceGroupInt VARCHAR(10);
DECLARE @BuildingsPresent VARCHAR(10);

SET @ExcludedList = '0;9;999999999'
SET @PriceGroupInt = '0;1;2'
SET @BuildingsPresent = '0;1'

-- Extract prices
use LosAngelesParcels

SELECT avg(Price_Per_Single_Area_Unit), BuildingsPresent, Price_Group_int, LS1_Sale_Date/10000 as YearSold
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date > 20150000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND Price_Group_int in (SELECT value FROM STRING_SPLIT(@PriceGroupInt, ';'))
	  AND BuildingsPresent in (SELECT value FROM STRING_SPLIT(@BuildingsPresent, ';'))
GROUP BY BuildingsPresent, Price_Group_int, LS1_Sale_Date/10000
ORDER BY Price_Group_int, BuildingsPresent, LS1_Sale_Date/10000 asc

---------

use LosAngelesParcels
CREATE TABLE Price_Factors (
    BuildingsPresent INT NOT NULL,
    Price_Group_int INT,
    AveragePrice FLOAT(10) NOT NULL,
    ScaledPrice FLOAT(10) NOT NULL,
    YearSold INT,
);


-- insert values into Price_Factors
-- scale on BuildingsPresent

INSERT INTO Price_Factors
SELECT BuildingsPresent, NULL as Price_Group_int, avg(Price_Per_Single_Area_Unit) as AveragePrice, avg(Price_Per_Single_Area_Unit)/538.1800919705275 as ScaledPrice, LS1_Sale_Date/10000 as YearSold
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date > 20150000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND Price_Group_int in (SELECT value FROM STRING_SPLIT(@PriceGroupInt, ';'))
	  AND BuildingsPresent = 0
	  AND Parcel_Area != 0
GROUP BY BuildingsPresent, LS1_Sale_Date/10000;

INSERT INTO Price_Factors
SELECT BuildingsPresent, NULL as Price_Group_int, avg(Price_Per_Single_Area_Unit) as AveragePrice, avg(Price_Per_Single_Area_Unit)/140.22179068848186 as ScaledPrice, LS1_Sale_Date/10000 as YearSold
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date > 20150000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND Price_Group_int in (SELECT value FROM STRING_SPLIT(@PriceGroupInt, ';'))
	  AND BuildingsPresent = 1
	  AND Parcel_Area != 0
GROUP BY BuildingsPresent, LS1_Sale_Date/10000;

-- scale on BuildingsPresent, Price_Group_int
-- Values added but Scale factor set to 0 in order to omit in computations

DECLARE @ExcludedList VARCHAR(MAX);
DECLARE @PriceGroupInt VARCHAR(10);
DECLARE @BuildingsPresent VARCHAR(10);

SET @ExcludedList = '0;9;999999999'
SET @PriceGroupInt = '0;1;2'
SET @BuildingsPresent = '0;1'
INSERT INTO Price_Factors
SELECT BuildingsPresent, Price_Group_int, avg(Price_Per_Single_Area_Unit) as AveragePrice, 0 as ScaledPrice, LS1_Sale_Date/10000 as YearSold
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date > 20150000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND Price_Group_int in (SELECT value FROM STRING_SPLIT(@PriceGroupInt, ';'))
	  AND BuildingsPresent in (SELECT value FROM STRING_SPLIT(@BuildingsPresent, ';'))
GROUP BY BuildingsPresent, Price_Group_int, LS1_Sale_Date/10000

-- Queries
-- grouped on price group and buildings present
select PR_destination.AveragePrice, PR_helpers.AveragePrice, PR_destination.AveragePrice/PR_helpers.AveragePrice, PR_destination.ScaledPrice, PR_destination.*
FROM PRICE_FACTORS PR_destination
INNER JOIN
PRICE_FACTORS PR_helpers
ON PR_helpers.YearSold = 2015 AND PR_destination.BuildingsPresent = PR_helpers.BuildingsPresent AND PR_destination.Price_Group_int = PR_helpers.Price_Group_int

-- grouped on buildings present
select PR_destination.AveragePrice, PR_helpers.AveragePrice, PR_destination.AveragePrice/PR_helpers.AveragePrice, PR_destination.ScaledPrice, PR_destination.*
FROM PRICE_FACTORS PR_destination
INNER JOIN
PRICE_FACTORS PR_helpers
ON PR_helpers.YearSold = 2015 AND PR_destination.BuildingsPresent = PR_helpers.BuildingsPresent AND PR_helpers.Price_Group_int IS NULL AND PR_destination.Price_Group_int IS NULL

-- SQL Update queries

UPDATE PR_destination
SET ScaledPrice = PR_destination.AveragePrice/PR_helpers.AveragePrice
FROM PRICE_FACTORS PR_destination
INNER JOIN PRICE_FACTORS PR_helpers
ON PR_helpers.YearSold = 2015 AND PR_destination.BuildingsPresent = PR_helpers.BuildingsPresent


UPDATE PR_destination
SET ScaledPrice = PR_destination.AveragePrice/PR_helpers.AveragePrice
from PRICE_FACTORS PR_destination
INNER JOIN PRICE_FACTORS PR_helpers
ON PR_helpers.YearSold = 2015 AND PR_destination.BuildingsPresent = PR_helpers.BuildingsPresent AND PR_destination.Price_Group_int = PR_helpers.Price_Group_int

-- Update

IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_VECTORS' and COLUMN_NAME = 'ScaledPriceOnBuildingsPresent'))
    BEGIN
        ALTER TABLE PARCEL_VECTORS
            ADD ScaledPriceOnBuildingsPresent int
    END

UPDATE PARCEL_VECTORS
SET PARCEL_VECTORS.ScaledPriceOnBuildingsPresent = PARCEL_VECTORS.Land_Curr_Value * (1 + (1 - pf.ScaledPrice))
FROM PARCEL_VECTORS
INNER JOIN PRICE_FACTORS pf
ON PARCEL_VECTORS.BuildingsPresent = pf.BuildingsPresent and pf.Price_group_int is null AND pf.YearSold = PARCEL_VECTORS.LS1_Sale_Date/10000

--


IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_VECTORS' and COLUMN_NAME = 'ScaledPriceOnBuildingsPresentAndPriceGroup'))
    BEGIN
        ALTER TABLE PARCEL_VECTORS
            ADD ScaledPriceOnBuildingsPresentAndPriceGroup int
    END
    GO
UPDATE PARCEL_VECTORS
SET PARCEL_VECTORS.ScaledPriceOnBuildingsPresentAndPriceGroup = PARCEL_VECTORS.Land_Curr_Value * (1 + (1 - pf.ScaledPrice))
FROM PARCEL_VECTORS
INNER JOIN PRICE_FACTORS pf
ON PARCEL_VECTORS.BuildingsPresent = pf.BuildingsPresent and pf.Price_group_int = PARCEL_VECTORS.Price_Group_int AND pf.YearSold = PARCEL_VECTORS.LS1_Sale_Date/10000
