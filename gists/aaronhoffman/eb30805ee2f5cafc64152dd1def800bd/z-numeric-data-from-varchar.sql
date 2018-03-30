-- pull numeric data from varchar columns
declare @table_name varchar(200) = 'dbo.tablename'

select
 c.name [column_name]
,',max(len(t.[' + c.name + '])) [' + c.name + '_max_len]'
,',max(charindex(''.'', t.[' + c.name + '])) [' + c.name + '_integer_part_len]'
,',max(len(t.[' + c.name + ']) - charindex(''.'', t.[' + c.name + '])) [' + c.name + '_decimal_part_len]'
from sys.columns c

where c.object_id = object_id(@table_name)