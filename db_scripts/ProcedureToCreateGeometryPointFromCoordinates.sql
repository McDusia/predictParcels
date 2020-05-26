
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Magdalena Nowak
-- Create date: 18.04.2020
-- Description:	Procedure to create geometry Point structure from X, Y coordinates in EPSG: 2229
-- =============================================
CREATE OR ALTER PROCEDURE CreateGeometryPoint
	@TableName varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE
			@geometryPointQuery nvarchar(200)
    
	select @geometryPointQuery = 'update '+ @TableName +' SET POINT = geometry::STGeomFromText(''POINT( ''+ 
	 CONVERT(varchar, POINT_X) + '' '' + CONVERT(varchar, POINT_Y) + '')'', 2229)'
	print @geometryPointQuery
	EXECUTE sp_executesql @geometryPointQuery
	
END
GO