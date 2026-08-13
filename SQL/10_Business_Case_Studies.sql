-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 10_Business_Case_Studies.sql
-- Purpose : Interview-style business case studies
-- =====================================================

USE e_commerce_sales;

-- =====================================================
-- Case Study 1: Top 10 Customers by Revenue
-- =====================================================
SELECT
    o.customer_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_revenue DESC
LIMIT 10;


-- =====================================================
-- Case Study 2: Best-Selling Product Categories
-- =====================================================
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- =====================================================
-- Case Study 3: Monthly Revenue Trend
-- =====================================================
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY sales_month
ORDER BY sales_month;


-- =====================================================
-- Case Study 4: Repeat Customer Analysis
-- =====================================================
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;


-- =====================================================
-- Case Study 5: Customer Lifetime Value
-- =====================================================
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS lifetime_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY lifetime_value DESC
LIMIT 10;


-- =====================================================
-- Case Study 6: Seller Performance
-- =====================================================
SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(
        SUM(oi.price + oi.freight_value) /
        COUNT(DISTINCT oi.order_id),
        2
    ) AS average_order_value
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;


-- =====================================================
-- Case Study 7: Cancellation / Order Status Analysis
-- =====================================================
SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0 /
        (SELECT COUNT(DISTINCT order_id) FROM orders),
        2
    ) AS percentage_of_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- Case Study 8: Payment Method Analysis
-- =====================================================
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- =====================================================
-- Case Study 9: Category Performance
-- =====================================================
SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(
        SUM(oi.price + oi.freight_value) /
        COUNT(DISTINCT oi.order_id),
        2
    ) AS average_order_value
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;


-- =====================================================
-- Case Study 10: Monthly Revenue Growth
-- =====================================================
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        SUM(oi.price + oi.freight_value) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
),
monthly_growth AS (
    SELECT
        sales_month,
        ROUND(total_revenue, 2) AS total_revenue,
        ROUND(
            LAG(total_revenue) OVER (
                ORDER BY sales_month
            ),
            2
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)
        * 100.0 /
        NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_percentage
FROM monthly_growth
ORDER BY sales_month;
