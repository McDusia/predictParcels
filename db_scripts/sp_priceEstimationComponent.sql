-- =============================================
-- Author:  Joanna Palewicz
-- Create date: 01.09.2018
-- Description: Procedures which needs to be run before running price estimation component
-- =============================================


-- ===============================================
-- Procedure to get training data
-- ===============================================

CREATE OR ALTER PROCEDURE dbo.GetDateToTrainModel
    @LimitDate nvarchar(30),
    @BucketType nvarchar(30),
    @ExcludedList nvarchar(MAX)
AS
SELECT  OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, LAND_Curr_Roll_Yr, LAND_Curr_Value, IMPROVE_Curr_Roll_YR,
        IMPROVE_Curr_Value, SA_House_Number, SA_Zip_Cde, MA_House_Number, MA_Zip_Cde, Recording_Date,
        Hmownr_Exempt_Number, Hmownr_Exempt_Value, LS1_Sale_Date, LS2_Sale_Date, LS3_Sale_Date,
        BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths,
        BD_LINE_1_Sq_Ft_of_Main_Improve, BD_LINE_2_Subpart, BD_LINE_2_Yr_Built, BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms, BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built, BD_LINE_3_No_of_Units, BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve, Current_Land_Base_Year, Current_Improvement_Base_Year,
        Current_Land_Base_Value, Current_Improvement_Base_Value, Cluster_Location, Cluster_Type,
        Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, BD_LINE_1_Year_Changed,
        BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main, BD_LINE_2_Year_Changed, BD_LINE_2_Unit_Cost_Main,
        BD_LINE_2_RCN_Main, BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main, BD_LINE_3_RCN_Main,
        BD_LINE_4_Year_Changed, Landlord_Reappraisal_Year, Landlord_Number_of_Units, Recorders_Document_Number,
        Price_Per_Single_Area_Unit, Parcel_Area, Residential, Special_Purposes_Plan, Agricultural, Commercial,
        Manufacturing, SA_Localization_int, MA_Localization_int, MA_Direction_int, SA_Direction_int, Simple_Zone_int,
        Zoning_Code_int, BD_LINE_1_Quality__Class___Shap_int, City_int, Sale_Amount
FROM PARCEL_VECTORS
WHERE Price_Group_int LIKE @BucketType
      AND LS1_Sale_Date > @LimitDate
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1
GO


-- EXEC dbo.getTrainingDataPriceEstimation @LimitDate = '20150000', @BucketType="cheap", @ExcludedList='0;9'

-- ===============================================
-- Procedure to get training data - without price columns
-- ===============================================

CREATE OR ALTER PROCEDURE dbo.GetDateToTrainModelWithoutPrice
    @LimitDate nvarchar(30),
    @BucketType nvarchar(30),
    @ExcludedList nvarchar(MAX)
AS
SELECT  OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, LAND_Curr_Roll_Yr, IMPROVE_Curr_Roll_YR,
        IMPROVE_Curr_Value, SA_House_Number, SA_Zip_Cde, MA_House_Number, MA_Zip_Cde, Recording_Date,
        Hmownr_Exempt_Number, Hmownr_Exempt_Value, LS1_Sale_Date, LS2_Sale_Date, LS3_Sale_Date,
        BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths,
        BD_LINE_1_Sq_Ft_of_Main_Improve, BD_LINE_2_Subpart, BD_LINE_2_Yr_Built, BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms, BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built, BD_LINE_3_No_of_Units, BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve, Current_Land_Base_Year, Current_Improvement_Base_Year,
        Current_Improvement_Base_Value, Cluster_Location, Cluster_Type,
        Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, BD_LINE_1_Year_Changed,
        BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main, BD_LINE_2_Year_Changed, BD_LINE_2_Unit_Cost_Main,
        BD_LINE_2_RCN_Main, BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main, BD_LINE_3_RCN_Main,
        BD_LINE_4_Year_Changed, Landlord_Reappraisal_Year, Landlord_Number_of_Units, Recorders_Document_Number,
        Parcel_Area, Residential, Special_Purposes_Plan, Agricultural, Commercial,
        Manufacturing, SA_Localization_int, MA_Localization_int, MA_Direction_int, SA_Direction_int, Simple_Zone_int,
        Zoning_Code_int, BD_LINE_1_Quality__Class___Shap_int, City_int, Sale_Amount
FROM PARCEL_VECTORS
WHERE Price_Group_int LIKE @BucketType
      AND LS1_Sale_Date > @LimitDate
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  and Land_Curr_Value not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
	  AND Price_Per_Single_Area_Unit > 1 
GO

-- EXEC dbo.GetDateToTrainModelWithoutPrice @LimitDate = '20150000', @BucketType="cheap", @ExcludedList='0;9'



-- ===============================================
-- Procedure to get data to calculate
-- ===============================================

CREATE OR ALTER PROCEDURE dbo.GetDataToParcelsValuation
    @LimitDate nvarchar(30),
    @BucketType nvarchar(30),
    @ExcludedList nvarchar(MAX)
