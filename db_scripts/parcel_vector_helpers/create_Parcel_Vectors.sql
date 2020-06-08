-- =============================================
-- Author:		Magdalena Nowak, Joanna Palewicz
-- Create date: 01.05.2018
-- Description:	Preparation of the table Parcel_Vectors
-- =============================================

-- =============================================
-- CREATE NEW TABLE PARCEL_VECTORS
-- not interested values are dropped
-- =============================================


IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'PARCEL_VECTORS'))
BEGIN
	DROP TABLE PARCEL_VECTORS
END

SELECT  
	OBJECTID, PERIMETER, PARCEL_TYP, TRA_1, 
	Land_Curr_Roll_Yr, Land_Curr_Value, IMPROVE_Curr_Roll_YR, IMPROVE_Curr_Value, 
	SA_House_Number, SA_Direction, SA_Street_Name, SA_City_and_State, SA_Zip_Cde,
	MA_House_Number, MA_Direction, MA_Street_Name, MA_City_and_State, MA_Zip_Cde, 
	Recording_Date, Zoning_Code, Hmownr_Exempt_Number, Hmownr_Exempt_Value, --22
	LS1_Sale_Amount, LS1_Sale_Date,	LS2_Sale_Date,	LS3_Sale_Date,	
	BD_LINE_1_Quality__Class___Shap, BD_LINE_1_Yr_Built, BD_LINE_1_No_of_Units, 
	BD_LINE_1_No_of_Bedrooms, BD_LINE_1_No_of_Baths, BD_LINE_1_Sq_Ft_of_Main_Improve, 
	BD_LINE_2_Subpart, BD_LINE_2_Yr_Built,	BD_LINE_2_No_of_Units,	
	BD_LINE_2_No_of_Bedrooms,	BD_LINE_2_No_of_Baths, BD_LINE_2_Sq_Ft_of_Main_Improve, 
	BD_LINE_3_Subpart,	BD_LINE_3_Yr_Built,	BD_LINE_3_No_of_Units,	--19
	BD_LINE_3_No_of_Bedrooms, BD_LINE_3_No_of_Baths, BD_LINE_3_Sq_Ft_of_Main_Improve,
	Current_Land_Base_Year, Current_Improvement_Base_Year, Current_Land_Base_Value, 
	Current_Improvement_Base_Value, 
	Cluster_Location, Cluster_Type, Cluster_Appraisal_Unit, Document_Transfer_Tax_Sales_Amo, 
	BD_LINE_1_Year_Changed, BD_LINE_1_Unit_Cost_Main, BD_LINE_1_RCN_Main,
	BD_LINE_2_Year_Changed,	BD_LINE_2_Unit_Cost_Main, BD_LINE_2_RCN_Main, 
	BD_LINE_3_Year_Changed, BD_LINE_3_Unit_Cost_Main,BD_LINE_3_RCN_Main,	--20
	BD_LINE_4_Year_Changed,	Landlord_Reappraisal_Year,	Landlord_Number_of_Units,	
	Recorders_Document_Number, Shape, --5,
	CENTER_X, CENTER_Y, CENTER_LAT, CENTER_LON
INTO PARCEL_VECTORS FROM PARCEL;

-- =============================================
-- Add indexes to PARCEL_VECTORS
-- Primary Key on objectID
-- Spatial index on Shape
-- =============================================

ALTER TABLE PARCEL_VECTORS
ADD CONSTRAINT PK_ObjectID PRIMARY KEY CLUSTERED (OBJECTID);  
GO  

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

