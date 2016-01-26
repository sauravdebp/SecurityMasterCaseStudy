USE [SecurityMaster]
GO

CREATE  PROCEDURE DeleteEquity
(
@securityId INT
)
AS
BEGIN
	DELETE FROM dbo.Equity 
	WHERE SecurityId=@securityId

	DELETE FROM dbo.Security
	WHERE SecurityId = @securityId
END