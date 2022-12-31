
ALTER VIEW [dbo].[view_gps_with_less_10_113_85_49_etc]
AS
SELECT     dbo.view_last_gps_device_data.evb2, dbo.view_last_gps_device_data.gps_id_device_data_38, 
                      dbo.view_last_gps_device_data.gps_id_device_data_39, dbo.partition_view.id_device_data AS state_id_device_data
FROM         dbo.view_last_gps_device_data INNER JOIN
                      dbo.partition_view ON dbo.view_last_gps_device_data.evb2 = dbo.partition_view.evb2 AND 
                      dbo.partition_view.id_device_data < dbo.view_last_gps_device_data.gps_id_device_data_39 AND dbo.partition_view.evb3 IN (10, 113, 213, 119, 219, 85, 
                      49, 115)
