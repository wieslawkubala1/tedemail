	ALTER procedure [dbo].[spTankowania] 
	    @carno integer, 
	    @start datetime, 
	    @stop datetime, 
	    @first_1bak numeric(10, 3) OUTPUT, 
	    @last_1bak numeric(10, 3) OUTPUT, 
	    @first_2bak numeric(10, 3) OUTPUT, 
	    @last_2bak numeric(10, 3) OUTPUT, 
	    @droga numeric(10, 3) OUTPUT, 
	    @jalowy integer OUTPUT, 
	    @srednio_km numeric(10, 3) OUTPUT, 
	    @srednio_h numeric(10, 3) OUTPUT, 
      @nested integer = 0, 
	    @id_progress bigint = 0, 
		@no_cache integer = 1 
	as 
	    declare @cistern integer 
	    select @cistern = cistern from car where id_car = @carno 
	    declare @canceled bit 
	    set @canceled = 0 
	    declare @num_records integer 
		  declare @start_prior datetime 
 
	    declare @evb1 numeric(3, 0) 
	    declare @evb2 numeric(3, 0) 
	    declare @evb3 numeric(3, 0) 
	    declare @evb4 numeric(3, 0) 
	    declare @evb5 numeric(3, 0) 
	    declare @evb6 numeric(3, 0) 
	    declare @evb7 numeric(3, 0) 
	    declare @evb8 numeric(3, 0) 
	    declare @evb9 numeric(3, 0) 
	    declare @evb10 numeric(3, 0) 
	    declare @evdata datetime 
	    declare @id integer 
	    declare @sonda_flag integer 
 
	    declare @stan integer 
	    declare @fuel_max numeric(10, 3) 
	    declare @fuel_max2 numeric(10, 3) 
	    declare @last117 numeric(10, 3) 
	    declare @last118 numeric(10, 3) 
	    declare @last217 numeric(10, 3) 
	    declare @last218 numeric(10, 3) 
	    declare @kiedy117 datetime 
	    declare @kiedy118 datetime 
	    declare @kiedy113 datetime 
	    declare @kiedy213 datetime 
	    declare @max113 numeric(10, 3) 
	    declare @max213 numeric(10, 3) 
	    declare @licznik integer 
	    declare @przyrost_droga numeric(10, 3) 
 
	    declare @min_tank numeric(10, 3) 
	    declare @min_ubytk numeric(10, 3) 
 
	    declare @car_type integer 
	    declare @kiedy10 datetime 
 
	    declare @min_stralis_1 numeric(10, 3) 
	    declare @min_stralis_2 numeric(10, 3) 
	    declare @max_stralis_1 numeric(10, 3) 
	    declare @max_stralis_2 numeric(10, 3) 
 
	    declare @min_stralis_pal_1 integer 
	    declare @min_stralis_pal_2 integer 
	    declare @max_stralis_pal_1 integer 
	    declare @max_stralis_pal_2 integer 
 
	    declare @kiedy_min_stralis_1 datetime 
	    declare @kiedy_min_stralis_2 datetime 
	    declare @kiedy_max_stralis_1 datetime 
	    declare @kiedy_max_stralis_2 datetime 
 
 
	    declare @czy_w_czasie_jazdy integer 
 
		declare @aproksym_enabled1 integer 
		declare @aproksym_wsp1 integer 
		declare @aproksym_kind1 integer 
		declare @aproksym_enabled2 integer 
		declare @aproksym_wsp2 integer 
		declare @aproksym_kind2 integer 
		declare @i integer 
		declare @max_aproks_mem integer 
 
	    declare @_117 datetime 
	    declare @_118 datetime 
	    declare @sonda numeric(10, 3) 
	    declare @from_sonda numeric(10, 3) 
	    declare @to_sonda numeric(10, 3) 
	    declare @from_sonda2 numeric(10, 3) 
	    declare @to_sonda2 numeric(10, 3) 
	    declare @from_sonda3 numeric(10, 3) 
	    declare @to_sonda3 numeric(10, 3) 
		declare @zb1 numeric(10, 3) 
		declare @zb2 numeric(10, 3) 
	    declare @was_15 integer 
	    declare @czy_dynamiczny integer 
 
		declare @paliwo_pal_1 integer 
		declare @paliwo_pal_2 integer 
 
		declare @max_skok numeric(10, 3) 
		declare @max_skok_czas datetime 
 
		declare @dyn_data integer 
		select @dyn_data = dyn_data_enabled from car where id_car = @carno 
 
	    select @stan = 0 
	    select @last117 = 0.0 
	    select @last118 = 0.0 
	    select @last217 = 0.0 
	    select @last218 = 0.0 
	    select @kiedy117 = NULL 
	    select @kiedy118 = NULL 
	    select @kiedy113 = NULL 
	    select @kiedy213 = NULL 
	    select @first_1bak = 0 
	    select @last_1bak = 0 
	    select @first_2bak = 0 
	    select @last_2bak = 0 
	    select @droga = 0 
	    select @jalowy = 0 
 
	    select @max113 = 0 
	    select @max213 = 0 
 
	    select @licznik = 0 
	    select @kiedy10 = NULL 
 
	    select @min_tank = I_TANK from car where id_car = @carno 
	    select @min_ubytk = I_UP from car where id_car = @carno 
 
	    select @car_type = use_motohours from car where id_car = @carno 
	    select @sonda_flag = id_probe_type from car where id_car = @carno 
	    select @fuel_max = max_capacity from fuel_tank where id_car = @carno and tank_nr = 1 
	    if @fuel_max is null 
	        select @fuel_max = 0 
	    select @fuel_max2 = max_capacity from fuel_tank where id_car = @carno and tank_nr = 2 
	    if @fuel_max2 is null 
	        select @fuel_max2 = 0 
 
 
	    select @min_stralis_1 = 1000000 
	    select @min_stralis_2 = 1000000 
	    select @max_stralis_1 = 0 
	    select @max_stralis_2 = 0 
	    select @max_skok = 0 
 
 
		select @start_prior = DATEADD(Day, -5, @start) 
		
