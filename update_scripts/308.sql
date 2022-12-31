delete from event where id_event in
(select 117
union
select 118
union
select 217
union
select 218)