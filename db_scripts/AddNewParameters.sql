exec CreateGeometryPoint @TableName='Public_Elementary_Schools'
exec CreateGeometryPoint @TableName='Public_Middle_Schools'
exec CreateGeometryPoint @TableName='Public_High_Schools'
exec CreateGeometryPoint @TableName='Shopping_Centers'
exec CreateGeometryPoint @TableName='Health_Centers'
exec CreateGeometryPoint @TableName='Street_Maintenance'
exec CreateGeometryPoint @TableName='Pools'
exec CreateGeometryPoint @TableName='Manufacturing'
exec CreateGeometryPoint @TableName='Economic_Development'
exec CreateGeometryPoint @TableName='Business_Centers'
exec CreateGeometryPoint @TableName='Agriculture_and_Food'
exec CreateGeometryPoint @TableName='Health_Clinics'
exec CreateGeometryPoint @TableName='Natural_Areas_and_Wildlife_Sanctuaries'
exec CreateGeometryPoint @TableName='Child_Care'
exec CreateGeometryPoint @TableName='Crime_Prevention_and_Support'
exec CreateGeometryPoint @TableName='Water'

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
	DistanceToRailroads numeric(38,8) null


	-- Count Distance to Public Elementary Schools
	exec CountDistancesFromParcelsToObject @TableName = 'Public_Elementary_Schools',
	@ColumnInParcelVectorsToUpdate = 'DistanceToElementarySchool',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Public Middle Schools
	exec CountDistancesFromParcelsToObject @TableName = 'Public_Middle_Schools',
	@ColumnInParcelVectorsToUpdate = 'DistanceToMiddleSchool',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Public High Schools
	exec CountDistancesFromParcelsToObject @TableName = 'Public_High_Schools',
	@ColumnInParcelVectorsToUpdate = 'DistanceToHighSchool',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Shopping_Centers
	exec CountDistancesFromParcelsToObject @TableName = 'Shopping_Centers',
	@ColumnInParcelVectorsToUpdate = 'DistanceToShopping_Centers',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Health_Centers
	exec CountDistancesFromParcelsToObject @TableName = 'Health_Centers',
	@ColumnInParcelVectorsToUpdate = 'DistanceToHealth_Centers',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Street_Maintenance
	exec CountDistancesFromParcelsToObject @TableName = 'Street_Maintenance',
	@ColumnInParcelVectorsToUpdate = 'DistanceToStreet_Maintenance',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Pools
	exec CountDistancesFromParcelsToObject @TableName = 'Pools',
	@ColumnInParcelVectorsToUpdate = 'DistanceToPools',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Manufacturing
	exec CountDistancesFromParcelsToObject @TableName = 'Manufacturing',
	@ColumnInParcelVectorsToUpdate = 'DistanceManufacturing',
	@index_start = 0,
	@index_stop = 2400375
	   
	-- Count Distance to Economic_Development
	exec CountDistancesFromParcelsToObject @TableName = 'Economic_Development',
	@ColumnInParcelVectorsToUpdate = 'DistanceToEconomic_Development',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Business_Centers
	exec CountDistancesFromParcelsToObject @TableName = 'Business_Centers',
	@ColumnInParcelVectorsToUpdate = 'DistanceToBusiness_Centers',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Agriculture_and_Food
	exec CountDistancesFromParcelsToObject @TableName = 'Agriculture_and_Food',
	@ColumnInParcelVectorsToUpdate = 'DistanceToAgriculture_and_Food',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Health_Clinics
	exec CountDistancesFromParcelsToObject @TableName = 'Health_Clinics',
	@ColumnInParcelVectorsToUpdate = 'DistanceToHealth_Clinics',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to DistanceToNatural_Areas_and_Wildlife_Sanctuaries
	exec CountDistancesFromParcelsToObject @TableName = 'Natural_Areas_and_Wildlife_Sanctuaries',
	@ColumnInParcelVectorsToUpdate = 'DistanceToNatural_Areas_and_Wildlife_Sanctuaries',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Child_Care

	exec CountDistancesFromParcelsToObject @TableName = 'Child_Care',
	@ColumnInParcelVectorsToUpdate = 'DistanceToChild_Care',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to DistanceToCrime_Prevention_and_Support

	exec CountDistancesFromParcelsToObject @TableName = 'Crime_Prevention_and_Support',
	@ColumnInParcelVectorsToUpdate = 'DistanceToCrime_Prevention_and_Support',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Water
	exec CountDistancesFromParcelsToObject @TableName = 'Water',
	@ColumnInParcelVectorsToUpdate = 'DistanceToWater',
	@index_start = 0,
	@index_stop = 2400375

	-- Count Distance to Airport
	update PARCEL_VECTORS set DistanceToAirport = 
	(
		SELECT TOP 1 
		([LosAngelesCounty].[dbo].[AIRPORTS].shape).STDistance([LosAngelesParcels].[dbo].[PARCEL_VECTORS].shape) 
		AS Distance
		FROM [LosAngelesCounty].[dbo].[AIRPORTS]
		ORDER BY ([LosAngelesCounty].[dbo].[AIRPORTS].shape).STDistance([LosAngelesParcels].[dbo].[PARCEL_VECTORS].shape) ASC
	) 
	where OBJECTID BETWEEN CONVERT(varchar, 0) AND CONVERT(varchar, 2400375)

		-- Count Distance to River
	update PARCEL_VECTORS set DistanceToRiver = 
	(
		SELECT TOP 1 
		([LosAngelesCounty].[dbo].[RIVERS].shape).STDistance([LosAngelesParcels].[dbo].[PARCEL_VECTORS].shape) 
		AS Distance
		FROM [LosAngelesCounty].[dbo].[RIVERS]
		ORDER BY ([LosAngelesCounty].[dbo].[RIVERS].shape).STDistance([LosAngelesParcels].[dbo].[PARCEL_VECTORS].shape) ASC
	) 
	where OBJECTID BETWEEN CONVERT(varchar, 0) AND CONVERT(varchar, 2400375)

		-- Count Distance to Railroads
	update PARCEL_VECTORS set DistanceToRailroads = 
	(
		SELECT TOP 1 
		([LosAngelesCounty].[dbo].[Railroads].shape).STDistance([LosAngelesParcels].[dbo].[PARCEL_VECTORS].shape) 
		AS Distance
		FROM [LosAngelesCounty].[dbo].[Railroads]
		ORDER BY ([LosAngelesCounty].[dbo].[Railroads].shape).STDistance([LosAngelesParcels].[dbo].[PARCEL_VECTORS].shape) ASC
	) 
	where OBJECTID BETWEEN CONVERT(varchar, 0) AND CONVERT(varchar, 2400375)

-- Count how many POI are in specified distance from parcel
	
ALTER TABLE PARCEL_VECTORS
ADD ElementarySchoolsInNeighbourhood integer null, 
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

update PARCEL_VECTORS set
ElementarySchoolsInNeighbourhood = 
(
	SELECT
	Count(*) AS Quantity
	FROM
	Public_Elementary_Schools PES

	WHERE
	PES.POINT.Filter(shape.STBuffer(25000)) = 1	-- 7620.01524 meters
)
where OBJECTID < 10