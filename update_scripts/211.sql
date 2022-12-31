create table partition_info
(
 last_lower_range_change datetime,
 lower_range datetime
)

insert into partition_info (last_lower_range_change, lower_range)
values (DATEADD(day, -1000, getdate()), DATEADD(month, -3, getdate()))