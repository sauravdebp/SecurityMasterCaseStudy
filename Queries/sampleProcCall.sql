DECLARE @xmlData xml = 
'<Securities>
	<Equity>
		<Name>abc</Name>
		<EquityDescription>description</EquityDescription>
	</Equity>
	<Equity>
		<Name>egf</Name>
		<EquityDescription>description1</EquityDescription>
	</Equity>
</Securities>'

EXEC CreateEquity @xmlData