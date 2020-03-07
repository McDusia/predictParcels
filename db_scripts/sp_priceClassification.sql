-- =============================================
-- Author:  Joanna Palewicz
-- Create date: 01.09.2018
-- Description: Procedures to created before running the price estimation component
-- =============================================

-- ===============================================
-- Procedure to get training data
-- ===============================================

CREATE PROCEDURE [dbo].[GetDataToTrainClassificationModel]
    @LimitDate nvarchar(8),
    @ExcludedList nvarchar(MAX)
AS
SELECT OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, LAND_Curr_Roll_Yr,
 IMPROVE_Curr_Roll_YR,
		MA_House_Number, MA_Zip_Cde, Recording_Date,
        Hmownr_Exempt_Number, Hmownr_Exempt_Value,
        BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths,
        BD_LINE_1_Sq_Ft_of_Main_Improve, BD_LINE_2_Subpart, BD_LINE_2_Yr_Built, BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms, BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built, BD_LINE_3_No_of_Units, BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve,
		Cluster_Location, Cluster_Type,
        Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, BD_LINE_1_Year_Changed,
        BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main, BD_LINE_2_Year_Changed, BD_LINE_2_Unit_Cost_Main,
        BD_LINE_2_RCN_Main, BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main, BD_LINE_3_RCN_Main,
        BD_LINE_4_Year_Changed, Landlord_Reappraisal_Year, Landlord_Number_of_Units, Recorders_Document_Number,
		 Parcel_Area, Residential, Special_Purposes_Plan, Agricultural, Commercial,
        Manufacturing, SA_Localization_int, MA_Localization_int, MA_Direction_int, SA_Direction_int, Simple_Zone_int,
        Zoning_Code_int, BD_LINE_1_Quality__Class___Shap_int, City_int, Sale_Amount, Price_Group_int
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date > @LimitDate
      AND LS1_Sale_Amount not in (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
GO


-- EXEC dbo.GetDateToTrainClassificationModel @LimitDate = '20150000', @list='0;9'

-- ============================================================================
-- Procedure to get minimum an maximum object ID for parcels to calculate price
-- ============================================================================


CREATE PROCEDURE dbo.GetMinimumAndMaxumimObjectID_ParcelVectors
    @LimitDate nvarchar(30),
    @ExcludedList nvarchar(MAX)
AS
SELECT min(OBJECTID) 'MinimumObjectID', max(OBJECTID) as 'MaximumObjectID'
FROM PARCEL_VECTORS
WHERE LS1_Sale_Date <= @LimitDate
      AND
      LS1_Sale_Amount IN (SELECT value FROM STRING_SPLIT(@ExcludedList, ';'))
GO


-- =======================================================
-- Procedure to get data to calculate price group for them
-- =======================================================

CREATE PROCEDURE [dbo].[GetDataToParcelClassification]
    @LimitDate nvarchar(30),
    @ExcludedList nvarchar(MAX),
    @ObjectIdMin int,
    @ObjectIdMax int
AS
SELECT  OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, LAND_Curr_Roll_Yr,
 IMPROVE_Curr_Roll_YR,
		MA_House_Number, MA_Zip_Cde, Recording_Date,
        Hmownr_Exempt_Number, Hmownr_Exempt_Value, --LS1_Sale_Date, LS2_Sale_Date, LS3_Sale_Date,
        BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths,
        BD_LINE_1_Sq_Ft_of_Main_Improve, BD_LINE_2_Subpart, BD_LINE_2_Yr_Built, BD_LINE_2_No_of_Units,
        BD_LINE_2_No_of_Bedrooms, BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, BD_LINE_3_Subpart,
        BD_LINE_3_Yr_Built, BD_LINE_3_No_of_Units, BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths,
        BD_LINE_3_Sq_Ft_of_Main_Improve,
		Cluster_Location, Cluster_Type,
        Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, BD_LINE_1_Year_Changed,
        BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main, BD_LINE_2_Year_Changed, BD_LINE_2_Unit_Cost_Main,
        BD_LINE_2_RCN_Main, BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main, BD_LINE_3_RCN_Main,
        BD_LINE_4_Year_Changed, Landlord_Reappraisal_Year, Landlord_Number_of_Units, Recorders_Document_Number,
		 Parcel_Area, Residential, Special_Purposes_Plan, Agricultural, Commercial,
        Manufacturing, SA_Localization_int, MA_Localization_int, MA_Direction_int, SA_Direction_int, Simple_Zone_int,
        Zoning_Code_int, BD_LINE_1_Quality__Class___Shap_int, City_int, Sale_Amount, Price_Group_int
FROM PARCEL_VECTORS
WHERE @ObjectIdMin <= OBJECTID AND OBJECTID < @ObjectIdMax
      AND ( LS1_Sale_Date <= @LimitDate
            OR
            LS1_Sale_Amount IN (SELECT value FROM STRING_SPLIT(@ExcludedList, ';')))
GO



-- ===============================================
-- Procedure to update table with new value
-- ===============================================
CREATE PROCEDURE dbo.UpdateEstimatedPriceCategoryGroup
    @NEW_Estimated_Price_Group varchar(20),
    @ObjectID int
AS
SET NOCOUNT ON;
UPDATE PARCEL_VECTORS
  SET Price_Group_int = @NEW_Estimated_Price_Group, Row_Version_Stamp = Row_Version_Stamp + 1
  WHERE OBJECTID = @ObjectID
GO