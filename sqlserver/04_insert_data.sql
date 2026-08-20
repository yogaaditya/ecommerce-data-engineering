USE ecommerce_db;
GO

INSERT INTO dbo.customers
(
    first_name,
    last_name,
    email,
    city,
    country
)
VALUES
('Andi', 'Saputra', 'andi@example.com', 'Jakarta', 'Indonesia'),
('Budi', 'Santoso', 'budi@example.com', 'Surabaya', 'Indonesia'),
('Citra', 'Lestari', 'citra@example.com', 'Bandung', 'Indonesia'),
('Deni', 'Pratama', 'deni@example.com', 'Malang', 'Indonesia'),
('Eka', 'Putri', 'eka@example.com', 'Semarang', 'Indonesia'),
('Fajar', 'Wijaya', 'fajar@example.com', 'Jakarta', 'Indonesia'),
('Gita', 'Permata', 'gita@example.com', 'Surabaya', 'Indonesia'),
('Hendra', 'Kurniawan', 'hendra@example.com', 'Yogyakarta', 'Indonesia'),
('Intan', 'Sari', 'intan@example.com', 'Bandung', 'Indonesia'),
('Joko', 'Setiawan', 'joko@example.com', 'Denpasar', 'Indonesia');
GO

select * from dbo.customers;

INSERT INTO dbo.products
(
    product_name,
    category,
    price,
    stock_quantity
)
VALUES
('ASUS ROG Laptop', 'Laptop', 15000000, 20),
('Lenovo ThinkPad', 'Laptop', 12000000, 15),
('Logitech G102 Mouse', 'Accessories', 350000, 100),
('Mechanical Keyboard', 'Accessories', 750000, 50),
('LG 24 Inch Monitor', 'Monitor', 2500000, 30),
('Samsung 27 Inch Monitor', 'Monitor', 4500000, 25),
('USB-C Hub', 'Accessories', 450000, 80),
('Webcam Logitech', 'Accessories', 900000, 40),
('MacBook Air', 'Laptop', 18000000, 10),
('iPad Air', 'Tablet', 10000000, 20);
GO

select * from dbo.products;

INSERT INTO dbo.orders
(
    customer_id,
    order_date,
    status,
    total_amount
)
VALUES
(1, '2026-08-01 10:00:00', 'PAID', 15350000),
(2, '2026-08-02 11:30:00', 'PAID', 12750000),
(3, '2026-08-03 09:20:00', 'COMPLETED', 2500000),
(4, '2026-08-04 14:00:00', 'CANCELLED', 350000),
(5, '2026-08-05 15:30:00', 'PAID', 15000000),
(6, '2026-08-06 10:15:00', 'SHIPPED', 4500000),
(7, '2026-08-07 12:00:00', 'PAID', 1250000),
(8, '2026-08-08 13:45:00', 'COMPLETED', 1350000),
(9, '2026-08-09 16:00:00', 'PAID', 18000000),
(10, '2026-08-10 17:30:00', 'PENDING', 10000000);
GO

select * from dbo.orders;

