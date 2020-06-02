-- Load new parameters from csv file

-- Load data to temporary table
CREATE TABLE [dbo].[PARCEL_VECTORSNewParameters] (
	[OBJECTID] int unique NOT NULL,
	DistanceToElementarySchool numeric(38,8) null, 
	DistanceToMiddleSchool numeric(38,8) null, 
	DistanceToHighSchool numeric(38,8) null, 
	DistanceToShopping_Centers numeric(38,8) null, 
	DistanceToHealth_Centers numeric(38,8) null, 
	DistanceToStreet_Maintenance numeric(38,8) null, 
	DistanceToPools numeric(38,8) null, 
	DistanceToManufacturing numeric(38,8) null, 
	DistanceToEconomic_Development numeric(38,8) null, 
	DistanceToBusiness_Centers numeric(38,8) null, 
	DistanceToAgriculture_and_Food numeric(38,8) null,
	DistanceToHealth_Clinics numeric(38,8) null,
	DistanceToNatural_Areas_and_Wildlife_Sanctuaries numeric(38,8) null, 
	DistanceToChild_Care numeric(38,8) null, 
	DistanceToCrime_Prevention_and_Support numeric(38,8) null, 
	DistanceToWater numeric(38,8) null,
	DistanceToAirport numeric(38,8) null,
	DistanceToRiver numeric(38,8) null,
	DistanceToRailroads numeric(38,8) null
	/*,ElementarySchoolsInNeighbourhood integer null, 
	MiddleSchoolInNeighbourhood integer null, 
	HighSchoolInNeighbourhood integer null, 
	Shopping_CentersInNeighbourhood integer null, 
	Health_CentersInNeighbourhood integer null, 
	Street_MaintenanceInNeighbourhood integer null, 
	PoolsInNeighbourhood integer null, 
	ManufacturingInNeighbourhood integer null, 
	Economic_DevelopmentInNeighbourhood integer null, 
	Business_CentersInNeighbourhood integer null, 
	Agriculture_and_FoodInNeighbourhood integer null, 
	Health_ClinicsInNeighbourhood integer null, 
	Natural_Areas_and_Wildlife_SanctuariesInNeighbourhood integer null, 
	Child_CareInNeighbourhood integer null, 
	Crime_Prevention_and_SupportInNeighbourhood integer null, 
	WaterInNeighbourhood integer null, 
	AirportInNeighbourhood integer null, 
	RiverInNeighbourhood integer null, 
	RailroadsInNeighbourhood integer null*/
)


BULK INSERT [PARCEL_VECTORSNewParameters]
    FROM '\data\PARCEL_VECTORSNewParameters_Part1_Vol2.csv'	-- Here change path
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  -- CSV field delimiter
    ROWTERMINATOR = '\n',
    ERRORFILE = '\data\ep_errors.txt',	-- Here change path
    TABLOCK
    )
GO

-- Add new columns to PARCEL_VECTORS
ALTER TABLE PARCEL_VECTORS
ADD DistanceToElementarySchool numeric(38,8) null, 
	DistanceToMiddleSchool numeric(38,8) null, 
	DistanceToHighSchool numeric(38,8) null, 
	DistanceToShopping_Centers numeric(38,8) null, 
	DistanceToHealth_Centers numeric(38,8) null, 
	DistanceToStreet_Maintenance numeric(38,8) null, 
	DistanceToPools numeric(38,8) null, 
	DistanceToManufacturing numeric(38,8) null, 
	DistanceToEconomic_Development numeric(38,8) null, 
	DistanceToBusiness_Centers numeric(38,8) null, 
	DistanceToAgriculture_and_Food numeric(38,8) null,
	DistanceToHealth_Clinics numeric(38,8) null,
	DistanceToNatural_Areas_and_Wildlife_Sanctuaries numeric(38,8) null, 
	DistanceToChild_Care numeric(38,8) null, 
	DistanceToCrime_Prevention_and_Support numeric(38,8) null, 
	DistanceToWater numeric(38,8) null,
	DistanceToAirport numeric(38,8) null,
	DistanceToRiver numeric(38,8) null,
	DistanceToRailroads numeric(38,8) null,
	ElementarySchoolsInNeighbourhood integer null, 
	MiddleSchoolInNeighbourhood integer null, 
	HighSchoolInNeighbourhood integer null, 
	Shopping_CentersInNeighbourhood integer null, 
	Health_CentersInNeighbourhood integer null, 
	Street_MaintenanceInNeighbourhood integer null, 
	PoolsInNeighbourhood integer null, 
	ManufacturingInNeighbourhood integer null, 
	Economic_DevelopmentInNeighbourhood integer null, 
	Business_CentersInNeighbourhood integer null, 
	Agriculture_and_FoodInNeighbourhood integer null, 
	Health_ClinicsInNeighbourhood integer null, 
	Natural_Areas_and_Wildlife_SanctuariesInNeighbourhood integer null, 
	Child_CareInNeighbourhood integer null, 
	Crime_Prevention_and_SupportInNeighbourhood integer null, 
	WaterInNeighbourhood integer null, 
	AirportInNeighbourhood integer null, 
	RiverInNeighbourhood integer null, 
	RailroadsInNeighbourhood integer null

-- TODO !!!CHECK THIS PROCEDURE!!!
-- Copy new parameters from PARCEL_VECTORSNewParameters to PARCEL_VECTORS
	UPDATE PV SET
	
		PV.DistanceToElementarySchool = PVNP.DistanceToElementarySchool,
		PV.DistanceToMiddleSchool = PVNP.DistanceToMiddleSchool,
		PV.DistanceToHighSchool = PVNP.DistanceToHighSchool,
		PV.DistanceToShopping_Centers = PVNP.DistanceToShopping_Centers,
		PV.DistanceToHealth_Centers = PVNP.DistanceToHealth_Centers,
		PV.DistanceToStreet_Maintenance = PVNP.DistanceToStreet_Maintenance,
		PV.DistanceToPools = PVNP.DistanceToPools,
		PV.DistanceToManufacturing = PVNP.DistanceToManufacturing,
		PV.DistanceToEconomic_Development =  PVNP.DistanceToEconomic_Development,
		PV.DistanceToBusiness_Centers = PVNP.DistanceToBusiness_Centers,
		PV.DistanceToAgriculture_and_Food = PVNP.DistanceToAgriculture_and_Food,
		PV.DistanceToHealth_Clinics = PVNP.DistanceToHealth_Clinics,
		PV.DistanceToNatural_Areas_and_Wildlife_Sanctuaries = PVNP.DistanceToNatural_Areas_and_Wildlife_Sanctuaries,
		PV.DistanceToChild_Care = PVNP.DistanceToChild_Care,
		PV.DistanceToCrime_Prevention_and_Support = PVNP.DistanceToCrime_Prevention_and_Support,
		PV.DistanceToWater = PVNP.DistanceToWater,
		PV.DistanceToAirport = PVNP.DistanceToAirport,
		PV.DistanceToRiver = PVNP.DistanceToRiver,
		PV.DistanceToRailroads = PVNP.DistanceToRailroads
	FROM PARCEL_VECTORS as PV
	INNER JOIN PARCEL_VECTORSNewParameters PVNP
		ON PVNP.OBJECTID = PV.OBJECTID