use role sysadmin;
use warehouse adhoc_wh;
use database food_delivery_db;
use schema enriched_sch;

CREATE OR REPLACE TABLE enriched_sch.order_item_fact (
    order_item_fact_sk NUMBER AUTOINCREMENT comment 'Surrogate Key (EDW)',
    order_item_id NUMBER comment 'Order Item FK (Source System)',
    order_id NUMBER comment 'Order FK (Source System)',
    customer_dim_key NUMBER comment 'Order FK (Source System)',
    customer_address_dim_key NUMBER,
    restaurant_dim_key NUMBER,
    restaurant_location_dim_key NUMBER,
    menu_dim_key NUMBER,
    delivery_agent_dim_key NUMBER,
    order_date_dim_key NUMBER,
    quantity NUMBER,
    price NUMBER(10, 2),
    subtotal NUMBER(10, 2),
    delivery_status VARCHAR,
    estimated_time VARCHAR
)
comment = 'The item order fact table that has item level price, quantity and other details';

MERGE INTO enriched_sch.order_item_fact AS target
USING (
    SELECT
        oi.Order_Item_ID AS order_item_id,
        oi.Order_ID_fk AS order_id,
        c.CUSTOMER_HK AS customer_dim_key,
        ca.CUSTOMER_ADDRESS_HK AS customer_address_dim_key,
        r.RESTAURANT_HK AS restaurant_dim_key,
        rl.restaurant_location_hk AS restaurant_location_dim_key,
        m.Menu_Dim_HK AS menu_dim_key,
        da.DELIVERY_AGENT_HK AS delivery_agent_dim_key,
        dd.DATE_DIM_HK AS order_date_dim_key,
        oi.Quantity::number(2) AS quantity,
        oi.Price AS price,
        oi.Subtotal AS subtotal,
        o.PAYMENT_METHOD,
        d.delivery_status AS delivery_status,
        d.estimated_time AS estimated_time
    FROM
        curated_sch.order_item oi
    JOIN
        curated_sch.orders o
            ON oi.Order_ID_fk = o.Order_ID
    JOIN
        curated_sch.delivery d
            ON o.Order_ID = d.Order_ID_fk
    JOIN
        enriched_sch.customer_dim c
            ON o.Customer_ID_fk = c.customer_id
    JOIN
        enriched_sch.customer_address_dim ca
            ON c.Customer_ID = ca.CUSTOMER_ID_fk
    JOIN
        enriched_sch.restaurant_dim r
            ON o.Restaurant_ID_fk = r.restaurant_id
    JOIN
        enriched_sch.menu_dim m
            ON oi.MENU_ID_fk = m.menu_id
    JOIN
        enriched_sch.delivery_agent_dim da
            ON d.Delivery_Agent_ID_fk = da.delivery_agent_id
    JOIN
        enriched_sch.restaurant_location_dim rl
            ON r.LOCATION_ID_FK = rl.location_id
    JOIN
        ENRICHED_SCH.DATE_DIM dd
            ON dd.calendar_date = DATE(o.order_date)
) AS source_stm
ON
    target.order_item_id = source_stm.order_item_id
    AND target.order_id = source_stm.order_id
WHEN MATCHED THEN
    UPDATE SET
        target.customer_dim_key = source_stm.customer_dim_key,
        target.customer_address_dim_key = source_stm.customer_address_dim_key,
        target.restaurant_dim_key = source_stm.restaurant_dim_key,
        target.restaurant_location_dim_key = source_stm.restaurant_location_dim_key,
        target.menu_dim_key = source_stm.menu_dim_key,
        target.delivery_agent_dim_key = source_stm.delivery_agent_dim_key,
        target.order_date_dim_key = source_stm.order_date_dim_key,
        target.quantity = source_stm.quantity,
        target.price = source_stm.price,
        target.subtotal = source_stm.subtotal,
        target.delivery_status = source_stm.delivery_status,
        target.estimated_time = source_stm.estimated_time
WHEN NOT MATCHED THEN
    INSERT (
        order_item_id,
        order_id,
        customer_dim_key,
        customer_address_dim_key,
        restaurant_dim_key,
        restaurant_location_dim_key,
        menu_dim_key,
        delivery_agent_dim_key,
        order_date_dim_key,
        quantity,
        price,
        subtotal,
        delivery_status,
        estimated_time
    )
    VALUES (
        source_stm.order_item_id,
        source_stm.order_id,
        source_stm.customer_dim_key,
        source_stm.customer_address_dim_key,
        source_stm.restaurant_dim_key,
        source_stm.restaurant_location_dim_key,
        source_stm.menu_dim_key,
        source_stm.delivery_agent_dim_key,
        source_stm.order_date_dim_key,
        source_stm.quantity,
        source_stm.price,
        source_stm.subtotal,
        source_stm.delivery_status,
        source_stm.estimated_time
    );

-- Foreign key constraints

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_customer_dim
    FOREIGN KEY (customer_dim_key)
    REFERENCES enriched_sch.customer_dim (customer_hk);

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_customer_address_dim
    FOREIGN KEY (customer_address_dim_key)
    REFERENCES enriched_sch.customer_address_dim (customer_address_hk);

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_restaurant_dim
    FOREIGN KEY (restaurant_dim_key)
    REFERENCES enriched_sch.restaurant_dim (restaurant_hk);

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_restaurant_location_dim
    FOREIGN KEY (restaurant_location_dim_key)
    REFERENCES enriched_sch.restaurant_location_dim (restaurant_location_hk);

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_menu_dim
    FOREIGN KEY (menu_dim_key)
    REFERENCES enriched_sch.menu_dim (menu_dim_hk);

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_delivery_agent_dim
    FOREIGN KEY (delivery_agent_dim_key)
    REFERENCES enriched_sch.delivery_agent_dim (delivery_agent_hk);

ALTER TABLE enriched_sch.order_item_fact
    ADD CONSTRAINT fk_order_item_fact_delivery_date_dim
    FOREIGN KEY (order_date_dim_key)
    REFERENCES enriched_sch.date_dim (date_dim_hk);