-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 03_Exploratory_Data_Analysis.sql
-- Author  : Ashish Gautam
-- Purpose : Explore the dataset to understand business
--           patterns and prepare for deeper analysis.
-- =====================================================

USE e_commerce_sales;

-- =====================================================
-- 1. Customer Analysis
-- =====================================================
-- Business Objective:
-- Understand the customer base and geographical distribution.

-- How many customers are registered?

SELECT COUNT(*) AS total_customers
FROM customers;

-- How many unique customers exist?

SELECT COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- Which states have the highest number of customers?

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- Which cities have the most customers?

SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;

-- =====================================================
-- 2. Order Analysis
-- =====================================================
-- Business Objective:
-- Analyze order volume, status, and purchase trends.

-- total numbers of order

SELECT COUNT(*) AS total_orders
FROM orders;

-- Order Status Distribution

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- First & Last Order Date

SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- Monthly Order Trend

SELECT
    DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_month
ORDER BY order_month;


-- =====================================================
-- 3. Product Analysis
-- =====================================================
-- Business Objective:
-- Explore the product catalog.

-- Total Products

SELECT COUNT(*) AS total_products
FROM products;

-- Top 10 Product Categories

SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM products
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;


-- =====================================================
-- 4. Seller Analysis
-- =====================================================
-- Business Objective:
-- Understand seller distribution across states.

-- Total Sellers

SELECT COUNT(*) AS total_sellers
FROM sellers;

-- Sellers by State

SELECT
    seller_state,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY seller_state
ORDER BY total_sellers DESC;


-- =====================================================
-- 5. Payment Analysis
-- =====================================================
-- Business Objective:
-- Understand customer payment preferences.

-- Payment Method Distribution

SELECT
    payment_type,
    COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- Average Payment Value

SELECT
    ROUND(AVG(payment_value),2) AS average_payment
FROM payments;

-- Average Installments

SELECT
    ROUND(AVG(payment_installments),2) AS average_installments
FROM payments;


-- =====================================================
-- 6. Review Analysis
-- =====================================================
-- Business Objective:
-- Analyze customer satisfaction.

-- Average Review Score

SELECT
    ROUND(AVG(review_score),2) AS average_review_score
FROM reviews;

-- Review Score Distribution

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- =====================================================
-- 7. Order Items Analysis
-- =====================================================
-- Business Objective:
-- Analyze product sales, pricing, and shipping costs
-- to understand sales performance.

-- How many individual products have been sold?

SELECT COUNT(*) AS total_products_sold
FROM order_items;

-- How many unique products have been sold?

SELECT COUNT(DISTINCT product_id) AS unique_products_sold
FROM order_items;

-- What is the total sales revenue excluding shipping charges?

SELECT
    ROUND(SUM(price),2) AS total_sales
FROM order_items;

-- What is the total shipping cost paid by customers?

SELECT
    ROUND(SUM(freight_value),2) AS total_shipping_cost
FROM order_items;

-- What is the average selling price of products?

SELECT
    ROUND(AVG(price),2) AS average_product_price
FROM order_items;

-- What is the average shipping cost per product?

SELECT
    ROUND(AVG(freight_value),2) AS average_shipping_cost
FROM order_items;

-- Which products have the highest selling price?

SELECT
    product_id,
    price
FROM order_items
ORDER BY price DESC
LIMIT 10;

-- Which products have the highest shipping charges?

SELECT
    product_id,
    freight_value
FROM order_items
ORDER BY freight_value DESC
LIMIT 10;
