
	ALTER procedure [dbo].[sp_day_work] 
	    @isInCarMode integer, 
	    @car_or_driver_no integer, 
	    @start datetime, 
	    @stop datetime, 
	    @id_progress bigint, 
		@calculate_fuel integer = 0, 
		@show_only_last_day_route integer = 0, 
		@DoNotShowEmptyTracks integer = 0, 
	   	@with_gps integer = 0, 
		@kosztPaliwa numeric(10, 3) = 0.0, 
		@no_cache integer = 1 
	as 
		declare @DoNotShowEmptyTracks2 integer 
		set @DoNotShowEmptyTracks2 = @DoNotShowEmptyTracks 
		declare @car_or_driver_no2 integer 
		declare @start2 datetime 
		declare @stop2 datetime 
	    declare @stan integer 
	    declare @tmp integer 
	    declare @tmp2 integer 
	    declare @tmp3 integer 
	    declare @i integer 
	    declare @roznica datetime 
	    declare @czas_10 datetime 
	    declare @car_no integer 
	    declare @last_kierowca varchar(200) 
	    declare @last_lastkierowca varchar(200) 
		declare @last_kierowca123 varchar(200) 
	    declare @last_groupid integer 
 
	    declare @id integer 
	    declare @evb1 integer 
	    declare @evb2 integer 
	    declare @evb3 integer 
	    declare @evb4 integer 
	    declare @evb5 integer 
	    declare @evb6 integer 
	    declare @evb7 integer 
	    declare @evb8 integer 
	    declare @evb9 integer 
	    declare @evb10 integer 
	    declare @evdata datetime 
	    declare @rej_numb2 varchar(200) 
	    declare @name2 varchar(200) 
	    declare @car_no2 integer 
	    declare @kierowca2 varchar(200) 
	    declare @car_type2 integer 
 
	    declare @tmpdatetime datetime 
	    declare @tmpdatetime2 datetime 
 
	    declare @first_event_datetime_db datetime 
	    declare @last_event_datetime_db datetime 
	    declare @first_event_datetime_cache datetime 
	    declare @last_event_datetime_cache datetime 
 
	    declare @przesuniecie integer 
 
	    declare @tmpnumeric numeric(10, 3) 
	    declare @tmpinteger integer 
 
	    declare @start_praca_tmp datetime 
	    declare @stop_praca_tmp datetime 
	    declare @start_postoj_tmp datetime 
	    declare @stop_postoj_tmp datetime 
	    declare @old_droga_tmp numeric(10, 3) 
	    declare @old_jalowy_tmp numeric(10, 3) 
	    declare @jalowy_tmp numeric(10, 3) 
	    declare @droga_tmp numeric(10, 3) 
	    declare @ile_postoj_tmp varchar(20) 
	    declare @ile_praca_tmp varchar(20) 
	    declare @ile_jalowy_tmp varchar(20) 
	    declare @dzien varchar(5) 
 
		declare @szerokosc varchar(30) 
		declare @dlugosc varchar(30) 
 
		declare @szerokosc0 varchar(30) 
		declare @dlugosc0 varchar(30) 
 
		declare @obroty numeric(10, 3) 
		declare @obroty_count integer 
 
 
		declare @srednio_km numeric(10, 1) 
		declare @srednio_h numeric(10, 1) 
		DECLARE	@first_1bak numeric(10, 3), 
				@last_1bak numeric(10, 3), 
				@first_2bak numeric(10, 3), 
				@last_2bak numeric(10, 3), 
				@droga123 numeric(10, 3), 
				@jalowy int; 
		declare @sonda_all_tank numeric(10, 3) 
		declare @ZuzycieSum numeric(10, 3) 
		declare @ZuzycieSum_route numeric(10, 3) 
		declare @sonda numeric(10, 3) 
 
		set @szerokosc0 = null 
		set @dlugosc0 = null 
		set @szerokosc = null 
		set @dlugosc = null 
 
	    create table #eksport_day_work 
	    ( 
	        id integer not null identity (1,1), 
			evb2 integer, 
	        dzien varchar(5), 
	        data datetime, 
	        week integer, 
	        month integer, 
	        przebieg numeric(10, 3) not null, 
	        opis varchar(200), 
	        ile_praca varchar(20) not null, 
	        ile_praca_sek integer not null, 
	        ile_postoj varchar(20), 
	        ile_postoj_sek integer not null, 
	        ile_jalowy varchar(20) not null, 
	        ile_jalowy_sek integer not null, 
	        marka_pojazdu varchar(250), 
	        nr_rej_pojazdu varchar(200), 
	        kierowca varchar(100), 
	        start_praca datetime not null, 
	        stop_praca datetime not null, 
	        start_postoj datetime not null, 
	        stop_postoj datetime, 
			summary_przebieg_day numeric(10, 3) not null, 
			summary_przebieg_week numeric(10, 3) not null, 
			summary_przebieg_month numeric(10, 3) not null, 
			summary_przebieg_all numeric(10, 3) not null, 
 
			summary_praca_day varchar(20) not null, 
			summary_praca_week varchar(20) not null, 
			summary_praca_month varchar(20) not null, 
			summary_praca_all varchar(20) not null, 
 
			summary_postoj_day varchar(20) not null, 
			summary_postoj_week varchar(20) not null, 
			summary_postoj_month varchar(20) not null, 
			summary_postoj_all varchar(20) not null, 
 
			summary_jalowy_day varchar(20) not null, 
			summary_jalowy_week varchar(20) not null, 
			summary_jalowy_month varchar(20) not null, 
			summary_jalowy_all varchar(20) not null, 
 
			summary_paliwo_srednio_km_day numeric(10, 1) not null, 
			summary_paliwo_srednio_km_week numeric(10, 1) not null, 
			summary_paliwo_srednio_km_month numeric(10, 1) not null, 
			summary_paliwo_srednio_km_all numeric(10, 1) not null, 
 
			summary_paliwo_srednio_h_day numeric(10, 1) not null, 
			summary_paliwo_srednio_h_week numeric(10, 1) not null, 
			summary_paliwo_srednio_h_month numeric(10, 1) not null, 
			summary_paliwo_srednio_h_all numeric(10, 1) not null, 
 
			summary_paliwo_koszt numeric(10, 2) not null, 
 
	        group_id integer, 
			ulica_start varchar(50), 
			ulica_stop varchar(50), 
			szerokosc0 varchar(30), 
			dlugosc0 varchar(30), 
			szerokosc varchar(30), 
			dlugosc varchar(30), 
 
			srednio_km numeric(10, 1) not null, 
			srednio_h numeric(10, 1) not null, 
 
			first_1bak numeric(10, 3) not null, 
			last_1bak numeric(10, 3) not null, 
			first_2bak numeric(10, 3) not null, 
			last_2bak numeric(10, 3) not null, 
			tank_sum numeric(10, 3) not null, 
			ZuzycieSum numeric(10, 3) not null, 
			ZuzycieSum_day numeric(10, 3) not null, 
			ZuzycieSum_week numeric(10, 3) not null, 
			ZuzycieSum_month numeric(10, 3) not null, 
			ZuzycieSum_all numeric(10, 3) not null, 
 			ZuzycieSum_all_route numeric(10, 3) not null, 
			
			first_event_datetime datetime, 
			last_event_datetime datetime, 
			srednie_obroty numeric(10, 3), 
			count122 integer, 
	        primary key(id) 
	    ); 
 
 
	    create table #paliwo_wynik2 
	    ( 
	        id integer not null identity(1, 1), 
	        _117 datetime, 
	        _118 datetime, 
	        sonda numeric(10, 3), 
	        from_sonda numeric(10, 3), 
	        from_sonda_pal numeric(10, 3), 
	        to_sonda numeric(10, 3), 
	        to_sonda_pal numeric(10, 3), 
	        from_sonda2 numeric(10, 3), 
	        from_sonda2_pal numeric(10, 3), 
	        to_sonda2 numeric(10, 3), 
	        to_sonda2_pal numeric(10, 3), 
	        was_15 integer, 
	        czy_dynamiczny integer, 
	        primary key(id) 
	    ) 
 
	    create index eksport_day_work_index on 
	        #eksport_day_work(evb2, dzien, week, month, group_id) 
 
	--	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[#zmienne]') AND type in (N'U')) 
	--		DROP TABLE [dbo].[#zmienne] 
 
	    create table #zmienne 
	    ( 
	        id integer not null identity (1,1), 
	        car_no integer, 
	        last85 datetime, 
	        last49_115 datetime, 
	        start_praca datetime, 
	        stop_praca datetime, 
	        start_postoj datetime, 
	        stop_postoj datetime, 
	        last_last85 datetime, 
	        last_last49_115 datetime, 
	        old_droga numeric(10, 3), 
	        droga numeric(10, 3), 
	        jalowy integer, 
	        old_jalowy integer, 
	        tmp_jalowy integer, 
			first_event_datetime_db datetime, 
			last_event_datetime_db datetime, 
			first_event_datetime_cache datetime, 
			last_event_datetime_cache datetime, 
			obroty numeric(10, 3), 
			obroty_count integer, 
			old_obroty numeric(10, 3), 
			old_obroty_count integer, 
			count122 integer, 
			old_count122 integer, 
			primary key(id) 
	    ); 
 
		set @start2 = DATEADD(month, -1, @start) 
		set @stop2 = DATEADD(month, 1, @stop) 
		
--		exec check_partition_lower_range @actual_needed_lower_range=@start
 
		if @car_or_driver_no <> 0 
		begin 
			if @isInCarMode = 1 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.date), max(t1.date) 
					from device_data t1 
					left join car_change t2 
						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
							   and (t1.date <= t2.end_date or t2.end_date is null)) 
					left join driver t3 
						on (t3.id_driver = t2.id_driver) 
					left join car t4 
						on (t1.evb2 = t4.id_car) 
					where t1.evb2 = @car_or_driver_no and t1.date >= @start2 and t1.date <= @stop2 
					and (t1.evb3 = 115 or t1.evb3 = 49 or 
							t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) 
					group by t1.evb2 
			end 
			else 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.date), max(t1.date) 
					from device_data t1 inner join car_change t2 
						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
									   and (t1.date <= t2.end_date or t2.end_date is null)) 
					inner join car t3 on (t2.id_car = t3.id_car) 
					left join driver t4 on (t2.id_driver = t4.id_driver) 
					where t2.id_driver = @car_or_driver_no and t1.date >= @start2 
						 and t1.date <= @stop2 
						and (evb3 = 115 or evb3 = 49 or evb3 = 10 
								 or evb3 = 15 or evb3 = 122) 
					group by t1.evb2 
			end 
		end 
		else 
		begin 
			if @isInCarMode = 1 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.date), max(t1.date) 
					from device_data t1 
					left join car_change t2 
						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
							   and (t1.date <= t2.end_date or t2.end_date is null)) 
					left join driver t3 
						on (t3.id_driver = t2.id_driver) 
					left join car t4 on (t1.evb2 = t4.id_car) 
					where t1.date >= @start2 and t1.date <= @stop2 
					and (t1.evb3 = 115 or t1.evb3 = 49 or 
							t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) 
					group by t1.evb2 
			end 
			else 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.date), max(t1.date) 
					from device_data t1 inner join car_change t2 
						on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
									   and (t1.date <= t2.end_date or t2.end_date is null)) 
					inner join car t3 on (t2.id_car = t3.id_car) 
					left join driver t4 on (t2.id_driver = t4.id_driver) 
					where t1.date >= @start2 
						 and t1.date <= @stop2 
						and (evb3 = 115 or evb3 = 49 or evb3 = 10 
									 or evb3 = 15 or evb3 = 122) 
					group by t1.evb2 
			end 
		end 
 
	    open zdarzenia_cr2 
	    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_db, @last_event_datetime_db 
	    while (@@fetch_status <> -1) 
	    begin 
	        select @tmpinteger = id from #zmienne where car_no = @car_no 
	        if @tmpinteger is null 
	            insert into #zmienne (car_no) values(@car_no) 
 
	        update #zmienne set first_event_datetime_db = @first_event_datetime_db, last_event_datetime_db = @last_event_datetime_db where car_no = @car_no 
 
		    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_db, @last_event_datetime_db 
	    end 
	    close zdarzenia_cr2 
	    deallocate zdarzenia_cr2 
 
		if @car_or_driver_no <> 0 
		begin 
			if @isInCarMode = 1 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime 
				from cache_day_work t1 
				left join car_change t2 
					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date 
						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) 
				where t1.evb2 = @car_or_driver_no 
				group by t1.evb2 
			end 
			else 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime 
				from cache_day_work t1 
				inner join car_change t2 
					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date 
						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) 
				where t2.id_driver = @car_or_driver_no 
				group by t1.evb2 
			end 
		end 
		else 
		begin 
			if @isInCarMode = 1 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime 
				from cache_day_work t1 
				left join car_change t2 
					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date 
						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) 
				group by t1.evb2 
			end 
			else 
			begin 
				declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
				for select t1.evb2, min(t1.first_event_datetime) first_event_datetime, max(t1.last_event_datetime) last_event_datetime 
				from cache_day_work t1 
				inner join car_change t2 
					on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date 
						   and (t1.start_praca <= t2.end_date or t2.end_date is null)) 
				group by t1.evb2 
			end 
		end 
 
	    open zdarzenia_cr2 
	    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_cache, @last_event_datetime_cache 
	    while (@@fetch_status <> -1) 
	    begin 
	        select @tmpinteger = id from #zmienne where car_no = @car_no 
	        if @tmpinteger is null 
	            insert into #zmienne (car_no) values(@car_no) 
 
	        update #zmienne set first_event_datetime_cache = @first_event_datetime_cache, last_event_datetime_cache = @last_event_datetime_cache where car_no = @car_no 
 
		    fetch zdarzenia_cr2 into @car_no, @first_event_datetime_cache, @last_event_datetime_cache 
	    end 
	    close zdarzenia_cr2 
	    deallocate zdarzenia_cr2 
 
	    select @id = id, @last_event_datetime_cache = last_event_datetime_cache from #zmienne 
	    where not (first_event_datetime_cache is not null and 
				   last_event_datetime_cache is not null and 
				   first_event_datetime_cache <= first_event_datetime_db and 
				   last_event_datetime_cache >= last_event_datetime_db ) 
 
		if @id is null and @no_cache = 0 
		begin 
			update cache_day_work set ulica_start = 
			( 
				select top 1 t2.street from street t2 where evb2 = t2.id_car and  start_praca = t2._datetime 
			) 
			where ulica_start is null 
 
			declare @max_id integer 
			select @max_id = max(id) from #eksport_day_work 
 
			update cache_day_work set ulica_stop = 
			( 
				select top 1 t2.street from street t2 where evb2 = t2.id_car and  stop_praca = t2._datetime 
			) 
			where id = @max_id and ulica_stop is null 
 
			declare raport_kursor cursor   for 
				select t1.id, t1.ulica_start, t1.ulica_stop 
				from cache_day_work t1 
				where t1.ulica_stop is null 
				order by t1.id desc 
				for update of t1.ulica_stop 
			open raport_kursor 
 
			declare @ulica_start_old varchar(50); 
			declare @ulica_start varchar(50); 
			declare @ulica_stop varchar(50); 
 
			set @ulica_start_old = ''; 
 
			fetch raport_kursor into @id, @ulica_start, @ulica_stop 
			while (@@fetch_status <> -1) 
			begin 
				if @ulica_start_old <> '' 
				begin 
					update cache_day_work set ulica_stop = @ulica_start_old where id = @id; 
				end 
				set @ulica_start_old = @ulica_start; 
				fetch raport_kursor into @id, @ulica_start, @ulica_stop 
			end 
			close raport_kursor 
			deallocate raport_kursor 
 
			if @isInCarMode = 1 
			begin 
				select * from cache_day_work 
				where (stop_praca > @start) and (start_praca < @stop) 
				   and (evb2 = @car_or_driver_no) 
				order by id 
			end 
			else 
			begin 
				select * from cache_day_work t1 
					inner join car_change t2 
						on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date 
									   and (t1.start_praca <= t2.end_date or t2.end_date is null)) 
			    where (stop_praca > @start) and (t1.start_praca < @stop) 
				   and (t2.id_driver = @car_or_driver_no) 
				order by id 
			end 
		end 
		else 
		begin 
			select @show_only_last_day_route = 0 
	        select @DoNotShowEmptyTracks = 0 
	        select @kosztPaliwa = 0 
 
	        select @przesuniecie = 0 
 
	        if @no_cache = 1 or @no_cache = 2 
	        begin 
				select @car_or_driver_no2 = @car_or_driver_no 
				set @start2 = DATEADD(month, -1, @start) 
				set @stop2 = DATEADD(month, 1, @stop) 
	        end 
	        else 
			if @last_event_datetime_cache is null 
			begin 
				select @car_or_driver_no2 = @car_or_driver_no 
	--			select @car_or_driver_no = 0 
				if @start > cast('2010-06-01' as datetime) 
				begin 
					select @start2 = cast('2010-06-01' as datetime) 
				end 
				else 
				begin 
					select @start2 = @start 
				end 
			end 
			else 
			begin 
				select @car_or_driver_no2 = @car_or_driver_no 
				select @start2 = @last_event_datetime_cache 
				select @przesuniecie = 2 
			end 
 
			set @last_kierowca123 = '' 
 
			declare @num_records integer 
			if @car_or_driver_no <> 0 
			begin 
				if @isInCarMode = 1 
				begin 
					declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, 
						t1.evb8, t1.evb9, t1.evb10, t1.date, null, null, null, 
						t3.driver_name kierowca, t4.use_motohours, 
					    t4.RPM_OBRO, t4.RPM_DISP, t4.RPM_STAT 
						from device_data t1 
						left join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
								   and (t1.date <= t2.end_date or t2.end_date is null)) 
						left join driver t3 
							on (t3.id_driver = t2.id_driver) 
						left join car t4 on (t1.evb2 = t4.id_car) 
						where t1.evb2 = @car_or_driver_no and t1.date >= @start2 and t1.date <= @stop2 
						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or 
								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) 
						order by t1.id_device_data 
					select @num_records = count(*) 
						from device_data t1 
						left join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
								   and (t1.date <= t2.end_date or t2.end_date is null)) 
						left join driver t3 
							on (t3.id_driver = t2.id_driver) 
						left join car t4 on (t1.evb2 = t4.id_car) 
						where t1.evb2 = @car_or_driver_no and t1.date >= @start2 and t1.date <= @stop2 
						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or 
								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) 
				end 
				else 
				begin 
					declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, 
						t1.evb8, t1.evb9, t1.evb10, t1.date, t3.rej_numb, t3.name, t2.id_car_change, 
								   t4.driver_name kierowca, t3.use_motohours, 
								   t3.RPM_OBRO, t3.RPM_DISP, t3.RPM_STAT 
						from device_data t1 inner join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
										   and (t1.date <= t2.end_date or t2.end_date is null)) 
						inner join car t3 on (t2.id_car = t3.id_car) 
						left join driver t4 on (t2.id_driver = t4.id_driver) 
						where t2.id_driver = @car_or_driver_no and t1.date >= @start2 
							 and t1.date <= @stop2 
							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 
										 or evb3 = 15 or evb3 = 122) 
						order by t2.start_date, t2.id_car, t1.id_device_data 
					select @num_records = count(*) 
						from device_data t1 inner join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
										   and (t1.date <= t2.end_date or t2.end_date is null)) 
						inner join car t3 on (t2.id_car = t3.id_car) 
						left join driver t4 on (t2.id_driver = t4.id_driver) 
						where t2.id_driver = @car_or_driver_no and t1.date >= @start2 
							 and t1.date <= @stop2 
							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 
										 or evb3 = 15 or evb3 = 122) 
				end 
			end 
			else 
			begin 
				if @isInCarMode = 1 
				begin 
					declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, 
						t1.evb8, t1.evb9, t1.evb10, t1.date, null, null, null, 
						t3.driver_name kierowca, t4.use_motohours, 
								   t4.RPM_OBRO, t4.RPM_DISP, t4.RPM_STAT 
						from device_data t1 
						left join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
								   and (t1.date <= t2.end_date or t2.end_date is null)) 
						left join driver t3 
							on (t3.id_driver = t2.id_driver) 
						left join car t4 on (t1.evb2 = t4.id_car) 
						where t1.date >= @start2 and t1.date <= @stop2 
						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or 
								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) 
						order by t1.evb2, t1.id_device_data 
					select @num_records = count(*) 
						from device_data t1 
						left join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
								   and (t1.date <= t2.end_date or t2.end_date is null)) 
						left join driver t3 
							on (t3.id_driver = t2.id_driver) 
						left join car t4 on (t1.evb2 = t4.id_car) 
						where t1.date >= @start2 and t1.date <= @stop2 
						and (t1.evb3 = 85 or t1.evb3 = 115 or t1.evb3 = 49 or 
								t1.evb3 = 10 or t1.evb3 = 15 or t1.evb3 = 122) 
				end 
				else 
				begin 
					declare zdarzenia_cr2 cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, 
						t1.evb8, t1.evb9, t1.evb10, t1.date, t3.rej_numb, t3.name, t2.id_car_change, 
								   t4.driver_name kierowca, t3.use_motohours, 
								   t3.RPM_OBRO, t3.RPM_DISP, t3.RPM_STAT 
						from device_data t1 inner join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
										   and (t1.date <= t2.end_date or t2.end_date is null)) 
						inner join car t3 on (t2.id_car = t3.id_car) 
						left join driver t4 on (t2.id_driver = t4.id_driver) 
						where t1.date >= @start2 
							 and t1.date <= @stop2 
							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 
										 or evb3 = 15 or evb3 = 122) 
						order by t2.start_date, t2.id_car, t1.id_device_data 
					select @num_records = count(*) 
						from device_data t1 inner join car_change t2 
							on (t1.evb2 = t2.id_car and t1.date >= t2.start_date 
										   and (t1.date <= t2.end_date or t2.end_date is null)) 
						inner join car t3 on (t2.id_car = t3.id_car) 
						left join driver t4 on (t2.id_driver = t4.id_driver) 
						where t1.date >= @start2 
							 and t1.date <= @stop2 
							and (evb3 = 85 or evb3 = 115 or evb3 = 49 or evb3 = 10 
										 or evb3 = 15 or evb3 = 122) 
				end 
			end 
 
			declare @record_index integer 
			declare @record_step integer 
 
			set @record_index = 1 
			set @record_step = 10 
 
			select @car_no = 0 
 
			select @czas_10 = null 
			select @last_groupid = 0 
 
			declare @RPM_STAT bit 
			declare @RPM_DISP integer 
			declare @RPM_OBRO integer 
			declare @last_evdata datetime 
			declare @sekundy integer 
			declare @impulsy integer 
 
			open zdarzenia_cr2 
			fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
					@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, 
					@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT 
 
			declare @canceled bit 
			declare @w_czasie_jazdy integer 
			set @w_czasie_jazdy = 0 
			set @canceled = 0 
			set @last_evdata = null 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				while((@przesuniecie > 0) and (@@fetch_status <> -1)) 
				begin 
					select @przesuniecie = @przesuniecie - 1 
					fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
						@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, 
						@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT 
				end 
 
				select @car_no = @evb2 
 
				select @tmpinteger = id from #zmienne where car_no = @car_no 
				if @tmpinteger is null 
					insert into #zmienne (car_no) values(@car_no) 
 
				select @tmpdatetime = start_postoj from #zmienne 
					where car_no = @car_no 
				if @tmpdatetime is null 
					update #zmienne set start_postoj = @evdata where car_no = @car_no 
				select @tmpdatetime = start_praca from #zmienne 
					where car_no = @car_no 
				if @tmpdatetime is null 
					update #zmienne set start_praca = @evdata where car_no = @car_no 
 
				if @evb3 <> 85 and @evb3 <> 117 and @evb3 <> 217 
				begin 
					update #zmienne set first_event_datetime_db = @evdata where car_no = @car_no and first_event_datetime_db is null 
					update #zmienne set last_event_datetime_db = @evdata where car_no = @car_no 
				end 
 
				if @evb3 = 122 
				begin 
				    print @evdata; 
 
					set @impulsy = @evb1 * 256 * 256 + 
								   @evb9 * 256 + 
							       @evb10 
 
					if (@last_evdata is not null) and (@RPM_STAT = 1) 
					begin 
						set @sekundy = DATEDIFF(second, @last_evdata, @evdata); 
						if (@sekundy <> 0) and (@RPM_DISP <> 0) and (@RPM_STAT = 1) and (@impulsy <> 0) 
						begin 
							update #zmienne set obroty = 0.0 where car_no = @car_no and obroty is null 
							update #zmienne set obroty_count = 0 where car_no = @car_no and obroty_count is null 
 
							update #zmienne set obroty = obroty + (@impulsy / @sekundy * @RPM_OBRO / @RPM_DISP) where car_no = @car_no 
							update #zmienne set obroty_count = obroty_count + 1 where car_no = @car_no 
						end 
					end 
					set @last_evdata = @evdata 
				end 
 
				if @evb3 = 10 
				begin 
					set @last_evdata = @evdata 
					select @czas_10 = @evdata 
					set @w_czasie_jazdy = 1 
					update #zmienne set obroty = 0.0 where car_no = @car_no 
					update #zmienne set obroty_count = 0 where car_no = @car_no 
				end 
 
				if @evb3 = 85 
				begin 
					set @w_czasie_jazdy = 0 
					select @tmpdatetime = last49_115 from #zmienne 
						where car_no = @car_no 
					if (@tmpdatetime < @czas_10) or (@tmpdatetime is null) 
					begin 
						update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no 
						update #zmienne set last49_115 = @evdata where car_no = @car_no 
					end 
 
					select @tmpdatetime = last85 from #zmienne 
						where car_no = @car_no 
					update #zmienne set last_last85 = @tmpdatetime where car_no = @car_no 
					update #zmienne set last85 = @evdata where car_no = @car_no 
 
					select @tmpnumeric = droga from #zmienne 
						where car_no = @car_no 
					update #zmienne set old_droga = @tmpnumeric where car_no = @car_no 
					execute spDroga @car_no, @evb9, @evb10, @tmpnumeric OUTPUT 
					update #zmienne set droga = @tmpnumeric where car_no = @car_no 
 
					select @tmpinteger = jalowy from #zmienne 
						where car_no = @car_no 
					update #zmienne set old_jalowy = @tmpinteger where car_no = @car_no 
					update #zmienne set jalowy = @evb1 * 256 + @evb4 where car_no = @car_no 
 
					select @last_lastkierowca = isnull(@last_kierowca, '') 
					select @last_kierowca = isnull(@kierowca2, '') 
 
					select @stan = 1 
				end 
				else 
				if (@evb3 = 49) or (@evb3 = 115) 
				begin 
					select @tmpdatetime = last49_115 from #zmienne 
						where car_no = @car_no 
					update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no 
					update #zmienne set last49_115 = @evdata where car_no = @car_no 
 
					select @stan = 2 
				end 
				else 
				begin 
					select @stan = 0 
				end 
 
				if (@evb3 = 15) and (@w_czasie_jazdy = 1) 
				begin 
				  set @id = null 
					select top 1 @id = id_device_data, @evb1 = evb1, @evb10 = evb10, @evdata = date from device_data 
						where evb2 = @evb2 and evb3 = 113 and date <= @evdata and date >= @czas_10 
						order by id_device_data desc 
					if @id is not null 
					begin 
						select @tmpdatetime = last49_115 from #zmienne 
							where car_no = @car_no 
						update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no 
						update #zmienne set last49_115 = @evdata where car_no = @car_no 
 
						set @w_czasie_jazdy = 0 
						select @tmpdatetime = last49_115 from #zmienne 
							where car_no = @car_no 
						if (@tmpdatetime < @czas_10) or (@tmpdatetime is null) 
						begin 
							update #zmienne set last_last49_115 = @tmpdatetime where car_no = @car_no 
							update #zmienne set last49_115 = @evdata where car_no = @car_no 
						end 
 
						select @tmpdatetime = last85 from #zmienne 
							where car_no = @car_no 
						update #zmienne set last_last85 = @tmpdatetime where car_no = @car_no 
						update #zmienne set last85 = @czas_10 where car_no = @car_no 
 
						select @tmpnumeric = droga from #zmienne 
							where car_no = @car_no 
						update #zmienne set old_droga = @tmpnumeric where car_no = @car_no 
						execute spDroga @car_no, @evb1, @evb10, @tmpnumeric OUTPUT 
						update #zmienne set droga = @tmpnumeric where car_no = @car_no 
 
						select @tmpinteger = jalowy from #zmienne 
							where car_no = @car_no 
						update #zmienne set old_jalowy = @tmpinteger where car_no = @car_no 
						update #zmienne set jalowy = 0 where car_no = @car_no 
 
						select @last_lastkierowca = isnull(@last_kierowca, '') 
						select @last_kierowca = isnull(@kierowca2, '') 
 
						select @stan = 1 
					end; 
				end 
 
				if (@stan = 1) 
				begin 
					select @tmpdatetime = last_last85 from #zmienne 
						where car_no = @car_no 
					select @tmpdatetime2 = last_last49_115 from #zmienne 
						where car_no = @car_no 
 
					if (@tmpdatetime is null) or (@tmpdatetime2 is null) 
					begin 
						fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
								@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, 
								@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT 
 
						continue 
					end 
 
					select @tmpdatetime = last_last85 from #zmienne 
						where car_no = @car_no 
					update #zmienne set start_praca = @tmpdatetime where car_no = @car_no 
					select @tmpdatetime = last_last49_115 from #zmienne 
						where car_no = @car_no 
					update #zmienne set stop_praca = @tmpdatetime where car_no = @car_no 
					update #zmienne set start_postoj = @tmpdatetime where car_no = @car_no 
					select @tmpdatetime = last85 from #zmienne 
						where car_no = @car_no 
					update #zmienne set stop_postoj = @tmpdatetime where car_no = @car_no 
 
					select @start_praca_tmp = start_praca from #zmienne 
						where car_no = @car_no 
					select @stop_praca_tmp = stop_praca from #zmienne 
						where car_no = @car_no 
					select @start_postoj_tmp = start_postoj from #zmienne 
						where car_no = @car_no 
					select @stop_postoj_tmp = stop_postoj from #zmienne 
						where car_no = @car_no 
					select @old_droga_tmp = old_droga from #zmienne 
						where car_no = @car_no 
 
					select @tmp = DATEDIFF(second, @start_postoj_tmp, @stop_postoj_tmp) 
					if @tmp = 0 
						select @tmp = 60 
					if @tmp < 0 
						select @tmp = 0 
					set @ile_postoj_tmp = dbo.spGetGGMMf(@tmp); 
 
					select @tmp2 = DATEDIFF(second, @start_praca_tmp, @stop_praca_tmp) 
					if @tmp2 = 0 
						select @tmp2 = 60 
					set @ile_praca_tmp = dbo.spGetGGMMf(@tmp2); 
 
					select @old_jalowy_tmp = old_jalowy from #zmienne 
						where car_no = @car_no 
					if @old_jalowy_tmp > @tmp2 
						select @old_jalowy_tmp = @tmp2 
					set @ile_jalowy_tmp = dbo.spGetGGMMf(@old_jalowy_tmp); 
 
					set @dzien = dbo.spNazwaDnia_f(@start_praca_tmp); 
 
					select @tmp3 = DATEPART(week, @start_praca_tmp) 
					if DATEPART(weekday, @start_praca_tmp) = 1 
						select @tmp3 = @tmp3 - 1 
 
					if not((@DoNotShowEmptyTracks = 1) and 
						  (@old_droga_tmp < 0.00001) ) 
					begin 
						if (@last_lastkierowca <> @last_kierowca123) 
						begin 
							set @last_groupid = @last_groupid + 1 
							set @last_kierowca123 = @last_lastkierowca 
						end 
 
						select @first_event_datetime_db = first_event_datetime_db, @last_event_datetime_db = last_event_datetime_db from #zmienne 
							where car_no = @car_no 
 
						select @obroty = old_obroty, 
							   @obroty_count = old_obroty_count from #zmienne 
							where car_no = @car_no 
 
						if @obroty is null 
							set @obroty = 0.0 
						if @obroty_count is null 
							set @obroty_count = 0 
 
						update #zmienne 
							set old_obroty = obroty, 
							    old_obroty_count = obroty_count 
							where car_no = @car_no 
 
						if @obroty_count > 0 
						begin 
							set @obroty = @obroty / @obroty_count 
						end 
						else 
						begin 
							set @obroty = 0.0 
						end 
 
						insert into #eksport_day_work (evb2, marka_pojazdu, nr_rej_pojazdu, kierowca, 
							opis, start_praca, stop_praca, start_postoj, stop_postoj, przebieg, 
							group_id, ile_postoj, ile_praca, ile_jalowy, data, dzien, 
							ile_postoj_sek, ile_praca_sek, ile_jalowy_sek, 
							week, month, szerokosc, dlugosc, szerokosc0, dlugosc0, 
							first_event_datetime, last_event_datetime, srednie_obroty, count122, 
							summary_przebieg_day, 
							summary_przebieg_week, 
							summary_przebieg_month, 
							summary_przebieg_all, 
							summary_praca_day, 
							summary_praca_week, 
							summary_praca_month, 
							summary_praca_all, 
							summary_postoj_day, 
							summary_postoj_week, 
							summary_postoj_month, 
							summary_postoj_all, 
							summary_jalowy_day, 
							summary_jalowy_week, 
							summary_jalowy_month, 
							summary_jalowy_all, 
							summary_paliwo_srednio_km_day, 
							summary_paliwo_srednio_km_week, 
							summary_paliwo_srednio_km_month, 
							summary_paliwo_srednio_km_all, 
							summary_paliwo_srednio_h_day, 
							summary_paliwo_srednio_h_week, 
							summary_paliwo_srednio_h_month, 
							summary_paliwo_srednio_h_all, 
							summary_paliwo_koszt, 
							srednio_km, 
							srednio_h, 
							first_1bak, 
							last_1bak, 
							first_2bak, 
							last_2bak, 
							tank_sum, 
							ZuzycieSum,  
							ZuzycieSum_day, 
							ZuzycieSum_week, 
							ZuzycieSum_month,  
							ZuzycieSum_all,
							ZuzycieSum_all_route) 
							values(@car_no, '', '', @last_lastkierowca, '', 
							@start_praca_tmp, @stop_praca_tmp, @start_postoj_tmp, 
							@stop_postoj_tmp, @old_droga_tmp, @last_groupid, @ile_postoj_tmp, 
							@ile_praca_tmp, @ile_jalowy_tmp, 
							cast(STR(MONTH(@start_praca_tmp)) + '/' + 
								 STR(DAY(@start_praca_tmp)) + '/' + 
								 STR(YEAR(@start_praca_tmp)) as datetime), 
							@dzien, @tmp, @tmp2, FLOOR(@old_jalowy_tmp / 60) * 60, 
							DATEPART(year, @start_praca_tmp) * 100 + @tmp3, 
							DATEPART(year, @start_praca_tmp) * 100 + 
								DATEPART(month, @start_praca_tmp), @szerokosc, @dlugosc, @szerokosc0, @dlugosc0, 
							@first_event_datetime_db, @last_event_datetime_db, @obroty, @obroty_count, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); 
						update #zmienne set obroty = 0.0 where car_no = @car_no 
						update #zmienne set obroty_count = 0 where car_no = @car_no 
					end 
					set @dlugosc0 = @dlugosc 
					set @szerokosc0 = @szerokosc 
				end 
 
				if (@record_index % @record_step = 0) 
					exec sp_progress_set @id_progress, @record_index, @num_records, @canceled output; 
				set @record_index = @record_index + 1 
 
				fetch zdarzenia_cr2 into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
						@evb8, @evb9, @evb10, @evdata, @rej_numb2, @name2, 
						@car_no2, @kierowca2, @car_type2, @RPM_OBRO, @RPM_DISP, @RPM_STAT 
 
			end 
			close zdarzenia_cr2 
			deallocate zdarzenia_cr2 
 
			if @car_no <> 0 
			begin 
 
				select @tmpdatetime = last85 from #zmienne 
					where car_no = @car_no 
				select @tmpdatetime2 = last49_115 from #zmienne 
					where car_no = @car_no 
 
				if (@tmpdatetime is not null) and (@tmpdatetime2 is not null) 
				begin 
					update #zmienne set start_praca = @tmpdatetime where car_no = @car_no 
					update #zmienne set stop_praca = @tmpdatetime2 where car_no = @car_no 
					update #zmienne set start_postoj = @tmpdatetime2 where car_no = @car_no 
 
					select @start_praca_tmp = start_praca from #zmienne 
						where car_no = @car_no 
					select @stop_praca_tmp = stop_praca from #zmienne 
						where car_no = @car_no 
					select @start_postoj_tmp = start_postoj from #zmienne 
						where car_no = @car_no 
					select @stop_postoj_tmp = stop_postoj from #zmienne 
						where car_no = @car_no 
					select @droga_tmp = droga from #zmienne 
						where car_no = @car_no 
 
					select @tmp = DATEDIFF(second, @start_postoj_tmp, @stop_postoj_tmp) 
					if @tmp = 0 
						select @tmp = 60 
					if @tmp < 0 
						select @tmp = 0 
					set @ile_postoj_tmp = dbo.spGetGGMMf(@tmp); 
 
					select @tmp2 = DATEDIFF(second, @start_praca_tmp, @stop_praca_tmp) 
					if @tmp2 = 0 
						select @tmp2 = 60 
					set @ile_praca_tmp = dbo.spGetGGMMf(@tmp2); 
 
					select @jalowy_tmp = jalowy from #zmienne 
						where car_no = @car_no 
					if @jalowy_tmp > @tmp2 
						select @jalowy_tmp = @tmp2 
					set @ile_jalowy_tmp = dbo.spGetGGMMf(@jalowy_tmp); 
 
					set @dzien = dbo.spNazwaDnia_f(@start_praca_tmp); 
 
					select @tmp3 = DATEPART(week, @start_praca_tmp) 
					if DATEPART(weekday, @start_praca_tmp) = 1 
						select @tmp3 = @tmp3 - 1 
 
					if not((@DoNotShowEmptyTracks = 1) and 
						  (@droga_tmp < 0.00001) ) 
					begin 
						if (@last_lastkierowca <> @last_kierowca123) 
						begin 
							set @last_groupid = @last_groupid + 1 
							set @last_kierowca123 = @last_lastkierowca 
						end 
 
						select @first_event_datetime_db = first_event_datetime_db, @last_event_datetime_db = last_event_datetime_db from #zmienne 
							where car_no = @car_no 
 
						select @obroty = old_obroty, 
							   @obroty_count = old_obroty_count from #zmienne 
							where car_no = @car_no 
 
						if @obroty is null 
							set @obroty = 0.0 
						if @obroty_count is null 
							set @obroty_count = 0 
 
						update #zmienne 
							set old_obroty = obroty, 
							    old_obroty_count = obroty_count 
							where car_no = @car_no 
 
 
						if @obroty_count > 0 
						begin 
							set @obroty = @obroty / @obroty_count 
						end 
						else 
						begin 
							set @obroty = 0.0 
						end 
 
						insert into #eksport_day_work (evb2, marka_pojazdu, nr_rej_pojazdu, kierowca, 
							opis, start_praca, stop_praca, start_postoj, stop_postoj, przebieg, 
							group_id, ile_postoj, ile_praca, ile_jalowy, data, dzien, 
							ile_postoj_sek, ile_praca_sek, ile_jalowy_sek, 
							week, month, szerokosc, dlugosc, szerokosc0, dlugosc0, 
							first_event_datetime, last_event_datetime, srednie_obroty, count122, 
							summary_przebieg_day, 
							summary_przebieg_week, 
							summary_przebieg_month, 
							summary_przebieg_all, 
							summary_praca_day, 
							summary_praca_week, 
							summary_praca_month, 
							summary_praca_all, 
							summary_postoj_day, 
							summary_postoj_week, 
							summary_postoj_month, 
							summary_postoj_all, 
							summary_jalowy_day, 
							summary_jalowy_week, 
							summary_jalowy_month, 
							summary_jalowy_all, 
							summary_paliwo_srednio_km_day, 
							summary_paliwo_srednio_km_week, 
							summary_paliwo_srednio_km_month, 
							summary_paliwo_srednio_km_all, 
							summary_paliwo_srednio_h_day, 
							summary_paliwo_srednio_h_week, 
							summary_paliwo_srednio_h_month, 
							summary_paliwo_srednio_h_all, 
							summary_paliwo_koszt, 
							srednio_km, 
							srednio_h, 
							first_1bak, 
							last_1bak, 
							first_2bak, 
							last_2bak, 
							tank_sum, 
							ZuzycieSum, 
							ZuzycieSum_day, 
							ZuzycieSum_week, 
							ZuzycieSum_month,  
							ZuzycieSum_all,
							ZuzycieSum_all_route) 
							values(@car_no, '', '', @last_lastkierowca, '', 
							@start_praca_tmp, @stop_praca_tmp, @start_postoj_tmp, 
							null, @droga_tmp, @last_groupid, null, 
							@ile_praca_tmp, @ile_jalowy_tmp, 
							cast(STR(MONTH(@start_praca_tmp)) + '/' + 
								 STR(DAY(@start_praca_tmp)) + '/' + 
								 STR(YEAR(@start_praca_tmp)) as datetime), 
							@dzien, 
							@tmp, @tmp2, FLOOR(@jalowy_tmp / 60) * 60, 
							DATEPART(year, @start_praca_tmp) * 100 + @tmp3, 
							DATEPART(year, @start_praca_tmp) * 100 + 
								DATEPART(month, @start_praca_tmp), @szerokosc, @dlugosc, 
							@szerokosc0, @dlugosc0, 
							@first_event_datetime_db, @last_event_datetime_db, @obroty, @obroty_count, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) 
						update #zmienne set obroty = 0.0 where car_no = @car_no 
						update #zmienne set obroty_count = 0 where car_no = @car_no 
					end 
					set @szerokosc0 = @szerokosc 
					set @dlugosc0 = @dlugosc 
				end 
			end 
 
	--		drop table #zmienne 
 
			declare @aggr_car_no integer 
			declare @aggr_start_praca datetime 
			declare @aggr_stop_praca datetime 
 
			if (@calculate_fuel = 1) 
			begin 
				declare aggr_cr5 cursor  LOCAL FAST_FORWARD
					for select evb2, min(start_praca), max(stop_praca) from #eksport_day_work 
					where (stop_praca > @start) and (start_praca < @stop) 
					and start_praca is not null and stop_praca is not null 
					group by evb2 
				open aggr_cr5 
 
				fetch aggr_cr5 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca 
				while (@@fetch_status <> -1) and (@canceled = 0) 
				begin 
					set	@first_1bak = 0 
					set	@last_1bak = 0 
					set	@first_2bak = 0 
					set	@last_2bak = 0 
					set	@droga123 = 0 
					set	@jalowy = 0 
 
					exec sp_progress_set @id_progress, 0, @num_records, @canceled output; 
 
					EXEC spTankowania @aggr_car_no, 
							@aggr_start_praca, @aggr_stop_praca, 
							@first_1bak OUTPUT, @last_1bak OUTPUT, 
							@first_2bak OUTPUT, @last_2bak OUTPUT, 
							@droga123 OUTPUT, @jalowy OUTPUT, @srednio_km OUTPUT, @srednio_h OUTPUT, 
							1, @id_progress 
 
					set @first_1bak = isnull(@first_1bak, 0.0) 
					set @first_2bak = isnull(@first_2bak, 0.0) 
					set @last_1bak = isnull(@last_1bak, 0.0) 
					set @last_2bak = isnull(@last_2bak, 0.0) 
					set @droga123 = isnull(@droga123, 0.0) 
					set @jalowy = isnull(@jalowy, 0) 
					declare @min_tank numeric(10, 3) 
					declare @min_ubytk numeric(10, 3) 
					select @min_tank = I_TANK from car where id_car = @aggr_car_no 
					select @min_ubytk = I_UP from car where id_car = @aggr_car_no 
 
					set @sonda_all_tank = 0.0 
					declare tankowania_kursor cursor  LOCAL FAST_FORWARD for 
						select sonda from #paliwo_wynik2 
					open tankowania_kursor 
					fetch tankowania_kursor into @sonda 
					while (@@fetch_status <> -1) and (@canceled = 0) 
					begin 
						if ((@sonda >= @min_tank) or (@sonda <= (-@min_ubytk))) 
								set @sonda_all_tank = @sonda_all_tank + isnull(@sonda, 0.0) 
						fetch tankowania_kursor into @sonda 
					end 
					close tankowania_kursor 
					deallocate tankowania_kursor 
					print @first_1bak 
					print @first_2bak 
					print @sonda_all_tank 
					print @last_1bak 
					print @last_2bak 
 
  
 					set @ZuzycieSum = @first_1bak + @first_2bak + @sonda_all_tank - @last_1bak - @last_2bak 
					set @ZuzycieSum_route = @first_1bak + @first_2bak + @ZuzycieSum - @last_1bak - @last_2bak 
 

 						print 'first_1bak: ' + cast(@first_1bak as varchar(20)) 
						print 'first_2bak: ' + cast(@first_2bak as varchar(20)) 
						print 'last_1bak: ' + cast(@last_1bak as varchar(20)) 
						print 'last_2bak: ' + cast(@last_2bak as varchar(20)) 
						print 'sonda_all_tank: ' + cast(@sonda_all_tank as varchar(20)) 
						print 'ZuzycieSum: ' + cast(@ZuzycieSum as varchar(20)) 
 
					set @srednio_km = CASE WHEN (@droga123 >= 0.5) THEN cast((@ZuzycieSum / @droga123 * 100) * 10 + 0.5 as integer) / 10.0 ELSE 0.0 END 
					set @srednio_h = CASE WHEN (DATEDIFF(minute, @aggr_start_praca, @aggr_stop_praca) >= 15) THEN cast((@ZuzycieSum / (cast(DATEDIFF(minute, @aggr_start_praca, @aggr_stop_praca) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0  ELSE 0.0 END 
 
 
					update #eksport_day_work set ZuzycieSum_all=@ZuzycieSum, 
												 ZuzycieSum_all_route=@ZuzycieSum_route, 
												 summary_paliwo_srednio_km_all=@srednio_km, 
												 summary_paliwo_srednio_h_all=@srednio_h, 
												 summary_paliwo_koszt=@kosztPaliwa * @ZuzycieSum 
						where evb2 = @aggr_car_no 
					fetch aggr_cr5 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca 
				end 
				close aggr_cr5 
				deallocate aggr_cr5 
			end 
 
 
			declare @group_id_aggr integer 
			declare @group_evb2 integer 
 
			declare aggr_cr cursor  LOCAL FAST_FORWARD
					for select evb2, data, group_id, sum(ZuzycieSum), sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), 
						sum(ile_jalowy_sek), 
						CASE WHEN sum(przebieg) >= 0.5 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / sum(przebieg) * 100) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END, 
					    CASE WHEN sum(DATEDIFF(minute, start_praca, stop_praca)) >= 15 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / (cast(sum(DATEDIFF(minute, start_praca, stop_praca)) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END 
						 from #eksport_day_work  left join car on (#eksport_day_work.evb2 = car.id_car)
						where (stop_praca > @start) and (start_praca < @stop) 
						group by evb2, data, group_id  
 
			print 'start: ' + cast(@start as varchar(30)) 
			print 'stop: ' + cast(@stop as varchar(30)) 
 
			declare @day_aggr datetime 
			declare @day_przebieg numeric(10, 3) 
			declare @day_zuzycie numeric(10, 3) 
			declare @day_praca_sek integer 
			declare @day_postoj_sek integer 
			declare @day_jalowy_sek integer 
 
 
			open aggr_cr 
			fetch aggr_cr into @group_evb2, @day_aggr, @group_id_aggr, @day_zuzycie, @day_przebieg, @day_praca_sek, @day_postoj_sek, @day_jalowy_sek, 
				@srednio_km, @srednio_h 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				print 'summary_paliwo_srednio_km_day'; 
				update #eksport_day_work set summary_przebieg_day=@day_przebieg, 
				               ZuzycieSum_day = @day_zuzycie, 
											 summary_praca_day=dbo.spGetGGMMf(@day_praca_sek), 
											 summary_postoj_day=dbo.spGetGGMMf(@day_postoj_sek), 
											 summary_jalowy_day=dbo.spGetGGMMf(@day_jalowy_sek), 
											 summary_paliwo_srednio_km_day = @srednio_km, 
											 summary_paliwo_srednio_h_day = @srednio_h 
 
					where data = @day_aggr and group_id = @group_id_aggr and evb2 = @group_evb2 
				fetch aggr_cr into @group_evb2, @day_aggr, @group_id_aggr, @day_zuzycie, @day_przebieg, @day_praca_sek, @day_postoj_sek, @day_jalowy_sek, @srednio_km, @srednio_h 
			end 
			close aggr_cr; 
			deallocate aggr_cr; 
 
 
			declare aggr_cr2 cursor  LOCAL FAST_FORWARD
					for select evb2, week, group_id, sum(ZuzycieSum), sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), 
						sum(ile_jalowy_sek), 
						CASE WHEN sum(przebieg) >= 0.5 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / sum(przebieg) * 100) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END, 
					    CASE WHEN sum(DATEDIFF(minute, start_praca, stop_praca)) >= 15 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / (cast(sum(DATEDIFF(minute, start_praca, stop_praca)) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END 
						from #eksport_day_work  left join car on (#eksport_day_work.evb2 = car.id_car)
						where (stop_praca > @start) and (start_praca < @stop) 
						group by evb2, week, group_id 
 
			declare @week_aggr integer 
			declare @week_przebieg numeric(10, 3) 
			declare @week_praca_sek integer 
			declare @week_zuzycie numeric(10, 3) 
			declare @week_postoj_sek integer 
			declare @week_jalowy_sek integer 
 
			open aggr_cr2 
			fetch aggr_cr2 into @group_evb2, @week_aggr, @group_id_aggr, @week_zuzycie, @week_przebieg, @week_praca_sek, @week_postoj_sek, 
				 @week_jalowy_sek, @srednio_km, @srednio_h 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				update #eksport_day_work set summary_przebieg_week=@week_przebieg, 
											 summary_praca_week=dbo.spGetGGMMf(@week_praca_sek), 
											 ZuzycieSum_week = @week_zuzycie, 
											 summary_postoj_week=dbo.spGetGGMMf(@week_postoj_sek), 
											 summary_jalowy_week=dbo.spGetGGMMf(@week_jalowy_sek), 
											 summary_paliwo_srednio_km_week = @srednio_km, 
											 summary_paliwo_srednio_h_week = @srednio_h 
					where week = @week_aggr and group_id = @group_id_aggr and evb2 = @group_evb2 
				fetch aggr_cr2 into @group_evb2, @week_aggr, @group_id_aggr, @week_zuzycie, @week_przebieg, @week_praca_sek, @week_postoj_sek, @week_jalowy_sek, @srednio_km, @srednio_h 
			end 
			close aggr_cr2; 
			deallocate aggr_cr2; 
 
 
			declare aggr_cr3 cursor  LOCAL FAST_FORWARD
					for select evb2, month, group_id, sum(ZuzycieSum), sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), 
						sum(ile_jalowy_sek), 
						CASE WHEN sum(przebieg) >= 0.5 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / sum(przebieg) * 100) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END, 
					    CASE WHEN sum(DATEDIFF(minute, start_praca, stop_praca)) >= 15 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / (cast(sum(DATEDIFF(minute, start_praca, stop_praca)) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END 
						from #eksport_day_work  left join car on (#eksport_day_work.evb2 = car.id_car) 
						where (stop_praca > @start) and (start_praca < @stop) 
						group by evb2, month, group_id 
 
			declare @month_aggr integer 
			declare @month_przebieg numeric(10, 3) 
			declare @month_zuzycie numeric(10, 3) 
			declare @month_praca_sek integer 
			declare @month_postoj_sek integer 
			declare @month_jalowy_sek integer 
 
 
			open aggr_cr3 
			fetch aggr_cr3 into @group_evb2, @month_aggr, @group_id_aggr, @month_zuzycie, @month_przebieg, @month_praca_sek, @month_postoj_sek, @month_jalowy_sek, @srednio_km, @srednio_h 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				update #eksport_day_work set summary_przebieg_month=@month_przebieg, 
											 summary_praca_month=dbo.spGetGGMMf(@month_praca_sek), 
											 ZuzycieSum_month = @month_zuzycie, 
											 summary_postoj_month=dbo.spGetGGMMf(@month_postoj_sek), 
											 summary_jalowy_month=dbo.spGetGGMMf(@month_jalowy_sek), 
											 summary_paliwo_srednio_km_month = @srednio_km, 
											 summary_paliwo_srednio_h_month = @srednio_h 
					where month = @month_aggr and group_id = @group_id_aggr and evb2 = @group_evb2 
				fetch aggr_cr3 into @group_evb2, @month_aggr, @group_id_aggr, @month_zuzycie, @month_przebieg, @month_praca_sek, @month_postoj_sek, @month_jalowy_sek, @srednio_km, @srednio_h 
			end 
			close aggr_cr3; 
			deallocate aggr_cr3; 
 
 
			declare aggr_cr4 cursor  LOCAL FAST_FORWARD
					for select evb2, sum(ZuzycieSum), sum(przebieg), sum(ile_praca_sek), sum(ile_postoj_sek), 
						sum(ile_jalowy_sek), 
						CASE WHEN sum(przebieg) >= 0.5 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / sum(przebieg) * 100) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END, 
					    CASE WHEN sum(DATEDIFF(minute, start_praca, stop_praca)) >= 15 THEN dbo.InlineMax(0, cast((sum(ZuzycieSum) / (cast(sum(DATEDIFF(minute, start_praca, stop_praca)) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0) ELSE 0.0 END 
						from #eksport_day_work  left join car on (#eksport_day_work.evb2 = car.id_car)
						where (stop_praca > @start) and (start_praca < @stop) 
						group by evb2  
 
			declare @all_przebieg numeric(10, 3) 
			declare @all_zuzycie numeric(10, 3) 
			declare @all_praca_sek integer 
			declare @all_postoj_sek integer 
			declare @all_jalowy_sek integer 
 
			open aggr_cr4 
			fetch aggr_cr4 into @group_evb2, @all_zuzycie, @all_przebieg, @all_praca_sek, @all_postoj_sek, @all_jalowy_sek, @srednio_km, @srednio_h 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				update #eksport_day_work set summary_przebieg_all=@all_przebieg, 
											 summary_praca_all=dbo.spGetGGMMf(@all_praca_sek), 
											 ZuzycieSum_all_route = @all_zuzycie, 
											 summary_postoj_all=dbo.spGetGGMMf(@all_postoj_sek), 
											 summary_jalowy_all=dbo.spGetGGMMf(@all_jalowy_sek), 
											 summary_paliwo_srednio_km_all = @srednio_km, 
											 summary_paliwo_srednio_h_all = @srednio_h 
				where evb2 = @group_evb2 
				fetch aggr_cr4 into @group_evb2, @all_zuzycie, @all_przebieg, @all_praca_sek, @all_postoj_sek, @all_jalowy_sek, @srednio_km, @srednio_h 
			end 
			close aggr_cr4; 
			deallocate aggr_cr4; 
 
			update #eksport_day_work set marka_pojazdu = 
				(select NAME from car where id_car = #eksport_day_work.evb2) 
			update #eksport_day_work set nr_rej_pojazdu = 
				(select REJ_NUMB from car where id_car = #eksport_day_work.evb2) 
 
 
 
 
			if (@with_gps = 1) 
			begin 
				declare aggr_cr6 cursor  LOCAL FAST_FORWARD
					for select evb2, min(start_praca), max(stop_praca) from #eksport_day_work 
					where (stop_praca > @start) and (start_praca < @stop) 
					and start_praca is not null and stop_praca is not null 
					group by evb2 
				open aggr_cr6 
 
				fetch aggr_cr6 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca 
				while (@@fetch_status <> -1) and (@canceled = 0) 
				begin 
					exec sp_progress_set @id_progress, 0, @num_records, @canceled output; 
					exec sp_GPS 1, @aggr_car_no, @aggr_start_praca, @aggr_stop_praca, 
						@id_progress, 0, 0, 1 
					fetch aggr_cr6 into @aggr_car_no, @aggr_start_praca, @aggr_stop_praca 
				end 
				close aggr_cr6 
				deallocate aggr_cr6 
			end 
 
			if (@show_only_last_day_route = 1) 
			begin 
				declare zdarz_3 cursor  LOCAL FAST_FORWARD for 
				select id, data from #eksport_day_work order by id desc 
				open zdarz_3 
				declare @id_3 integer 
				declare @data_3 datetime 
				fetch zdarz_3 into @id_3, @data_3 
				declare @start_route_day datetime 
				set @start_route_day = null 
				while (@@fetch_status <> -1) 
				begin 
					if (@start_route_day is null) or 
					   (@start_route_day <> @data_3) 
					begin 
						set @start_route_day = @data_3 
						fetch zdarz_3 into @id_3, @data_3 
					end 
					else 
					begin 
						delete from #eksport_day_work where id = @id_3 
						fetch zdarz_3 into @id_3, @data_3 
					end 
				end 
				close zdarz_3 
				deallocate zdarz_3 
			end 
 
			exec sp_progress_unregister @id_progress; 
 
 
			update #eksport_day_work set ulica_start = 
			( 
				select top 1 t2.street from street t2 where evb2 = t2.id_car and  start_praca = t2._datetime 
			) 
 
			select @max_id = max(id) from #eksport_day_work 
 
			update #eksport_day_work set ulica_stop = 
			( 
				select top 1 t2.street from street t2 where evb2 = t2.id_car and  stop_praca = t2._datetime 
			) 
			where id = @max_id 
 
			declare raport_kursor cursor  for 
				select t1.id, t1.ulica_start, t1.ulica_stop 
				from #eksport_day_work t1 
				order by t1.id desc 
				for update of t1.ulica_stop 
			open raport_kursor 
 
			set @ulica_start_old = ''; 
 
			fetch raport_kursor into @id, @ulica_start, @ulica_stop 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				if @ulica_start_old <> '' 
				begin 
					update #eksport_day_work set ulica_stop = @ulica_start_old where id = @id; 
				end 
				set @ulica_start_old = @ulica_start; 
				fetch raport_kursor into @id, @ulica_start, @ulica_stop 
			end 
			close raport_kursor 
			deallocate raport_kursor 
 
			if ((@no_cache = 0) or (@no_cache = 2)) and (@start > cast('2010-06-01' as datetime)) 
			begin 
 
				select @car_or_driver_no = @car_or_driver_no2 
 
				if @start > cast('2010-06-01' as datetime) 
				begin 
					if @isInCarMode = 1 
					begin 
						select * from cache_day_work 
						where (stop_praca > @start) and (start_praca < @stop) 
						and (evb2 = @car_or_driver_no) 
						order by id 
					end 
					else 
					begin 
						select * from cache_day_work t1 
							inner join car_change t2 
								on (t1.evb2 = t2.id_car and t1.start_praca >= t2.start_date 
											and (t1.start_praca <= t2.end_date or t2.end_date is null)) 
						where (stop_praca > @start) and (t1.start_praca < @stop) 
							and (t2.id_driver = @car_or_driver_no) 
						order by id 
					end 
				end 
				else 
				begin 
					if @DoNotShowEmptyTracks2 = 1 
					begin 
						select t1.*, 
t1.ZuzycieSum_all as summary_paliwo_sum, 
t1.summary_paliwo_srednio_km_all as summary_paliwo_srednio,
t1.srednio_km as srednio  
						from #eksport_day_work 
						where (stop_praca > @start) and (start_praca < @stop) 
						and przebieg > 0.0 
						order by id 
					end 
					else 
					begin 
						select t1.*, 
t1.ZuzycieSum_all as summary_paliwo_sum, 
t1.summary_paliwo_srednio_km_all as summary_paliwo_srednio,
t1.srednio_km as srednio  
						from #eksport_day_work 
						where (stop_praca > @start) and (start_praca < @stop) 
						order by id 
					end 
				end 
			end 
			else 
			begin 
				select @car_or_driver_no = @car_or_driver_no2 
 
				if @DoNotShowEmptyTracks2 = 1 
				begin 
					select t1.*, 
t1.ZuzycieSum_all as summary_paliwo_sum, 
t1.summary_paliwo_srednio_km_all as summary_paliwo_srednio,
t1.srednio_km as srednio  
					from #eksport_day_work t1
					where (t1.stop_praca > @start) and (t1.start_praca < @stop) 
					and t1.przebieg > 0.0 
					order by id 
				end 
				else 
				begin 
					select t1.*, 
t1.ZuzycieSum_all as summary_paliwo_sum, 
t1.summary_paliwo_srednio_km_all as summary_paliwo_srednio,
t1.srednio_km as srednio  
					from #eksport_day_work 
					where (stop_praca > @start) and (start_praca < @stop) 
					order by id 
				end 
			end 
		end 


