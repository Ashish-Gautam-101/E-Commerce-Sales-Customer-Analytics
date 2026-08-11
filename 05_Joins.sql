-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 05_Joins.sql
-- Purpose : JOIN-based business analysis
-- =====================================================

USE e_commerce_sales;

-- Q1. Orders with customer information
SELECT
    o.order_id,
    o.order_status,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LIMIT 20;

-- Q2. Orders with order-item revenue
SELECT
    o.order_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS order_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY order_revenue DESC
LIMIT 20;

-- Q3. Product categories and sales
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Q4. Seller revenue
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q5. Customer revenue
SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Q6. Payment value by payment method
SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- Q7. Review score with order status
SELECT
    r.review_score,
    o.order_status,
    COUNT(*) AS review_count
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
GROUP BY r.review_score, o.order_status
ORDER BY r.review_score DESC, review_count DESC;
