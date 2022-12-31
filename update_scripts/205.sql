
ALTER FUNCTION [dbo].[get_previous_device_data_with_fuel]
(
	@tank_nr int,           -- numer zbiornika
	@id_device_data bigint	-- id zdarzenia
)
RETURNS bigint
AS
BEGIN
	declare @evb3 tinyint;
    declare @evb2 tinyint;
	declare @id_last_event_with_fuel bigint;
	declare @id_event_with_fuel int;
	
	
	if (@tank_nr < 1 or @tank_nr > 9)
	        return NULL;
	select @evb2=evb2,@evb3=evb3 from partition_view where id_device_data=@id_device_data;
	-- sprawdz czy zdarzenie posiada dane dotyczace paliwa w tym zbiorniku
	-- jest tak tylko wtedy gdy figuruje w tabeli event_with_fuel
	set @id_event_with_fuel = (select id_event_with_fuel from event_with_fuel where id_event=@evb3 and tank_nr=@tank_nr);
	if (@id_event_with_fuel is NULL)
	begin
	        -- zdarzenie nie ma informacji o paliwie
	        
	        -- poszukiwane jest poprzednie zdarzenie z paliwem, dotyczace tego samego pojazdu i zbiornika
	        -- jego id jest podstawienae za @id_last_event_with_fuel
	        
	        set @id_last_event_with_fuel = (select top 1 id_device_data 
				from view_device_data_with_fuel 
				where id_device_data<@id_device_data and evb2=@evb2 and tank_nr=@tank_nr
				order by id_device_data desc
				);

	end
	else
	begin
	       -- jesli zdarzenie zawiera informacje o paliwie, to jego id jest podstawiane
	       -- za @id_last_event_with_fuel
	       set @id_last_event_with_fuel = @id_device_data;
	end        
	return @id_last_event_with_fuel;
END



