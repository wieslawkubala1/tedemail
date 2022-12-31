ALTER VIEW [dbo].[view_device_data_38]
AS
SELECT     id_device_data, evb1, evb2, evb3, evb4, evb5, evb6, evb7, evb8, evb9, evb10
FROM         partition_view
WHERE     (evb3 = 38) AND (evb4 >= 48) AND (evb4 <= 57) AND (evb5 >= 48) AND (evb5 <= 57) AND (evb6 >= 48) AND (evb6 <= 57) AND (evb7 >= 48) AND 
                      (evb7 <= 57)