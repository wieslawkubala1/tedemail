
	create procedure [dbo].[sp_day_work_with_tank] 
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
	