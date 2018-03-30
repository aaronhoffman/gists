-- sp spaced used each table http://stackoverflow.com/a/7892361/47226

-- must be temp table, table var not referenceable by SP
create table #TableSize (
  Name varchar(255),
  [rows] int,
  reserved varchar(255),
  data varchar(255),
  index_size varchar(255),
  unused varchar(255))

declare @ConvertedSizes table (
  Name varchar(255),
  [rows] int,
  reservedKb int,
  dataKb int,
  reservedIndexSize int,
  reservedUnused int)

-- exec sp_spaceused for each table, insert into #tablesize
EXEC sp_MSforeachtable @command1="insert into #TableSize EXEC sp_spaceused '?'"

-- convert those values to numbers
insert into @ConvertedSizes (Name, [rows], reservedKb, dataKb, reservedIndexSize, reservedUnused)
select
 name
 ,[rows]
 ,SUBSTRING(reserved, 0, LEN(reserved)-2)
 ,SUBSTRING(data, 0, LEN(data)-2)
 ,SUBSTRING(index_size, 0, LEN(index_size)-2)
 ,SUBSTRING(unused, 0, LEN(unused)-2)
from #TableSize

select * from @ConvertedSizes

drop table #TableSize