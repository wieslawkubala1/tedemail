ALTER procedure [dbo].[ted_partitions]
 @partition_count int
as
	if not exists (select * from sysobjects where name='ted_transactions' and xtype='U')
		create table ted_transactions
		(
			id int not null identity(1, 1),
			name varchar(150) not null,
			year int not null,
			month int not null,
			primary key (id)
		)

	IF not EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'ted_transactions'
                 AND COLUMN_NAME = 'recordCount') 
		alter table ted_transactions add recordCount int;
		

	declare @part_count int;
	declare @now_year int;
	declare @now_month int;
	declare @year int;
	declare @month int;
	declare @year_month int;
	declare @ilosc bigint;
	declare @db2_name varchar(100);
	declare @SQLString nvarchar(4000);
	declare @start_date varchar(100);
	declare @stop_date varchar(100);

	declare cr_partitions cursor for
	select count(*), year(date), month(date), year(date) * 100 + month(date)
	from device_data
	group by year(date), month(date)
	order by year(date), month(date);

	set @now_year = year(getdate());
	set @now_month = month(getdate());

	open cr_partitions;
	fetch cr_partitions into @ilosc, @year, @month, @year_month;

	set @part_count = 1;
	while (@@fetch_status <> -1)
	begin
		if @now_year = @year and @now_month = @month
		begin
			break;
		end;

		set @db2_name = 'part_' + db_name() + ltrim(str(@year_month));
		
		if dbo.DatabaseExists(@db2_name) = 0
		begin
			set @SQLString = N' create database ' + @db2_name;
			EXECUTE sp_executesql @SQLString;
			print @SQLString;

			set @SQLString = N' insert into ted_transactions (name, year, month, recordCount) values(''' + @db2_name + ''', ' +
				  ltrim(str(@year)) + ', ' + ltrim(str(@month))	+ ', ' + ltrim(str(@ilosc)) + ') ';
			EXECUTE sp_executesql @SQLString;
			print @SQLString;
			
			set @SQLString = N' create table ' + @db2_name + '.dbo.device_data (
				id_device_data bigint NOT NULL,
				evb1 tinyint NOT NULL,
				evb2 tinyint NOT NULL,
				evb3 tinyint NOT NULL,
				evb4 tinyint NOT NULL,
				evb5 tinyint NOT NULL,
				evb6 tinyint NOT NULL,
				evb7 tinyint NOT NULL,
				evb8 tinyint NOT NULL,
				evb9 tinyint NOT NULL,
				evb10 tinyint NOT NULL,
				pal1 tinyint NOT NULL,
				pal2 tinyint NOT NULL,
				date datetime NULL,
				timezonebias int NOT NULL,
				primary key (id_device_data)
			) ';
			EXECUTE sp_executesql @SQLString;
			print @SQLString;
			
			set @SQLString = N' CREATE NONCLUSTERED INDEX [device_data_index] ON ' + @db2_name + '.[dbo].[device_data] 
				( 
					[evb2] ASC, 
					[evb3] ASC, 
					[date] ASC 
				) ';
			EXECUTE sp_executesql @SQLString;
			print @SQLString;

		end
		else
		begin
			set @SQLString = N' update ted_transactions set recordCount = recordCount + ' + ltrim(str(@ilosc)) + 
				' where year = ' + ltrim(str(@year)) + ' and month = ' + ltrim(str(@month));
			EXECUTE sp_executesql @SQLString;
			print @SQLString;		
		end;




		set @start_date = ltrim(str(@year)) + '-' + RIGHT('00'+ltrim(str(@month)),2) + '-01';
		set @month = @month + 1;
		if @month > 12
		begin
			set @year = @year + 1;
			set @month = 1;
		end;
		set @stop_date = ltrim(str(@year)) + '-' + RIGHT('00'+ltrim(str(@month)),2) + '-01';

		set @SQLString = N' insert into ' + @db2_name + '.dbo.device_data (
			id_device_data, evb1, evb2, evb3, evb4, evb5, evb6, evb7,
				evb8, evb9, evb10, pal1, pal2, date, timezonebias)
			select id_device_data, evb1, evb2, evb3, evb4, evb5, evb6, evb7,
				evb8, evb9, evb10, pal1, pal2, date, timezonebias
			from device_data
			where date >= ''' + @start_date + ''' and date < ''' + @stop_date + ''' ';
		EXECUTE sp_executesql @SQLString;
		print @SQLString;

		set @SQLString = N' delete from device_data
			where date >= ''' + @start_date + ''' and date < ''' + @stop_date + ''' ';
		EXECUTE sp_executesql @SQLString;
		print @SQLString;

		set @SQLString = N' dbcc shrinkdatabase (''' + DB_NAME() + ''', 10) ';
		EXECUTE sp_executesql @SQLString;
		print @SQLString;

		set @part_count = @part_count + 1;

		if (@part_count > @partition_count) or (@partition_count = 0)
		begin
			break;
		end;

		fetch cr_partitions into @ilosc, @year, @month, @year_month;
	end

	close cr_partitions
	deallocate cr_partitions
	
	set @SQLString = N' alter view partition_view as ';
	
	declare part_cr cursor for
	select name from ted_transactions
	order by year, month;
	
	declare @name varchar(200);

	open part_cr;
	fetch part_cr into @name;

	set @part_count = 1;
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
	
	select * from ted_transactions
	order by year, month