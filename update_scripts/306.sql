delete from device_data where evb3 in 
(select 117
union
select 118
union
select 217
union
select 218)