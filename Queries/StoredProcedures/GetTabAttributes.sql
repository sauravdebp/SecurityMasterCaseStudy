USE [SecurityMaster]
GO

ALTER PROCEDURE [dbo].[GetTabAttributes]
(
	@securityTypeName VARCHAR(MAX)
)
AS
BEGIN
	SELECT AttributeDisplayName, AttributeRealName, TabName, AttributeDataType
	FROM SecurityAttributes sa
	JOIN SecurityType st ON sa.SecurityTypeId = st.SecurityTypeId
	WHERE SecurityClassName = @securityTypeName
END

--EXEC SelectSecurity 1, 25