CREATE SPATIAL INDEX [SP_Shape] ON [dbo].[PARCEL_VECTORS]
(
	[Shape]
)USING  GEOMETRY_AUTO_GRID 
WITH (BOUNDING_BOX =(6275487.79, 1384146.14, 6668480.77, 2122084.6), 
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



-- =============================================
-- Get data from Zoning_Code column
-- Adding and filling new column Simple_Zoning_Code
-- Adding and filling new column City
-- Adding new column Price_Per_Single_Area_Unit 
-- Adding new column Parcel_Area
-- =============================================

IF (NOT EXISTS (select * from information_schema.COLUMNS where TABLE_NAME = 'PARCEL_VECTORS' and COLUMN_NAME = 'Simple_Zoning_Code'))
	BEGIN
		ALTER TABLE PARCEL_VECTORS
			ADD 
				Simple_Zoning_Code NVARCHAR(15), 
				City NVARCHAR(5),
				Price_Per_Single_Area_Unit FLOAT(10),
				Parcel_Area INT
	END
GO

UPDATE PARCEL_VECTORS
  SET City=substring(Zoning_Code,1,2)
GO

-- =============================================
-- Get data from connected to parcel area
-- data from Shape geometry column
-- =============================================

UPDATE PARCEL_VECTORS
  SET Parcel_Area=Shape.STArea()
GO

UPDATE PARCEL_VECTORS
  SET Price_Per_Single_Area_Unit = CAST(LS1_Sale_Amount AS FLOAT(10)) / Parcel_Area
WHERE Parcel_Area != 0
GO

UPDATE PARCEL_VECTORS
  SET Price_Per_Single_Area_Unit=0
WHERE Parcel_Area = 0
GO

-- =============================================
-- ADD NEW COLUMNS FOR BASIC AREAS TYPES
-- =============================================

IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_VECTORS' and COLUMN_NAME = 'Residential'))
BEGIN
	ALTER TABLE PARCEL_VECTORS
  ADD 
	Residential SMALLINT, 
	Special_Purposes_Plan SMALLINT, 
	Agricultural SMALLINT, 
	Commercial SMALLINT,
	Manufacturing SMALLINT,
	Price_Group_int INT
END
GO

-- =============================================
-- Parse Zoning codes
-- RESIDENTIAL
-- R1 - single family residence
-- R2 - two family residence
-- R3 - limited multiple residence
-- =============================================

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code =
    CASE substring(Zoning_Code, 3, 1)
        WHEN 'R' THEN
             CASE substring(Zoning_Code, 4, 1)
                WHEN '1' THEN 'R1'
                WHEN '2' THEN 'R2'
                WHEN '3' THEN 'R3'
				WHEN '4' THEN 'R4'
              END
	END
	WHERE Simple_Zoning_Code IS NULL
GO


-- For SCUR1, SCUR2, SCUR3, SCUR4, SCUR5 
UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = substring(Zoning_Code, 4, 2)
    WHERE Zoning_Code LIKE 'SCUR%'
GO


UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'R2'
	WHERE Zoning_Code LIKE 'LAMR2'
GO

UPDATE PARCEL_VECTORS
    SET Residential = (CASE
                       WHEN Simple_Zoning_code IN ('R1', 'R2', 'R3', 'R4', 'R5') THEN 1 ELSE 0 END)
GO

-- =============================================
-- AGRICULTURAL
-- A1: Light Agriculture
-- A2: Heavy Agriculture, Including Hog Ranches

-- COMMERCIAL
-- C1: Restricted Business
-- C2: Neighborhood Business
-- C3: Unlimited Commercial
-- CM: Commercial Manufacturing
-- CR: Commercial Recreation
-- CPD: Commercial Planned Development

-- MANUFACTURING
-- M1: Light Manufacturing
-- M2 Aircraft Heavy Manufacturing
-- M3: Unclassified
-- =============================================

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code =
    CASE substring(Zoning_Code, 3, 1)
        WHEN 'A' THEN
             CASE substring(Zoning_Code, 4, 1)
                WHEN '1' THEN 'A1'
                WHEN '2' THEN 'A2'
                WHEN '3' THEN 'A3'
              END

        WHEN 'C' THEN
             CASE substring(Zoning_Code, 4, 1)
                WHEN '1' THEN 'C1'
                WHEN '2' THEN 'C2'
                WHEN '3' THEN 'C3'
                WHEN '4' THEN 'C4'
              END

        WHEN 'M' THEN
             CASE substring(Zoning_Code, 4, 1)
                WHEN '1' THEN 'M1'
                WHEN '2' THEN 'M2'
                WHEN '3' THEN 'M3'
              END
    END
WHERE Simple_Zoning_Code IS NULL;


UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'C5'
    WHERE Zoning_Code like 'LAC5';


UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'CM'
    WHERE Zoning_Code like 'LACM';


UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'CR'
    WHERE Zoning_Code like 'LBCR*'
          or Zoning_Code like 'LBCR'
          or Zoning_Code like 'AHCR'
          or Zoning_Code like 'LRCR*';

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'CPD'
    WHERE Zoning_Code like 'CPD';

UPDATE PARCEL_VECTORS
    SET Agricultural = (CASE
                       WHEN Simple_Zoning_code IN ('A1', 'A2', 'A3') THEN 1 ELSE 0 END);

UPDATE PARCEL_VECTORS
    SET Commercial = (CASE
                       WHEN Simple_Zoning_code IN ('C1', 'C2', 'C3', 'C4', 'C5', 'CM', 'CPD', 'CR') THEN 1 ELSE 0 END);

UPDATE PARCEL_VECTORS
    SET Manufacturing = (CASE
                       WHEN Simple_Zoning_code IN ('M1', 'M2', 'M3') THEN 1 ELSE 0 END);

-- =============================================
-- SPECIAL PURPOSE ZONES
-- SP: Specific Plan
-- PR - restricted parking
-- RR - resort and recreation
-- =============================================

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'SP'
    WHERE Zoning_Code like 'PDSP'
          or Zoning_Code like 'PDSP*'
          or Zoning_Code like 'LRSP'
          or Zoning_Code like 'NOSP2*'
		  or Zoning_Code like 'SCSP';

		  
UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'RR'
    WHERE substring(Zoning_Code, 3, 3) like 'RR-';    

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'PR'
    WHERE substring(Zoning_Code, 3, 3) like 'PR-' or Zoning_Code like 'LCPR*' or Zoning_Code like 'POPRD*';


UPDATE PARCEL_VECTORS
    SET Special_Purposes_Plan = (CASE
                       WHEN Simple_Zoning_code IN ('SP', 'RR', 'PR') THEN 1 ELSE 0 END);


-- =============================================
-- OTHER TYPES
-- =============================================

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code =
    CASE Zoning_Code
        WHEN 'GAMUO' THEN 'GAMUO' 
		WHEN 'RBPDR*' THEN 'RBPDR*' 
		WHEN 'PRSF*' THEN 'SF?' 
		WHEN 'LAWC' THEN 'W1' 
		WHEN 'LACW' THEN 'W2' 
		WHEN 'PSC-' THEN 'PSC?'  
		WHEN 'LBPD1' THEN 'PD1?' 
		WHEN 'LAMR1' THEN 'R1'     
	END
WHERE Simple_Zoning_Code is null
GO

UPDATE PARCEL_VECTORS
  SET Simple_Zoning_Code = 'R'
    WHERE Zoning_Code like '__R%'
           and Simple_Zoning_Code is null;

-- =============================================
-- SPECIFY PRICE GROUPS DEPENDS ON THE PRICE
-- =============================================

 UPDATE PARCEL_VECTORS
 SET Price_Group_int = 0
   WHERE LS1_Sale_Amount <= 500000
 UPDATE PARCEL_VECTORS
 SET Price_Group_int = 1
   WHERE ( LS1_Sale_Amount > 500000 and LS1_Sale_Amount < 1000000 )
 UPDATE PARCEL_VECTORS
 SET Price_Group_int = 2
    WHERE LS1_Sale_Amount >= 1000000

-- =============================================
-- STREET and STATE CONCATENATIONS
-- New column to PARCEL_VECTORS to concatenate MA_Street_Name and MA_City_and_State
-- New column to PARCEL_VECTORS to concatenate SA_Street_Name and SA_City_and_State
-- =============================================

ALTER TABLE PARCEL_VECTORS
ADD MA_Street_and_City_and_State nvarchar(100), SA_Street_and_City_and_State nvarchar(100)
GO

UPDATE PARCEL_VECTORS
SET MA_Street_and_City_and_State = MA_Street_Name + ' '+ MA_City_and_State,
	SA_Street_and_City_and_State = SA_Street_Name + ' '+ SA_City_and_State;

-- =============================================
-- TEMP TABLES	TO MAPPING
-- Mapping tables:
-- Simple_Zones_Mapping +
-- Directions_Mapping +
-- Localization_SA_Mapping +
-- Localization_MA_Mapping +
-- Zoning_Codes_Mapping
-- BD_LINE_1_Quality__Class___Shap_Mapping
-- City_Mapping
-- =============================================

--1
---Table to map simple_zone

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Simple_Zones_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END

ELSE
BEGIN
	INSERT INTO Simple_Zones_Mapping (Simple_Zoning_Code)
	SELECT DISTINCT P.Simple_Zoning_Code 
	FROM PARCEL_VECTORS P
	WHERE P.Simple_Zoning_Code not in (
		SELECT DISTINCT P.Simple_Zoning_Code FROM PARCEL_VECTORS P
		inner join Simple_Zones_Mapping L
		ON L.Simple_Zoning_Code = P.Simple_Zoning_Code
	)

END

--2
-- Table to map SA_Direction and MA_Direction
-- only possible values are NULL, W, E, N, S - so this table do not need updates when the data set is growing

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Directions_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END
ELSE
BEGIN
	INSERT INTO Directions_Mapping (Direction)
	SELECT DISTINCT P.SA_Direction 
	FROM PARCEL_VECTORS P
	WHERE P.SA_Direction NOT IN (
	SELECT DISTINCT P.SA_Direction FROM PARCEL_VECTORS P
	INNER JOIN Directions_Mapping D
	ON D.Direction = P.SA_Direction)

	INSERT INTO Directions_Mapping (Direction)
	SELECT DISTINCT P.MA_Direction 
	FROM PARCEL_VECTORS P
	WHERE P.MA_Direction NOT IN (
	SELECT DISTINCT P.MA_Direction FROM PARCEL_VECTORS P
	INNER JOIN Directions_Mapping D
	ON D.Direction = P.MA_Direction
	)
END

--3
-- Table to map SA_Street-and_City-and_State 
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Localization_SA_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END
ELSE
BEGIN
	INSERT INTO Localization_SA_Mapping (SA_Street_and_City_and_State)
	SELECT DISTINCT P.SA_Street_and_City_and_State 
	FROM PARCEL_VECTORS P
	WHERE P.SA_Street_and_City_and_State NOT IN (
	SELECT DISTINCT P.SA_Street_and_City_and_State FROM PARCEL_VECTORS P
	INNER JOIN Localization_SA_Mapping L
	ON L.SA_Street_and_City_and_State = P.SA_Street_and_City_and_State
	)
END

--4
-- Table to map MA_Street-and_City-and_State
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Localization_MA_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END
ELSE
BEGIN
	INSERT INTO Localization_MA_Mapping (MA_Street_and_City_and_State)
	SELECT DISTINCT P.MA_Street_and_City_and_State 
	FROM PARCEL_VECTORS P
	WHERE P.MA_Street_and_City_and_State NOT IN (
	SELECT DISTINCT P.MA_Street_and_City_and_State FROM PARCEL_VECTORS P
	INNER JOIN Localization_MA_Mapping L
	ON L.MA_Street_and_City_and_State = P.MA_Street_and_City_and_State
	)
END

--5
-- Table to map Zoning_Code
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Zoning_Codes_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END
ELSE
BEGIN
	
	INSERT INTO Zoning_Codes_Mapping (Zoning_Code)
	SELECT DISTINCT P.Zoning_Code 
	FROM PARCEL_VECTORS P
	WHERE P.Zoning_Code NOT IN (
	SELECT DISTINCT P.Zoning_Code FROM PARCEL_VECTORS P
	INNER JOIN Zoning_Codes_Mapping L
	ON L.Zoning_Code = P.Zoning_Code
	)
END

--6
-- Table to map BD_LINE_1_Quality
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'BD_LINE_1_Quality__Class___Shap_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END
ELSE
BEGIN

	INSERT INTO BD_LINE_1_Quality__Class___Shap_Mapping (BD_LINE_1_Quality__Class___Shap)
	SELECT DISTINCT P.BD_LINE_1_Quality__Class___Shap 
	FROM PARCEL_VECTORS P
	WHERE P.BD_LINE_1_Quality__Class___Shap NOT IN (
	SELECT DISTINCT P.BD_LINE_1_Quality__Class___Shap FROM PARCEL_VECTORS P
	INNER JOIN BD_LINE_1_Quality__Class___Shap_Mapping M
	ON M.BD_LINE_1_Quality__Class___Shap = P.BD_LINE_1_Quality__Class___Shap
	)
END

--7
-- Table to map City
IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'City_Mapping'))
BEGIN
	PRINT 'FIRSTLY RUN create_mapping_tables SCRIPT'
