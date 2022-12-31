CREATE procedure [dbo].[showRealTimeRangeByRoutes]
(
	@id_car int,
	@start_date datetime,
	@stop_date datetime,
    @start_date_real datetime output,
    @stop_date_real datetime output
)
as
declare @id_device_data_start bigint;
declare @evb3_start int;
declare @id_device_data_stop bigint;
declare @evb3_stop int;

set @id_device_data_start = null;
set @evb3_start = null;
set @start_date_real = null;

select top 1 
	@id_device_data_start = id_device_data, 
	@evb3_start = evb3, 
	@start_date_real = date 
from device_data
where evb2 = @id_car and date >= @start_date and date <= @stop_date and 
	  (evb3 = 15 or evb3 = 10 or evb3 = 49)
order by id_device_data
--print 'evb3_start: ' + cast(isnull(@evb3_start, 0) as varchar(5)) + 'start_date_real: ' + cast(isnull(@start_date_real, '') as varchar(20))


set @id_device_data_stop = null;
set @evb3_stop = null;
set @stop_date_real = null;

select top 1 
	@id_device_data_stop = id_device_data, 
	@evb3_stop = evb3, 
	@stop_date_real = date 
from device_data
where evb2 = @id_car and date >= @start_date and date <= @stop_date and 
	  (evb3 = 15 or evb3 = 10 or evb3 = 49)
order by id_device_data desc
--print 'evb3_stop: ' + cast(isnull(@evb3_stop, 0) as varchar(5)) + 'stop_date_real: ' + cast(isnull(@stop_date_real, '') as varchar(20))

if @evb3_start is not null and @evb3_start <> 10
begin
	select top 1 
		@id_device_data_start = id_device_data, 
		@evb3_start = evb3, 
		@start_date_real = date 
	from device_data
	where evb2 = @id_car and date < @start_date and
		  (evb3 = 10) and id_device_data is not null
	order by id_device_data desc
--	print 'evb3_start: ' + cast(isnull(@evb3_start, 0) as varchar(5)) + 'start_date_real: ' + cast(isnull(@start_date_real, '') as varchar(20))
end

if @evb3_stop is not null and @evb3_stop <> 49 and @evb3_stop <> 15
begin
	select top 1 
		@id_device_data_stop = id_device_data, 
		@evb3_stop = evb3, 
		@stop_date_real = date 
	from device_data
	where evb2 = @id_car and date > @stop_date and
		  (evb3 = 49 or evb3 = 15) and id_device_data is not null
	order by id_device_data
--	print 'evb3_stop: ' + cast(isnull(@evb3_stop, 0) as varchar(5)) + 'stop_date_real: ' + cast(isnull(@stop_date_real, '') as varchar(20))
end