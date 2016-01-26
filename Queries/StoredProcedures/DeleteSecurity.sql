USE SecurityMaster
GO

ALTER PROCEDURE DeleteSecurity
(
	@securityTypeName VARCHAR(MAX),
	@securityId INT
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(100)
	DECLARE @query VARCHAR(500)

	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityClassName = @securityTypeName
	
	SET @query = 'DELETE FROM ' + @entity_name + ' WHERE SecurityId = ' + CONVERT(VARCHAR(MAX), @securityId)

	EXECUTE(@query)
END

--EXEC DeleteSecurity 25, 1