--		exec check_partition_lower_range @actual_needed_lower_range=@start
 
 
	    create table #paliwo_wynik 
	    ( 
	        id integer not null identity(1, 1), 
	        _117 datetime, -- poczatek tankowania 
	        _118 datetime, -- koniec tankowania 
	        sonda numeric(10, 3), -- ilo zatankowanego lub upuszczonego paliwa w ltr 
	        from_sonda numeric(10, 3), -- tankowanie/upust "z poziomu" w ltr 
	        from_sonda_pal numeric(10, 3), -- tankowanie/upust "z poziomu" w palach 
	        to_sonda numeric(10, 3), -- tankowanie/upust "do poziomu" w ltr 
	        to_sonda_pal numeric(10, 3), -- tankowanie/upust "do poziomu" w palach 
	        from_sonda2 numeric(10, 3), -- tankowanie/upust "z poziomu" w ltr dla drugiej sondy 
	        from_sonda2_pal numeric(10, 3), -- tankowanie/upust "z poziomu" w palach dla drugiej sondy 
	        to_sonda2 numeric(10, 3), -- tankowanie/upust "do poziomu" w ltr dla drugiej sondy 
	        to_sonda2_pal numeric(10, 3), -- tankowanie/upust "do poziomu" w palach dla drugiej sondy 
	        was_15 integer, -- zmienna pomocnicza do wentrznego uytku 
	        czy_dynamiczny integer, -- zmienna pomocnicza do wentrznego uytku 
			first_event_datetime datetime, 
			last_event_datetime datetime, 
	        primary key(id) 
	    ) 
 
		declare	@first_event_datetime_db datetime 
		declare @last_event_datetime_db datetime 
		declare @first_event_datetime_cache datetime 
		declare @last_event_datetime_cache datetime 
 
	    create table #aproksymacja_params -- tabela tymczasowa dot. aproksymacji wykresu paliwa 
	    ( 
			enabled1 integer, 
			wsp1 integer, 
			kind1 integer, 
			start_pos1_bak1 integer, 
			start_pos1_bak2 integer, 
 
			enabled2 integer, 
			wsp2 integer, 
			kind2 integer, 
			start_pos2_bak1 integer, 
			start_pos2_bak2 integer 
	    ) 
 
	    create table #aproksymacja 
	    ( 
	        id integer not null, 
	        nr_zb integer not null, 
	        step integer not null, 
	        ltr numeric(10, 3), 
	        primary key (id, nr_zb, step) 
	    ) 
 
 		IF OBJECT_ID('tempdb..#paliwo85') IS NULL
		create table #paliwo85 -- paliwo w momencie wystapienia zdarzenia 49/115 wykorzystywane do liczania redniego zuycia paliwa dla tras 
		( 
	        id integer not null identity(1, 1), 
			dataczas datetime, 
			evb2 integer,
			evb3 integer,
			zb1 numeric(10, 3), 
			zb2 numeric(10, 3), 
			primary key(id) 
		) 
 
		select @aproksym_wsp1 = factor_approx_1 from car where id_car = @carno 
		select @aproksym_kind1 = id_approx_type_1 from car where id_car = @carno 
		select @aproksym_wsp2 = factor_approx_2 from car where id_car = @carno 
		select @aproksym_kind2 = id_approx_type_2 from car where id_car = @carno 
 
		if (@aproksym_wsp1 <> 0.0) 
				and (@aproksym_kind1 <> 0.0) 
			select @aproksym_enabled1 = 1 
		else 
			select @aproksym_enabled1 = null 
 
		if (@aproksym_wsp2 <> 0.0) 
				and (@aproksym_kind2 <> 0.0) 
			select @aproksym_enabled2 = 1 
		else 
			select @aproksym_enabled2 = null 
 
		if (@aproksym_enabled1 is not null) and (@aproksym_enabled1 = 1) 
				and (@aproksym_enabled2 is not null) 
				and (@aproksym_enabled2 <> 0) 
				and (@aproksym_wsp2 <> 0.0) 
				and (@aproksym_wsp2 is not null) 
			select @aproksym_enabled2 = 1 
		else 
		begin 
			select @aproksym_enabled2 = null 
			select @aproksym_wsp2 = 0 
		end 
 
 
		if (@aproksym_enabled1 is not null) and (@aproksym_enabled1 = 1) 
		begin 
			insert into #aproksymacja_params (enabled1, wsp1, kind1, start_pos1_bak1, start_pos1_bak2, 
										  enabled2, wsp2, kind2, start_pos2_bak1, start_pos2_bak2) 
				values(@aproksym_enabled1, @aproksym_wsp1, @aproksym_kind1, 0, 0, 
				       @aproksym_enabled2, @aproksym_wsp2, @aproksym_kind2, 0, 0) 
 
			select @max_aproks_mem = @aproksym_wsp1 
			if @max_aproks_mem < @aproksym_wsp2 
				select @max_aproks_mem = @aproksym_wsp2 
			select @i = 0 
			while (@i < @max_aproks_mem) 
			begin 
				insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 1, 1, 1000000) 
			    if (@sonda_flag = 3) 
					insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 2, 1, 1000000) 
 
				if (@aproksym_enabled2 is not null) and (@aproksym_enabled2 = 1) 
				begin 
					insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 1, 2, 1000000) 
					if (@sonda_flag = 3) 
						insert into #aproksymacja (id, nr_zb, step, ltr) values(@i, 2, 2, 1000000) 
				end 
 
				select @i = @i + 1 
			end 
		end 
 
 
		if (@sonda_flag = 3) 
		begin 
			declare zdarzenia_cr cursor LOCAL FAST_FORWARD 
				for select min(t1.date), max(t1.date) 
					from device_data t1 
			  left join fuel_tank t2 
					  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
			  left join probe_liters t22 
					  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
			  left join fuel_tank t3 
					  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) 
			  left join probe_liters t33 
					  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) 
				where t1.evb2 = @carno and t1.date >= @start_prior and t1.date <= @stop and 
				((t1.evb3 = 119 and t1.evb4 >= 0) or 
				 (t1.evb3 = 113 and t1.evb4 >= 0) or 
				 (t1.evb3 = 219 and t1.evb4 >= 0) or 
				 (t1.evb3 = 213 and t1.evb4 >= 0) 
					or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
		end 
		else 
		if (@sonda_flag = 1) 
		begin 
			declare zdarzenia_cr cursor LOCAL FAST_FORWARD
			  for select min(t1.date), max(t1.date) 
					from device_data t1 
			  left join fuel_tank t2 
					  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
			  left join probe_liters t22 
					  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
				where t1.evb2 = @carno and t1.date >= @start_prior and t1.date <= @stop and 
				(((t1.evb3 = 113) and (t1.evb4 > 3)) 
					or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
		end 
		else 
		begin 
			declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
			  for select min(t1.date), max(t1.date) 
					from device_data t1 
			  left join fuel_tank t2 
					  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
			  left join probe_liters t22 
					  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
				where t1.evb2 = @carno and t1.date >= @start_prior and t1.date <= @stop and 
				((t1.evb3 = 119 and t1.evb4 >= 0) or 
				 (t1.evb3 = 113 and t1.evb4 >= 0) 
					or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
		end 
 
	    open zdarzenia_cr 
	    fetch zdarzenia_cr into @first_event_datetime_db, @last_event_datetime_db 
	    close zdarzenia_cr 
	    deallocate zdarzenia_cr 
 
		declare zdarzenia_cr cursor   LOCAL FAST_FORWARD
			for select min(t1.first_event_datetime) first_event_datetime, 
					   max(t1.last_event_datetime) last_event_datetime 
				from cache_refueling t1 
			where t1.id_car = @carno and t1._117 >= @start_prior and t1._118 < @stop 
 
	    open zdarzenia_cr 
	    fetch zdarzenia_cr into @first_event_datetime_cache, @last_event_datetime_cache 
	    close zdarzenia_cr 
	    deallocate zdarzenia_cr 
 
	    declare @start2 datetime 
	    declare @stop2 datetime 
	    declare @scope_type integer 
		select @scope_type = 0 
 
	    if (@first_event_datetime_cache is null and 
		   @last_event_datetime_cache is null) or 
		   (@no_cache = 1) or (@nested = 1) 
		begin -- stworz pierwsza pozycje w cache 
			select @start2 = @start_prior 
			select @stop2 = @stop 
			select @scope_type = 1 
		end 
		else 
		if @first_event_datetime_cache is not null and 
		   @first_event_datetime_db is not null and 
		   @last_event_datetime_cache is not null and 
		   @last_event_datetime_db is not null and 
		   @first_event_datetime_db < @first_event_datetime_cache and 
		   @last_event_datetime_db <= @last_event_datetime_cache 
		begin -- dodaj do cache tylko starsze niz w cache 
			select @start2 = @start_prior 
			select @stop2 = @first_event_datetime_cache 
			select @scope_type = 2 
		end 
		else 
		if @last_event_datetime_cache is not null and 
		   @last_event_datetime_db is not null and 
		   @first_event_datetime_cache is not null and 
		   @first_event_datetime_db is not null and 
		   @last_event_datetime_db > @last_event_datetime_cache and 
		   @first_event_datetime_db >= @first_event_datetime_cache 
		begin -- dodaj do cache tylko nowsze ni¿ w cache 
			select @start2 = @last_event_datetime_cache 
			select @stop2 = @stop 
			select @scope_type = 3 
		end 
		else 
		if @last_event_datetime_cache is not null and 
		   @last_event_datetime_db is not null and 
		   @first_event_datetime_cache is not null and 
		   @first_event_datetime_db is not null and 
		   @last_event_datetime_db <= @last_event_datetime_cache and 
		   @first_event_datetime_db >= @first_event_datetime_cache 
		begin -- nie trzeba nic wyliczac, pobierz tylko z cache 
			select @scope_type = 4 
		end 
		else 
		begin -- nie obs³ugiwane na razie, potrzeba wyliczenia danych 
			  -- zarówno starszych jak i m³odszych ni¿ w cache (w dwóch przebiegach) 
			select @scope_type = 5 
			RAISERROR('@Not supported', 16, 1); 
		end 
 
		if @scope_type < 4 
		begin 
			if (@scope_type = 2) or (@scope_type = 3) 
			begin 
				if (@sonda_flag = 3) 
				begin 
					declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
						for select min(t1.date), max(t1.date) 
							from device_data t1 
					  left join fuel_tank t2 
							  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
					  left join probe_liters t22 
							  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
					  left join fuel_tank t3 
							  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) 
					  left join probe_liters t33 
							  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) 
						where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
						((t1.evb3 = 119 and t1.evb4 >= 0) or 
						 (t1.evb3 = 113 and t1.evb4 >= 0) or 
						 (t1.evb3 = 219 and t1.evb4 >= 0) or 
						 (t1.evb3 = 213 and t1.evb4 >= 0) or 
						 (t1.evb3 = 49) or (t1.evb3 = 10) or 
						 (t1.evb3 = 115) or (t1.evb3 = 15)) 
				end 
				else 
				if (@sonda_flag = 1) 
				begin 
					declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
					  for select min(t1.date), max(t1.date) 
							from device_data t1 
					  left join fuel_tank t2 
							  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
					  left join probe_liters t22 
							  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
						where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
						(((t1.evb3 = 113) and (t1.evb4 > 3)) 
							or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
				end 
				else 
				begin 
					declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
					  for select min(t1.date), max(t1.date) 
							from device_data t1 
					  left join fuel_tank t2 
							  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
					  left join probe_liters t22 
							  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
						where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
						((t1.evb3 = 119 and t1.evb4 >= 0) or 
						 (t1.evb3 = 113 and t1.evb4 >= 0) or 
						 (t1.evb3 = 49) or (t1.evb3 = 10) or 
						 (t1.evb3 = 115) or (t1.evb3 = 15)) 
				end 
 
				open zdarzenia_cr 
				fetch zdarzenia_cr into @first_event_datetime_db, @last_event_datetime_db 
				close zdarzenia_cr 
				deallocate zdarzenia_cr 
			end 
 
			if (@sonda_flag = 3) 
			begin 
				declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, 
							t1.date, t22.liters, t33.liters from device_data t1 
				  left join fuel_tank t2 
						  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
				  left join probe_liters t22 
						  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
				  left join fuel_tank t3 
						  on (t1.evb2 = t3.id_car and t3.tank_nr = 2) 
				  left join probe_liters t33 
						  on (t3.id_fuel_tank = t33.id_fuel_tank and t33.id_probe = t1.pal2) 
					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
					((t1.evb3 = 119 and t1.evb4 >= 0) or 
					 (t1.evb3 = 113 and t1.evb4 >= 0) or 
					 (t1.evb3 = 219 and t1.evb4 >= 0) or 
					 (t1.evb3 = 213 and t1.evb4 >= 0) or 
					 (t1.evb3 = 85) or (t1.evb3 = 49) or 
					 (t1.evb3 = 10) or (t1.evb3 = 115) or 
					 (t1.evb3 = 15)) 
					order by t1.id_device_data 
				select @num_records = count(*) 
					from device_data t1 
					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
					((t1.evb3 = 119 and t1.evb4 >= 0) or 
					 (t1.evb3 = 113 and t1.evb4 >= 0) or 
					 (t1.evb3 = 219 and t1.evb4 >= 0) or 
					 (t1.evb3 = 213 and t1.evb4 >= 0) or 
					 (t1.evb3 = 85) or (t1.evb3 = 49) or 
					 (t1.evb3 = 10) or (t1.evb3 = 115) or 
					 (t1.evb3 = 15)) 
			end 
			else 
			if (@sonda_flag = 1) 
			begin 
				declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, 
															   t1.date, t22.liters, 0.0 from device_data t1 
				  left join fuel_tank t2 
						  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
				  left join probe_liters t22 
						  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
					(((t1.evb3 = 113) and (t1.evb4 > 3)) or (t1.evb3 = 85) 
						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
					order by t1.id_device_data 
				select @num_records = count(*) 
				from device_data t1 
					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
					(((t1.evb3 = 113) and (t1.evb4 > 3)) or (t1.evb3 = 85) 
						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
			end 
			else 
			begin 
				declare zdarzenia_cr cursor  LOCAL FAST_FORWARD
					for select t1.id_device_data, t1.evb1, t1.evb2, t1.evb3, t1.evb4, t1.evb5, t1.evb6, t1.evb7, t1.evb8, t1.evb9, t1.evb10, 
															   t1.date, t22.liters, 0.0 from device_data t1 
				  left join fuel_tank t2 
						  on (t1.evb2 = t2.id_car and t2.tank_nr = 1) 
				  left join probe_liters t22 
						  on (t2.id_fuel_tank = t22.id_fuel_tank and t22.id_probe = t1.pal1) 
					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
					((t1.evb3 = 119 and t1.evb4 >= 0) or 
					 (t1.evb3 = 113 and t1.evb4 >= 0) or (t1.evb3 = 85) 
						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
					order by t1.id_device_data 
				select @num_records = count(*) 
				from device_data t1 
					where t1.evb2 = @carno and t1.date >= @start2 and t1.date <= @stop2 and 
					((t1.evb3 = 119 and t1.evb4 >= 0) or 
					 (t1.evb3 = 113 and t1.evb4 >= 0) or (t1.evb3 = 85) 
						or (t1.evb3 = 49) or (t1.evb3 = 10) or (t1.evb3 = 115) or (t1.evb3 = 15)) 
			end 
			select @czy_w_czasie_jazdy = 0 
 
			open zdarzenia_cr 
			fetch zdarzenia_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
													@evb8, @evb9, @evb10, @evdata, @zb1, @zb2 
 
			declare @dyn_data_max_useles numeric(10, 3) 
			select @dyn_data_max_useles = dyn_data_max_useles from car where id_car = @carno 
			declare @dyn_data_max_bad_time numeric(10, 3) 
			select @dyn_data_max_bad_time = dyn_data_max_bad_time from car where id_car = @carno 
			declare @last_droga numeric(10, 3) 
			select @last_droga = 0 
			declare @last_zb1 numeric(10, 3) 
			select @last_zb1 = @zb1 
			declare @last_zb2 numeric(10, 3) 
			select @last_zb2 = @zb2 
			declare @last_czas113 datetime 
			select @last_czas113 = @evdata 
			declare @bad_count integer 
			select @bad_count = 0 
			declare @zuzycie_dx numeric(10, 3) 
			declare @droga_ numeric(10, 3) 
			declare @czas113 datetime 
			declare @bad_count_start_time datetime 
 
			declare @first_filtry integer 
			select @first_filtry = filter_first from car where id_car = @carno 
			if @first_filtry is null 
			begin 
				select @first_filtry = 0 
			end 
 
			declare @licznik_rec integer 
			set @licznik_rec = 0 
			declare @last_droga2 numeric(10, 3) 
			set @last_droga2 = 0.0 
			declare @droga_2 numeric(10, 3) 
			set @droga_2 = 0.0 
 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
	 			if (@evb3 = 10) and (@evdata >= @start) 
				begin 
					set @last_droga2 = 0 
					set @droga_2 = 0.0 
				end 
				if (@evb3 = 113) and (@evdata >= @start) 
				begin 
					execute spDroga @carno, @evb1, @evb10, @droga_2 OUTPUT 
					set @droga = @droga + @droga_2 - @last_droga2 
					set @last_droga2 = @droga_2 
				end 
				if (@evb3 = 49) and (@evdata >= @start) 
				begin 
					set @droga_2 = -100 
				end 
				if (@evb3 = 85) and (@evdata >= @start) and (@droga_2 = -100) 
				begin 
					execute spDroga @carno, @evb9, @evb10, @droga_2 OUTPUT 
					set @droga = @droga + @droga_2 - @last_droga2 
					set @last_droga2 = @droga_2 
				end 
			if @cistern = 1 
			begin 
			  if @evb3 = 113 
				set @evb3 = 119 
			  else 
			  if @evb3 = 213 
				set @evb3 = 219 
			end 
				if @zb1 is null 
				begin 
					select @zb1 = 0 
				end 
				if @zb2 is null 
				begin 
					select @zb2 = 0 
				end 
				if (@dyn_data is not null) and (@dyn_data = 1) 
				begin 
						if (@evb3 = 10) 
						begin 
							select @last_droga = 0.0 
							select @last_czas113 = @evdata 
						end 
						else 
						if (@evb3 = 113) or (@evb3 = 119) or (@evb3 = 213) or (@evb3 = 219) 
						begin 
							if (@evb3 = 119) and (@first_filtry = 1) 
								execute spPaliwo @carno, @evb3, 1, @evb4, @evb9, @zb1 OUTPUT 
							else 
							if (@evb3 = 113) and (@first_filtry = 1) 
								execute spPaliwo @carno, @evb3, 1, @evb4, @evb9, @zb1 OUTPUT 
 
							if (@evb3 = 219) and (@first_filtry = 1) 
								execute spPaliwo @carno, @evb3, 2, @evb4, @evb9, @zb2 OUTPUT 
							else 
							if (@evb3 = 213) and (@first_filtry = 1) 
								execute spPaliwo @carno, @evb3, 2, @evb4, @evb9, @zb2 OUTPUT 
							if @zb1 is null 
							begin 
								select @zb1 = 0 
							end 
							if @zb2 is null 
							begin 
								select @zb2 = 0 
							end 
 
							if (@evb3 = 113) 
								select @droga_ = (@evb1 * 256 + @evb10) / 10.0 
							else 
							if (@evb3 = 119) or (@evb3 = 219) 
								select @droga_ = @last_droga 
							select @czas113 = @evdata 
 
 
							if @evb3 <> 213 
							begin 
								if (@car_type <> 1) or (@car_type is null) 
								begin 
									if abs(@droga_ - @last_droga) > 0.0001 
										select @zuzycie_dx = (((@last_zb1 + @last_zb2) - (@zb1 + @zb2)) / (@droga_ - @last_droga)) * 100 
									else 
										select @zuzycie_dx = (@last_zb1 + @last_zb2) - (@zb1 + @zb2) 
								end 
								else 
								begin 
									if @last_czas113 <> @czas113 
										select @zuzycie_dx = ((@last_zb1 + @last_zb2) - (@zb1 + @zb2)) / (DATEDIFF(minute, @last_czas113, @czas113) / 60.0) 
									else 
										select @zuzycie_dx = ((@last_zb1 + @last_zb2) - (@zb1 + @zb2)) / (1 / 60.0) 
								end 
							end 
 
							if abs(@zuzycie_dx) > @dyn_data_max_useles 
							begin 
								if @bad_count = 0 
									select @bad_count_start_time = @evdata 
								if DATEDIFF(minute, @bad_count_start_time, @evdata) < @dyn_data_max_bad_time 
								begin 
									select @bad_count = @bad_count + 1 
									fetch zdarzenia_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
													@evb8, @evb9, @evb10, @evdata, @zb1, @zb2 
									if (@car_type = 1) select @last_czas113 = @czas113 
 
									continue 
								end 
							end 
							select @bad_count = 0 
							select @last_droga = @droga_ 
							select @last_czas113 = @czas113 
							select @last_zb1 = @zb1 
							select @last_zb2 = @zb2 
						end 
				end 
 
				if @evdata >= @start 
					select @evdata = @evdata 
 
				if (@evb3 = 49) or (@evb3 = 115) or (@evb3 = 85) or (@evb3 = 119) 
				begin 
					if @czy_w_czasie_jazdy = 1 
						if ((@sonda_flag <> 3) or (@sonda_flag is null)) 
						begin 
							if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) 
								if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 
								begin 
									select @kiedy_max_stralis_1 = @kiedy_min_stralis_1 
									select @max_stralis_1 = @min_stralis_1 
									select @max_skok = 0 
								end 
						end 
						else 
						begin 
							if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) 
								if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 
								begin 
									select @kiedy_max_stralis_2 = @kiedy_min_stralis_2 
									select @max_stralis_2 = @min_stralis_2 
									select @kiedy_max_stralis_1 = @kiedy_min_stralis_1 
									select @max_stralis_1 = @min_stralis_1 
									select @max_skok = 0 
								end 
						end 
					select @czy_w_czasie_jazdy = 0 
				end 
				else 
				if (@evb3 = 113) or (@evb3 = 10) 
				begin 
					if @czy_w_czasie_jazdy = 0 
						if ((@sonda_flag <> 3) or (@sonda_flag is null)) 
						begin 
							if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) 
								if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 
								begin 
									if (@sonda_flag <> 1) or (@sonda_flag is null) or 
										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) 
									begin 
										if @kiedy_max_stralis_1 >= @start_prior 
											insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
												czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--							            values(@kiedy_max_stralis_1, @kiedy_min_stralis_1, 
												values(@max_skok_czas, @max_skok_czas, 
												@min_stralis_1 - @max_stralis_1, @max_stralis_1, @min_stralis_1, 0.0, 0.0, 1, 
												@max_stralis_pal_1, @min_stralis_pal_1, 0.0, 0.0) 
										select @max_stralis_1 = @min_stralis_1 
										select @max_skok = 0 
									end 
								end 
						end 
						else 
						begin 
							if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) 
								if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 
								begin 
									if (@sonda_flag <> 1) or (@sonda_flag is null) or 
										((@sonda_flag = 1) and (@min_stralis_2 <> 0)) 
									begin 
										if @kiedy_max_stralis_2 >= @start_prior 
											insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
												czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--								        values(@kiedy_max_stralis_2, @kiedy_min_stralis_2, 
												values(@max_skok_czas, @max_skok_czas, 
												@min_stralis_2 - @max_stralis_2 + 
												@min_stralis_1 - @max_stralis_1, 
												@max_stralis_1, @min_stralis_1, 
												@max_stralis_2, @min_stralis_2, 1, 
												@max_stralis_pal_1, @min_stralis_pal_1, 
												@max_stralis_pal_2, @min_stralis_pal_2) 
										select @max_stralis_1 = @min_stralis_1 
										select @max_stralis_2 = @min_stralis_1 
										select @max_skok = 0 
									end 
								end 
						end 
					select @czy_w_czasie_jazdy = 1 
				end 
 
				if (@evb3 = 119) and (((@first_1bak < (@fuel_max / 17.0)) and @fuel_max <> 0) and (@first_1bak = 0) 
						or (@first_1bak = 0 and @fuel_max = 0)) and (@evdata >= @start) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @first_1bak = @zb1 
					else 
						execute spPaliwo @carno, @evb3, 1, @evb4, @evb9, @first_1bak OUTPUT 
				end 
				else 
				if (@evb3 = 113) and (((@first_1bak < (@fuel_max / 17.0)) and @fuel_max <> 0) and (@first_1bak = 0) 
						or (@first_1bak = 0 and @fuel_max = 0)) and (@evdata >= @start) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @first_1bak = @zb1 
					else 
						execute spPaliwo @carno, @evb3, 1, @evb4, @evb9, @first_1bak OUTPUT 
				end 
 
				if (@evb3 = 219) and (((@first_2bak < (@fuel_max2 / 17.0)) and @fuel_max2 <> 0) and (@first_2bak = 0) 
						or (@first_2bak = 0 and @fuel_max2 = 0)) and (@evdata >= @start) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @first_2bak = @zb2 
					else 
						execute spPaliwo @carno, @evb3, 2, @evb4, @evb9, @first_2bak OUTPUT 
				end 
				else 
				if (@evb3 = 213) and (((@first_2bak < (@fuel_max2 / 17.0)) and @fuel_max2 <> 0)  and (@first_2bak = 0) 
						or (@first_2bak = 0 and @fuel_max2 = 0)) and (@evdata >= @start) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @first_2bak = @zb2 
					else 
						execute spPaliwo @carno, @evb3, 2, @evb4, @evb9, @first_2bak OUTPUT 
				end 
 
				if (@evb3 = 119) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @last_1bak = @zb1 
					else 
						execute spPaliwo @carno, @evb3, 1, @evb4, @evb9, @last_1bak OUTPUT 
					select @paliwo_pal_1 = @evb4 
				end 
				else 
				if (@evb3 = 113) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @last_1bak = @zb1 
					else 
						execute spPaliwo @carno, @evb3, 1, @evb4, @evb9, @last_1bak OUTPUT 
					select @paliwo_pal_1 = @evb4 
				end 
 
				if (@evb3 = 219) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @last_2bak = @zb2 
					else 
						execute spPaliwo @carno, @evb3, 2, @evb4, @evb9, @last_2bak OUTPUT 
					select @paliwo_pal_2 = @evb4 
				end 
				else 
				if (@evb3 = 213) 
				begin 
					if (@dyn_data is not null) and (@dyn_data = 1) 
						select @last_2bak = @zb2 
					else 
						execute spPaliwo @carno, @evb3, 2, @evb4, @evb9, @last_2bak OUTPUT 
					select @paliwo_pal_2 = @evb4 
				end 
 
				if (@evb3 = 119) or (@evb3 = 113) 
				begin 
					if ((@sonda_flag <> 3) or (@sonda_flag is null)) 
					begin 
						if (@last_1bak <= @min_stralis_1) 
						begin 
							if @max_skok < abs(@min_stralis_1 - @last_1bak) 
							begin 
								select @max_skok = abs(@min_stralis_1 - @last_1bak) 
								select @max_skok_czas = @evdata 
							end 
							select @kiedy_min_stralis_1 = @evdata 
							select @min_stralis_1 = @last_1bak 
							select @min_stralis_pal_1 = @paliwo_pal_1 
						end 
						else 
						if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) 
							if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 
							begin 
								if (@sonda_flag <> 1) or (@sonda_flag is null) or 
										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) 
								begin 
									if (@evb3 = 119) and (@kiedy_max_stralis_1 >= @start_prior) 
										insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
												czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--							            values(@kiedy_max_stralis_1, @kiedy_min_stralis_1, 
												values(@max_skok_czas, @max_skok_czas, 
												@min_stralis_1 - @max_stralis_1, 
												@max_stralis_1, @min_stralis_1, 
												0.0, 0.0, 1, 
												@max_stralis_pal_1, @min_stralis_pal_1, 
												0.0, 0.0) 
									select @max_stralis_1 = @min_stralis_1 
									select @max_skok = 0 
								end 
							end 
 
						if (@last_1bak >= @max_stralis_1) 
						begin 
							if @max_skok < abs(@max_stralis_1 - @last_1bak) 
							begin 
								select @max_skok = abs(@max_stralis_1 - @last_1bak) 
								select @max_skok_czas = @evdata 
							end 
							select @kiedy_max_stralis_1 = @evdata 
							select @max_stralis_1 = @last_1bak 
							select @max_stralis_pal_1 = @paliwo_pal_1 
						end 
						else 
						if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) 
							if @kiedy_min_stralis_1 <= @kiedy_max_stralis_1 
							begin 
								if (@sonda_flag <> 1) or (@sonda_flag is null) or 
										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) 
								begin 
									if @kiedy_min_stralis_1 >= @start_prior 
									begin 
										insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
											czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--                                    values(@kiedy_min_stralis_1, @kiedy_max_stralis_1, 
											values(@max_skok_czas, @max_skok_czas, 
											@max_stralis_1 - @min_stralis_1, 
											@min_stralis_1, @max_stralis_1, 0.0, 0.0, 1, 
											@min_stralis_pal_1, @max_stralis_pal_1, 0.0, 0.0) 
									end 
									select @min_stralis_1 = @max_stralis_1 
									select @max_skok = 0 
								end 
							end 
					end 
				end 
 
				if (@evb3 = 219) or (@evb3 = 213) 
				begin 
					if ((@last_1bak + @last_2bak) <= (@min_stralis_1 + @min_stralis_2)) 
					begin 
						if @max_skok < abs(@min_stralis_1 - @last_1bak + @min_stralis_2 - @last_2bak) 
						begin 
							select @max_skok = abs(@min_stralis_1 - @last_1bak + @min_stralis_2 - @last_2bak) 
							select @max_skok_czas = @evdata 
						end 
						select @kiedy_min_stralis_2 = @evdata 
						select @kiedy_min_stralis_1 = @evdata 
						select @min_stralis_2 = @last_2bak 
						select @min_stralis_pal_2 = @paliwo_pal_2 
	   					select @min_stralis_1 = @last_1bak 
						select @min_stralis_pal_1 = @paliwo_pal_1 
					end 
					else 
					if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) 
						if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 
						begin 
							if (@sonda_flag <> 1) or (@sonda_flag is null) or 
								((@sonda_flag = 1) and (@min_stralis_2 <> 0)) 
							begin 
								if (@evb3 = 219) and (@kiedy_max_stralis_2 >= @start_prior) 
									insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
										czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--					            values(@kiedy_max_stralis_2, @kiedy_min_stralis_2, 
										values(@max_skok_czas, @max_skok_czas, 
										@min_stralis_2 - @max_stralis_2 + 
										@min_stralis_1 - @max_stralis_1, 
										@max_stralis_1, @min_stralis_1, 
										@max_stralis_2, @min_stralis_2, 1, 
										@max_stralis_pal_1, @min_stralis_pal_1, 
										@max_stralis_pal_2, @min_stralis_pal_2) 
								select @max_stralis_1 = @min_stralis_1 
								select @max_stralis_2 = @min_stralis_2 
								select @max_skok = 0 
							end 
						end 
 
					if ((@last_1bak + @last_2bak) >= (@max_stralis_1 + @max_stralis_2)) 
					begin 
						if @max_skok < abs(@max_stralis_1 - @last_1bak + @max_stralis_2 - @last_2bak) 
						begin 
							select @max_skok = abs(@max_stralis_1 - @last_1bak + @max_stralis_2 - @last_2bak) 
							select @max_skok_czas = @evdata 
						end 
						select @kiedy_max_stralis_1 = @evdata 
						select @kiedy_max_stralis_2 = @evdata 
						select @max_stralis_1 = @last_1bak 
						select @max_stralis_pal_1 = @paliwo_pal_1 
						select @max_stralis_2 = @last_2bak 
						select @max_stralis_pal_2 = @paliwo_pal_2 
					end 
					else 
					if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) 
						if @kiedy_min_stralis_2 <= @kiedy_max_stralis_2 
						begin 
							if (@sonda_flag <> 1) or (@sonda_flag is null) or 
									((@sonda_flag = 1) and (@min_stralis_2 <> 0)) 
							   if @kiedy_min_stralis_2 >= @start_prior 
								begin 
									insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
										czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--								values(@kiedy_min_stralis_2, @kiedy_max_stralis_2, 
										values(@max_skok_czas, @max_skok_czas, 
										@max_stralis_2 - @min_stralis_2 + 
										@max_stralis_1 - @min_stralis_1, 
										@min_stralis_1, @max_stralis_1, 
										@min_stralis_2, @max_stralis_2, 1, 
										@min_stralis_pal_1, @max_stralis_pal_1, 
										@min_stralis_pal_2, @max_stralis_pal_2) 
									select @min_stralis_1 = @max_stralis_1 
									select @min_stralis_2 = @max_stralis_2 
									select @max_skok = 0 
								end 
						end 
				end 
 
				if (@evb3 = 85) 
				begin 
					if @evdata >= @start 
					begin 
						execute spDroga @carno, @evb9, @evb10, @przyrost_droga OUTPUT 
						select @jalowy = @jalowy + cast((@evb1 * 256 + @evb4) / 60 as integer) 
					end 
				end 
 
				if (@evb3 = 10) 
					select @kiedy10 = @evdata 
 
--				if (@evb3 = 49) or (@evb3 = 115) 
--				begin 
--					if @car_type = 1 
--						if @kiedy10 is not null 
--							if @evdata >= @start 
--								select @motogodziny = @motogodziny - 
--										(cast((@evdata - @kiedy10) as numeric(10, 6)) * 86400) 
--				end 
 
				if (@evb3 = 49) or (@evb3 = 115) or (@evb3 = 10) or (@evb3 = 15)
				begin 
					insert into #paliwo85(dataczas, zb1, zb2, evb2, evb3) 
					    values(@evdata, @last_1bak, @last_2bak, @carno, @evb3) 
				end 
 
				if (@evb3 = 15) 
				begin 
					insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
						czy_dynamiczny, was_15, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) values(@evdata, 
						@evdata, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 0, 0) 
				end 
 
				set @licznik_rec = @licznik_rec + 1 
				if (@licznik_rec % 10 = 0) 
					exec sp_progress_set @id_progress, @licznik_rec, @num_records, @canceled output; 
 
				fetch zdarzenia_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
						@evb8, @evb9, @evb10, @evdata, @zb1, @zb2 
			end 
			close zdarzenia_cr 
			deallocate zdarzenia_cr 
			if ((@sonda_flag <> 3) or (@sonda_flag is null)) 
			begin 
				if (@czy_w_czasie_jazdy = 0) 
					if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) 
						if @kiedy_min_stralis_1 > @kiedy_max_stralis_1 
						begin 
							if (@sonda_flag <> 1) or (@sonda_flag is null) or 
										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) 
							begin 
								if @kiedy_max_stralis_1 >= @start_prior 
											  insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
													 czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--							                 values(@kiedy_max_stralis_1, @kiedy_min_stralis_1, 
													 values(@max_skok_czas, @max_skok_czas, 
														 @min_stralis_1 - @max_stralis_1, 
														 @max_stralis_1, @min_stralis_1, 
														 0.0, 0.0, 1, 
														 @max_stralis_pal_1, @min_stralis_pal_1, 
														 0.0, 0.0) 
								select @max_stralis_1 = 0 
								select @max_skok = 0 
							end 
						end 
 
				if (@max_stralis_1 <> 0) and (@min_stralis_1 <> 1000000) 
					if @kiedy_min_stralis_1 <= @kiedy_max_stralis_1 
					begin 
						if (@sonda_flag <> 1) or (@sonda_flag is null) or 
										((@sonda_flag = 1) and (@min_stralis_1 <> 0)) 
						begin 
							if @kiedy_min_stralis_1 >= @start_prior 
								insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
											czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--                                    values(@kiedy_min_stralis_1, @kiedy_max_stralis_1, 
											values(@max_skok_czas, @max_skok_czas, 
											@max_stralis_1 - @min_stralis_1, 
											@min_stralis_1, @max_stralis_1, 0.0, 0.0, 1, 
											@min_stralis_pal_1, @max_stralis_pal_1, 0.0, 0.0) 
							select @min_stralis_1 = 1000000 
							select @max_skok = 0 
						end 
					end 
			end 
			else 
			begin 
				if (@czy_w_czasie_jazdy = 0) 
					if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) 
						if @kiedy_min_stralis_2 > @kiedy_max_stralis_2 
								 begin 
							 if (@sonda_flag <> 1) or (@sonda_flag is null) or 
											   ((@sonda_flag = 1) and (@min_stralis_2 <> 0)) 
									   begin 
								 if @kiedy_max_stralis_2 >= @start_prior 
											 insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
												   czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--					                       values(@kiedy_max_stralis_2, @kiedy_min_stralis_2, 
												   values(@max_skok_czas, @max_skok_czas, 
													   @min_stralis_2 - @max_stralis_2 + 
								                		 @min_stralis_1 - @max_stralis_1, 
														 @max_stralis_1, @min_stralis_1, 
														 @max_stralis_2, @min_stralis_2, 1, 
														 @max_stralis_pal_1, @min_stralis_pal_1, 
														 @max_stralis_pal_2, @min_stralis_pal_2) 
								 select @max_stralis_1 = 0 
								 select @max_stralis_2 = 0 
	 							 select @max_skok = 0 
							 end 
						 end 
 
				if (@max_stralis_2 <> 0) and (@min_stralis_2 <> 1000000) 
					if @kiedy_min_stralis_2 <= @kiedy_max_stralis_2 
					begin 
						if (@sonda_flag <> 1) or (@sonda_flag is null) or 
									((@sonda_flag = 1) and (@min_stralis_2 <> 0)) 
							if @kiedy_min_stralis_2 >= @start_prior 
											  insert into #paliwo_wynik (_117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
							            			czy_dynamiczny, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal) 
		--						            		values(@kiedy_min_stralis_2, @kiedy_max_stralis_2, 
							            			values(@max_skok_czas, @max_skok_czas, 
													@max_stralis_2 - @min_stralis_2 + 
								            		@max_stralis_1 - @min_stralis_1, 
													@min_stralis_1, @max_stralis_1, 
													@min_stralis_2, @max_stralis_2, 1, 
													@min_stralis_pal_1, @max_stralis_pal_1, 
													@min_stralis_pal_2, @max_stralis_pal_2) 
							select @min_stralis_1 = 1000000 
							select @min_stralis_2 = 1000000 
							select @max_skok = 0 
					end 
			end 
 
			select @jalowy = @jalowy * 60 
 
			drop table #aproksymacja_params 
			drop table #aproksymacja 
 
			declare tankowania_cr cursor  LOCAL FAST_FORWARD
					for select id, _117, _118, sonda, from_sonda, to_sonda, from_sonda2, to_sonda2, 
							was_15, czy_dynamiczny from #paliwo_wynik 
					order by id 
 
 
			open tankowania_cr 
			fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, 
							@was_15, @czy_dynamiczny 
 
			declare @id1 integer 
			declare @id2 integer 
			declare @id3 integer 
			declare @sonda1 numeric(10, 3) 
			declare @sonda2 numeric(10, 3) 
 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				if (@was_15 is not null) and (@was_15 = 1) 
				begin 
					select @id1 = @id 
					while (@@fetch_status <> -1) and (@was_15 is not null) and (@was_15 = 1) and (@canceled = 0) 
						fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, 
							@was_15, @czy_dynamiczny 
					if (@@fetch_status <> -1) and (@canceled = 0) 
					begin 
						select @id2 = @id 
						if (@sonda < 0.0) and (@to_sonda < 10.0) 
						begin 
							select @sonda1 = @sonda 
							fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, 
								@was_15, @czy_dynamiczny 
							while (@@fetch_status <> -1) and (@was_15 is not null) and (@was_15 = 1) and (@canceled = 0) 
								fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, 
									@was_15, @czy_dynamiczny 
							if (@@fetch_status <> -1) and (@canceled = 0) 
							begin 
								select @id3 = @id 
								if (@sonda > 0.0) and (@from_sonda < 10.0) 
								begin 
									select @sonda2 = @sonda 
									close tankowania_cr 
									delete from #paliwo_wynik where id = @id1 
									delete from #paliwo_wynik where id = @id3 
									update #paliwo_wynik set sonda = @sonda1 + @sonda2, czy_dynamiczny = 15 where id = @id2 
									open tankowania_cr 
								end 
							end 
						end 
					end 
				end 
				fetch tankowania_cr into @id, @_117, @_118, @sonda, @from_sonda, @to_sonda, @from_sonda2, @to_sonda2, 
							@was_15, @czy_dynamiczny 
			end 
			close tankowania_cr 
			deallocate tankowania_cr 
 
	 		declare @id_w integer 
			declare @car_no_w integer 
			declare @dataczas_w datetime 
			declare @ilosc_w numeric(10, 3) 
			declare wyjatki_cr cursor  LOCAL FAST_FORWARD
				for select id, car_no, dataczas, ilosc from paliwo_wyjatki 
				where car_no = @carno and 
				dataczas >= @start and dataczas <= @stop 
				order by id 
			open wyjatki_cr 
			fetch wyjatki_cr into @id_w, @car_no_w, @dataczas_w, @ilosc_w 
		  while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				delete from #paliwo_wynik where sonda = @ilosc_w and _117 = @dataczas_w 
				fetch wyjatki_cr into @id_w, @car_no_w, @dataczas_w, @ilosc_w 
			end 
		  close wyjatki_cr 
		  deallocate wyjatki_cr 
 
		  if @nested = 0 
			 exec sp_progress_unregister @id_progress; 
 
		  if @nested = 1 
		  begin 
			delete from #paliwo_wynik2 
			insert into #paliwo_wynik2(_117, _118, sonda, from_sonda, 
				from_sonda_pal, to_sonda, to_sonda_pal, from_sonda2, 
				from_sonda2_pal, to_sonda2, to_sonda2_pal, 
				was_15, czy_dynamiczny) 
			  select _117, _118, sonda, from_sonda, 
				from_sonda_pal, to_sonda, to_sonda_pal, from_sonda2, 
				from_sonda2_pal, to_sonda2, to_sonda2_pal, 
				was_15, czy_dynamiczny from #paliwo_wynik order by id 
 
			declare czas_pracy_cr cursor  LOCAL FAST_FORWARD for 
			select id, start_praca, stop_praca, przebieg from #eksport_day_work 
			order by id 
 
			declare @start_praca_pr datetime 
			declare @stop_praca_pr datetime 
			declare @id_pr integer 
			declare @first_bak1_pr numeric(10, 3) 
			declare @first_bak2_pr numeric(10, 3) 
			declare @last_bak1_pr numeric(10, 3) 
			declare @last_bak2_pr numeric(10, 3) 
			declare @tank_sum numeric(10, 3) 
			declare @ZuzycieSum numeric(10, 3) 
			declare @droga_pr numeric(10, 3) 
 
			open czas_pracy_cr 
			fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr, @droga_pr 
			while (@@fetch_status <> -1) and (@canceled = 0) 
			begin 
				select @first_bak1_pr = zb1 from #paliwo85 where dataczas = @start_praca_pr 
				select @first_bak2_pr = zb2 from #paliwo85 where dataczas = @start_praca_pr 
				select @last_bak1_pr = zb1 from #paliwo85 where dataczas = @stop_praca_pr 
				select @last_bak2_pr = zb2 from #paliwo85 where dataczas = @stop_praca_pr 
 
				set @first_1bak = isnull(@first_1bak, 0.0) 
				set @first_2bak = isnull(@first_2bak, 0.0) 
				set @last_1bak = isnull(@last_1bak, 0.0) 
				set @last_2bak = isnull(@last_2bak, 0.0) 
				set @from_sonda3 = 0.0;
				set @to_sonda3 = 0.0;
 
				select @tank_sum = sum(sonda),
					@from_sonda3 = min(from_sonda + from_sonda2), 
					@to_sonda3 = max(to_sonda + to_sonda2) 
				from #paliwo_wynik where _117 >= @start_praca_pr and _118 < @stop_praca_pr 
					and ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) 
				set @tank_sum = isnull(@tank_sum, 0.0) 

