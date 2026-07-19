use role sysadmin;
use warehouse adhoc_wh;
use database food_delivery_db;
use schema enriched_sch;

select * from enriched_sch.order_item_fact limit 100;

create or replace view enriched_sch.vw_yearly_revenue_kpis as
select
    d.year as year,
    sum(fact.subtotal) as total_revenue,
    count(distinct fact.order_id) as total_orders,
    round(sum(fact.subtotal) / count(distinct fact.order_id), 2) as avg_revenue_per_order,
    round(sum(fact.subtotal) / count(fact.order_item_id), 2) as avg_revenue_per_item,
    max(fact.subtotal) as max_order_value
from
    enriched_sch.order_item_fact fact
join
    enriched_sch.date_dim d
on
    fact.order_date_dim_key = d.date_dim_hk
where DELIVERY_STATUS = 'Delivered'
group by
    d.year
order by
    d.year;


CREATE OR REPLACE VIEW enriched_sch.vw_monthly_revenue_kpis AS
SELECT
    d.YEAR AS year,
    d.MONTH AS month,
    SUM(fact.subtotal) AS total_revenue,
    COUNT(DISTINCT fact.order_id) AS total_orders,
    ROUND(SUM(fact.subtotal) / COUNT(DISTINCT fact.order_id), 2) AS avg_revenue_per_order,
    ROUND(SUM(fact.subtotal) / COUNT(fact.order_item_id), 2) AS avg_revenue_per_item,
    MAX(fact.subtotal) AS max_order_value
FROM
    enriched_sch.order_item_fact fact
JOIN
    enriched_sch.DATE_DIM d
ON
    fact.order_date_dim_key = d.DATE_DIM_HK
where DELIVERY_STATUS = 'Delivered'
GROUP BY
    d.YEAR, d.MONTH
ORDER BY
    d.YEAR, d.MONTH;


CREATE OR REPLACE VIEW enriched_sch.vw_daily_revenue_kpis AS
SELECT
    d.YEAR AS year,
    d.MONTH AS month,
    d.DAY_OF_THE_MONTH AS day,
    SUM(fact.subtotal) AS total_revenue,
    COUNT(DISTINCT fact.order_id) AS total_orders,
    ROUND(SUM(fact.subtotal) / COUNT(DISTINCT fact.order_id), 2) AS avg_revenue_per_order,
    ROUND(SUM(fact.subtotal) / COUNT(fact.order_item_id), 2) AS avg_revenue_per_item,
    MAX(fact.subtotal) AS max_order_value
FROM
    enriched_sch.order_item_fact fact
JOIN
    enriched_sch.DATE_DIM d
ON
    fact.order_date_dim_key = d.DATE_DIM_HK
where DELIVERY_STATUS = 'Delivered'
GROUP BY
    d.YEAR, d.MONTH, d.DAY_OF_THE_MONTH
ORDER BY
    d.YEAR, d.MONTH, d.DAY_OF_THE_MONTH;


CREATE OR REPLACE VIEW enriched_sch.vw_day_revenue_kpis AS
SELECT
    d.YEAR AS year,
    d.MONTH AS month,
    d.DAY_NAME AS DAY_NAME,
    SUM(fact.subtotal) AS total_revenue,
    COUNT(DISTINCT fact.order_id) AS total_orders,
    ROUND(SUM(fact.subtotal) / COUNT(DISTINCT fact.order_id), 2) AS avg_revenue_per_order,
    ROUND(SUM(fact.subtotal) / COUNT(fact.order_item_id), 2) AS avg_revenue_per_item,
    MAX(fact.subtotal) AS max_order_value
FROM
    enriched_sch.order_item_fact fact
JOIN
    enriched_sch.DATE_DIM d
ON
    fact.order_date_dim_key = d.DATE_DIM_HK
GROUP BY
    d.YEAR, d.MONTH, d.DAY_NAME
ORDER BY
    d.YEAR, d.MONTH, d.DAY_NAME;


CREATE OR REPLACE VIEW enriched_sch.vw_monthly_revenue_by_restaurant AS
SELECT
    d.YEAR AS year,
    d.MONTH AS month,
    fact.DELIVERY_STATUS,
    r.name as restaurant_name,
    SUM(fact.subtotal) AS total_revenue,
    COUNT(DISTINCT fact.order_id) AS total_orders,
    ROUND(SUM(fact.subtotal) / COUNT(DISTINCT fact.order_id), 2) AS avg_revenue_per_order,
    ROUND(SUM(fact.subtotal) / COUNT(fact.order_item_id), 2) AS avg_revenue_per_item,
    MAX(fact.subtotal) AS max_order_value
FROM
    enriched_sch.order_item_fact fact
JOIN
    enriched_sch.DATE_DIM d
ON
    fact.order_date_dim_key = d.DATE_DIM_HK
JOIN
    enriched_sch.restaurant_dim r
ON
    fact.restaurant_dim_key = r.RESTAURANT_HK
GROUP BY
    d.YEAR, d.MONTH, fact.DELIVERY_STATUS, restaurant_name
ORDER BY
    d.YEAR, d.MONTH;