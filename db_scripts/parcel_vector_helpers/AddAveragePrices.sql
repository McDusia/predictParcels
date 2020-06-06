IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Average_Prices'))
BEGIN
	DROP TABLE Average_Prices
END

use LosAngelesParcels
CREATE TABLE Average_Prices (
    Simple_Zone_int INT,
    Current_Land_Base_Value_Avg INT, -- srednia wartosc za dzialke -> z wszystkimi dzialkami
    Current_Improvement_Base_Value_Avg_Buildings INT, -- srednia cena za improvement, do liczenia tylko dzialki z zabudowaniami
    Current_Land_Base_Value_Avg_Buildings INT, -- srednia cena za jednostke dla dzialek z budynkami
    Current_Land_Base_Value_Avg_No_Buildings INT, -- -//- dla dzialek bez budynkow
);
--================================
-- Count average values
--================================
DECLARE @ExcludedList VARCHAR(MAX);
SET @ExcludedList = '0;9;1;999999999'

INSERT INTO Average_Prices
select Simple_Zone_int, avg(cast((Current_Land_Base_Value/ Parcel_Area) as bigint)), NULL, NULL, NULL a
from PARCEL_VECTORS
where LS1_Sale_Date >= 20140000 AND LS1_Sale_Date < 20170000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND LS1_Sale_Amount < 250000000
	  AND OBJECTID not in (2188180, 2194874, 2194882, 2194928, 2194960, 2194981, 2200204, 2215273,2215288, 2215313,
	  2215319,22152340,2215397,2215462,2215483,2215484,2215495,2215496,2215528,2215547,2215548,2215563,2215564,2215568,
	  2215598,2215614,2215625,2215626,2215635,2215682,2215683,2215692,2215768,2215785,2215798,2215810,2215821,2215823,
	  2215824,2215839,2215850,2215851,2184233,2215861,2215874,2215886,2215895,2215907,2215924,2215936,2215984,2215987,
	  2216014,2216015,2216190,2216196,2223061,2223063,2223085,2223093,2223168,2223218,2242397,2248300,2249304,2313228,
	  2313359,2313367,2313437,2314516,2315037,2316056,2316065,2316067,2316094,2316110,2316174,2316196,2319204,2319937,
	  2319941,2319961,2323781,2328539,2339044,2342849,2344222,2355731,2374254,2379400,2387108,2387109,2387604,
	  2390674,2398109) 
	  AND Parcel_Area != 0
group by Simple_Zone_int

--=================================================================================
-- Average prices per parcels with buildings / not buildings
--=================================================================================
DECLARE @ExcludedList VARCHAR(MAX);
SET @ExcludedList = '0;9;1;999999999'

UPDATE Average_Prices
set Current_Improvement_Base_Value_Avg_Buildings = A.Current_Improvement_Base_Value_Avg_Buildings
from
(
select Simple_Zone_int,
		avg(cast((Current_Improvement_Base_Value/(BD_LINE_1_Sq_Ft_of_Main_Improve + BD_LINE_2_Sq_Ft_of_Main_Improve + BD_LINE_3_Sq_Ft_of_Main_Improve)) as bigint)) as Current_Improvement_Base_Value_Avg_Buildings
from PARCEL_VECTORS
where LS1_Sale_Date >= 20140000 AND LS1_Sale_Date < 20170000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND LS1_Sale_Amount < 250000000
	  AND OBJECTID not in (2188180, 2194874, 2194882, 2194928, 2194960, 2194981, 2200204, 2215273,2215288, 2215313,
	  2215319,22152340,2215397,2215462,2215483,2215484,2215495,2215496,2215528,2215547,2215548,2215563,2215564,2215568,
	  2215598,2215614,2215625,2215626,2215635,2215682,2215683,2215692,2215768,2215785,2215798,2215810,2215821,2215823,
	  2215824,2215839,2215850,2215851,2184233,2215861,2215874,2215886,2215895,2215907,2215924,2215936,2215984,2215987,
	  2216014,2216015,2216190,2216196,2223061,2223063,2223085,2223093,2223168,2223218,2242397,2248300,2249304,2313228,
	  2313359,2313367,2313437,2314516,2315037,2316056,2316065,2316067,2316094,2316110,2316174,2316196,2319204,2319937,
	  2319941,2319961,2323781,2328539,2339044,2342849,2344222,2355731,2374254,2379400,2387108,2387109,2387604,
	  2390674,2398109) and BD_LINE_1_Sq_Ft_of_Main_Improve + BD_LINE_2_Sq_Ft_of_Main_Improve + BD_LINE_3_Sq_Ft_of_Main_Improve != 0
	  AND Current_Improvement_Base_Value != 0
	  AND BuildingsPresent = 1
	  AND Parcel_Area != 0
group by Simple_Zone_int
) A
where A.Simple_Zone_int = Average_Prices.Simple_Zone_int

