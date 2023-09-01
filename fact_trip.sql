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

IF OBJECT_ID('dbo.fact_trip') IS NOT NULL 
BEGIN 
	DROP EXTERNAL TABLE [dbo].[fact_trip]; 
END

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION     = 'fact_trip',
    DATA_SOURCE = [udacity3_udacity3_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS

SELECT
    t.trip_id AS trip_id,
	t.rideable_type AS rideable_type,
	t.start_at AS started_at,
    t.ended_at AS ended_at,
    t.start_station_id AS start_station_id,
    t.end_station_id AS end_station_id,
	t.rider_id AS rider_id,
	DATEDIFF(year, r.birthday, t.start_at) AS rider_age,
    DATEDIFF(MINUTE, t.start_at, t.ended_at) AS trip_duration
FROM dbo.trips t
JOIN dbo.riders r ON t.rider_id = r.rider_id;

SELECT TOP 100 * FROM dbo.fact_trip
GO