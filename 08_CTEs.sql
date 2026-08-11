-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 08_CTEs.sql
-- Purpose : Common Table Expression analysis
-- =====================================================

USE e_commerce_sales;

-- Q1. Top customers using a CTE
WITH customer_sales AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_sales
ORDER BY total_revenue DESC
LIMIT 10;

-- Q2. Monthly sales using a CTE
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue
FROM monthly_sales
ORDER BY sales_month;

-- Q3. Seller performance using a CTE
WITH seller_sales AS (
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(price + freight_value) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT
    seller_id,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_revenue / NULLIF(total_orders, 0), 2)
        AS average_order_value
FROM seller_sales
ORDER BY total_revenue DESC
LIMIT 10;

-- Q4. Premium customers
-- Definition: customers with at least 2 orders and
-- revenue above the average customer revenue.
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
    customer_unique_id,
    total_orders,
    ROUND(total_revenue, 2) AS total_revenue
FROM customer_sales
CROSS JOIN customer_average
WHERE total_orders >= 2
  AND total_revenue > average_revenue
ORDER BY total_revenue DESC;
