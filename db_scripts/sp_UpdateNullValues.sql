-- =============================================
-- Author:		Magdalena Nowak
-- Create date: 8.09.2018
-- Description:	Procedure to update all NULL values to 0.
--				Works for nvarchar and int columns.
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE UpdateNullValues 
	@Table_Name nvarchar(255) = 'PARCEL_VECTORS'
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @sql as nvarchar(max)=''	

	SELECT @sql+='SET NOCOUNT ON; IF EXISTS (select * from ' + c.TABLE_NAME + ' where ' + 
	c.COLUMN_NAME + ' is null)' + 
	'UPDATE ' + c.TABLE_NAME +' SET ' + c.COLUMN_NAME +' = 0 WHERE '+ 
	c.COLUMN_NAME +' is null' + CHAR(13)
	FROM information_schema.columns c where table_name = @Table_Name and c.COLUMN_NAME != 'Shape'

	EXEC sp_executesql @sql

END
GO

--Exec UpdateNullValues