
ALTER VIEW [dbo].[view_last_gps_with_state]
AS
SELECT     dbo.view_cars_with_current_drivers.id_car, dbo.view_cars_with_current_drivers.name, dbo.view_cars_with_current_drivers.rej_numb, 
                      dbo.view_cars_with_current_drivers.driver_name, device_data_2.evb3 AS state_evb3, dbo.gps_latitude(device_data_1.evb1, device_data_1.evb4, 
                      device_data_1.evb5, device_data_1.evb6, device_data_1.evb7, device_data_1.evb8, device_data_1.evb9, device_data_1.evb10) AS latitude, 
                      dbo.gps_longitude(dbo.partition_view.evb1, dbo.partition_view.evb4, dbo.partition_view.evb5, dbo.partition_view.evb6, dbo.partition_view.evb7, 
                      dbo.partition_view.evb8, dbo.partition_view.evb9, dbo.partition_view.evb10) AS longitude, device_data_2.date, dbo.events_online.dataczas AS eo_dataczas, 
                      dbo.events_online.gps AS eo_gps, dbo.events_online.state AS eo_state, dbo.events_online.evb3 AS eo_evb3, 
                      dbo.events_online.gps_status AS eo_gps_status, dbo.events_online.packet_prefix AS eo_packet_prefix
FROM         dbo.view_last_gps_with_state_id INNER JOIN
                      dbo.partition_view ON dbo.view_last_gps_with_state_id.gps_id_device_data_39 = dbo.partition_view.id_device_data INNER JOIN
                      dbo.partition_view AS device_data_1 ON dbo.view_last_gps_with_state_id.gps_id_device_data_38 = device_data_1.id_device_data INNER JOIN
                      dbo.partition_view AS device_data_2 ON dbo.view_last_gps_with_state_id.max_state_id_device_data = device_data_2.id_device_data INNER JOIN
                      dbo.view_cars_with_current_drivers ON dbo.view_last_gps_with_state_id.evb2 = dbo.view_cars_with_current_drivers.id_car LEFT OUTER JOIN
                      dbo.events_online ON dbo.view_last_gps_with_state_id.evb2 = dbo.events_online.car_no AND dbo.events_online.dataczas > dbo.partition_view.date
