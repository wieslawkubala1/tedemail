create view partition_view 
as
select id_device_data,evb1,evb2,evb3,evb4,evb5,evb6,evb7,evb8,evb9,evb10,pal1,pal2,date,timezonebias from 
dbo.device_data