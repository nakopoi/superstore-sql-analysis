-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 03_data_quality_check.sql
-- PURPOSE: Validate data quality before analysis
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Check total rows
-- =====================================================

SELECT COUNT(*) AS total_rows
FROM orders_clean;


-- =====================================================
-- 2. Check missing values in important columns
-- =====================================================

SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM orders_clean;


-- =====================================================
-- 3. Check duplicate Row ID
-- =====================================================

SELECT
    row_id,
    COUNT(*) AS duplicate_count
FROM orders_clean
GROUP BY row_id
HAVING COUNT(*) > 1;


-- =====================================================
-- 4. Check invalid shipping dates
-- Ship date should not be earlier than order date
-- =====================================================

SELECT
    row_id,
    order_id,
    order_date,
    ship_date
FROM orders_clean
WHERE ship_date < order_date;


-- =====================================================
-- 5. Check numeric value ranges
-- =====================================================

SELECT
    MIN(sales) AS min_sales,
    MAX(sales) AS max_sales,

    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,

    MIN(discount) AS min_discount,
    MAX(discount) AS max_discount,

    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit
FROM orders_clean;