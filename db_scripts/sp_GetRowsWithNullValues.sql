-- =============================================
-- Author:		Magdalena Nowak
-- Create date: 7.09.2018
-- Description:	Procedure to get rows with at least one NULL value.
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE GetRowsWithNullValues 
	@TableName nvarchar(255) = N'PARCEL_VECTORS' 
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @tb NVARCHAR(255) = @TableName;

	DECLARE @sql NVARCHAR(MAX) = N'SELECT * FROM ' + @tb
		+ ' WHERE 1 = 0';

	SELECT @sql += N' OR ' + QUOTENAME(name) + ' IS NULL'
		FROM sys.columns 
		WHERE [object_id] = OBJECT_ID(@tb);

	EXEC sp_executesql @sql;
END
GO

--exec GetRowsWithNullValues 
