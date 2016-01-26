USE SecurityMaster
GO

DECLARE @xml XML = '
<Securities>
	<Security>
		<Name>MICROSOFT</Name>
		<Description>blah</Description>
	</Security>
	<Security>
		<Name>crAPPLE</Name>
		<Description>CRAPPY STOCK</Description>
	</Security>
</Securities>
'
EXEC CreateSecurity 1, @xml