
//This script sets up the connection between AWS S3 and Snowflake.

CREATE DATABASE IF NOT EXISTS clickstream;
USE DATABASE clickstream;
CREATE SCHEMA IF NOT EXISTS bronze;
USE SCHEMA bronze;

//Creating storage integration 
CREATE OR REPLACE STORAGE INTEGRATION s3_int
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::000000000000:role/snowflake-role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://snowflake-demo-clickstream/clickstream/');

//retrieving the AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID for AWS Trust Policy
DESC INTEGRATION s3_int;

//creating file format for snowflake ingestion
CREATE OR REPLACE FILE FORMAT json_format
    TYPE = JSON
    STRIP_OUTER_ARRAY = TRUE;

//creating external stage pointing to s3 bucket
CREATE OR REPLACE STAGE s3_stg
    STORAGE_INTEGRATION = s3_int
    URL = 's3://snowflake-demo-clickstream/clickstream/'
    FILE_FORMAT = json_format
    DIRECTORY = (ENABLE = TRUE);


LS @s3_stg;