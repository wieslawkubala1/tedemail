ALTER VIEW [dbo].[view_nonstandardEvents_driverMode]
AS
SELECT     TOP 100 PERCENT dbo.partition_view.evb1, dbo.partition_view.evb2, dbo.partition_view.evb4, dbo.partition_view.evb9, 
dbo.partition_view.evb10, 
                      dbo.partition_view.date, dbo.event.description, dbo.car.name AS car_name, dbo.car.rej_numb, dbo.driver.id_driver, dbo.partition_view.evb3, 
                      dbo.partition_view.id_device_data, dbo.driver.driver_name
FROM         dbo.partition_view INNER JOIN
                      dbo.car ON dbo.partition_view.evb2 = dbo.car.id_car INNER JOIN
                      dbo.car_change ON dbo.car.id_car = dbo.car_change.id_car AND dbo.partition_view.date >= dbo.car_change.start_date AND 
                      (dbo.partition_view.date <= dbo.car_change.end_date OR
                      dbo.car_change.end_date IS NULL) INNER JOIN
                      dbo.driver ON dbo.car_change.id_driver = dbo.driver.id_driver INNER JOIN
                      dbo.event ON dbo.partition_view.evb3 = dbo.event.id_event INNER JOIN
                      dbo.event_nonstandard ON dbo.event.id_event = dbo.event_nonstandard.id_event
