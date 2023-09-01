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

IF OBJECT_ID('dbo.dim_rider') IS NOT NULL 
BEGIN 
	DROP EXTERNAL TABLE [dbo].[dim_rider]; 
END

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
    LOCATION     = 'dim_rider',
    DATA_SOURCE = [udacity3_udacity3_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS

SELECT
    
	 DISTINCT [rider_id],
	[first] AS first_name,
	[last] AS last_name,
	[address],
	[birthday] ,
	[account_start_date],
	[account_end_date],
	[is_member]
FROM dbo.riders;

SELECT TOP 100 * FROM dbo.dim_rider
GO