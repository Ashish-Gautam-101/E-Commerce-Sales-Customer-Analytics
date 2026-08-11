-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 07_Window_Functions.sql
-- Purpose : Window-function analysis
-- =====================================================

USE e_commerce_sales;


-- Q1. Rank sellers by revenue


SELECT
    seller_id,
    ROUND(SUM(price + freight_value), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(price + freight_value) DESC
    ) AS revenue_rank
FROM order_items
GROUP BY seller_id;


-- Q2. Rank product categories by revenue


SELECT
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.price + oi.freight_value) DESC
    ) AS category_rank
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name;


-- Q3. Monthly revenue with previous month



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
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        LAG(total_revenue) OVER (ORDER BY sales_month),
        2
    ) AS previous_month_revenue
FROM monthly_sales
ORDER BY sales_month;


-- Q4. Customer order sequence


SELECT
    customer_id,
    order_id,
    order_purchase_timestamp,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_purchase_timestamp
    ) AS order_sequence
FROM orders;


-- Q5. Seller revenue compared with previous seller


WITH seller_sales AS (
    SELECT
        seller_id,
        SUM(price + freight_value) AS total_revenue
    FROM order_items
    GROUP BY seller_id
)
SELECT
    seller_id,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        LAG(total_revenue) OVER (ORDER BY total_revenue DESC),
        2
    ) AS previous_seller_revenue
FROM seller_sales
ORDER BY total_revenue DESC;
