USE SecurityMaster
GO

ALTER PROCEDURE CreateSecurity
(
	@securityTypeName VARCHAR(MAX),
	@xml XML
)
AS
BEGIN
	DECLARE @entity_name VARCHAR(200)
	DECLARE @query VARCHAR(MAX)
	
	SELECT @entity_name = TableName
	FROM SecurityType
	WHERE SecurityClassName = @securityTypeName

	SET @query = 'DECLARE @securityId INT' + CHAR(13)
	SET @query = @query + 'SELECT @securityId = CASE WHEN MAX(SecurityId) IS NULL THEN 0 ELSE MAX(SecurityId) END FROM ' + @entity_name + CHAR(13)

	--DROP TABLE #tmpTable

	SET @query = @query + 'DECLARE @security_data XML' + CHAR(13)
	SET @query = @query + 'SELECT @security_data = ''' + CONVERT(VARCHAR(MAX), @xml) + ''';' + CHAR(13)	--Assigning the xml data to security data var
	
	--SET @query = @query + 'INSERT INTO ' + @entity_name + ' (SecurityId, Name, Description)'	--THIS STATEMENT IS FOR TESTING ONLY
	SET @query = @query + 'INSERT INTO ' + @entity_name	--This is the final statement to be used. NOT THE ABOVE ONE
	SET @query = @query + ' SELECT '
	
	--The below part will generate a table which will have all the @entity_name attributes using the sys.columns table
	SELECT
		@query = 
			CASE
				WHEN name = 'SecurityId'-- AND @generateSecurityId = 1
				THEN @query + ' CASE WHEN doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') = '''' THEN @securityId + ROW_NUMBER() OVER(ORDER BY (SELECT 0)) ELSE doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') END [' + name + '], ' + CHAR(13) 
				ELSE @query + ' CASE WHEN doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') = '''' THEN NULL ELSE doc.col.value('''+ name + '[1]'', ''nvarchar(MAX)'') END [' + name + '], ' + CHAR(13) 
			END
	FROM sys.columns 
	WHERE object_id = OBJECT_ID(@entity_name,'TABLE') 
	--AND name IN ('SecurityId', 'Name', 'Description')	--THIS STATEMENT IS FOR TESTING ONLY
	ORDER BY sys.columns.column_id
	
	--The below part is specifying in the generated query to use the XML
	SET @query = LEFT(@query, LEN(@query) - 3) +  ' FROM @security_data.nodes(''/ArrayOfSecurity/Security'') doc(col); ' + CHAR(13) 
	--PRINT CAST(@query as NTEXT)
	EXECUTE (@query)
END