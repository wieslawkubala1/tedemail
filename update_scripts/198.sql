ALTER VIEW [dbo].[view_device_data_with_fuel] 
AS 
SELECT  TOP 100 PERCENT dbo.partition_view.id_device_data, dbo.partition_view.evb2, dbo.event_with_fuel.tank_nr 
FROM         partition_view INNER JOIN 
                      dbo.event ON dbo.partition_view.evb3 = dbo.event.id_event INNER JOIN 
                      dbo.event_with_fuel ON dbo.event.id_event = dbo.event_with_fuel.id_event 