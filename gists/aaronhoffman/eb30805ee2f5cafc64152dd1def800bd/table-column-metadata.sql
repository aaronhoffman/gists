-- query to generate a query for each column that gathers metadata about that column based on its data type
declare @table_name varchar(200) = 'dbo.tablename'

-- queries for individual rows
select
 c.name [column_name]
,c.system_type_id
,c.max_length
,c.is_identity
,c.is_nullable
,c.precision
,c.scale
,case 
    -- text
    when c.system_type_id in (35, 99, 167, 175, 231, 239) 
    then 'select ' + c.name + ', count(1) [cnt], ( (count(1) * 1.0) / (sum(count(1)) over()) ) [percent] from ' + @table_name + ' group by ' + c.name + ' order by 2 desc ' -- assume dimension, group and count

    -- date
    when c.system_type_id in (40, 42, 58, 61) 
    then
        'select min(' + c.name + ') mindate, max(' + c.name + ') maxdate from ' + @table_name + char(13) -- min/max
        + 'select datepart(year, ' + c.name + ') [year], count(1) cnt from ' + @table_name + ' group by datepart(year, ' + c.name + ') order by 1 ' + char(13) -- year group
        + 'select datepart(year, ' + c.name + ') [year], datepart(month, ' + c.name + ') [month], count(1) cnt from ' + @table_name + ' group by datepart(year, ' + c.name + '), datepart(month, ' + c.name + ') order by 1, 2 ' + char(13) -- year/month group
        + 'select datepart(year, ' + c.name + ') [year], datepart(dayofyear, ' + c.name + ') [dayofyear], count(1) cnt from ' + @table_name + ' group by datepart(year, ' + c.name + '), datepart(dayofyear, ' + c.name + ') order by 1, 2 ' + char(13) -- year/dayofyear group
        + 'select datepart(dayofyear, ' + c.name + ') [dayofyear], datepart(hour, ' + c.name + ') [hour], count(1) cnt from ' + @table_name + ' group by datepart(dayofyear, ' + c.name + '), datepart(hour, ' + c.name + ') order by 1, 2 ' + char(13) -- dayofyear/hour group
    
    -- numeric
    when c.system_type_id in (48, 52, 56, 59, 60, 62, 106, 122, 127) 
    then 
        'select ' + c.name + ', count(1) cnt from ' + @table_name + ' group by ' + c.name + ' order by 2 desc ' + char(13) -- could be dimension, group and count
        + 'select count(1) cnt, sum(case when ' + c.name + ' is null then 1 else 0 end) nullcnt, sum(' + c.name + ') [sum], min(' + c.name + ') [min], max(' + c.name + ') [max], avg(' + c.name + ') [avg], stdev(' + c.name + ') [stdev] from ' + @table_name -- various aggregates

    else '-- no query for type '
end [querytext]

from sys.columns c

where c.object_id = object_id(@table_name)

-- single query to gather info on every text column and union all results togetehr into a single result set
select 'select ''' + c.name + ''' [column_name], ' + c.name + ', len(' + c.name + ') [optionlen], count(1) [cnt], ( (count(1) * 1.0) / (sum(count(1)) over()) ) [percent] from ' + @table_name + ' group by ' + c.name + ' union all' [textColumnsUnionAllQuery]
from sys.columns c
where
c.object_id = object_id(@table_name)
and 
c.system_type_id in (35, 99, 167, 175, 231, 239) -- text types

-- single query to gather metadata about each text/dimension column. Takes the result of the query above as input
/*
select 
 x.column_name
,count(1) uniquecnt             -- unique number of options in this column
,min(x.optionlen) minlen        -- shortest option text length
,max(x.optionlen) maxlen        -- longest option text length
,avg(x.optionlen * 1.0) avglen  -- average length
,min(x.cnt) mincnt              -- least commonly occurring option count
,max(x.cnt) maxcnt              -- most commonly occurring option count
,avg(x.cnt * 1.0) avgcnt        -- average occurrence of an option count
,stdev(x.cnt) stdevcnt          -- stdev of option occurrences
from (
{{insert union all queries generated above here}}
) x
group by
x.column_name
*/

-- single query to gather info on every numeric column and union all results together into a single result set
select 'select ''' + c.name + ''' [column_name], count(1) cnt, sum(case when ' + c.name + ' is null then 1 else 0 end) nullcnt, sum(' + c.name + ') [sum], min(' + c.name + ') [min], max(' + c.name + ') [max], avg(' + c.name + ') [avg], stdev(' + c.name + ') [stdev] from ' + @table_name + ' union all ' [numericColumnsUnionAllQuery]
from sys.columns c
where
c.object_id = object_id(@table_name)
and 
c.system_type_id in (48, 52, 56, 59, 60, 62, 106, 122, 127) -- numeric types


/*
system_type_id	ref
34	image
35	text
36	uniqueidentifier
40	date
41	time
42	datetime2
48	tinyint
52	smallint
56	int
58	smalldatetime
59	real
60	money
61	datetime
62	float
98	sql_variant
99	ntext
104	bit
106	decimal
108	numeric
122	smallmoney
127	bigint
165	varbinary
167	varchar
173	binary
175	char
189	timestamp
231	nvarchar
239	nchar
241	xml
*/