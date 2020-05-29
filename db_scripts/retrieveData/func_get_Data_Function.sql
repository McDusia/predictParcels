CREATE OR ALTER FUNCTION Fun_GetDataToTrainModel(
    @LimitDate nvarchar(30),
    @ExcludedList nvarchar(MAX),
    @PriceGroupInt nvarchar(30),
    @BuildingsPresent nvarchar(30))
RETURNS TABLE
AS
RETURN
    SELECT
        -- ObjectID is necessary for inner join. Easier to omit in code than remember about modifying dependent stored procedures
        OBJECTID,
        PERIMETER,
        PARCEL_TYP,
        -- TRA_1,
        SA_Zip_Cde,
        MA_Zip_Cde,
        Hmownr_Exempt_Number,
        Hmownr_Exempt_Value,
        BD_LINE_1_Yr_Built,
        BD_LINE_1_No_of_Units,
        BD_LINE_1_No_of_Bedrooms,
        BD_LINE_1_No_of_Baths,
        BD_LINE_2_Subpart,
        BD_LINE_2_Yr_Built,
        BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms,
        BD_LINE_2_No_of_Baths,
        BD_LINE_2_Sq_Ft_of_Main_Improve,
        BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built,
        BD_LINE_3_No_of_Units,
        BD_LINE_3_No_of_Bedrooms,
        BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve,
        Cluster_Location,
        Cluster_Type,
        Cluster_Appraisal_Unit,
        BD_LINE_1_Year_Changed,
        Parcel_Area,
        CENTER_LAT,
        CENTER_LON,
        Residential,
        Special_Purposes_Plan,
        Agricultural,
        Commercial,
        Manufacturing,
        SA_Localization_int,
        MA_Localization_int,
        MA_Direction_int,
        SA_Direction_int,
        Simple_Zone_int,
        Zoning_Code_int,
        BD_LINE_1_Quality__Class___Shap_int,
        City_int,
        --Sale_Amount
        ScaledPriceOnBuildingsPresent
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date >= @LimitDate
      AND LS1_Sale_Date < 20170000
      AND Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
	  AND Price_Group_int in (SELECT value FROM STRING_SPLIT(@PriceGroupInt, ';'))
	  AND BuildingsPresent in (SELECT value FROM STRING_SPLIT(@BuildingsPresent, ';'))
	  AND OBJECTID not in (2188180, 2194874, 2194882, 2194928, 2194960, 2194981, 2200204, 2215273,2215288, 2215313,
	  2215319,22152340,2215397,2215462,2215483,2215484,2215495,2215496,2215528,2215547,2215548,2215563,2215564,2215568,
	  2215598,2215614,2215625,2215626,2215635,2215682,2215683,2215692,2215768,2215785,2215798,2215810,2215821,2215823,
	  2215824,2215839,2215850,2215851,2184233,2215861,2215874,2215886,2215895,2215907,2215924,2215936,2215984,2215987,
	  2216014,2216015,2216190,2216196,2223061,2223063,2223085,2223093,2223168,2223218,2242397,2248300,2249304,2313228,
	  2313359,2313367,2313437,2314516,2315037,2316056,2316065,2316067,2316094,2316110,2316174,2316196,2319204,2319937,
	  2319941,2319961,2323781,2328539,2339044,2342849,2344222,2355731,2374254,2379400,2387108,2387109,2387604,
	  2390674,2398109)