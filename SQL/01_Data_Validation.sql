-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 01_Data_Validation.sql
-- Author  : Ashish Gautam
-- Purpose : Validate imported data before analysis
-- =====================================================

USE e_commerce_sales;

-- =====================================================
-- 1. Check Total Records
-- =====================================================
-- Business Objective: Verify that all tables have been imported successful


SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT COUNT(*) AS total_payments
FROM payments;

SELECT COUNT(*) AS total_reviews
FROM reviews;

SELECT COUNT(*) AS total_geolocations
FROM geolocation;

SELECT COUNT(*) AS total_categories
FROM category_translation;


-- =====================================================
-- 2. Check Table Structure 
-- =====================================================
-- Business Objective: Review column names, data types, and table schema.

DESCRIBE customers;

DESCRIBE orders;

DESCRIBE category_translation;

DESCRIBE order_items;

DESCRIBE geolocation;

DESCRIBE payments;

DESCRIBE products;

DESCRIBE reviews;

DESCRIBE sellers;


-- =====================================================
-- 3. Preview the Data
-- =====================================================
-- Business Objective: Inspect sample records to understand the dataset.

SELECT *
FROM customers
LIMIT 5;

SELECT *
FROM category_translation
LIMIT 5;

SELECT *
FROM geolocation
LIMIT 5;

SELECT *
FROM order_items
LIMIT 5;

SELECT *
FROM orders
LIMIT 5;

SELECT *
FROM payments
LIMIT 5;

SELECT *
FROM products
LIMIT 5;

SELECT *
FROM reviews
LIMIT 5;

SELECT *
FROM sellers
LIMIT 5;

-- =====================================================
-- 4. Check for Duplicate Primary Keys 
-- =====================================================
-- Business Objective: Identify duplicate primary key values.

SELECT customer_id,COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id,COUNT(*) AS duplicate_count
FROM orders
GROUP BY  order_id
HAVING COUNT(*) > 1;

SELECT product_id,COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT seller_id,COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


-- =====================================================
-- 5. Check for Missing Values 
-- =====================================================
-- Business Objective: Identify duplicate primary key values.

SELECT *
FROM customers
WHERE customer_id IS NULL;

SELECT *
FROM orders
WHERE customer_id IS NULL;

SELECT *
FROM order_items
WHERE order_id IS NULL
   OR product_id IS NULL
   OR seller_id IS NULL;
   
SELECT *
FROM category_translation
WHERE product_category_name IS NULL 
   OR product_category_name_english IS NULL;
   
SELECT *
FROM geolocation
WHERE geolocation_zip_code_prefix IS NULL
    OR geolocation_lat IS NULL
    OR geolocation_lng IS NULL
    OR geolocation_city IS NULL
    OR geolocation_state IS NULL;
    
SELECT *
FROM payments
WHERE order_id IS NULL
   OR payment_sequential IS NULL
   OR payment_type IS NULL
   OR payment_installments IS NULL
   OR payment_value IS NULL;
   
SELECT *
FROM products
WHERE product_id IS NULL
   OR product_category_name IS NULL
   OR product_name_lenght IS NULL
   OR product_description_lenght IS NULL
   OR product_photos_qty IS NULL
   OR product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;
 
 -- HOW MANY NULL VALUES IN EACH COLUMN --
 
SELECT
    COUNT(*) AS total_rows,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(product_category_name IS NULL) AS null_category,
    SUM(product_name_lenght IS NULL) AS null_name_length,
    SUM(product_description_lenght IS NULL) AS null_description_length,
    SUM(product_photos_qty IS NULL) AS null_photos,
    SUM(product_weight_g IS NULL) AS null_weight,
    SUM(product_length_cm IS NULL) AS null_length,
    SUM(product_height_cm IS NULL) AS null_height,
    SUM(product_width_cm IS NULL) AS null_width
FROM products;

SELECT
    COUNT(*) AS total_rows,
    SUM(review_id IS NULL) AS null_review_id,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(review_score IS NULL) AS null_review_score,
    SUM(review_comment_title IS NULL) AS null_comment_title,
    SUM(review_comment_message IS NULL) AS null_comment_message,
    SUM(review_creation_date IS NULL) AS null_creation_date,
    SUM(review_answer_timestamp IS NULL) AS null_answer_timestamp
FROM reviews;

SELECT
    COUNT(*) AS total_rows,
    SUM(seller_id IS NULL) AS null_seller_id,
    SUM(seller_zip_code_prefix IS NULL) AS null_zip_code,
    SUM(seller_city IS NULL) AS null_city,
    SUM(seller_state IS NULL) AS null_state
FROM sellers;


-- =====================================================
-- 6. Understand Relationships 
-- =====================================================
-- Business Objective: Verify referential integrity between related tables.
 
SELECT o.order_id
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT oi.order_id
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT oi.product_id
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT oi.seller_id
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT p.order_id
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT r.order_id
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;
