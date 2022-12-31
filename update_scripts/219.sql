ALTER procedure [dbo].[sp_GPS] 
    @isInCarMode integer, 
    @car_or_driver_no integer, 
    @start datetime, 
    @stop datetime, 
    @id_progress bigint, 
	@ShowLastPostionIfNone int, 
	@result_count int OUTPUT, 
	@nested int = 0 
as 
    if @nested = 1 
    begin 
        set @stop = DATEADD(day, 1, @stop) 
    end 
	
	exec check_partition_lower_range @actual_needed_lower_range=@start
 
	declare @num_records integer 
	declare @dodaj_pozycje integer 
	set @dodaj_pozycje = 0 
	if @isInCarMode = 1 
	begin 
		declare zdarzenia_gps_cr cursor for 
		select t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, 
		t1_probe_liters.liters as zb1, 
		t2_probe_liters.liters as zb2, 
		t_cardata.rej_numb, t_cardata.name, t_probe_type.description, 
		t_komentarze.comment as komentarz, driver_name as kierowca 
		from partition_view t_zdarzenia 
		  left join car_change t_przesiadki 
			 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date 
							   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) 
		  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) 
		  left join fuel_tank t1_fuel_tank 
				  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) 
		  left join probe_liters t1_probe_liters 
				  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) 
		  left join fuel_tank t2_fuel_tank 
				  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) 
		  left join probe_liters t2_probe_liters 
				  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) 
		  left join comment t_komentarze 
				  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) 
		  left join driver t_kierowcy 
				  on (t_kierowcy.id_driver = t_przesiadki.id_driver) 
		  left join probe_type t_probe_type on t_cardata.id_probe_type=t_probe_type.id_probe_type 
		where evb2 = @car_or_driver_no and 
			 t_zdarzenia.date >= @start and 
			 t_zdarzenia.date <= @stop and (t_kierowcy.fired=0 or t_kierowcy.fired is null) and 
			(evb3 = 36 or evb3 = 37 or evb3 = 38 or evb3 = 39 
				 or evb3 = 10 or evb3 = 49 or evb3 = 115 or evb3 = 85 
				 or evb3 = 113 or evb3 = 15 or evb3 = 14 or evb3 = 171 or evb3 = 172 or evb3 = 173) 
		order by t_zdarzenia.id_device_data 
 
 
		select @num_records = count(*) 
			from partition_view 
			where evb2 = @car_or_driver_no and 
				 date >= @start and 
				 date <= @stop and 
				(evb3 = 36 or evb3 = 37 or evb3 = 38 or evb3 = 39 
					 or evb3 = 10 or evb3 = 49 or evb3 = 115 or evb3 = 85 
					 or evb3 = 113 or evb3 = 15 or evb3 = 14 or evb3 = 171 or evb3 = 172 or evb3 = 173) 
 
	end 
	else 
	begin 
		declare zdarzenia_gps_cr cursor for 
 
		select t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, 
		t1_probe_liters.liters as zb1, 
		t2_probe_liters.liters as zb2, 
		t_cardata.rej_numb, t_cardata.name, t_probe_type.description, 
		t_komentarze.comment as komentarz, t_kierowcy.driver_name as kierowca 
		from partition_view t_zdarzenia 
		  inner join car_change t_przesiadki 
			 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date 
							   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) 
 
		  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) 
		  left join fuel_tank t1_fuel_tank 
				  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) 
		  left join probe_liters t1_probe_liters 
				  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) 
		  left join fuel_tank t2_fuel_tank 
				  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) 
		  left join probe_liters t2_probe_liters 
				  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) 
		  left join comment t_komentarze 
				  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) 
		  left join driver t_kierowcy 
				  on (t_kierowcy.id_driver = t_przesiadki.id_driver) 
		  left join probe_type t_probe_type 
				  on (t_probe_type.id_probe_type=t_cardata.id_probe_type) 
		where t_przesiadki.id_driver = @car_or_driver_no and 
			 t_zdarzenia.date >= @start and 
			 t_zdarzenia.date <= @stop and (t_kierowcy.fired is null or t_kierowcy.fired = 0) and 
			(t_zdarzenia.evb3 = 36 or t_zdarzenia.evb3 = 37 or t_zdarzenia.evb3 = 38 or t_zdarzenia.evb3 = 39 
				 or t_zdarzenia.evb3 = 10 or t_zdarzenia.evb3 = 49 or t_zdarzenia.evb3 = 115 or 
				t_zdarzenia.evb3 = 85 or t_zdarzenia.evb3 = 113 or t_zdarzenia.evb3 = 15 or t_zdarzenia.evb3 = 14 or t_zdarzenia.evb3 = 171 or t_zdarzenia.evb3 = 172 or t_zdarzenia.evb3 = 173) 
		order by t_zdarzenia.id_device_data 
 
		select @num_records = count(*) 
		from partition_view t1 
		  inner join car_change t5 
			 on (t1.evb2 = t5.id_car and t1.date >= t5.start_date 
							   and (t1.date <= t5.end_date or t5.end_date is null)) 
		where t5.id_driver = @car_or_driver_no and 
			 t1.date >= @start and 
			 t1.date <= @stop and 
			(t1.evb3 = 36 or t1.evb3 = 37 or t1.evb3 = 38 or t1.evb3 = 39 or 
				t1.evb3 = 10 or t1.evb3 = 49 or t1.evb3 = 115 or 
				t1.evb3 = 85 or t1.evb3 = 113 or t1.evb3 = 15 or t1.evb3 = 14 or 
				t1.evb3 = 171 or t1.evb3 = 172 or t1.evb3 = 173) 
	end 
 
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
	declare @zb1 numeric(10, 3) 
	declare @zb2 numeric(10, 3) 
    declare @rej_numb varchar(200) 
    declare @name varchar(200) 
	declare @sonda varchar(5) 
	declare @komentarz varchar(7000) 
	declare @kierowca varchar(100) 
 
	declare @L_evdata datetime 
	declare @L_evb2 integer 
	declare @L_evb3 integer 
	declare @L_szerokosc numeric(15, 8) 
	declare @L_dlugosc numeric(15, 8) 
	declare @L_opis varchar(200) 
	declare @L_komentarz varchar(7000) 
	declare @L_dataczas varchar(20) 
	declare @L_czy_w_czasie_jazdy integer 
	declare @L_droga_dyn numeric(10, 3) 
	declare @L_zb1 numeric(10, 3) 
	declare @L_zb2 numeric(10, 3) 
 
	set @L_evdata = null 
 
	declare @licznik int 
	declare @last_szer numeric(15, 8) 
	declare @last_dl numeric(15, 8) 
	declare @czy_w_czasie_jazdy int 
	declare @szerokosc numeric(15, 8) 
	declare @dlugosc numeric(15, 8) 
	declare @droga_dyn numeric(10, 3) 
 
    set @licznik = 0 
 
    set @last_szer = 0.0 
    set @last_dl = 0.0 
    set @czy_w_czasie_jazdy = 0 
    set @szerokosc = 0.0 
    set @dlugosc = 0.0 
    set @droga_dyn = 0.0 
 
	declare @kiedy10 datetime 
	set @kiedy10 = null 
 
    declare @ss integer 
    declare @sek integer 
    declare @mm integer 
    declare @dd numeric(15, 10) 
    declare @ddd numeric(15, 10) 
 
	create table #zdarzenia_gps 
	( 
		id int not null identity(1, 1), 
		evdata datetime, 
		evb2 int, 
		evb3 int, 
		szerokosc varchar(30), 
		dlugosc varchar(30), 
		opis varchar(200), 
		komentarz varchar(7000), 
		dataczas varchar(20), 
		czy_w_czasie_jazdy int, 
		droga_dyn numeric(10, 3), 
		zb1 numeric(10, 3), 
		zb2 numeric(10, 3), 
		primary key(id) 
	) 
 
	declare @opis varchar(200) 
	declare @dataczas varchar(20) 
 
    declare @sek11 integer 
    declare @sek21 integer 
    declare @sek12 integer 
    declare @sek22 integer 
 
	declare @drugi_przebieg integer 
	set @drugi_przebieg = 0 
  declare @canceled bit 
  set @canceled = 0 
 
    set @drugi_przebieg = 0 
    while @drugi_przebieg <= 1 
    begin 
 
    open zdarzenia_gps_cr 
 
    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
            @evb8, @evb9, @evb10, @evdata, @zb1, @zb2, 
			@rej_numb, @name, @sonda, @komentarz, @kierowca 
	exec sp_progress_set @id_progress, @num_records, @num_records, @canceled output; 
    while (@@fetch_status <> -1) and (@canceled = 0) 
    begin 
		if @evb3 = 10 
			set @kiedy10 = @evdata 
 
		if @evb3 = 10 or @evb3 = 113 
			set @czy_w_czasie_jazdy = 1 
		else 
		if @evb3 = 49 or @evb3 = 115 or @evb3 = 85 
			set @czy_w_czasie_jazdy = 0 
 
		if @evb3 = 10 
			set @droga_dyn = 0 
		else 
		if @evb3 = 113 
			exec spDroga @evb2, @evb1, @evb10, @droga_dyn OUTPUT 
		else 
		if @evb3 = 85 
			exec spDroga @evb2, @evb9, @evb10, @droga_dyn OUTPUT 
 
		if (@evb3 = 15) and (@szerokosc <> 0.0) and (@dlugosc <> 0.0) and (@nested = 0) 
		begin 
			set @dataczas = 
				dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(hour, @evdata)))) + ':' + 
				dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(minute, @evdata)))) + ' ' + 
				LTRIM(STR(YEAR(@evdata))) + '-' + 
				dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(@evdata)))) + '-' + 
				dbo.spDoDwochZnakowf(LTRIM(STR(DAY(@evdata)))) 
			set @opis = 'Poczatek wylaczenia zasilania: ' + @dataczas 
 
			if @drugi_przebieg = 0 
			begin 
				insert into #zdarzenia_gps (evdata, evb2, evb3, 
					szerokosc, dlugosc, opis, komentarz, dataczas, 
					czy_w_czasie_jazdy, droga_dyn, zb1, zb2) 
				values(@evdata, @evb2, @evb3, cast(@szerokosc as varchar(30)), cast(@dlugosc as varchar(30)), 
				@opis, @komentarz, @dataczas, @czy_w_czasie_jazdy, @droga_dyn, @zb1, @zb2) 
			end 
		end 
 
		if (@evb3 = 14) or (@evb3 = 171) or (@evb3 = 172) or (@evb3 = 173) 
		begin 
		    set @last_szer = 0.0 
			set @last_dl = 0.0 
		end 
 
		if ((@dodaj_pozycje = 1) or (@nested = 0)) begin 
		if (@evb3 = 38) and (@evb1 = 65) and 
		   (@evb4 >= 48) and (@evb4 <= 57) and 
           (@evb5 >= 48) and (@evb5 <= 57) and 
           (@evb6 >= 48) and (@evb6 <= 57) and 
           (@evb7 >= 48) and (@evb7 <= 57) 
 
		begin 
            select @sek11 = FLOOR(@evb8 / 16) - 3 
            select @sek21 = (@evb8 - (FLOOR(@evb8 / 16) * 16)) - 3 
            select @sek12 = FLOOR(@evB9 / 16) - 3 
            select @sek22 = (@evb9 - (FLOOR(@evb9 / 16) * 16)) - 3 
 
            if (@sek11 >= 0) and (@sek11 <= 9) and (@sek21 >= 0) and (@sek21 <= 9) 
                    and (@sek12 >= 0) and (@sek12 <= 9) and (@sek22 >= 0) 
                    and (@sek22 <= 9) 
            begin 
                select @szerokosc = CAST(CHAR(@evb4) + CHAR(@evb5) as integer) + 
                  (CAST(CHAR(@evb6) + CHAR(@evb7) as integer) / 60.0) 
                select @szerokosc = @szerokosc + 
                    (CAST((LTRIM(STR(@sek11)) + LTRIM(STR(@sek21)) + 
                    LTRIM(STR(@sek12)) + LTRIM(STR(@sek22))) as integer) / 600000.0) 
                if CHAR(@evb10) = 'S' 
                    select @szerokosc = @szerokosc * (-1) 
            end 
            else 
            begin 
                select @szerokosc = CAST((CHAR(@evb4) + 
                        CHAR(@evb5)) as integer) + 
                  (CAST((CHAR(@evb6) + 
                        CHAR(@evb7)) as integer) / 60.0) 
                if CHAR(@evb10) = 'S' 
                    select @szerokosc = @szerokosc * (-1.0) 
            end 
 
		    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
				@evb8, @evb9, @evb10, @evdata, @zb1, @zb2, 
				@rej_numb, @name, @sonda, @komentarz, @kierowca 
 
			set @licznik = @licznik + 1 
			if (@licznik % 10 = 0) 
			exec sp_progress_set @id_progress, @licznik, @num_records, @canceled output; 
 
			if (@evb3 = 39) and 
			   (@evb4 >= 48) and (@evb4 <= 57) and 
			   (@evb5 >= 48) and (@evb5 <= 57) and 
			   (@evb6 >= 48) and (@evb6 <= 57) and 
			   (@evb7 >= 48) and (@evb7 <= 57) and 
			   (@evb8 >= 48) and (@evb8 <= 57) 
			begin 
				select @sek11 = FLOOR(@evb1 / 16) - 3 
				select @sek21 = (@evb1 - (FLOOR(@evb1 / 16) * 16)) - 3; 
				select @sek12 = FLOOR(@evB9 / 16) - 3; 
				select @sek22 = (@evb9 - (FLOOR(@evb9 / 16) * 16)) - 3; 
 
				if (@sek11 >= 0) and (@sek11 <= 9) and (@sek21 >= 0) and (@sek21 <= 9) 
						and (@sek12 >= 0) and (@sek12 <= 9) and (@sek22 >= 0) 
						and (@sek22 <= 9) 
				begin 
					select @dlugosc = CAST((CHAR(@evb4) + 
							CHAR(@evb5) + CHAR(@evb6)) as integer) + 
					  (CAST((CHAR(@evb7) + 
							CHAR(@evb8)) as integer) / 60.0) + 
					  (CAST((LTRIM(STR(@sek11)) + LTRIM(STR(@sek21)) + 
						LTRIM(STR(@sek12)) + LTRIM(STR(@sek22))) as integer) / 600000.0) 
					if CHAR(@evb10) = 'W' 
						select @dlugosc = @dlugosc * (-1.0) 
				end 
				else 
				begin 
					select @dlugosc = CAST((CHAR(@evb4) + 
							CHAR(@evb5) + CHAR(@evb6)) as integer) + 
					  (CAST((CHAR(@evb7) + 
							CHAR(@evb8)) as integer) / 60.0) 
					if CHAR(@evb10) = 'W' 
						select @dlugosc = @dlugosc * (-1.0) 
				end 
 
				if (@last_szer = 0.0) and (@szerokosc <> 0.0) 
					select @last_szer = @szerokosc 
				if (@last_dl = 0.0) and (@dlugosc <> 0.0) 
					select @last_dl = @dlugosc 
 
				if ((abs(@last_szer - @szerokosc) < 1.0) and 
                   (abs(@last_dl - @dlugosc) < 1.0) or 
				   (@kiedy10 is not null)) and 
					  (@dlugosc <> 0.0) and (@szerokosc <> 0.0) 
				begin 
					select @last_szer = @szerokosc 
					select @last_dl = @dlugosc 
 
					set @dataczas = 
						dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(hour, @evdata)))) + ':' + 
						dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(minute, @evdata)))) + ' ' + 
						LTRIM(STR(YEAR(@evdata))) + '-' + 
						dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(@evdata)))) + '-' + 
						dbo.spDoDwochZnakowf(LTRIM(STR(DAY(@evdata)))) 
					set @opis = '' 
 
					if @drugi_przebieg = 0 
					begin 
						insert into #zdarzenia_gps (evdata, evb2, evb3, 
							szerokosc, dlugosc, opis, komentarz, dataczas, 
							czy_w_czasie_jazdy, droga_dyn, zb1, zb2) 
						values(@evdata, @evb2, @evb3, cast(@szerokosc as varchar(30)), cast(@dlugosc as varchar(30)), @opis, 
						@komentarz, @dataczas, @czy_w_czasie_jazdy, @droga_dyn, @zb1, @zb2) 
						set @kiedy10 = null 
					end 
					else 
					begin 
						set @L_evdata = @evdata; 
						set @L_evb2 = @evb2; 
						set @L_evb3 = @evb3; 
						set @L_szerokosc = @szerokosc; 
						set @L_dlugosc = @dlugosc; 
						set @L_opis = @opis; 
						set @L_komentarz = @komentarz; 
						set @L_dataczas = @dataczas; 
						set @L_czy_w_czasie_jazdy = @czy_w_czasie_jazdy; 
						set @L_droga_dyn = @droga_dyn; 
						set @L_zb1 = @zb1; 
						set @L_zb2 = @zb2; 
					end; 
					set @dodaj_pozycje = 0 
				end 
			end 
		end end 
 
        if ((@dodaj_pozycje = 1) or (@nested = 0)) begin 
        if (@evb3 = 36) 
        begin 
            select @szerokosc = 0.0; 
			if (@evb4 >= 48) and 
                    (@evb4 <= 57) and 
                (@evb5 >= 48) and 
                    (@evb5 <= 57) and 
                (@evb6 >= 48) and 
                    (@evb6 <= 57) and 
                (@evb7 >= 48) and 
                    (@evb7 <= 57) and 
                (@evb8 >= 48) and 
                    (@evb8 <= 57) and 
                (@evb9 >= 48) and 
                    (@evb9 <= 57) 
 
            begin 
                select @ss = CAST((CHAR(@evb4) + 
                        CHAR(@evb5)) as integer) 
                select @sek = CAST((CHAR(@evb8) + 
                        CHAR(@evb9)) as integer) 
                select @mm = CAST((CHAR(@evb6) + 
                        CHAR(@evb7)) as integer) 
 
                if (@ss >= 0) and (@ss <= 90) and (@sek <= 99) and (@mm >= 0) and 
                    (@mm <= 59) 
                begin 
                    select @dd = (@mm*100/60)/100.0 + (@sek*100/60)/10000.0 
                    select @szerokosc = FLOOR((@ss+@dd) * 1000000.0) / 1000000.0 
		            if (@evb10 = 83) 
						select @szerokosc = @szerokosc * (-1.0) 
                end 
            end; 
 
		    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
				@evb8, @evb9, @evb10, @evdata, @zb1, @zb2, 
				@rej_numb, @name, @sonda, @komentarz, @kierowca 
 
			set @licznik = @licznik + 1 
			if (@licznik % 10 = 0) 
			exec sp_progress_set @id_progress, @licznik, @num_records, @canceled output; 
 
            select @dlugosc = 0.0 
            if (@evb3 = 37) and (@evb4 >= 48) and 
                    (@evb4 <= 57) and 
                (@evb5 >= 48) and 
                    (@evb5 <= 57) and 
                (@evb6 >= 48) and 
                    (@evb6 <= 57) and 
                (@evb7 >= 48) and 
                    (@evb7 <= 57) and 
                (@evb8 >= 48) and 
                    (@evb8 <= 57) and 
                (@evb9 >= 48) and 
                    (@evb9 <= 57) 
            begin 
                select @dd = CAST((CHAR(@evb4) + 
                        CHAR(@evb5) + CHAR(@evb6)) as integer) 
                select @sek = CAST((CHAR(@evb9) + '0') as integer) 
                select @mm = CAST((CHAR(@evb7) + 
                        CHAR(@evb8)) as integer) 
 
                if (@dd >= 0) and (@dd <= 180) and (@sek <= 99) and (@mm >= 0) and 
                    (@mm <= 60) and (@sek <= 99) 
                begin 
                    select @ddd = (@mm*100/60)/100.0 + (@sek*100/60)/10000.0 
                    select @dlugosc = FLOOR((@dd+@ddd) * 1000000.0) / 1000000.0 
					If @evb10 = 87 
						select @dlugosc = @dlugosc * (-1.0) 
                end 
            end 
			if (@szerokosc <> 0.0) and (@dlugosc <> 0.0) 
			begin 
				set @dataczas = 
					dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(hour, @evdata)))) + ':' + 
					dbo.spDoDwochZnakowf(LTRIM(STR(DATEPART(minute, @evdata)))) + ' ' + 
					LTRIM(STR(YEAR(@evdata))) + '-' + 
					dbo.spDoDwochZnakowf(LTRIM(STR(MONTH(@evdata)))) + '-' + 
					dbo.spDoDwochZnakowf(LTRIM(STR(DAY(@evdata)))) 
				set @opis = '' 
 
				if @drugi_przebieg = 0 
				begin 
					insert into #zdarzenia_gps (evdata, evb2, evb3, 
						szerokosc, dlugosc, opis, komentarz, dataczas, 
						czy_w_czasie_jazdy, droga_dyn, zb1, zb2) 
					values(@evdata, @evb2, @evb3, cast(@szerokosc as varchar(30)), cast(@dlugosc as varchar(30)), @opis, 
					@komentarz, @dataczas, @czy_w_czasie_jazdy, @droga_dyn, @zb1, @zb2) 
				end 
				else 
				begin 
					set @L_evdata = @evdata; 
					set @L_evb2 = @evb2; 
					set @L_evb3 = @evb3; 
					set @L_szerokosc = @szerokosc; 
					set @L_dlugosc = @dlugosc; 
					set @L_opis = @opis; 
					set @L_komentarz = @komentarz; 
					set @L_dataczas = @dataczas; 
					set @L_czy_w_czasie_jazdy = @czy_w_czasie_jazdy; 
					set @L_droga_dyn = @droga_dyn; 
					set @L_zb1 = @zb1; 
					set @L_zb2 = @zb2; 
				end 
				set @dodaj_pozycje = 0 
			end 
        end end 
 
		if (@evb3 = 49) or (@evb3 = 115) or (@evb3 = 10) or (@nested = 0) 
		begin 
			set @dodaj_pozycje = 1 
		end 
 
		set @licznik = @licznik + 1 
		if (@licznik % 10 = 0) 
		exec sp_progress_set @id_progress, @licznik, @num_records, @canceled output; 
 
	    fetch zdarzenia_gps_cr into @id, @evb1, @evb2, @evb3, @evb4, @evb5, @evb6, @evb7, 
            @evb8, @evb9, @evb10, @evdata, @zb1, @zb2, 
			@rej_numb, @name, @sonda, @komentarz, @kierowca 
	end 
    close zdarzenia_gps_cr 
    deallocate zdarzenia_gps_cr 
 
	if (@drugi_przebieg = 1) and (@L_evdata is not null) 
	begin 
		insert into #zdarzenia_gps (evdata, evb2, evb3, 
			szerokosc, dlugosc, opis, komentarz, dataczas, 
			czy_w_czasie_jazdy, droga_dyn, zb1, zb2) 
		values(@L_evdata, @L_evb2, 123, cast(@L_szerokosc as varchar(30)), 
		cast(@L_dlugosc as varchar(30)), @L_opis, 
		@L_komentarz, @L_dataczas, @L_czy_w_czasie_jazdy, @L_droga_dyn, @L_zb1, @L_zb2) 
	end 
 
	select @result_count = count(*) from #zdarzenia_gps 
 
	if (@result_count = 0) and (@ShowLastPostionIfNone = 1) and (@drugi_przebieg = 0) and (@nested = 0) 
	begin 
		if @isInCarMode = 1 
		begin 
			declare zdarzenia_gps_cr cursor for 
			select top 500 t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, 
			t1_probe_liters.liters as zb1, 
			t2_probe_liters.liters as zb2, 
			t_cardata.rej_numb, t_cardata.name, t_probe_type.description, 
			t_komentarze.comment as komentarz, driver_name as kierowca 
			from partition_view t_zdarzenia 
			  left join car_change t_przesiadki 
				 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date 
								   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) 
			  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) 
			  left join fuel_tank t1_fuel_tank 
					  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) 
			  left join probe_liters t1_probe_liters 
					  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) 
			  left join fuel_tank t2_fuel_tank 
					  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) 
			  left join probe_liters t2_probe_liters 
					  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) 
			  left join comment t_komentarze 
					  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) 
			  left join driver t_kierowcy 
					  on (t_kierowcy.id_driver = t_przesiadki.id_driver) 
			  left join probe_type t_probe_type on t_cardata.id_probe_type=t_probe_type.id_probe_type 
			where evb2 = @car_or_driver_no and 
				 t_zdarzenia.date < @start and 
				 (t_kierowcy.fired=0 or t_kierowcy.fired is null) and 
				(evb3 = 36 or evb3 = 37 or evb3 = 38 or evb3 = 39 
					 or evb3 = 10 or evb3 = 49 or evb3 = 115 or evb3 = 85 
					 or evb3 = 113 or evb3 = 15 or evb3 = 14 or evb3 = 171 or evb3 = 172 or evb3 = 173) 
			order by t_zdarzenia.id_device_data 
 
			select @num_records = 500 
		end 
		else 
		begin 
			declare zdarzenia_gps_cr cursor for 
			select top 500 t_zdarzenia.id_device_data,t_zdarzenia.evb1, t_zdarzenia.evb2, t_zdarzenia.evb3, t_zdarzenia.evb4, t_zdarzenia.evb5, t_zdarzenia.evb6, t_zdarzenia.evb7, t_zdarzenia.evb8, t_zdarzenia.evb9, t_zdarzenia.evb10, t_zdarzenia.date, 
			t1_probe_liters.liters as zb1, 
			t2_probe_liters.liters as zb2, 
			t_cardata.rej_numb, t_cardata.name, t_probe_type.description, 
			t_komentarze.comment as komentarz, t_kierowcy.driver_name as kierowca 
			from partition_view t_zdarzenia 
			  inner join car_change t_przesiadki 
				 on (t_zdarzenia.evb2 = t_przesiadki.id_car and t_zdarzenia.date >= t_przesiadki.start_date 
								   and (t_zdarzenia.date <= t_przesiadki.end_date or t_przesiadki.end_date is null)) 
 
			  left join car t_cardata on (t_cardata.id_car = t_zdarzenia.evb2) 
			  left join fuel_tank t1_fuel_tank 
					  on (t1_fuel_tank.id_car = t_cardata.id_car and t1_fuel_tank.tank_nr=1) 
			  left join probe_liters t1_probe_liters 
					  on (t1_fuel_tank.id_fuel_tank=t1_probe_liters.id_fuel_tank and t1_probe_liters.id_probe=t_zdarzenia.pal1) 
			  left join fuel_tank t2_fuel_tank 
					  on (t2_fuel_tank.id_car = t_cardata.id_car and t2_fuel_tank.tank_nr=2) 
			  left join probe_liters t2_probe_liters 
					  on (t2_fuel_tank.id_fuel_tank=t2_probe_liters.id_fuel_tank and t2_probe_liters.id_probe=t_zdarzenia.pal2) 
			  left join comment t_komentarze 
					  on (cast(cast(t_zdarzenia.date - 0.5 as integer) as datetime) = t_komentarze.date and t_zdarzenia.evb2 = t_komentarze.id_car) 
			  left join driver t_kierowcy 
					  on (t_kierowcy.id_driver = t_przesiadki.id_driver) 
			  left join probe_type t_probe_type 
					  on (t_probe_type.id_probe_type=t_cardata.id_probe_type) 
			where t_przesiadki.id_driver = @car_or_driver_no and 
				 t_zdarzenia.date < @start and 
				 (t_kierowcy.fired is null or t_kierowcy.fired = 0) and 
				(t_zdarzenia.evb3 = 36 or t_zdarzenia.evb3 = 37 or t_zdarzenia.evb3 = 38 or t_zdarzenia.evb3 = 39 
					 or t_zdarzenia.evb3 = 10 or t_zdarzenia.evb3 = 49 or t_zdarzenia.evb3 = 115 or 
					t_zdarzenia.evb3 = 85 or t_zdarzenia.evb3 = 113 or t_zdarzenia.evb3 = 15 or t_zdarzenia.evb3 = 14 or t_zdarzenia.evb3 = 171 or t_zdarzenia.evb3 = 172 or t_zdarzenia.evb3 = 173) 
			order by t_zdarzenia.id_device_data 
 
			select @num_records = 500 
		end 
		set @drugi_przebieg = 1 
	end 
      else 
        break 
    end 
  if @nested = 0 
	  exec sp_progress_unregister @id_progress; 
 
  if @nested = 1 
  begin 
	declare @start_praca_pr datetime 
	declare @stop_praca_pr datetime 
	declare @id_pr integer 
	declare @szerokosc0 varchar(30) 
	declare @dlugosc0 varchar(30) 
 
	declare czas_pracy_cr cursor for 
	select id, start_praca, stop_praca from #eksport_day_work 
	order by id 
 
 
	open czas_pracy_cr 
	fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr 
	while (@@fetch_status <> -1) and (@canceled = 0) 
	begin 
		select top 1 @szerokosc0 = szerokosc from #zdarzenia_gps where evdata >= @start_praca_pr order by evdata 
		select top 1 @dlugosc0 = dlugosc from #zdarzenia_gps where evdata >= @start_praca_pr order by evdata 
		select top 1 @szerokosc = szerokosc from #zdarzenia_gps where evdata >= @stop_praca_pr order by evdata 
		select top 1 @dlugosc = dlugosc from #zdarzenia_gps where evdata >= @stop_praca_pr order by evdata 
		update #eksport_day_work set szerokosc = @szerokosc, dlugosc = @dlugosc, szerokosc0 = @szerokosc0, dlugosc0 = @dlugosc0 where id = @id_pr 
		fetch czas_pracy_cr into @id_pr, @start_praca_pr, @stop_praca_pr 
	end 
	close czas_pracy_cr 
	deallocate czas_pracy_cr 
  end 
  else 
    select * from #zdarzenia_gps order by id; 
