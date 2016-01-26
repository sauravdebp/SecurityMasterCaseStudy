declare @XML xml = 
'<root>
  <item>
    <item_number>IT23</item_number>
    <title>Item number twenty-three</title>
    <setting>5 to 20</setting>
    <parameter>10 to 16</parameter>
    <new_node>data</new_node>
  </item>
  <item>
    <item_number>RJ12</item_number>
    <title>Another item with a 12</title>
    <setting>7 to 35</setting>
    <parameter>1 to 34</parameter>
    <new_node>goes</new_node>
  </item>
  <item>
    <item_number>LN90</item_number>
    <title>LN with 90</title>
    <setting>3 to 35</setting>
    <parameter>9 to 50</parameter>
    <new_node>here</new_node>
  </item>
</root>'

declare @SQL nvarchar(max) = ''
declare @Col nvarchar(max) = ', T.N.value(''[COLNAME][1]'', ''varchar(100)'') as [COLNAME]' 

select @SQL = @SQL + replace(@Col, '[COLNAME]', T.N.value('local-name(.)', 'sysname'))
from @XML.nodes('/root/item[1]/*') as T(N)

set @SQL = 'select '+stuff(@SQL, 1, 2, '')+' from @XML.nodes(''/root/item'') as T(N)' 

exec sp_executesql @SQL, N'@XML xml', @XML