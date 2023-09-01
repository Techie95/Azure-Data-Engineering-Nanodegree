IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacity3_udacity3_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacity3_udacity3_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacity3@udacity3.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.payments (
	[payment_id] nvarchar(4000),
	[date] nvarchar(4000),
	[amount] nvarchar(4000),
	[rider_id] nvarchar(4000)
	)
	WITH (
	LOCATION = 'publicpayment.txt',
	DATA_SOURCE = [udacity3_udacity3_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.payments
GO