-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 08_product_analysis.sql
-- PURPOSE: Analyze product sales and profitability
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Top 10 Products by Sales
-- =====================================================

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- =====================================================
-- 2. Top 10 Products by Profit
-- =====================================================

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
ORDER BY total_profit DESC
LIMIT 10;


-- =====================================================
-- 3. Top 10 Products with Highest Loss
-- =====================================================

SELECT
    product_id,
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY
    product_id,
    product_name,
    category,
    sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;