END
ELSE
BEGIN
	INSERT INTO City_Mapping (City)
	SELECT DISTINCT P.City 
	FROM PARCEL_VECTORS P
	WHERE P.City NOT IN (
	SELECT DISTINCT P.City FROM PARCEL_VECTORS P
	INNER JOIN City_Mapping M
	ON M.City = P.City
	)
END
-- =============================================

ALTER TABLE PARCEL_VECTORS
ADD SA_Localization_int int, 
	MA_Localization_int int, 
	MA_Direction_int int, 
	SA_Direction_int int,
	Simple_Zone_int int,
	Zoning_Code_int int,
	BD_LINE_1_Quality__Class___Shap_int int,
	City_int int
GO

-- Rewriting mapping from mapping tables into Lands_Vector table
--1
UPDATE P SET P.SA_Direction_int = D.Direction_int
FROM PARCEL_VECTORS P
INNER JOIN Directions_Mapping D ON P.SA_Direction = D.Direction
GO

UPDATE PARCEL_VECTORS
SET SA_Direction_int = 1 
WHERE SA_Direction IS NULL
GO

--2
UPDATE P SET P.MA_Direction_int = D.Direction_int
FROM PARCEL_VECTORS P
INNER JOIN Directions_Mapping D ON P.MA_Direction = D.Direction
GO

