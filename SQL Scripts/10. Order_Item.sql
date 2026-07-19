use role sysadmin;
use database food_delivery_db;
use schema raw_sch;
use warehouse adhoc_wh;

create or replace table raw_sch.orderitem (
    orderitemid text comment 'Primary Key (Source System)',
    orderid text comment 'Order FK(Source System)',
    menuid text comment 'Menu FK(Source System)',
    quantity text,
    price text,
    subtotal text,
    createddate text,
    modifieddate text,

    -- audit columns with appropriate data types
    _stg_file_name text,
    _stg_file_load_ts timestamp,
    _stg_file_md5 text,
    _copy_data_ts timestamp default current_timestamp
)
comment = 'This is the order item stage/raw table where data will be copied from internal stage using copy command. This is as-is data represetation from the source location. All the columns are text data type except the audit columns that are added for traceability.';

create or replace stream raw_sch.orderitem_stm
on table raw_sch.orderitem
append_only = true
comment = 'This is the append-only stream object on order item table that only gets delta data';

list @raw_sch.csv_stg/initial/order_item;

copy into raw_sch.orderitem (
    orderitemid,
    orderid,
    menuid,
    quantity,
    price,
    subtotal,
    createddate,
    modifieddate,
    _stg_file_name,
    _stg_file_load_ts,
    _stg_file_md5,
    _copy_data_ts
)
from (
    select
        t.$1::text as orderitemid,
        t.$2::text as orderid,
        t.$3::text as menuid,
        t.$4::text as quantity,
        t.$5::text as price,
        t.$6::text as subtotal,
        t.$7::text as createddate,
        t.$8::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @raw_sch.csv_stg/initial/order_item/ t
)
file_format = (format_name = 'raw_sch.csv_file_format')
on_error = abort_statement;

select * from raw_sch.orderitem;
select * from raw_sch.orderitem_stm;

CREATE OR REPLACE TABLE curated_sch.order_item (
    order_item_sk NUMBER AUTOINCREMENT PRIMARY KEY comment 'Surrogate Key (EDW)',
    order_item_id NUMBER NOT NULL UNIQUE comment 'Primary Key (Source System)',
    order_id_fk NUMBER NOT NULL comment 'Order FK(Source System)',
    menu_id_fk NUMBER NOT NULL comment 'Menu FK(Source System)',
    quantity NUMBER(10,2),
    price NUMBER(10,2),
    subtotal NUMBER(10,2),
    created_dt TIMESTAMP,
    modified_dt TIMESTAMP,

    -- Audit columns
    _stg_file_name VARCHAR(255),
    _stg_file_load_ts TIMESTAMP,
    _stg_file_md5 VARCHAR(255),
    _copy_data_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
comment = 'Order item entity under clean schema with appropriate data type under clean schema layer, data is populated using merge statement from the stage layer location table. This table does not support SCD2';

create or replace stream CURATED_SCH.order_item_stm
on table CURATED_SCH.order_item
comment = 'This is the stream object on order_item table table to track insert, update, and delete changes';

select * from curated_sch.order_item_stm;

MERGE INTO curated_sch.order_item AS target
USING raw_sch.orderitem_stm AS source
ON
    target.order_item_id = source.orderitemid
    AND target.order_id_fk = source.orderid
    AND target.menu_id_fk = source.menuid
WHEN MATCHED THEN
    UPDATE SET
        target.quantity = source.quantity,
        target.price = source.price,
        target.subtotal = source.subtotal,
        target.created_dt = source.createddate,
        target.modified_dt = source.modifieddate,
        target._stg_file_name = source._stg_file_name,
        target._stg_file_load_ts = source._stg_file_load_ts,
        target._stg_file_md5 = source._stg_file_md5,
        target._copy_data_ts = source._copy_data_ts
WHEN NOT MATCHED THEN
    INSERT (
        order_item_id,
        order_id_fk,
        menu_id_fk,
        quantity,
        price,
        subtotal,
        created_dt,
        modified_dt,
        _stg_file_name,
        _stg_file_load_ts,
        _stg_file_md5,
        _copy_data_ts
    )
    VALUES (
        source.orderitemid,
        source.orderid,
        source.menuid,
        source.quantity,
        source.price,
        source.subtotal,
        source.createddate,
        source.modifieddate,
        source._stg_file_name,
        source._stg_file_load_ts,
        source._stg_file_md5,
        CURRENT_TIMESTAMP()
    );

-- part-2
list @raw_sch.csv_stg/delta/order_item/;

copy into raw_sch.orderitem (
    orderitemid,
    orderid,
    menuid,
    quantity,
    price,
    subtotal,
    createddate,
    modifieddate,
    _stg_file_name,
    _stg_file_load_ts,
    _stg_file_md5,
    _copy_data_ts
)
from (
    select
        t.$1::text as orderitemid,
        t.$2::text as orderid,
        t.$3::text as menuid,
        t.$4::text as quantity,
        t.$5::text as price,
        t.$6::text as subtotal,
        t.$7::text as createddate,
        t.$8::text as modifieddate,
        metadata$filename as _stg_file_name,
        metadata$file_last_modified as _stg_file_load_ts,
        metadata$file_content_key as _stg_file_md5,
        current_timestamp as _copy_data_ts
    from @raw_sch.csv_stg/delta/order_item/ t
)
file_format = (format_name = 'raw_sch.csv_file_format')
on_error = abort_statement;