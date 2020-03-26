/****** Script for SelectTopNRows command from SSMS  ******/
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
