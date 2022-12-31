create table chart_data
(
	id_chart_data bigint identity(1, 1),
	id_car int,
	start_date datetime,
	stop_date datetime,
	generated_at datetime,
	primary key (id_chart_data)
)

create table chart_data_item
(
	id_chart_data_item bigint identity(1, 1),
	id_chart_data bigint not null,
	id_device_data bigint not null,
	primary key (id_chart_data_item),
	foreign key (id_chart_data) references chart_data(id_chart_data) on delete cascade
)