-- WK20171211				if @from_sonda3 > 0.0 and @from_sonda3 < @first_bak1_pr
--				begin
--					set @first_bak1_pr = @from_sonda3 
--				end

				if (@first_bak1_pr is not null) and (@first_bak2_pr is not null) and 
				   (@last_bak1_pr is not null) and (@last_bak2_pr is not null) 
				begin 
					set @ZuzycieSum = @first_bak1_pr + @first_bak2_pr + @tank_sum - @last_bak1_pr - @last_bak2_pr 
					if @ZuzycieSum < 0.0 begin set @ZuzycieSum = 0.0 end
					if @droga_pr >= 0.5 
          begin 
						update #eksport_day_work set srednio_km = dbo.InlineMax(0, cast((@ZuzycieSum / @droga_pr * 100) * 10 + 0.5 as integer) / 10.0) where id = @id_pr 
						set @srednio_km = dbo.InlineMax(0, cast((@ZuzycieSum / @droga_pr * 100) * 10 + 0.5 as integer) / 10.0) 
          end 
					else 
          begin 
						update #eksport_day_work set srednio_km = 0.0 where id = @id_pr 
						set @srednio_km = 0.0; 
          end 
					update #eksport_day_work set first_1bak = @first_bak1_pr where id = @id_pr 
					update #eksport_day_work set first_2bak = @first_bak2_pr where id = @id_pr 
					update #eksport_day_work set last_1bak = @last_bak1_pr where id = @id_pr 
					update #eksport_day_work set last_2bak = @last_bak2_pr where id = @id_pr 
					update #eksport_day_work set tank_sum = @tank_sum where id = @id_pr 
					update #eksport_day_work set ZuzycieSum = @ZuzycieSum where id = @id_pr 
