-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 04_Basic_SQL.sql
-- Purpose : Fundamental SQL business queries
-- =====================================================

USE e_commerce_sales;

-- Q1. Total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q2. Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Q3. Total revenue
SELECT ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items;

-- Q4. Average product price
SELECT ROUND(AVG(price), 2) AS average_product_price
FROM order_items;

-- Q5. Orders by status
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Q6. Customers by state
SELECT customer_state, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- Q7. Payment methods by usage
SELECT payment_type, COUNT(*) AS payment_records
FROM payments
GROUP BY payment_type
ORDER BY payment_records DESC;

-- Q8. Products by category
SELECT product_category_name, COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC;

-- Q9. Orders by purchase year
SELECT YEAR(order_purchase_timestamp) AS purchase_year,
       COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY purchase_year;

-- Q10. High-value orders

SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_status
HAVING SUM(oi.price + oi.freight_value) > 1000
ORDER BY order_value DESC;

