-- ======================================================
-- Procedure to get training data with distances values
-- ======================================================
CREATE OR ALTER PROCEDURE dbo.GetDataToTrainModelWithDistances
    @LimitDate nvarchar(30),
    @ExcludedList nvarchar(MAX),
    @PriceGroupList nvarchar(30),
    @BuildingsPresent nvarchar(30)
AS
select
		BasicData.*,
		DistanceToElementarySchool,
        DistanceToMiddleSchool,
        DistanceToHighSchool,
        DistanceToShopping_Centers,
        DistanceToHealth_Centers,
        DistanceToStreet_Maintenance,
        DistanceToPools,
        DistanceToManufacturing,
        DistanceToEconomic_Development,
        DistanceToBusiness_Centers,
        DistanceToAgriculture_and_Food,
        DistanceToHealth_Clinics,
        DistanceToNatural_Areas_and_Wildlife_Sanctuaries,
        DistanceToChild_Care,
        DistanceToCrime_Prevention_and_Support,
        DistanceToWater,
        DistanceToAirport,
        DistanceToRiver,
        DistanceToRailroads
from Fun_GetDataToTrainModel(@LimitDate, @ExcludedList, @PriceGroupList, @BuildingsPresent) as BasicData
inner join PARCEL_VECTORS PV ON PV.OBJECTID = BasicData.OBJECTID