UPDATE PARCEL_VECTORS
SET MA_Direction_int = 1 
WHERE MA_Direction IS NULL
GO

--3
UPDATE P SET P.Zoning_Code_int = Z.Zoning_Code_int
FROM PARCEL_VECTORS P
INNER JOIN Zoning_Codes_Mapping Z ON P.Zoning_Code = Z.Zoning_Code
GO

-- Zoning Code = NULL -> Zoning_Code_int = 0
UPDATE PARCEL_VECTORS
SET Zoning_Code_int = 0 
WHERE Zoning_Code_int IS NULL
GO

--4
UPDATE P SET P.SA_Localization_int = LM.SA_Street_and_City_and_State_int
FROM PARCEL_VECTORS P
INNER JOIN Localization_SA_Mapping LM ON P.SA_Street_and_City_and_State = LM.SA_Street_and_City_and_State
GO

UPDATE PARCEL_VECTORS
SET SA_Localization_int = 0 
WHERE SA_Localization_int IS NULL
GO

--5
UPDATE P SET P.MA_Localization_int = LM.MA_Street_and_City_and_State_int
FROM PARCEL_VECTORS P
INNER JOIN Localization_MA_Mapping LM ON P.MA_Street_and_City_and_State = LM.MA_Street_and_City_and_State
GO