INSERT INTO dbo.order_details
(
    order_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(1, 1, 1, 15000000),
(1, 3, 1, 350000),
(2, 2, 1, 12000000),
(2, 4, 1, 750000),
(3, 5, 1, 2500000),
(4, 3, 1, 350000),
(5, 1, 1, 15000000),
(6, 6, 1, 4500000),
(7, 4, 1, 750000),
(7, 3, 1, 350000),
(7, 7, 1, 150000),
(8, 8, 1, 900000),
(8, 7, 1, 450000),
(9, 9, 1, 18000000),
(10, 10, 1, 10000000);
GO

select * from dbo.order_details;

INSERT INTO dbo.payments
(
    order_id,
    payment_date,
    payment_method,
    payment_status,
    amount
)
VALUES
(1, '2026-08-01 10:05:00', 'BANK_TRANSFER', 'SUCCESS', 15350000),
(2, '2026-08-02 11:35:00', 'E_WALLET', 'SUCCESS', 12750000),
(3, '2026-08-03 09:25:00', 'CREDIT_CARD', 'SUCCESS', 2500000),
(4, NULL, 'BANK_TRANSFER', 'REFUNDED', 350000),
(5, '2026-08-05 15:35:00', 'BANK_TRANSFER', 'SUCCESS', 15000000),
(6, '2026-08-06 10:20:00', 'CREDIT_CARD', 'SUCCESS', 4500000),
(7, '2026-08-07 12:05:00', 'E_WALLET', 'SUCCESS', 1250000),
(8, '2026-08-08 13:50:00', 'BANK_TRANSFER', 'SUCCESS', 1350000),
(9, '2026-08-09 16:05:00', 'CREDIT_CARD', 'SUCCESS', 18000000);
GO

select * from dbo.payments;

--Validasi jumlah data
SELECT 
  'customers' AS table_name, 
  COUNT(*) AS total 
FROM 
  dbo.customers 
UNION ALL 
SELECT 
  'products', 
  COUNT(*) 
FROM 
  dbo.products 
UNION ALL 
SELECT 
  'orders', 
  COUNT(*) 
FROM 
  dbo.orders 
UNION ALL 
SELECT 
  'order_details', 
  COUNT(*) 
FROM 
  dbo.order_details 
UNION ALL 
SELECT 
  'payments', 
  COUNT(*) 
FROM 
  dbo.payments;


--Query Bisnis pertama
SELECT
    o.order_id,
    o.order_date,
    c.first_name + ' ' + c.last_name AS customer_name,
    c.city,
    p.product_name,
    p.category,
    od.quantity,
    od.unit_price,
    od.quantity * od.unit_price AS subtotal,
    o.status
FROM dbo.orders o
INNER JOIN dbo.customers c
    ON o.customer_id = c.customer_id
INNER JOIN dbo.order_details od
    ON o.order_id = od.order_id
INNER JOIN dbo.products p
    ON od.product_id = p.product_id
ORDER BY o.order_date;

--Hitung Revenue
--Anggap sebagai transaksi sukses
SELECT
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM dbo.orders o,
dbo.order_details od
WHERE o.order_id = od.order_id 
and o.status IN
(
    'PAID',
    'SHIPPED',
    'COMPLETED'
);

--Revenue percategory
SELECT
    p.category,
    SUM(od.quantity * od.unit_price) AS revenue
FROM dbo.orders o,
dbo.order_details od,
dbo.products p
WHERE o.order_id = od.order_id 
    and od.product_id = p.product_id 
    and o.status IN
(
    'PAID',
    'SHIPPED',
    'COMPLETED'
)
GROUP BY
    p.category
ORDER BY
    revenue DESC;

-- Top 5
SELECT TOP 5
    p.product_name,
    SUM(od.quantity) AS total_quantity,
    SUM(od.quantity * od.unit_price) AS revenue
FROM dbo.orders o,
dbo.order_details od,
dbo.products p
WHERE o.order_id = od.order_id
and od.product_id = p.product_id
and o.status IN
(
    'PAID',
    'SHIPPED',
    'COMPLETED'
)
GROUP BY
    p.product_name
ORDER BY
    revenue DESC;

--Revenue percity
SELECT
    c.city,
    SUM(od.quantity * od.unit_price) AS revenue
FROM dbo.orders o,
dbo.customers c,
dbo.order_details od
WHERE o.customer_id = c.customer_id
and o.order_id = od.order_id
and o.status IN
(
    'PAID',
    'SHIPPED',
    'COMPLETED'
)
GROUP BY
    c.city
ORDER BY
    revenue DESC;


-- Cek data bermasalah
SELECT * FROM dbo.customers
where email IS NULL or LTRIM(RTRIM(email)) = '';

-- Product dengan harga negatif
SELECT * 
FROM dbo.products
where price < 0;

-- Order tanpa customer
SELECT o.* 
FROM dbo.orders o,
dbo.customers c
where o.customer_id = c.customer_id
and c.customer_id IS NULL;

-- Order detail tanpa product
SELECT od.*
FROM dbo.order_details od,
dbo.products p
where od.product_id = p.product_id
and p.product_id IS NULL;

-- Simulasi Perubahan data
UPDATE dbo.customers
SET city ='Depok',
update_at = SYSUTCDATETIME()
where customer_id = 1;