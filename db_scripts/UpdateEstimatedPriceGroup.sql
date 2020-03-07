
-- =============================================
-- Author:  Joanna Palewicz
-- Create date: 20.11.2018
-- Description: Procedures to update estimated price groups
-- =============================================


CREATE TABLE ESTIMATED_PRICE_GROUP
(
	OBJECTID INT NOT NULL UNIQUE,
		ESTIMATED_PRICE_GROUP INT
)
GO


DECLARE @SourceCSVPath VARCHAR(256)=  '';
DECLARE @ErrorFilePath VARCHAR(256)=  '';

DECLARE @sql NVARCHAR(MAX);
SET @sql = 'BULK INSERT ESTIMATED_PRICE_GROUP
    FROM ''' + @SourceCSVPath + '''
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''\n'',
    ERRORFILE = ''' + @ErrorFilePath + ''',
    TABLOCK
    )
'
exec sp_executesql @sql;


CREATE CLUSTERED INDEX ObjectIDIndex
ON dbo.ESTIMATED_PRICE_GROUP(OBJECTID)

UPDATE PARCEL_VECTORS
SET PARCEL_VECTORS.Price_Group_int = E.ESTIMATED_PRICE_GROUP
	FROM PARCEL_VECTORS P
	INNER JOIN ESTIMATED_PRICE_GROUP E
	ON P.OBJECTID = E.OBJECTID;
	GO