//defines bronze ingestion layer
USE DATABASE clickstream;
USE SCHEMA bronze;

//creating target table 
CREATE OR REPLACE TABLE json_ingest (
    json_data VARIANT
);

//creating snowpipe
CREATE OR REPLACE PIPE s3_pipe
    AUTO_INGEST = TRUE
AS 
COPY INTO clickstream.bronze.json_ingest
FROM @clickstream.bronze.s3_stg
FILE_FORMAT = (FORMAT_NAME = clickstream.bronze.json_format)
ON_ERROR = CONTINUE;

//check if pipe is running 
SELECT SYSTEM$PIPE_STATUS('s3_pipe');

SELECT * FROM json_ingest;