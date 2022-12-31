ALTER procedure [dbo].[spPaliwo] 
	@carno integer, 
	@evb3 integer, 
	@nr_zb integer, 
	@pal integer, 
	@mpal integer, 
	@wynik numeric(10, 3) OUTPUT 
as 
    if (@mpal <> 0) and (@mpal <> 64) and (@mpal <> 128) and (@mpal <> 192) 
        set @mpal = 0; 
    if (@mpal = 64)  
        set @mpal = 1 
    else 
    if (@mpal = 128)  
        set @mpal = 2 
    else 
    if (@mpal = 192)  
        set @mpal = 3 
 
	create table #eee 
	( 
		ltr numeric(10, 3) 
	) 
 
	declare @id_fuel_tank integer 
	declare @max_probe integer 
 
 
	if(@pal <= 0) 
		select @wynik = 0 
	else 
	begin 
		select @id_fuel_tank = id_fuel_tank, @max_probe = max_probe from fuel_tank where id_car = @carno and tank_nr = @nr_zb 
		if (@max_probe = 255  or  @max_probe = 0) 
		begin 
			set @wynik = dbo.compute_fuel(@id_fuel_tank, @evb3, 
					@pal, 
					0); 
		end 
		else 
		if (@max_probe = 1023) 
		begin 
			set @wynik = dbo.compute_fuel(@id_fuel_tank, @evb3, 
					(@pal * 4) + @mpal, 
					0); 
		end 
	end 
 
	declare @enabled1 integer 
	declare @wsp1 integer 
	declare @kind1 integer 
	declare @start_pos1_bak1 integer 
	declare @start_pos1_bak2 integer 
	declare @enabled2 integer 
	declare @wsp2 integer 
	declare @kind2 integer 
	declare @start_pos2_bak1 integer 
	declare @start_pos2_bak2 integer 
	declare @wynik1 numeric(10, 3) 
	declare @wynik2 numeric(10, 3) 
 	declare @suma numeric(10, 3) 
	declare @licznik integer 
	declare @i integer 
	declare @memi numeric(10, 3) 
	declare @memj numeric(10, 3) 
	declare @start_pos1 integer 
	declare @start_pos2 integer 
 
 
	select @enabled1 = enabled1 from #aproksymacja_params 
	select @wsp1 = wsp1 from #aproksymacja_params 
	select @kind1 = kind1 from #aproksymacja_params 
	select @start_pos1_bak1 = start_pos1_bak1 from #aproksymacja_params 
	select @start_pos1_bak2 = start_pos1_bak2 from #aproksymacja_params 
 
	select @enabled2 = enabled2 from #aproksymacja_params 
	select @wsp2 = wsp2 from #aproksymacja_params 
	select @kind2 = kind2 from #aproksymacja_params 
	select @start_pos2_bak1 = start_pos2_bak1 from #aproksymacja_params 
	select @start_pos2_bak2 = start_pos2_bak2 from #aproksymacja_params 
 
	if (@enabled1 is not null) and (@enabled1 = 1) and (@wynik is not null) 
		and (@evb3 <> 117) and (@evb3 <> 118) and (@evb3 <> 217) and (@evb3 <> 218) 
	begin 
		if @nr_zb = 1 
		begin 
			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak1 and nr_zb = @nr_zb and step = 1 
			select @start_pos1_bak1 = @start_pos1_bak1 + 1 
			if @start_pos1_bak1 >= @wsp1 
				select @start_pos1_bak1 = 0 
			select @start_pos1 = @start_pos1_bak1 
		end 
		else 
		if @nr_zb = 2 
		begin 
			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak2 and nr_zb = @nr_zb and step = 1 
			select @start_pos1_bak2 = @start_pos1_bak2 + 1 
			if @start_pos1_bak2 >= @wsp1 
				select @start_pos1_bak2 = 0 
			select @start_pos1 = @start_pos1_bak2 
		end 
		update #aproksymacja_params set start_pos1_bak1 = @start_pos1_bak1, start_pos1_bak2 = @start_pos1_bak2 
 
		if @kind1 = 1 
		begin 
			delete from #eee 
			insert into #eee (ltr) 
				SELECT TOP 50 PERCENT ltr 
				FROM #aproksymacja 
				WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0 
				ORDER BY ltr 
 
			SELECT @wynik1 = (SELECT TOP 1 ltr from #eee order by ltr DESC) 
 
			IF (SELECT COUNT(*) % 2 FROM #aproksymacja 
				WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0) = 1 
			begin 
				select @wynik = @wynik1 
			end 
			else 
			begin 
				delete from #eee 
				insert into #eee (ltr) 
					SELECT TOP 50 PERCENT ltr 
					FROM #aproksymacja 
					WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0 
					ORDER BY ltr DESC 
 
				SELECT @wynik2 = (SELECT TOP 1 ltr from #eee order by ltr) 
 
				select @wynik = (@wynik1 + @wynik2) / 2.0 
			end 
		end 
		else 
		if @kind1 = 2 
		begin 
			SELECT @wynik1 = AVG(ltr) 
			FROM #aproksymacja 
			WHERE nr_zb = @nr_zb and step = 1 and ltr <> 1000000.0 
 
			select @wynik = @wynik1 
		end 
		else 
		if @kind1 = 3 
		begin 
			select @suma = 0.0 
			select @licznik = 0 
 
			select @i = @start_pos1 - 1 
			while (@i >= (@start_pos1 - @wsp1)) 
			begin 
				select @memi = ltr from #aproksymacja where id = ((@i + @wsp1) % @wsp1) 
						and nr_zb = @nr_zb and step = 1 
				if @memi <> 1000000 
				begin 
				    select @suma = @suma + cast((@memi * @memi) as numeric(10, 3)) 
				    select @licznik = @licznik + 1 
				end 
				select @i = @i - 1 
			end; 
			if @licznik <> 0 
			begin 
				select @wynik = cast(sqrt(@suma / @licznik) as numeric(10, 3)) 
			end 
		end 
 
		if (@enabled2 is not null) and (@enabled2 = 1) 
		begin 
			if @nr_zb = 1 
			begin 
				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak1 and nr_zb = @nr_zb and step = 2 
				select @start_pos2_bak1 = @start_pos2_bak1 + 1 
				if @start_pos2_bak1 >= @wsp2 
					select @start_pos2_bak1 = 0 
				select @start_pos2 = @start_pos2_bak1 
			end 
			else 
			if @nr_zb = 2 
			begin 
				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak2 and nr_zb = @nr_zb and step = 2 
				select @start_pos2_bak2 = @start_pos2_bak2 + 1 
				if @start_pos2_bak2 >= @wsp2 
					select @start_pos2_bak2 = 0 
				select @start_pos2 = @start_pos2_bak2 
			end 
			update #aproksymacja_params set start_pos2_bak1 = @start_pos2_bak1, start_pos2_bak2 = @start_pos2_bak2 
 
			if @kind2 = 1 
			begin 
				delete from #eee 
				insert into #eee (ltr) 
					SELECT TOP 50 PERCENT ltr 
					FROM #aproksymacja 
					WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0 
					ORDER BY ltr 
 
				SELECT @wynik1 = (SELECT TOP 1 ltr from #eee order by ltr DESC) 
 
				IF (SELECT COUNT(*) % 2 FROM #aproksymacja 
					WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0) = 1 
				begin 
					select @wynik = @wynik1 
				end 
				else 
				begin 
					delete from #eee 
					insert into #eee (ltr) 
						SELECT TOP 50 PERCENT ltr 
						FROM #aproksymacja 
						WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0 
						ORDER BY ltr DESC 
 
					SELECT @wynik2 = (SELECT TOP 1 ltr from #eee order by ltr) 
 
					select @wynik = (@wynik1 + @wynik2) / 2.0 
				end 
			end 
			else 
			if @kind2 = 2 
			begin 
				SELECT @wynik1 = AVG(ltr) 
				FROM #aproksymacja 
				WHERE nr_zb = @nr_zb and step = 2 and ltr <> 1000000.0 
				select @wynik = @wynik1 
			end 
			else 
			if @kind2 = 3 
			begin 
				select @suma = 0.0 
				select @licznik = 0 
 
				select @i = @start_pos2 - 1 
				while (@i >= (@start_pos2 - @wsp2)) 
				begin 
					select @memi = ltr from #aproksymacja where id = ((@i + @wsp2) % @wsp2) 
							and nr_zb = @nr_zb and step = 2 
					if @memi <> 1000000 
					begin 
 
					    select @suma = @suma + cast((@memi * @memi) as numeric(10, 3)) 
						select @licznik = @licznik + 1 
					end 
					select @i = @i - 1 
				end; 
				if @licznik <> 0 
				begin 
					select @wynik = cast(sqrt(@suma / @licznik) as numeric(10, 3)) 
				end 
			end 
		end 
	end 
	else 
	if (@enabled1 is not null) and (@enabled1 = 1) and (@wynik is not null) 
		and ((@evb3 = 118) or (@evb3 = 218)) 
	begin 
		if @nr_zb = 1 
		begin 
			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak1 and nr_zb = @nr_zb and step = 1 
			select @start_pos1_bak1 = @start_pos1_bak1 + 1 
			if @start_pos1_bak1 >= @wsp1 
				select @start_pos1_bak1 = 0 
		end 
		else 
		if @nr_zb = 2 
		begin 
			update #aproksymacja set ltr = @wynik where id = @start_pos1_bak2 and nr_zb = @nr_zb and step = 1 
			select @start_pos1_bak2 = @start_pos1_bak2 + 1 
			if @start_pos1_bak2 >= @wsp1 
				select @start_pos1_bak2 = 0 
		end 
		update #aproksymacja_params set start_pos1_bak1 = @start_pos1_bak1, start_pos1_bak2 = @start_pos1_bak2 
		if (@enabled2 is not null) and (@enabled2 = 1) 
		begin 
			if @nr_zb = 1 
			begin 
				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak1 and nr_zb = @nr_zb and step = 2 
				select @start_pos2_bak1 = @start_pos2_bak1 + 1 
				if @start_pos2_bak1 >= @wsp2 
					select @start_pos2_bak1 = 0 
			end 
			else 
			if @nr_zb = 2 
			begin 
				update #aproksymacja set ltr = @wynik where id = @start_pos2_bak2 and nr_zb = @nr_zb and step = 2 
				select @start_pos2_bak2 = @start_pos2_bak2 + 1 
				if @start_pos2_bak2 >= @wsp2 
					select @start_pos2_bak2 = 0 
			end 
			update #aproksymacja_params set start_pos2_bak1 = @start_pos2_bak1, start_pos2_bak2 = @start_pos2_bak2 
		end 
	end 