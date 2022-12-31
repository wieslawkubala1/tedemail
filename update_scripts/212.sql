create procedure check_partition_lower_range
(
	@lower_range datetime
)
as
	declare @lower_range2 datetime;
	declare @last_lower_range_change datetime;
	declare @SQLString nvarchar(4000);

	declare part_range cursor for
	select last_lower_range_change, lower_range from partition_info;

	open part_range;
	fetch part_range into @last_lower_range_change, @lower_range2;

	while(@@fetch_status <> 0)
	begin
		fetch part_range into @last_lower_range_change, @lower_range2;
	end
	close part_range;
	deallocate part_range;

	if (@lower_range2 > @lower_range)
	begin
		update partition_info 
			set last_lower_range_change = getdate(), 
			    lower_range = @lower_range;

		set @SQLString = N' alter view partition_view as ';
	
		declare part_cr cursor for
		select name from ted_transactions
		where convert(varchar, ltrim(str(year)) + RIGHT('00'+ltrim(str(month)),2), 112) >= 
				@lower_range
		order by year, month;
	
		declare @name varchar(200);

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

	end
	else
	if (@last_lower_range_change > dateadd(week, -1, getdate())) and
			(@lower_range2 > dateadd(month, -3, getdate())) and
			(@lower_range > dateadd(month, -3, getdate()))
	begin
		update partition_info 
			set last_lower_range_change = getdate(), 
			    lower_range = dateadd(month, -3, getdate());

		set @SQLString = N' alter view partition_view as ';
	
		declare part_cr cursor for
		select name from ted_transactions
		where convert(varchar, ltrim(str(year)) + '-' + RIGHT('00'+ltrim(str(month)),2) + '-01', 112) > 
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
