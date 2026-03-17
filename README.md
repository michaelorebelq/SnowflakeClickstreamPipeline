# SnowflakeClickstreamPipeline
This project demonstrates continuous data ingestion and transformation pipeline using Snowflake and AWS S3.

Data Architecture
The pipeline follows a Medallion (Bronze -> Silver) architecture
    A[(AWS S3)] -- SQS Event --> B[Snowpipe]
    B -- COPY INTO --> C{Bronze Table: JSON_INGEST}
    C -- Continuous CDC --> D[Dynamic Table: SILVER_CLICKSTREAM]
    D -- Structured Data --> E[Analytics / BI]


1)Bronze
I implemented Snowpipe with Auto-Ingest to move away from batch-based loading. By leveraging a Storage Integration, I established a secure, keyless handshake between AWS and Snowflake via IAM Roles.

Resilience: Used ON_ERROR = CONTINUE to ensure a single malformed JSON record wouldn't stall the entire ingestion queue.
Semi-Structured Handling: Utilized STRIP_OUTER_ARRAY in the File Format to properly parse bulk JSON uploads into individual relational rows.

2)Silver
Instead of traditional Streams & Tasks, I opted for Dynamic Tables. This allowed me to define the "Final State" of the data using a declarative SELECT statement.
Cost Optimization: Set a TARGET_LAG of 5 minutes, allowing Snowflake to optimise the compute schedule and only spin up the COMPUTE_WH when enough data is present to justify the cost.
Type Casting: Strongly typed the JSON fields using Snowflake’s : pathing and :: casting operators to improve downstream query performance.