UPDATE PARCEL_VECTORS
SET MA_Localization_int = 0 
WHERE MA_Localization_int IS NULL
GO

--6
UPDATE P SET P.Simple_Zone_int = S.Simple_Zone_int
FROM PARCEL_VECTORS P
INNER JOIN Simple_Zones_Mapping S ON P.Simple_Zoning_Code = S.Simple_Zoning_Code
GO

UPDATE PARCEL_VECTORS
SET Simple_Zone_int = 1 
WHERE Simple_Zone_int IS NULL
GO

--7
UPDATE P SET P.BD_LINE_1_Quality__Class___Shap_int = M.BD_LINE_1_Quality__Class___Shap_int
FROM PARCEL_VECTORS P
INNER JOIN BD_LINE_1_Quality__Class___Shap_Mapping M ON P.BD_LINE_1_Quality__Class___Shap = M.BD_LINE_1_Quality__Class___Shap
GO

UPDATE PARCEL_VECTORS SET BD_LINE_1_Quality__Class___Shap_int = 0 
WHERE BD_LINE_1_Quality__Class___Shap_int IS NULL
GO

--8
UPDATE P SET P.City_int = C.City_int
FROM PARCEL_VECTORS P
INNER JOIN City_Mapping C ON P.City = C.City
GO

