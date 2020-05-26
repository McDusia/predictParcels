
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Magdalena Nowak
-- Create date: 16.05.2020
-- Description:	ProcedureToCountPOIInNeighbourhood
-- =============================================
CREATE OR ALTER PROCEDURE CountPOIInNeighbourhood
	@ColumnName varchar(100),
	@TableName varchar(100),
	@index_start int,
	@index_stop int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
			@query nvarchar(500)
    -- 25000 ~ 7620.01524 meters
	select @query = 'update PARCEL_VECTORS set ' + @ColumnName +' = 
	(
	SELECT
	Count(*) AS Quantity
	FROM '
	+ @TableName +
	' TAB WHERE
	TAB.POINT.Filter(shape.STBuffer(25000)) = 1
	)
	where OBJECTID BETWEEN '+ 
					CONVERT(varchar, @index_start) +' AND ' + CONVERT(varchar, @index_stop) + ' '
	print @query
	EXECUTE sp_executesql @query
END
GO