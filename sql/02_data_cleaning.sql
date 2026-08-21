-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 02_data_cleaning.sql
-- PURPOSE: Clean raw Superstore data for analysis
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Recreate clean table
-- =====================================================

DROP TABLE IF EXISTS orders_clean;


CREATE TABLE orders_clean AS
SELECT
    CAST(`ï»¿Row ID` AS UNSIGNED) AS row_id,
    `Order ID` AS order_id,

    STR_TO_DATE(`Order Date`, '%d/%m/%Y') AS order_date,
    STR_TO_DATE(`Ship Date`, '%d/%m/%Y') AS ship_date,

    `Ship Mode` AS ship_mode,
    `Customer ID` AS customer_id,
    `Customer Name` AS customer_name,
    `Segment` AS segment,
    `Country/Region` AS country_region,
    `City` AS city,
    `State/Province` AS state_province,
    `Postal Code` AS postal_code,
    `Region` AS region,

    `Product ID` AS product_id,
    `Category` AS category,
    `Sub-Category` AS sub_category,
    `Product Name` AS product_name,

    CAST(
        REPLACE(`Sales`, ',', '.')
        AS DECIMAL(12,4)
    ) AS sales,

    `Quantity` AS quantity,

    CAST(
        REPLACE(`Discount`, ',', '.')
        AS DECIMAL(5,4)
    ) AS discount,

    CAST(
        REPLACE(`Profit`, ',', '.')
        AS DECIMAL(12,4)
    ) AS profit

FROM orders_raw;


-- =====================================================
-- 2. Validate cleaned table
-- =====================================================

SELECT COUNT(*) AS total_clean_rows
FROM orders_clean;


-- =====================================================
-- 3. Preview cleaned data
-- =====================================================

SELECT *
FROM orders_clean
LIMIT 10;