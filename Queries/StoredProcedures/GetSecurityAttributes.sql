USE SecurityMaster
GO

ALTER PROCEDURE GetSecurityAttributes
(
	@securityTypeName VARCHAR(MAX)
)
AS
BEGIN

	SELECT 
		AttributeDisplayName, 
		AttributeRealName
	FROM
		SecurityAttributes
		JOIN
		SecurityType ON SecurityAttributes.SecurityTypeId = SecurityType.SecurityTypeId
	WHERE
		SecurityClassName = @securityTypeName
END