-- City = NULL -> City_int = 0
UPDATE PARCEL_VECTORS
SET City_int = 0 
WHERE City_int IS NULL
GO

-- =============================================
-- Droping columns with string values from Lands_Vectors
-- =============================================
ALTER TABLE PARCEL_VECTORS
DROP COLUMN 
SA_Direction, SA_Street_Name, SA_City_and_State, 
MA_Direction, MA_Street_Name, MA_City_and_State,
Zoning_Code, BD_LINE_1_Quality__Class___Shap,
SA_Street_and_City_and_State, MA_Street_and_City_and_State, City, Simple_Zoning_Code

-- =============================================
-- Move LS1_Sale_Amount column to the end and rename it
-- =============================================

ALTER TABLE PARCEL_VECTORS
ADD Sale_Amount int,
	Estimated_Amount int,
	Row_Version_Stamp int  
GO

UPDATE PARCEL_VECTORS SET Sale_Amount = LS1_Sale_Amount, 
						  Row_Version_Stamp = 0,
						  Estimated_Amount = 0						
GO

-- =============================================
-- Add Zoning Code info in oneHot format
-- =============================================


ALTER TABLE PARCEL_VECTORS
ADD	Simple_Zone_1 int,
	Simple_Zone_2 int,
	Simple_Zone_3 int,
	Simple_Zone_4 int,
	Simple_Zone_5 int,
	Simple_Zone_6 int,
	Simple_Zone_7 int,
	Simple_Zone_8 int,
	Simple_Zone_9 int,
	Simple_Zone_10 int,
	Simple_Zone_11 int,
	Simple_Zone_12 int,
	Simple_Zone_13 int,
	Simple_Zone_14 int,
	Simple_Zone_15 int,
	Simple_Zone_16 int,
	Simple_Zone_17 int,
	Simple_Zone_18 int,
	Simple_Zone_19 int,
	Simple_Zone_20 int,
	Simple_Zone_21 int,
	Simple_Zone_22 int,
	Simple_Zone_23 int,
	Simple_Zone_24 int,
	Simple_Zone_25 int,
	Simple_Zone_26 int,
	Simple_Zone_27 int,
	Simple_Zone_28 int,
	Simple_Zone_29 int,
	Simple_Zone_30 int
GO


UPDATE PARCEL_VECTORS
SET Simple_Zone_1 = 0,
	Simple_Zone_2 = 0,
	Simple_Zone_3 = 0,
    Simple_Zone_4 = 0,
    Simple_Zone_5 = 0,
    Simple_Zone_6 = 0,
    Simple_Zone_7 = 0,
    Simple_Zone_8 = 0,
    Simple_Zone_9 = 0,
    Simple_Zone_10 = 0,
    Simple_Zone_11 = 0,
    Simple_Zone_12 = 0,
    Simple_Zone_13 = 0,
    Simple_Zone_14 = 0,
    Simple_Zone_15 = 0,
    Simple_Zone_16 = 0,
    Simple_Zone_17 = 0,
    Simple_Zone_18 = 0,
    Simple_Zone_19 = 0,
    Simple_Zone_20 = 0,
    Simple_Zone_21 = 0,
    Simple_Zone_22 = 0,
    Simple_Zone_23 = 0,
    Simple_Zone_24 = 0,
    Simple_Zone_25 = 0,
    Simple_Zone_26 = 0,
    Simple_Zone_27 = 0,
    Simple_Zone_28 = 0,
    Simple_Zone_29 = 0,
    Simple_Zone_30 = 0
GO

---
UPDATE PARCEL_VECTORS SET Simple_Zone_1 = 1
WHERE Simple_Zone_int = 1

UPDATE PARCEL_VECTORS SET Simple_Zone_2 = 1
WHERE Simple_Zone_int = 2

UPDATE PARCEL_VECTORS SET Simple_Zone_3 = 1
WHERE Simple_Zone_int = 3

UPDATE PARCEL_VECTORS SET Simple_Zone_4 = 1
WHERE Simple_Zone_int = 4

UPDATE PARCEL_VECTORS SET Simple_Zone_5 = 1
WHERE Simple_Zone_int = 5

UPDATE PARCEL_VECTORS SET Simple_Zone_6 = 1
WHERE Simple_Zone_int = 6

