SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Magdalena Nowak
-- Create date: 17.04.2020
-- Description:	Procedure to get distance ( in foots) from object in table specified in parameters
-- =============================================
CREATE OR ALTER PROCEDURE CountDistancesFromParcelsToObject
	@TableName varchar(100),
	@ColumnInParcelVectorsToUpdate varchar(100),
	@index_start int,
	@index_stop int
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE 
			@updateQuery nvarchar(500)

			set @updateQuery = 'update PARCEL_VECTORS set '+ @ColumnInParcelVectorsToUpdate +' = 
				(
					SELECT TOP 1 
					POINT.STDistance(shape) AS Distance
					FROM '+ @TableName +
					' ORDER BY POINT.STDistance(shape) ASC) where OBJECTID BETWEEN '+ 
					CONVERT(varchar, @index_start) +' AND ' + CONVERT(varchar, @index_stop) + ' '
			print @updateQuery
			EXECUTE sp_executesql @updateQuery

END
GO

--exec CountDistancesFromParcelsToObject @TableName = 'Public_Elementary_Schools',
--	@ColumnInParcelVectorsToUpdate = 'DistanceToElementarySchool',
--	@index_start = 700000,
--	@index_stop = 1000000

