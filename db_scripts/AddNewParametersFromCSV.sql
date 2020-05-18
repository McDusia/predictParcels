-- Load new parameters from csv file

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

