-- ==========================================================
-- Snowflake Environment Setup
-- ==========================================================

-- Use SYSADMIN role
use role sysadmin;

-- Create warehouse if it does not exist
create warehouse if not exists adhoc_wh
     comment = 'This is the adhoc-wh'
     warehouse_size = 'x-small'
     auto_resume = true
     auto_suspend = 60
     enable_query_acceleration = false
     warehouse_type = 'standard'
     min_cluster_count = 1
     max_cluster_count = 1
     scaling_policy = 'standard'
     initially_suspended = true;

-- ==========================================================
-- Create Development Database and Schemas
-- ==========================================================

create database if not exists food_delivery_db;
use database food_delivery_db;



create schema if not exists raw_sch;
create schema if not exists curated_sch;
create schema if not exists enriched_sch;
create schema if not exists common;

use schema raw_sch;

-- ==========================================================
-- File Format for CSV Files
-- ==========================================================

create file format if not exists raw_sch.csv_file_format
        type = 'csv'
        compression = 'auto'
        field_delimiter = ','
        record_delimiter = '\n'
        skip_header = 1
        field_optionally_enclosed_by = '\042'
        null_if = ('\\N');

-- ==========================================================
-- Internal Stage for CSV File Uploads
-- ==========================================================

create stage raw_sch.csv_stg
    directory = (enable = true)
    comment = 'This is the Snowflake internal stage';

-- ==========================================================
-- Data Governance Objects
-- ==========================================================

create or replace tag
    common.pii_policy_tag
    allowed_values 'PII','PRICE','SENSITIVE','EMAIL'
    comment = 'This is PII policy tag object';

create or replace masking policy
    common.pii_masking_policy as (pii_text string)
    returns string ->
    to_varchar('** PII **');

create or replace masking policy
    common.email_masking_policy as (email_text string)
    returns string ->
    to_varchar('** EMAIL **');

create or replace masking policy
    common.phone_masking_policy as (phone string)
    returns string ->
    to_varchar('** Phone **');

list @raw_sch.csv_stg/initial;