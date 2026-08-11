-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 06_Subqueries.sql
-- Purpose : Subquery-based analysis
-- =====================================================

USE e_commerce_sales;

-- Q1. Products priced above the average item price
SELECT
    product_id,
    price
FROM order_items
WHERE price > (
    SELECT AVG(price)
    FROM order_items
)
ORDER BY price DESC;

-- Q2. Customers with more orders than the average customer
SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
GROUP BY o.customer_id
HAVING COUNT(DISTINCT o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(DISTINCT order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) x
)
ORDER BY total_orders DESC;


-- Q3. Sellers with revenue above average seller revenue


SELECT
    seller_id,
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM order_items
GROUP BY seller_id
HAVING SUM(price + freight_value) > (
    SELECT AVG(seller_revenue)
    FROM (
        SELECT SUM(price + freight_value) AS seller_revenue
        FROM order_items
        GROUP BY seller_id
    ) s
)
ORDER BY total_revenue DESC;

-- Q4. Orders above the average order value
SELECT
    order_id,
    ROUND(SUM(price + freight_value), 2) AS order_value
FROM order_items
GROUP BY order_id
HAVING SUM(price + freight_value) > (
    SELECT AVG(order_value)
    FROM (
        SELECT SUM(price + freight_value) AS order_value
        FROM order_items
        GROUP BY order_id
    ) o
)
ORDER BY order_value DESC;


-- Q5. Customers whose revenue is above average customer revenue


SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
HAVING SUM(oi.price + oi.freight_value) > (
    SELECT AVG(customer_revenue)
    FROM (
        SELECT
            c2.customer_unique_id,
            SUM(oi2.price + oi2.freight_value) AS customer_revenue
        FROM customers c2
        JOIN orders o2
            ON c2.customer_id = o2.customer_id
        JOIN order_items oi2
            ON o2.order_id = oi2.order_id
        GROUP BY c2.customer_unique_id
    ) cr
)
ORDER BY total_revenue DESC;
