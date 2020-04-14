/****** Script for SelectTopNRows command from SSMS  ******/
/*
1
*/
CREATE TABLE [dbo].[Public_Elementary_Schools] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[cat1] varchar(50),
[cat2] varchar(50),
[cat3] varchar(50),
[org_name] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[addrln2] varchar(50),
[city] varchar(50),
[state] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[use_type] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)

GO


BULK INSERT Public_Elementary_Schools
    FROM 'C:\Users\magda\Downloads\Public_Elementary_Schools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
2
*/
CREATE TABLE [dbo].[Public_Middle_Schools] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[cat1] varchar(50),
[cat2] varchar(50),
[org_name] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[addrln2] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)

GO


BULK INSERT [Public_Middle_Schools]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Public_Middle_Schools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
3
*/
CREATE TABLE [dbo].[Public_High_Schools] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[cat1] varchar(50),
[cat2] varchar(50),
[cat3] varchar(50),
[org_name] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[addrln2] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Public_High_Schools]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Public_High_Schools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
4
*/
CREATE TABLE [dbo].[Shopping_Centers] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(100),
[post_id] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Shopping_Centers]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Shopping_Centers.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
5
*/
CREATE TABLE [dbo].[Health_Centers] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[addrln2] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Health_Centers]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Health_Centers.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
6
*/
CREATE TABLE [dbo].[Street_Maintenance] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Street_Maintenance]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\Street_Maintenance.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
7
*/
CREATE TABLE [dbo].[Pools] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Pools]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\Pools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

--DROP TABLE Pools

/*
8
*/
CREATE TABLE [dbo].[Manufacturing] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(100),
[post_id] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Manufacturing]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\Manufacturing.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
9
*/
CREATE TABLE [dbo].[Economic_Development] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Economic_Development]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\Economic_Development.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
--DROP TABLE [Economic_Development]

/*
10
*/
CREATE TABLE [dbo].[Business_Centers] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(100),
[post_id] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Business_Centers]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\Business_Centers.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
11
*/
CREATE TABLE [dbo].[Agriculture_and_Food] (
[OBJECTID] int unique,
[X] varchar(50),
[Y] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO

BULK INSERT [Agriculture_and_Food]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\Agriculture_and_Food.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
12
*/
CREATE TABLE [dbo].[500Year_Flood_Plain] (
[OBJECTID] int unique,							
[DFIRM_ID] varchar(50),
[FLD_AR_ID] varchar(50),
[DUAL_ZONE] varchar(10),
[SOURCE_CIT] varchar(50),
[ShapeSTArea] varchar(50),
[ShapeSTLength] varchar(50)
)
GO


BULK INSERT [500Year_Flood_Plain]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\Prepared\500Year_Flood_Plain.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

/*
13
*/
CREATE TABLE [dbo].[Health_Clinics] (
[OBJECTID] int unique,
[X] varchar(50),
[Y]	varchar(50),						
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[description] varchar(500),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO


BULK INSERT [Health_Clinics]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\TODO\Health_Clinics.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Health_Clinics]

/*
14
*/
CREATE TABLE [dbo].[Natural_Areas_and_Wildlife_Sanctuaries] (
[OBJECTID] int unique,
[X] varchar(50),
[Y]	varchar(50),	
[org_name] varchar(100),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[description] varchar(500),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO


BULK INSERT [Natural_Areas_and_Wildlife_Sanctuaries]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\TODO\Natural_Areas_and_Wildlife_Sanctuaries.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Natural_Areas_and_Wildlife_Sanctuaries]

/*
15
*/
CREATE TABLE [dbo].[Child_Care] (
[OBJECTID] int unique,
[X] varchar(50),
[Y]	varchar(50),	
[org_name] varchar(100),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[description] varchar(500),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO


BULK INSERT [Child_Care]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\TODO\Child_Care.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Child_Care]

/*
16
*/
CREATE TABLE [dbo].[Crime_Prevention_and_Support] (
[OBJECTID] int unique,
[X] varchar(50),
[Y]	varchar(50),	
[post_id] varchar(50),
[Name] varchar(200),
[description] varchar(500),
[addrln1] varchar(50),
[city] varchar(50),
[zip] varchar(50),
[org_name] varchar(100),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO


BULK INSERT [Crime_Prevention_and_Support]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\TODO\Crime_Prevention_and_Support.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Crime_Prevention_and_Support]

/*
17
*/
CREATE TABLE [dbo].[Lakes_Simpler_Hydrology] (
[OBJECTID] int unique,
[COMID]	int,
[PERMANENT_] int,
[AREASQKM] varchar(50),
[REACHCODE]	varchar(50),	
[FTYPE] int,
[FCODE] int,
[OBJECTID_1] int,
[descriptio] varchar(500),
[HYDROGRAPH] varchar(50),
[Shapearea] varchar(50),
[Shapelen] varchar(50),
[InLA] varchar(10)
)
GO


BULK INSERT [Lakes_Simpler_Hydrology]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\TODO\Lakes_Simpler_Hydrology.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Lakes_Simpler_Hydrology]

/*
18
*/
CREATE TABLE [dbo].[Water] (
[OBJECTID] int unique,
[X] varchar(50),
[Y]	varchar(50),	
[org_name] varchar(100),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] varchar(50),
[longitude] varchar(50),
[POINT_X] varchar(50),
[POINT_Y] varchar(50)
)
GO


BULK INSERT [Water]
    FROM 'C:\Magdalena\MAGISTERKA\new_data_csv\TODO\Water.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = 'C:\Magdalena\MAGISTERKA\new_data_csv\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Water]
