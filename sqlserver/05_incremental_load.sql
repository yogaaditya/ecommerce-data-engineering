USE ecommerce_db;
GO

-- Stored Procedure Customer update
CREATE or ALTER PROCEDURE dbo.sp_get_customers_incremental
	@last_watermark datetime2(3)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		customer_id,
		first_name,
		last_name,
		email,
		city,
		country,
		create_at,
		update_at
	FROM dbo.customers
	WHERE update_at > @last_watermark
	ORDER BY update_at;
END;
GO

-- Product
CREATE OR ALTER PROCEDURE dbo.sp_get_products_incremental
    @last_watermark DATETIME2(3)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        product_id,
        product_name,
        category,
        price,
        stock_quantity,
        create_at,
        update_at
    FROM dbo.products
    WHERE update_at > @last_watermark
    ORDER BY update_at;

END;
GO

-- Orders
CREATE OR ALTER PROCEDURE dbo.sp_get_orders_incremental
    @last_watermark DATETIME2(3)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        order_id,
        customer_id,
        order_date,
        status,
        total_amount,
        create_at,
        update_at
    FROM dbo.orders
    WHERE update_at > @last_watermark
    ORDER BY update_at;

END;
GO

-- TES
EXEC dbo.sp_get_customers_incremental
	@last_watermark = '2026-08-20 00:00:00';

SELECT MAX(update_at) AS last_watermark
FROM dbo.customers;

UPDATE dbo.customers
SET city ='Tangerang',
    update_at = SYSUTCDATETIME()
WHERE customer_id = 2;

-- View untuk ETL
CREATE OR ALTER VIEW dbo.vw_sales 
AS 
SELECT 
  o.order_id, 
  o.order_date, 
  c.customer_id, 
  c.first_name, 
  c.last_name, 
  c.city, 
  c.country, 
  p.product_id, 
  p.product_name, 
  p.category, 
  od.quantity, 
  od.unit_price, 
  od.quantity * od.unit_price AS sales_amount, 
  o.status, 
  o.update_at 
FROM 
  dbo.orders o 
  INNER JOIN dbo.customers c ON o.customer_id = c.customer_id 
  INNER JOIN dbo.order_details od ON o.order_id = od.order_id 
  INNER JOIN dbo.products p ON od.product_id = p.product_id;
GO

-- Tes View
SELECT *
FROM dbo.vw_sales;