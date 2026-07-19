use role sysadmin;
use warehouse adhoc_wh;
use database food_delivery_db;
use schema ENRICHED_SCH;

CREATE OR REPLACE TABLE ENRICHED_SCH.DATE_DIM (
    DATE_DIM_HK NUMBER PRIMARY KEY comment 'Menu Dim HK (EDW)',   -- Surrogate key for date dimension
    CALENDAR_DATE DATE UNIQUE,
    YEAR NUMBER,
    QUARTER NUMBER,
    MONTH NUMBER,
    WEEK NUMBER,
    DAY_OF_YEAR NUMBER,
    DAY_OF_WEEK NUMBER,
    DAY_OF_THE_MONTH NUMBER,
    DAY_NAME STRING
)
comment = 'Date dimension table created using min of order data.';

insert into ENRICHED_SCH.DATE_DIM
with recursive my_date_dim_cte as
(
    -- anchor clause
    select
        current_date() as today,
        year(today) as year,
        quarter(today) as quarter,
        month(today) as month,
        week(today) as week,
        dayofyear(today) as day_of_year,
        dayofweek(today) as day_of_week,
        day(today) as day_of_the_month,
        dayname(today) as day_name

    union all

    -- recursive clause
    select
        dateadd('day', -1, today) as today_r,
        year(today_r) as year,
        quarter(today_r) as quarter,
        month(today_r) as month,
        week(today_r) as week,
        dayofyear(today_r) as day_of_year,
        dayofweek(today_r) as day_of_week,
        day(today_r) as day_of_the_month,
        dayname(today_r) as day_name
    from
        my_date_dim_cte
    where
        today_r > (select date(min(order_date)) from curated_sch.orders)
)
select
    hash(SHA1_hex(today)) as DATE_DIM_HK,
    today,
    YEAR,
    QUARTER,
    MONTH,
    WEEK,
    DAY_OF_YEAR,
    DAY_OF_WEEK,
    DAY_OF_THE_MONTH,
    DAY_NAME
from my_date_dim_cte;