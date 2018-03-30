-- SQL Query to search every guid/uniqueidentifier column in a database for the given id

declare @Id uniqueidentifier = 'ED4D0741-B092-4F0A-9E10-51C19265357C'
-- set to 1 to only search within columns that have '%id%' in the name, for all columns of uniqueidentifier type, set to 0
declare @onlyColumnsWithIdInName bit = 1

declare @Columns table (TableName varchar(200), ColumnName varchar(200))

insert into @Columns (TableName, ColumnName)
select
 o.name TableName
,c.name ColumnName
from
sys.columns c 
join sys.objects o on (c.object_id = o.object_id)
where
c.system_type_id = 36
and o.type = 'U'
and (@onlyColumnsWithIdInName = 0 or c.name like '%id%')

select count(1) ColumnsFoundCount from @Columns


declare @sql nvarchar(4000)

declare @TableName varchar(200)
declare @ColumnName varchar(200)

declare column_cursor cursor for 
select TableName, ColumnName from @Columns;

open column_cursor;
fetch next from column_cursor into @TableName, @ColumnName

while @@fetch_status = 0
begin
    set @sql = 'select ''' + @TableName + '.' + @ColumnName + ''' [TableNameColumnName], * from ' + @TableName + ' where ' + @ColumnName + ' = ''' + convert(varchar(36), @Id) + ''''
    
    set @sql = 'if exists (' + @sql + ')
                begin
                    ' + @sql + '
                end'
    
    exec sp_executesql @sql

    fetch next from column_cursor into @TableName, @ColumnName
end
close column_cursor
deallocate column_cursor