
IF (NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE TABLE_NAME = 'PARCEL_VECTORS' and COLUMN_NAME = 'BuildingsPresent'))
BEGIN
	ALTER TABLE PARCEL_VECTORS
  ADD
	BuildingsPresent INT
END
GO

UPDATE PARCEL_VECTOR
SET BuildingsPresent = 1
GO

UPDATE PARCEL_VECTORS
SET BuildingsPresent = 0
  WHERE BD_LINE_1_No_of_Units = 0 and BD_LINE_2_No_of_Units = 0 and BD_LINE_1_No_of_Units = 3