AS
SELECT  OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, LAND_Curr_Roll_Yr, LAND_Curr_Value, IMPROVE_Curr_Roll_YR,
        IMPROVE_Curr_Value, SA_House_Number, SA_Zip_Cde, MA_House_Number, MA_Zip_Cde, Recording_Date,
        Hmownr_Exempt_Number, Hmownr_Exempt_Value, LS1_Sale_Date, LS2_Sale_Date, LS3_Sale_Date,
        BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths,
        BD_LINE_1_Sq_Ft_of_Main_Improve, BD_LINE_2_Subpart, BD_LINE_2_Yr_Built, BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms, BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built, BD_LINE_3_No_of_Units, BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve, Current_Land_Base_Year, Current_Improvement_Base_Year,
        Current_Land_Base_Value, Current_Improvement_Base_Value, Cluster_Location, Cluster_Type,
        Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, BD_LINE_1_Year_Changed,
        BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main, BD_LINE_2_Year_Changed, BD_LINE_2_Unit_Cost_Main,
        BD_LINE_2_RCN_Main, BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main, BD_LINE_3_RCN_Main,
        BD_LINE_4_Year_Changed, Landlord_Reappraisal_Year, Landlord_Number_of_Units, Recorders_Document_Number,
        Price_Per_Single_Area_Unit, Parcel_Area, Residential, Special_Purposes_Plan, Agricultural, Commercial,
        Manufacturing, SA_Localization_int, MA_Localization_int, MA_Direction_int, SA_Direction_int, Simple_Zone_int,
        Zoning_Code_int, BD_LINE_1_Quality__Class___Shap_int, City_int, Sale_Amount
FROM PARCEL_VECTORS
WHERE Price_Group_int LIKE @BucketType
      AND ( LS1_Sale_Date <= @LimitDate
            AND
            LS1_Sale_Amount NOT IN (SELECT value FROM STRING_SPLIT(@ExcludedList, ';')))
GO

-- =====================================================================
-- Procedure to get data to calculate, but without any price parameters.
-- For data without any sensible price, different model is trained.
-- =====================================================================

CREATE OR ALTER PROCEDURE dbo.GetDataToParcelsValuationWithoutPriceParameters
    @LimitDate nvarchar(30),
    @BucketType nvarchar(30),
    @ExcludedList nvarchar(MAX)
AS
SELECT  OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, LAND_Curr_Roll_Yr, IMPROVE_Curr_Roll_YR,
        IMPROVE_Curr_Value, SA_House_Number, SA_Zip_Cde, MA_House_Number, MA_Zip_Cde, Recording_Date,
        Hmownr_Exempt_Number, Hmownr_Exempt_Value, LS1_Sale_Date, LS2_Sale_Date, LS3_Sale_Date,
        BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths,
        BD_LINE_1_Sq_Ft_of_Main_Improve, BD_LINE_2_Subpart, BD_LINE_2_Yr_Built, BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms, BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built, BD_LINE_3_No_of_Units, BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve, Current_Land_Base_Year, Current_Improvement_Base_Year,
        Current_Improvement_Base_Value, Cluster_Location, Cluster_Type,
        Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, BD_LINE_1_Year_Changed,
        BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main, BD_LINE_2_Year_Changed, BD_LINE_2_Unit_Cost_Main,
        BD_LINE_2_RCN_Main, BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main, BD_LINE_3_RCN_Main,
        BD_LINE_4_Year_Changed, Landlord_Reappraisal_Year, Landlord_Number_of_Units, Recorders_Document_Number,
        Parcel_Area, Residential, Special_Purposes_Plan, Agricultural, Commercial,
        Manufacturing, SA_Localization_int, MA_Localization_int, MA_Direction_int, SA_Direction_int, Simple_Zone_int,
        Zoning_Code_int, BD_LINE_1_Quality__Class___Shap_int, City_int, Sale_Amount
FROM PARCEL_VECTORS
WHERE Price_Group_int LIKE @BucketType
      AND LS1_Sale_Amount IN (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
GO

-- =================================================================================================================
-- View to get results of estimation and to get Simple Zone Code received after run create_Parcel_Vectors.sql script
-- =================================================================================================================

CREATE OR ALTER VIEW Estimated_Prices_and_Simple_Zone_Code_int_VIEW  
AS   
SELECT OBJECTID, Simple_Zone_int,  Estimated_Amount
FROM PARCEL_VECTORS     
GO 

-- ===============================================
-- Procedure to update table with calculated value
-- ===============================================

CREATE OR ALTER PROCEDURE dbo.UpdateEstimated_Amount
    @NEW_Estimated_Amount int,
    @ObjectID int
AS
UPDATE PARCEL_VECTORS
  SET Estimated_Amount = @NEW_Estimated_Amount, Row_Version_Stamp = Row_Version_Stamp + 1
  WHERE OBJECTID = @ObjectID
GO