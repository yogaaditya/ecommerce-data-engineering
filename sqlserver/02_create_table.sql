USE ecommerce_db;
GO

CREATE TABLE dbo.customers
(
    customer_id INT IDENTITY(1, 1) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name varchar(100) not null,
    email varchar(100) not null,
    city varchar(100) null,
    country varchar(100) null,
    create_at datetime2(3) not null
        constraint df_customers_create_at
        default sysutcdatetime(),
    update_at datetime2(3) not null
        constraint df_customers_update_at
        default sysutcdatetime(),
    constraint pk_customers
        primary key (customer_id),
    constraint uq_customers_email
        unique (email)
);
GO

Create table dbo.products
(
    product_id INT identity(1, 1) not null,
    product_name varchar(200) not null,
    category varchar(100) not null,
    price decimal(18, 2) not null,
    stock_quantity INT not null
        constraint df_products_stock
        default 0,
    create_at datetime2(3) not null
        constraint df_products_create_at
        default sysutcdatetime(),
    update_at datetime2(3) not null
        constraint df_products_update_at
        default sysutcdatetime(),
    constraint pk_products
        primary key (product_id),
    constraint ck_products_price check (price >= 0),
    constraint ck_products_stock check (stock_quantity >= 0)
);
GO

create table dbo.orders
(
    order_id bigint identity(1, 1) not null,
    customer_id INT not null,
    order_date datetime2(3) not null,
    status varchar(30) not null,
    total_amount decimal(18, 2) not null,
    create_at datetime2(3) not null
        constraint df_orders_create_at
        default sysutcdatetime(),
    update_at datetime2(3) not null
        constraint df_orders_update_at
        default sysutcdatetime(),
    constraint pk_orders
        primary key (order_id),
    constraint fk_orders_customer
        foreign key (customer_id)
        references dbo.customers (customer_id),
    constraint ck_orders_status check (status in ( 'PENDING', 'PAID', 'SHIPPED', 'COMPLETED', 'CANCELLED' )),
    constraint ck_orders_total_amount check (total_amount >= 0)
);
GO

create table dbo.order_details
(
    order_detail_id bigint identity(1, 1) not null,
    order_id bigint not null,
    product_id int not null,
    quantity int not null,
    unit_price decimal(18, 2) not null,
    create_at datetime2(3) not null
        constraint df_order_details_create_at
        default sysutcdatetime(),
    constraint pk_order_details
        primary key (order_detail_id),
    constraint fk_order_details_order
        foreign key (order_id)
        references dbo.orders (order_id),
    constraint fk_order_detail_product
        foreign key (product_id)
        references dbo.products (product_id),
    constraint ck_order_detail_quantity check (quantity > 0),
    constraint ck_order_detail_unit_price check (unit_price >= 0)
);
GO

create table dbo.payments
(
    payment_id bigint identity(1, 1) not null,
    order_id bigint not null,
    payment_date datetime2(3) null,
    payment_method varchar(50) null,
    payment_status varchar(30) null,
    amount decimal(18, 2) not null,
    create_at datetime2(3) not null
        constraint df_payments_create_at
        default sysutcdatetime(),
    update_at datetime2(3) not null
        constraint df_payments_update_at
        default sysutcdatetime(),
    constraint pk_payments
        primary key (payment_id),
    constraint fk_payments_order
        foreign key (order_id)
        references dbo.orders (order_id),
    constraint ck_payment_status check (payment_status in ( 'PENDING', 'SUCCESS', 'FAILED', 'REFUNDED' )),
    constraint ck_payments_amount check (amount >= 0)
);
GO

--DROP TABLE IF EXISTS ...;
--DROP TABLE ...;

--Cek schema
--select table_schema, table_name
--from INFORMATION_SCHEMA.TABLES
--where TABLE_TYPE = 'BASE TABLE'
--order by TABLE_NAME;