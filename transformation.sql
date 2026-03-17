
CREATE SCHEMA IF NOT EXISTS silver;
USE SCHEMA silver;

//creating dynamic table 
CREATE OR REPLACE DYNAMIC TABLE silver_clickstream 
    TARGET_LAG = '5 MINUTES'
    WAREHOUSE = 'COMPUTE_WH'
AS
SELECT 
    json_data:event_id::VARCHAR        AS event_id,
    json_data:user_id::VARCHAR         AS user_id,
    json_data:action::VARCHAR          AS action,
    json_data:device::VARCHAR          AS device,
    json_data:page_url::VARCHAR        AS page_url,
    json_data:event_timestamp::TIMESTAMP_NTZ AS event_timestamp
FROM clickstream.bronze.json_ingest;


SELECT * FROM silver_clickstream;