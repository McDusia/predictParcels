-------------------		MAPPING TABLES	-------------

--Simple_Zones_Mapping +
--Directions_Mapping +
--Localization_SA_Mapping +
--Localization_MA_Mapping +
--Zoning_Codes_Mapping
--BD_LINE_1_Quality__Class___Shap_Mapping
--City_Mapping


--1
---Table to map simple_zone

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Simple_Zones_Mapping'))
BEGIN
	CREATE TABLE Simple_Zones_Mapping	(
		Simple_Zoning_Code nvarchar(15),
		Simple_Zone_int int IDENTITY(1,1) NOT NULL
	)
END


--2
----Table to map SA_Direction and MA_Direction---

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Directions_Mapping'))
BEGIN
	
	CREATE TABLE Directions_Mapping	(
		Direction nvarchar(1),
		Direction_int int IDENTITY(1,1) NOT NULL
	)


END


--3
----Table to map SA_Street-and_City-and_State---

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Localization_SA_Mapping'))
BEGIN
	CREATE TABLE Localization_SA_Mapping	(
		SA_Street_and_City_and_State nvarchar(100),
		SA_Street_and_City_and_State_int int IDENTITY(1,1) NOT NULL
	)
END


--4
----Table to map MA_Street-and_City-and_State---

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Localization_MA_Mapping'))
BEGIN
	CREATE TABLE Localization_MA_Mapping	(
		MA_Street_and_City_and_State nvarchar(100),
		MA_Street_and_City_and_State_int int IDENTITY(1,1) NOT NULL
	)
END


--5
----Table to map Zoning_Code---

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'Zoning_Codes_Mapping'))
BEGIN
	CREATE TABLE Zoning_Codes_Mapping	(
		Zoning_Code nvarchar(15),
		Zoning_Code_int int IDENTITY(1,1) NOT NULL
	)
END


--6
----Table to map BD_LINE_1_Quality__Class___Shap_Mapping---

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'BD_LINE_1_Quality__Class___Shap_Mapping'))
BEGIN
	CREATE TABLE BD_LINE_1_Quality__Class___Shap_Mapping	(
		BD_LINE_1_Quality__Class___Shap nvarchar(5),
		BD_LINE_1_Quality__Class___Shap_int int IDENTITY(1,1) NOT NULL
	)
END


--7
----Table to map City---

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'City_Mapping'))
BEGIN
	CREATE TABLE City_Mapping	(
		City nvarchar(5),
		City_int int IDENTITY(1,1) NOT NULL
	)
END