UPDATE PARCEL_VECTORS SET Simple_Zone_7 = 1
WHERE Simple_Zone_int = 7

UPDATE PARCEL_VECTORS SET Simple_Zone_8 = 1
WHERE Simple_Zone_int = 8

UPDATE PARCEL_VECTORS SET Simple_Zone_9 = 1
WHERE Simple_Zone_int = 9

UPDATE PARCEL_VECTORS SET Simple_Zone_10 = 1
WHERE Simple_Zone_int = 10

UPDATE PARCEL_VECTORS SET Simple_Zone_11 = 1
WHERE Simple_Zone_int = 11

UPDATE PARCEL_VECTORS SET Simple_Zone_12 = 1
WHERE Simple_Zone_int = 12

UPDATE PARCEL_VECTORS SET Simple_Zone_13 = 1
WHERE Simple_Zone_int = 13

UPDATE PARCEL_VECTORS SET Simple_Zone_14 = 1
WHERE Simple_Zone_int = 14

UPDATE PARCEL_VECTORS SET Simple_Zone_15 = 1
WHERE Simple_Zone_int = 15

UPDATE PARCEL_VECTORS SET Simple_Zone_16 = 1
WHERE Simple_Zone_int = 16

UPDATE PARCEL_VECTORS SET Simple_Zone_17 = 1
WHERE Simple_Zone_int = 17

UPDATE PARCEL_VECTORS SET Simple_Zone_18 = 1
WHERE Simple_Zone_int = 18

UPDATE PARCEL_VECTORS SET Simple_Zone_19 = 1
WHERE Simple_Zone_int = 19

UPDATE PARCEL_VECTORS SET Simple_Zone_20 = 1
WHERE Simple_Zone_int = 20

UPDATE PARCEL_VECTORS SET Simple_Zone_21 = 1
WHERE Simple_Zone_int = 21

UPDATE PARCEL_VECTORS SET Simple_Zone_22 = 1
WHERE Simple_Zone_int = 22

UPDATE PARCEL_VECTORS SET Simple_Zone_23 = 1
WHERE Simple_Zone_int = 23

UPDATE PARCEL_VECTORS SET Simple_Zone_24 = 1
WHERE Simple_Zone_int = 24

UPDATE PARCEL_VECTORS SET Simple_Zone_25 = 1
WHERE Simple_Zone_int = 25

UPDATE PARCEL_VECTORS SET Simple_Zone_26 = 1
WHERE Simple_Zone_int = 26

UPDATE PARCEL_VECTORS SET Simple_Zone_27 = 1
WHERE Simple_Zone_int = 27

UPDATE PARCEL_VECTORS SET Simple_Zone_28 = 1
WHERE Simple_Zone_int = 28

UPDATE PARCEL_VECTORS SET Simple_Zone_29 = 1
WHERE Simple_Zone_int = 29

UPDATE PARCEL_VECTORS SET Simple_Zone_30 = 1
WHERE Simple_Zone_int = 30


---=============================================
-- Second approach for parcel price groups
--==============================================

ALTER TABLE PARCEL_VECTORS
ADD	Price_Group_int_vol2 int


 UPDATE PARCEL_VECTORS
 SET Price_Group_int_vol2 = 0
   WHERE LS1_Sale_Amount <= 500000

 UPDATE PARCEL_VECTORS
 SET Price_Group_int_vol2 = 1
   WHERE ( LS1_Sale_Amount > 500000 and LS1_Sale_Amount < 1000000 )

 UPDATE PARCEL_VECTORS
 SET Price_Group_int_vol2 = 2
    WHERE LS1_Sale_Amount >= 1000000

UPDATE PARCEL_VECTORS
SET Price_Group_int_vol2 = 3
    WHERE LS1_Sale_Amount >= 1000000



---=========

ALTER table PARCEL_VECTORS
ADD Price_Group_int_second int

UPDATE PARCEL_VECTORS
SET Price_Group_int_second = 0

UPDATE PARCEL_VECTORS
SET Price_Group_int_second = 1
WHERE Sale_Amount > 700000

UPDATE PARCEL_VECTORS
SET Price_Group_int_second = 2
WHERE Sale_Amount > 2000000