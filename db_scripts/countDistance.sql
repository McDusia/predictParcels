-- =============================================
-- CREATE NEW TABLE PARCEL_DESTINATIONS
-- =============================================
IF (EXISTS (SELECT *
                 FROM INFORMATION_SCHEMA.TABLES
                 WHERE TABLE_NAME = 'PARCEL_DESTINATIONS'))
BEGIN
	DROP TABLE PARCEL_DESTINATIONS
END

SELECT
	OBJECTID as Parcel_OBJECTID
INTO PARCEL_DESTINATIONS FROM PARCEL
GO
-- =============================================
-- ADD AIRPORT DISTANCE
-- =============================================

IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_DESTINATIONS' and COLUMN_NAME = 'Airport_disance'))
BEGIN
	ALTER TABLE PARCEL_DESTINATIONS
  ADD
	Airport_distance float
END
GO

WITH cte AS (
	   select min(P.Shape.STDistance(A.Shape)) as minDistance , p.OBJECTID
	   from PARCEL_DESTINATIONS PD
	   JOIN PARCEL P
	   ON P.OBJECTID = PD.Parcel_OBJECTID
	   CROSS JOIN AIRPORTS A
	   group by p.OBJECTID
	   )
UPDATE PARCEL_DESTINATIONS
SET PARCEL_DESTINATIONS.Airport_distance = minDistance
FROM cte AS x
INNER JOIN PARCEL_DESTINATIONS AS y ON y.Parcel_OBJECTID = x.OBJECTID;
SELECT * FROM PARCEL_DESTINATIONS
GO