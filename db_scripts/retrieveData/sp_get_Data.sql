-- ===============================================
-- Procedure to get training data
-- ===============================================
CREATE OR ALTER PROCEDURE dbo.GetDataToTrainModel
    @LimitDate nvarchar(30),
    @ExcludedList nvarchar(MAX),
    @PriceGroupList nvarchar(30),
    @BuildingsPresent nvarchar(30)
AS
select *
from Fun_GetDataToTrainModel(@LimitDate, @ExcludedList, @PriceGroupList, @BuildingsPresent)
