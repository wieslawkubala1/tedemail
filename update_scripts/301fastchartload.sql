create procedure showChartData
 @id_car int,
 @start_date datetime,
 @stop_date datetime,
 @select_part nvarchar(1000),
 @rest_sql nvarchar(4000),
 @orderby_statement nvarchar(1000),

 @id_chart_data bigint output, -- na poczatek ustawic na zero
 @record_count int output, -- na poczatek ustawic na zero, 
 -- zwraca ilosc rekordow dodanych do aktualnego wykresu o id @id_chart_data
 @co_ktory int output, -- na poczatek ustawic na zero, zwraca co ktory rekord z dostepnych dodal do zestawu,
 -- by nie przekroczyc @max_records_in_the_same_time (1000), 
 -- np.gdy @co_ktory = 3 co dodaje co trzeci, pomijajac kazdy pierwszy i drugi z trzech
 -- jesli @co_ktory = 1 to dodal wszystkie z podanego zakresu

 @start_date_zoomed datetime,
 @stop_date_zoomed datetime
as

declare @max_records_in_the_same_time int;

declare @numerize_records nvarchar(1000);
declare @sql nvarchar(4000);
declare @teraz datetime
set @teraz = getdate();


set @max_records_in_the_same_time = 1000;
--set @id_car = 4;
--set @start_date = '2017-10-02';
--set @stop_date = '2017-10-09';
--set @start_date_zoomed = '2017-10-02';
--set @stop_date_zoomed = '2017-10-09';

delete from chart_data where generated_at < DATEADD(day, -1, @teraz)

--set @id_chart_data = 9;
if @id_chart_data = 0
begin
	insert into chart_data(id_car, start_date, stop_date, generated_at) 
	  values(@id_car, @start_date, @stop_date, @teraz)
	select @id_chart_data = id_chart_data 
	  from chart_data 
	  where id_car = @id_car and generated_at = @teraz;
end


set @numerize_records = N' ROW_NUMBER() OVER (ORDER BY t1.id_device_data) as _row, ';
/*
set @select_part = N' t1.id_device_data id, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, 
t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, t1.date evdata, t44.RPM_OBRO, t44.RPM_DISP, t44.RPM_STAT, 
t22.liters zb1, 
t33.liters zb2, 
t22.liters + 
t33.liters razem ';

set @rest_sql =  N' from device_data t1 
		  left join fuel_tank t2 
				  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
		  left join probe_liters t22 
				  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
		  left join fuel_tank t3 
				  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) 
		  left join probe_liters t33 
				  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) 
     left join car t44 
         on (t44.id_car = t1.evb2) 
where (evb2 = @id_car) and (date >= @start_date) and (date <= @stop_date) and 
            ((evb3 = 119 and evb4 >= 0) or 
             (evb3 = 113 and evb4 >= 0) or 
             (evb3 = 125) or 
             (evb3 = 85) 
                or (evb3 = 49) or (evb3 = 10) or (evb3 = 115) or (evb3 = 15) or 
                (evb3 = 171) or (evb3 = 172) or (evb3 = 173) or (evb3 = 122)) ';

set @orderby_statement = N' order by id_device_data '; 
*/

--set @sql = N'select ' + @numerize_records + @select_part + @rest_sql + @orderby_statement;
--EXECUTE sp_executesql  @sql,
--N'@id_car int, @start datetime, @stop datetime',
--@id_car = @id_car, @start = @start, @stop = @stop

set @sql = N'select @record_count = count(*) ' + @rest_sql;
EXECUTE sp_executesql  @sql,
N'@id_car int, @start_date datetime, @stop_date datetime, @record_count int output',
@id_car = @id_car, @start_date = @start_date_zoomed, @stop_date = @stop_date_zoomed, @record_count = @record_count output

--select @record_count as record_count

set @co_ktory = @record_count / @max_records_in_the_same_time
if @co_ktory = 0
	set @co_ktory = 1

--select @co_ktory as co_ktory

set @sql = N'select @id_chart_data as id_chart_data, @record_count as record_count, @co_ktory as co_ktory, tbl.* from 
(
	select ' + @numerize_records + @select_part + @rest_sql + '
) as tbl left join 
chart_data_item on (tbl.id = chart_data_item.id_device_data and chart_data_item.id_chart_data = @id_chart_data) '; 

if @co_ktory <> 1
	set @sql = @sql + N' where (tbl._row % @co_ktory) = 0  and chart_data_item.id_device_data is null ';
else
	set @sql = @sql + N' where chart_data_item.id_device_data is null ';

set @sql = @sql + N' order by tbl.id ';

--print @sql;

EXECUTE sp_executesql  @sql,
N'@id_car int, @start_date datetime, @stop_date datetime, @co_ktory int, @id_chart_data bigint, @record_count int',
@id_car = @id_car, @start_date = @start_date_zoomed, @stop_date = @stop_date_zoomed, @co_ktory = @co_ktory, @id_chart_data = @id_chart_data, @record_count = @record_count

set @sql = N'insert into chart_data_item(id_chart_data, id_device_data) ' + 
		   N' select @id_chart_data, id from 
(
	select ' + @numerize_records + @select_part + @rest_sql + '
) as tbl left join 
chart_data_item on (tbl.id = chart_data_item.id_device_data and chart_data_item.id_chart_data = @id_chart_data) ';

if @co_ktory <> 1
	set @sql = @sql + N' where (tbl._row % @co_ktory) = 0 and chart_data_item.id_device_data is null ';
else
	set @sql = @sql + N' where chart_data_item.id_device_data is null ';
set @sql = @sql + N' order by tbl.id ';
EXECUTE sp_executesql  @sql,
N'@id_car int, @start_date datetime, @stop_date datetime, @co_ktory int, @id_chart_data bigint',
@id_car = @id_car, @start_date = @start_date_zoomed, @stop_date = @stop_date_zoomed, @co_ktory = @co_ktory, @id_chart_data = @id_chart_data