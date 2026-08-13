-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 09_Views.sql
-- Purpose : Reusable analytical views for Power BI
-- =====================================================

USE e_commerce_sales;

-- 1. Category Revenue
CREATE OR REPLACE VIEW vw_category_revenue AS
SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name;


-- 2. Customer Revenue
CREATE OR REPLACE VIEW vw_customer_revenue AS
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(
        SUM(oi.price + oi.freight_value) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id;


-- 3. Monthly Sales
CREATE OR REPLACE VIEW vw_monthly_sales AS
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m');


-- 4. Order Summary
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS order_value,
    COUNT(oi.order_item_id) AS item_count
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp;


-- 5. Premium Customers
-- Definition: at least 2 orders AND revenue above
-- the average revenue across customers.
CREATE OR REPLACE VIEW vw_premium_customers AS
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
),
customer_average AS (
    SELECT AVG(total_revenue) AS average_revenue
    FROM customer_sales
)
SELECT
    cs.customer_unique_id,
    cs.total_orders,
    ROUND(cs.total_revenue, 2) AS total_revenue,
    ROUND(
        cs.total_revenue / NULLIF(cs.total_orders, 0),
        2
    ) AS average_order_value
FROM customer_sales cs
CROSS JOIN customer_average ca
WHERE cs.total_orders >= 2
  AND cs.total_revenue > ca.average_revenue;


-- 6. Seller Performance
CREATE OR REPLACE VIEW vw_seller_performance AS
SELECT
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price + freight_value), 2) AS total_revenue,
    ROUND(
        SUM(price + freight_value) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items
GROUP BY seller_id;


-- Verify views
SELECT * FROM vw_category_revenue LIMIT 10;
SELECT * FROM vw_customer_revenue LIMIT 10;
SELECT * FROM vw_monthly_sales LIMIT 10;
SELECT * FROM vw_order_summary LIMIT 10;
SELECT * FROM vw_premium_customers LIMIT 10;
SELECT * FROM vw_seller_performance LIMIT 10;
