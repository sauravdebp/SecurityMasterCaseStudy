USE SecurityMaster
GO

CREATE PROCEDURE CreateSecurity
(
	@securityTypeId VARCHAR(50),
	@xml XML
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(200) = 'Equity',@query VARCHAR(MAX)
	--DECLARE @security_type_name VARCHAR(50)
	--SELECT @security_type_name = 'ivp_equity_common_stock'

	SET @query = ' DECLARE @security_data XML; '
	SET @query = @query + 'SELECT @security_data = ''' + CONVERT(VARCHAR(MAX), @xml) + ''';' + CHAR(13)	--Assigning the xml data to security data var
	SELECT @query = @query + 'INSERT INTO EQUITY (Name, EquityDescription)'
	SELECT @query = @query + 'SELECT'
	
	--The below part will generate a table which will have all the @entity_name attributes using the sys.columns table
	SELECT @query = @query + ' CASE WHEN doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') = '''' THEN NULL ELSE doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') END [' + name + '], ' + CHAR(13) 
	FROM sys.columns WHERE object_id = OBJECT_ID(@entity_name,'TABLE') AND name IN ('Name', 'EquityDescription')
	
	--The below part is specifying in the generated query to use the XML
	SELECT @query = LEFT(@query, LEN(@query) - 3) +  ' FROM @security_data.nodes(''/Securities/Equity'') doc(col); ' + CHAR(13) 
	
	--SELECT @query = 'INSERT INTO EQUITY ' + @query;
	PRINT @query

	EXECUTE (@query)
END