--					if @motogodziny < 0 
--					begin 
						if DATEDIFF(minute, @start_praca_pr, @stop_praca_pr) >= 15 
            begin 
							update #eksport_day_work set srednio_h = dbo.InlineMax(0, cast((@ZuzycieSum / (cast(DATEDIFF(minute, @start_praca_pr, @stop_praca_pr) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0) where id = @id_pr 
							set @srednio_h = dbo.InlineMax(0, cast((@ZuzycieSum / (cast(DATEDIFF(minute, @start_praca_pr, @stop_praca_pr) as numeric(10, 1)) / 60.0)) * 10 + 0.5 as integer) / 10.0) 
					  end 
						else 
            begin 
							update #eksport_day_work set srednio_h = 0.0 where id = @id_pr 
							set @srednio_h = 0.0; 
					  end 
--					end 
--						else 
--							update #eksport_day_work set srednio_h = 0.0 where id = @id_pr 
				end 
				fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr, @droga_pr 
			end 
			close czas_pracy_cr 
			deallocate czas_pracy_cr 
		  end 
		end 
		if @nested = 0 or @nested is null 
		begin 
		  if @no_cache = 0 
			  select sonda tankowanie, _117 poczatek, _118 koniec, _117 _113, from_sonda, to_sonda, from_sonda2, to_sonda2, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal, 
								czy_dynamiczny, sign(sonda) znak from cache_refueling 
				  where ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) and (_117 >= @start) and (_118 >= @start) and (_118 < @stop) 
				  and id_car = @carno 
				  order by first_event_datetime, _117, sign(sonda), czy_dynamiczny 
		  else 
			  select sonda tankowanie, _117 poczatek, _118 koniec, _117 _113, from_sonda, to_sonda, from_sonda2, to_sonda2, from_sonda_pal, to_sonda_pal, from_sonda2_pal, to_sonda2_pal, 
								czy_dynamiczny, sign(sonda) znak from #paliwo_wynik 
				  where ((sonda >= @min_tank) or (sonda <= (-@min_ubytk))) and (_117 >= @start) and (_118 >= @start) 
				  order by _117, sign(sonda), czy_dynamiczny  
		end