DECLARE @ExcludedList VARCHAR(MAX);
SET @ExcludedList = '0;9;1;999999999'
UPDATE Average_Prices
set Current_Land_Base_Value_Avg_Buildings = A.Current_Land_Base_Value_Avg_With_Buildings
from
(
select Simple_Zone_int,
		avg(cast((Current_Land_Base_Value/Parcel_Area)as bigint)) as Current_Land_Base_Value_Avg_With_Buildings
from PARCEL_VECTORS
where LS1_Sale_Date >= 20140000 AND LS1_Sale_Date < 20170000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND LS1_Sale_Amount < 250000000
	  AND OBJECTID not in (2188180, 2194874, 2194882, 2194928, 2194960, 2194981, 2200204, 2215273,2215288, 2215313,
	  2215319,22152340,2215397,2215462,2215483,2215484,2215495,2215496,2215528,2215547,2215548,2215563,2215564,2215568,
	  2215598,2215614,2215625,2215626,2215635,2215682,2215683,2215692,2215768,2215785,2215798,2215810,2215821,2215823,
	  2215824,2215839,2215850,2215851,2184233,2215861,2215874,2215886,2215895,2215907,2215924,2215936,2215984,2215987,
	  2216014,2216015,2216190,2216196,2223061,2223063,2223085,2223093,2223168,2223218,2242397,2248300,2249304,2313228,
	  2313359,2313367,2313437,2314516,2315037,2316056,2316065,2316067,2316094,2316110,2316174,2316196,2319204,2319937,
	  2319941,2319961,2323781,2328539,2339044,2342849,2344222,2355731,2374254,2379400,2387108,2387109,2387604,
	  2390674,2398109) and BD_LINE_1_Sq_Ft_of_Main_Improve + BD_LINE_2_Sq_Ft_of_Main_Improve + BD_LINE_3_Sq_Ft_of_Main_Improve != 0
	  AND BuildingsPresent = 1
	  AND Parcel_Area != 0
group by Simple_Zone_int
) A
where A.Simple_Zone_int = Average_Prices.Simple_Zone_int

DECLARE @ExcludedList VARCHAR(MAX);
SET @ExcludedList = '0;9;1;999999999'
UPDATE Average_Prices
set Current_Land_Base_Value_Avg_No_Buildings = A.Current_Land_Base_Value_Avg_No_Buildings
from
(
select Simple_Zone_int,
		avg(cast((Current_Land_Base_Value/Parcel_Area)as bigint)) as Current_Land_Base_Value_Avg_No_Buildings
from PARCEL_VECTORS
where LS1_Sale_Date >= 20140000 AND LS1_Sale_Date < 20170000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND LS1_Sale_Amount < 250000000
	  AND OBJECTID not in (2188180, 2194874, 2194882, 2194928, 2194960, 2194981, 2200204, 2215273,2215288, 2215313,
	  2215319,22152340,2215397,2215462,2215483,2215484,2215495,2215496,2215528,2215547,2215548,2215563,2215564,2215568,
	  2215598,2215614,2215625,2215626,2215635,2215682,2215683,2215692,2215768,2215785,2215798,2215810,2215821,2215823,
	  2215824,2215839,2215850,2215851,2184233,2215861,2215874,2215886,2215895,2215907,2215924,2215936,2215984,2215987,
	  2216014,2216015,2216190,2216196,2223061,2223063,2223085,2223093,2223168,2223218,2242397,2248300,2249304,2313228,
	  2313359,2313367,2313437,2314516,2315037,2316056,2316065,2316067,2316094,2316110,2316174,2316196,2319204,2319937,
	  2319941,2319961,2323781,2328539,2339044,2342849,2344222,2355731,2374254,2379400,2387108,2387109,2387604,
	  2390674,2398109) and BD_LINE_1_Sq_Ft_of_Main_Improve + BD_LINE_2_Sq_Ft_of_Main_Improve + BD_LINE_3_Sq_Ft_of_Main_Improve != 0
	  AND Current_Improvement_Base_Value != 0
	  AND BuildingsPresent = 0
	  AND Parcel_Area != 0
group by Simple_Zone_int
) A
where A.Simple_Zone_int = Average_Prices.Simple_Zone_int

