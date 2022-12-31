ALTER FUNCTION [dbo].[get_device_data_fuel2]
(
	@tank_nr int,           -- numer zbiornika
	@id_device_data bigint	-- id zdarzenia
)
RETURNS numeric(10,1)
AS
BEGIN
    declare @fuel numeric(10,1);          -- ilosc paliwa w zbiorniku
    declare @evb4 tinyint;
	declare @evb9 tinyint;
	declare @evb3 tinyint;
	declare @evb2 tinyint;
	declare @id_last_event_with_fuel bigint;
	declare @id_fuel_tank int;
	
    set @fuel = NULL;
        
    set @id_last_event_with_fuel = dbo.get_previous_device_data_with_fuel(@tank_nr, @id_device_data);
        -- sprawdz czy numer zbiornika jest poprawny
	if (@id_last_event_with_fuel is not NULL)
	begin
		
		select @evb2=evb2,@evb3=evb3,@evb4=evb4,@evb9=evb9 from partition_view where id_device_data=@id_last_event_with_fuel;
		set @id_fuel_tank = (select id_fuel_tank from fuel_tank where id_car=@evb2 and tank_nr=@tank_nr);
		-- zwracana jest ilosc paliwa w zdarzeniu @id_last_event_with_fuel
		set @fuel = dbo.compute_fuel(@id_fuel_tank, @evb3, @evb4, @evb9);
	end
	return @fuel;
END