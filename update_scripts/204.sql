ALTER VIEW [dbo].[view_speedEvents_driverMode]
AS
SELECT     TOP 100 PERCENT dbo.partition_view.evb2, dbo.partition_view.evb3, dbo.partition_view.evb9, dbo.partition_view.evb10, dbo.partition_view.date, 
                      dbo.car.name AS car_name, dbo.car.rej_numb, dbo.driver.id_driver, dbo.road_imp_div.imp_div, dbo.car.fast_imp, dbo.partition_view.id_device_data, 
                      dbo.driver.driver_name
FROM         dbo.partition_view INNER JOIN
                      dbo.car ON dbo.partition_view.evb2 = dbo.car.id_car INNER JOIN
                      dbo.car_change ON dbo.car.id_car = dbo.car_change.id_car AND dbo.partition_view.date >= dbo.car_change.start_date AND 
                      (dbo.partition_view.date <= dbo.car_change.end_date OR
                      dbo.car_change.end_date IS NULL) INNER JOIN
                      dbo.driver ON dbo.car_change.id_driver = dbo.driver.id_driver INNER JOIN
                      dbo.road_imp_div ON dbo.car.id_road_imp_div = dbo.road_imp_div.id_road_imp_div
WHERE     (dbo.partition_view.evb3 IN (50, 51, 57, 58))
