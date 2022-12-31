delete from partition_info;

insert into partition_info (last_lower_range_change, lower_range)
values (DATEADD(day, 1000, getdate()), DATEADD(month, 1000, getdate()));