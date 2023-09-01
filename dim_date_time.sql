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

IF OBJECT_ID('dbo.dim_date_time') IS NOT NULL 
BEGIN 
	DROP EXTERNAL TABLE [dbo].[dim_date_time]; 
END

CREATE EXTERNAL TABLE dbo.dim_date_time
WITH (
    LOCATION     = 'dim_date_time',
    DATA_SOURCE = [udacity3_udacity3_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS

SELECT
    TO_CHAR(t.start_at, 'HH24:MI:SS') AS time_id,
    CAST(t.start_at AS DATE) AS date,
    EXTRACT(DOW FROM t.start_at) AS day_of_week,
    EXTRACT(DAY FROM t.start_at) AS day_of_month,
    EXTRACT(WEEK FROM t.start_at) AS week_of_year,
    EXTRACT(MONTH FROM t.start_at) AS month,
    EXTRACT(QUARTER FROM t.start_at) AS quarter,
    EXTRACT(YEAR FROM t.start_at) AS year,
	t.ended_at AS ended_at,
	p.payment_date AS payment_date	
FROM dbo.trips t
JOIN dbo.payments p ON t.rider_id = p.rider_id;


SELECT TOP 100 * FROM dbo.dim_date_time
GO