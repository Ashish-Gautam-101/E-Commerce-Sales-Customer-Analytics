-- =====================================================
-- Project : E-Commerce Sales & Customer Analytics
-- File    : 02_Data_Cleaning.sql
-- Author  : Ashish Gautam
-- Purpose : Clean and standardize data before analysis
-- =====================================================

USE e_commerce_sales;

-- =====================================================
-- 1. Missing Value Assessment
-- =====================================================
-- Business Objective:
-- Identify missing values before applying cleaning rules.

SELECT
    SUM(product_category_name IS NULL) AS null_category,
    SUM(product_name_lenght IS NULL) AS null_name_length,
    SUM(product_description_lenght IS NULL) AS null_description,
    SUM(product_photos_qty IS NULL) AS null_photos,
    SUM(product_weight_g IS NULL) AS null_weight,
    SUM(product_length_cm IS NULL) AS null_length,
    SUM(product_height_cm IS NULL) AS null_height,
    SUM(product_width_cm IS NULL) AS null_width
FROM products;


-- =====================================================
-- 2. Handle Missing Product Categories
-- =====================================================
-- Product category is required for category-level analysis.
-- Missing categories are labelled as 'Unknown'.

SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET product_category_name = 'Unknown'
WHERE product_category_name IS NULL
   OR TRIM(product_category_name) = '';


-- =====================================================
-- 3. Trim Extra Spaces
-- =====================================================
-- Remove leading and trailing spaces from important text fields.

UPDATE customers
SET customer_city = TRIM(customer_city);

UPDATE sellers
SET seller_city = TRIM(seller_city);

UPDATE sellers
SET seller_state = TRIM(seller_state);


-- =====================================================
-- 4. Standardize Text Fields
-- =====================================================
-- Convert city names to lowercase for consistency.

UPDATE customers
SET customer_city = LOWER(customer_city);

UPDATE sellers
SET seller_city = LOWER(seller_city);


-- =====================================================
-- 5. Handle Blank Strings
-- =====================================================
-- Convert empty strings to NULL instead of keeping them
-- as misleading text values.

UPDATE customers
SET customer_city = NULL
WHERE customer_city = '';

UPDATE sellers
SET seller_city = NULL
WHERE seller_city = '';

UPDATE sellers
SET seller_state = NULL
WHERE seller_state = '';


-- =====================================================
-- 6. Review Missing Values
-- =====================================================
-- Review comments are optional fields.
-- NULL values are retained because no information should
-- be artificially created.

SELECT
    COUNT(*) AS missing_review_titles
FROM reviews
WHERE review_comment_title IS NULL;

SELECT
    COUNT(*) AS missing_review_messages
FROM reviews
WHERE review_comment_message IS NULL;


-- =====================================================
-- 7. Numeric Validation
-- =====================================================
-- Identify invalid negative payment values.

SELECT *
FROM payments
WHERE payment_value < 0;


-- =====================================================
-- 8. Post-Cleaning Validation
-- =====================================================
-- Verify that blank customer and seller cities were removed.

SELECT COUNT(*) AS remaining_blank_customer_cities
FROM customers
WHERE customer_city = '';

SELECT COUNT(*) AS remaining_blank_seller_cities
FROM sellers
WHERE seller_city = '';

SELECT COUNT(*) AS remaining_blank_seller_states
FROM sellers
WHERE seller_state = '';

SELECT COUNT(*) AS remaining_blank_product_categories
FROM products
WHERE product_category_name = '';


-- =====================================================
-- END OF DATA CLEANING
-- =====================================================
