USE [SecurityMaster]
GO

CREATE  PROCEDURE DeleteBond
(
@securityId INT
)
AS
BEGIN
	DELETE FROM dbo.CorporateBond
	WHERE SecurityId = @securityId

	DELETE FROM dbo.Security
	WHERE SecurityId = @securityId
END