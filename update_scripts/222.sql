ALTER procedure [dbo].[check_partition_lower_range]
(
	@actual_needed_lower_range datetime
)
as
	declare @last_set_lower_range datetime;
	declare @last_set_lower_range_time datetime;
	declare @SQLString nvarchar(4000);

	declare part_range cursor for
	select last_lower_range_change, lower_range from partition_info;

	open part_range;
	fetch part_range into @last_set_lower_range_time, @last_set_lower_range;

	while(@@fetch_status <> 0)
	begin
		fetch part_range into @last_set_lower_range_time, @last_set_lower_range;
	end
	close part_range;
	deallocate part_range;

	print 'last_set_lower_range: ' + cast(@last_set_lower_range as varchar)
	print 'actual_needed_lower_range: ' + cast(@actual_needed_lower_range as varchar)
	print 'actual_needed_lower_range < last_set_lower_range: ' + case when @actual_needed_lower_range < @last_set_lower_range then '1' else '0' end

	print 'last_set_lower_range_time:' + cast(@last_set_lower_range_time as varchar)
	print 'last_set_lower_range_time < dateadd(day, -2, getdate()): ' + case when @last_set_lower_range_time < dateadd(day, -2, getdate())  then '1' else '0' end
	print '(last_set_lower_range < dateadd(month, -1, getdate())): ' +	case when (@last_set_lower_range < dateadd(month, -1, getdate()))  then '1' else '0' end
	print '(actual_needed_lower_range > dateadd(month, -1, getdate())) ' + case when (@actual_needed_lower_range > dateadd(month, -1, getdate()))  then '1' else '0' end
	if (@actual_needed_lower_range < @last_set_lower_range)
	begin
		update partition_info 
			set last_lower_range_change = getdate(), 
			    lower_range = @actual_needed_lower_range;

		print 'Cofam zakres do ' + cast(@actual_needed_lower_range as varchar)

		set @SQLString = N' alter view partition_view as ';
	
		declare part_cr cursor for
		select name from ted_transactions
		where convert(varchar, ltrim(str(year)) + RIGHT('00'+ltrim(str(month)),2) + '28', 112) >= 
				dateadd(day, -4, @actual_needed_lower_range)
		order by year, month
	
		declare @name varchar(200);

		open part_cr;
		fetch part_cr into @name;

		while (@@fetch_status <> -1)
		begin
			set @SQLString = @SQLString + CHAR(13) + CHAR(10) + 
				' select id_device_data,evb1,evb2,evb3,evb4,evb5,evb6,evb7,evb8,evb9,evb10,pal1,pal2,date,timezonebias from ' +
				@name + '.dbo.device_data union all ';
			print @SQLString;
			fetch part_cr into @name;
		end

		close part_cr
		deallocate part_cr
	
		set @SQLString = @SQLString + CHAR(13) + CHAR(10) + 
				' select id_device_data,evb1,evb2,evb3,evb4,evb5,evb6,evb7,evb8,evb9,evb10,pal1,pal2,date,timezonebias from dbo.device_data';
		print @SQLString;

		EXECUTE sp_executesql @SQLString;

	end
	else
	if (@last_set_lower_range_time < dateadd(day, -2, getdate())) and
			(@last_set_lower_range < dateadd(month, -1, getdate())) and
			(@actual_needed_lower_range > dateadd(month, -1, getdate()))
	begin
		update partition_info 
			set last_lower_range_change = getdate(), 
			    lower_range = dateadd(month, -1, getdate());

		print 'Wracam po dwoch dniach do zakresu zakresu ostatnich 1 miesiecy'

		set @SQLString = N' alter view partition_view as ';
	
		declare part_cr cursor for
		select name from ted_transactions
		where convert(varchar, ltrim(str(year)) + '-' + RIGHT('00'+ltrim(str(month)),2) + '28', 112) > 
				dateadd(month, -3, getdate())
		order by year, month;


		open part_cr;
		fetch part_cr into @name;

		while (@@fetch_status <> -1)
		begin
			set @SQLString = @SQLString + CHAR(13) + CHAR(10) + 
				' select id_device_data,evb1,evb2,evb3,evb4,evb5,evb6,evb7,evb8,evb9,evb10,pal1,pal2,date,timezonebias from ' +
				@name + '.dbo.device_data union all ';
			fetch part_cr into @name;
		end

		close part_cr
		deallocate part_cr
	
		set @SQLString = @SQLString + CHAR(13) + CHAR(10) + 
				' select id_device_data,evb1,evb2,evb3,evb4,evb5,evb6,evb7,evb8,evb9,evb10,pal1,pal2,date,timezonebias from dbo.device_data';
	
		EXECUTE sp_executesql @SQLString;

	end;


