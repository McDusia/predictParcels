/****** Script for SelectTopNRows command from SSMS  ******/
/*
1
*/
CREATE TABLE [dbo].[Public_Elementary_Schools] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
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
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
 CONSTRAINT [PK_Public_Elementary_SchoolsObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT Public_Elementary_Schools
    FROM '\data\Public_Elementary_Schools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

ALTER TABLE Public_Elementary_Schools
ADD  POINT geometry;

-- DROP TABLE Public_Elementary_Schools

/*
2
*/
CREATE TABLE [dbo].[Public_Middle_Schools] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[cat1] varchar(50),
[cat2] varchar(50),
[org_name] varchar(50),
[Name] varchar(100),
[addrln1] varchar(50),
[addrln2] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Public_Middle_SchoolsObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Public_Middle_Schools]
    FROM '\data\Public_Middle_Schools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

ALTER TABLE Public_Middle_Schools
ADD POINT geometry;

-- DROP TABLE Public_Middle_Schools

/*
3
*/
CREATE TABLE [dbo].[Public_High_Schools] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
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
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Public_High_SchoolsObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Public_High_Schools]
    FROM '\data\Public_High_Schools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

ALTER TABLE [Public_High_Schools]
ADD POINT geometry;
-- DROP TABLE Public_High_Schools
/*
4
*/
CREATE TABLE [dbo].[Shopping_Centers] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(100),
[post_id] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Shopping_CentersObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Shopping_Centers]
    FROM '\data\Shopping_Centers.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Shopping_Centers]
ADD POINT geometry;
-- DROP TABLE Shopping_Centers

/*
5
*/
CREATE TABLE [dbo].[Health_Centers] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(100),
[addrln1] varchar(50),
[addrln2] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Health_CentersObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Health_Centers]
    FROM '\data\Health_Centers.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Health_Centers]
ADD POINT geometry;
-- DROP TABLE Health_Centers
/*
6
*/
CREATE TABLE [dbo].[Street_Maintenance] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(100),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_StreetMaintenanceObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Street_Maintenance]
    FROM '\data\Street_Maintenance.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Street_Maintenance]
ADD POINT geometry;
-- DROP TABLE Street_Maintenance
/*
7
*/
CREATE TABLE [dbo].[Pools] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_PoolsObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Pools]
    FROM '\data\Pools.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Pools]
ADD POINT geometry;
--DROP TABLE Pools

/*
8
*/
CREATE TABLE [dbo].[Manufacturing] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(100),
[post_id] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_ManufacturingObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Manufacturing]
    FROM '\data\Manufacturing.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Manufacturing]
ADD POINT geometry;
-- DROP TABLE Manufacturing
/*
9
*/
CREATE TABLE [dbo].[Economic_Development] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Economic_DevelopmentObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Economic_Development]
    FROM '\data\Economic_Development.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Economic_Development]
ADD POINT geometry;
--DROP TABLE [Economic_Development]

/*
10
*/
CREATE TABLE [dbo].[Business_Centers] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(100),
[post_id] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Business_CentersObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Business_Centers]
    FROM '\data\Business_Centers.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Business_Centers]
ADD POINT geometry;
-- DROP TABLE Business_Centers
/*
11
*/
CREATE TABLE [dbo].[Agriculture_and_Food] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y] numeric(38, 8) NULL,
[Name] varchar(100),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Agriculture_and_FoodObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


BULK INSERT [Agriculture_and_Food]
    FROM '\data\Agriculture_and_Food.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Agriculture_and_Food]
ADD POINT geometry;
-- DROP TABLE Agriculture_and_Food
/*
12
*/
CREATE TABLE [dbo].[500Year_Flood_Plain] (
[OBJECTID] int unique NOT NULL,
[DFIRM_ID] varchar(50),
[FLD_AR_ID] varchar(50),
[DUAL_ZONE] varchar(10),
[SOURCE_CIT] varchar(50),
[ShapeSTArea] varchar(50),
[ShapeSTLength] varchar(50),
CONSTRAINT [PK_500Year_Flood_PlainObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [500Year_Flood_Plain]
    FROM '\data\500Year_Flood_Plain.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
-- DROP TABLE [500Year_Flood_Plain]
/*
13
*/
CREATE TABLE [dbo].[Health_Clinics] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y]	numeric(38, 8) NULL,
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[description] varchar(500),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Health_ClinicsObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Health_Clinics]
    FROM '\data\Health_Clinics.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Health_Clinics]
ADD POINT geometry;
-- DROP TABLE [Health_Clinics]

/*
14
*/
CREATE TABLE [dbo].[Natural_Areas_and_Wildlife_Sanctuaries] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y]	numeric(38, 8) NULL,
[org_name] varchar(100),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[description] varchar(500),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Natural_Areas_and_Wildlife_SanctuariesObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Natural_Areas_and_Wildlife_Sanctuaries]
    FROM '\data\Natural_Areas_and_Wildlife_Sanctuaries.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Natural_Areas_and_Wildlife_Sanctuaries]
ADD POINT geometry;
-- DROP TABLE [Natural_Areas_and_Wildlife_Sanctuaries]

/*
15
*/
CREATE TABLE [dbo].[Child_Care] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y]	numeric(38, 8) NULL,
[org_name] varchar(100),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[description] varchar(500),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Child_CareObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Child_Care]
    FROM '\data\Child_Care.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Child_Care]
ADD POINT geometry;
-- DROP TABLE [Child_Care]

/*
16
*/
CREATE TABLE [dbo].[Crime_Prevention_and_Support] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y]	numeric(38, 8) NULL,
[post_id] varchar(50),
[Name] varchar(200),
[description] varchar(500),
[addrln1] varchar(50),
[city] varchar(50),
[zip] varchar(50),
[org_name] varchar(100),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_Crime_Prevention_and_SupportObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Crime_Prevention_and_Support]
    FROM '\data\Crime_Prevention_and_Support.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Crime_Prevention_and_Support]
ADD POINT geometry;
-- DROP TABLE [Crime_Prevention_and_Support]

/*
17
*/
CREATE TABLE [dbo].[Lakes_Simpler_Hydrology] (
[OBJECTID] int unique NOT NULL,
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
[InLA] varchar(10),
CONSTRAINT [PK_Lakes_Simpler_HydrologyObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Lakes_Simpler_Hydrology]
    FROM '\data\Lakes_Simpler_Hydrology.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- DROP TABLE [Lakes_Simpler_Hydrology]

/*
18
*/
CREATE TABLE [dbo].[Water] (
[OBJECTID] int unique NOT NULL,
[X] numeric(38, 8) NULL,
[Y]	numeric(38, 8) NULL,
[org_name] varchar(100),
[Name] varchar(200),
[addrln1] varchar(50),
[city] varchar(50),
[post_id] varchar(50),
[zip] varchar(50),
[latitude] numeric(38, 8) NULL,
[longitude] numeric(38, 8) NULL,
[POINT_X] numeric(38, 8) NULL,
[POINT_Y] numeric(38, 8) NULL,
CONSTRAINT [PK_WaterObjectID] PRIMARY KEY CLUSTERED
(
	[OBJECTID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

BULK INSERT [Water]
    FROM '\data\Water.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO
ALTER TABLE [Water]
ADD POINT geometry;
-- DROP TABLE [Water]
