drop index _dta_index_device_data_6_357576312__K3_K1_K4 on dbo.device_data;
drop index _dta_index_device_data_6_357576312__K4_K3_K12 on dbo.device_data;

CREATE NONCLUSTERED INDEX [device_data_index] ON [dbo].[device_data]
(
	[evb2] ASC,
	[evb3] ASC,
	[date] ASC
)

