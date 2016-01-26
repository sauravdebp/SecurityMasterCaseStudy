USE [SecurityMaster]
GO

ALTER PROCEDURE CreateEquity
(
	@xml XML
)
AS
BEGIN
      INSERT INTO dbo.Equity (Name, EquityDescription)
      SELECT
      Securities.value('(Name/text())[1]','VARCHAR(MAX)') AS Name, --TAG
      Securities.value('(EquityDescription/text())[1]','VARCHAR(MAX)') AS EquityDescription --TAG
      FROM
      @xml.nodes('/Securities/Equity')AS TEMPTABLE(Securities)
END