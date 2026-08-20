use ecommerce_db;
GO

create index ix_orders_customer_id on dbo.orders(customer_id);
GO
create index ix_orders_order_date on dbo.orders(order_date);
GO
create index ix_orders_update_at on dbo.orders(update_at);
GO
create index ix_order_details_order_id on dbo.order_details(order_id);
GO
create index ix_order_details_product_id on dbo.order_details(product_id);
GO
create index ix_payments_order_id on dbo.payments(order_id);
GO
create index ix_payments_update_at on dbo.payments(update_at);
GO
create index ix_products_update_at on dbo.products(update_at);
GO
create index ix_customers_update_at on dbo.customers(update_at);
GO