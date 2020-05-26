use LosAngelesParcels
-- =============================================
-- CREATE NEW TABLE PARCEL_DESTINATIONS_FILTERED
-- =============================================
IF (EXISTS (SELECT *
                 FROM INFORMATION_SCHEMA.TABLES
                 WHERE TABLE_NAME = 'PARCEL_DESTINATIONS_FILTERED'))
BEGIN
 DROP TABLE PARCEL_DESTINATIONS_FILTERED
END

SELECT
 OBJECTID as Parcel_OBJECTID
INTO PARCEL_DESTINATIONS_FILTERED FROM PARCEL
GO
-- =============================================
-- ADD AIRPORT DISTANCE
-- =============================================

IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_DESTINATIONS_FILTERED' and COLUMN_NAME = 'Airport_distance'))
    BEGIN
        ALTER TABLE PARCEL_DESTINATIONS_FILTERED
            ADD Airport_distance float
    END

WITH distances AS (
    select min(P.Shape.STDistance(A.Shape)) as minDistance , p.OBJECTID
    from PARCEL_DESTINATIONS_FILTERED PD
             JOIN PARCEL P
                  ON P.OBJECTID = PD.Parcel_OBJECTID
             CROSS JOIN LosAngeles.dbo.AIRPORTS A
    group by p.OBJECTID
)
UPDATE PARCEL_DESTINATIONS_FILTERED
SET PARCEL_DESTINATIONS_FILTERED.Airport_distance = minDistance
FROM distances
         INNER JOIN PARCEL_DESTINATIONS_FILTERED AS y ON y.Parcel_OBJECTID = distances.OBJECTID;

-- =============================================
-- ADD RIVER DISTANCE
-- =============================================

IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_DESTINATIONS_FILTERED' and COLUMN_NAME = 'River_distance'))
BEGIN
 ALTER TABLE PARCEL_DESTINATIONS_FILTERED
  ADD
 River_distance float
END
GO


WITH distances AS (
    select min(P.Shape.STDistance(R.Shape)) as minDistance , p.OBJECTID
    from PARCEL_DESTINATIONS_FILTERED PD
    JOIN LosAngeles.dbo.PARCEL P
    ON P.OBJECTID = PD.Parcel_OBJECTID
    CROSS JOIN  RIVERS R
    group by p.OBJECTID
    )
UPDATE PARCEL_DESTINATIONS_FILTERED
SET PARCEL_DESTINATIONS_FILTERED.River_distance = minDistance
FROM distances
INNER JOIN PARCEL_DESTINATIONS_FILTERED AS y ON y.Parcel_OBJECTID = distances.OBJECTID;
GO