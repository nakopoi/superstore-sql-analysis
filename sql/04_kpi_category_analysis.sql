-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 04_kpi_category_analysis.sql
-- PURPOSE: Analyze overall KPIs and category performance
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Overall Business KPIs
-- =====================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM orders_clean;


-- =====================================================
-- 2. Profit Margin and Average Order Value
-- =====================================================

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin_pct,

    COUNT(DISTINCT order_id) AS total_orders,

    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value

FROM orders_clean;


-- =====================================================
-- 3. Sales and Profit by Category
-- =====================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY category
ORDER BY total_sales DESC;


-- =====================================================
-- 4. Profit Margin by Category
-- =====================================================

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders_clean
GROUP BY category
ORDER BY profit_margin_pct DESC;


-- =====================================================
-- 5. Furniture Sub-Category Performance
-- =====================================================

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders_clean
WHERE category = 'Furniture'
GROUP BY sub_category
ORDER BY total_profit ASC;
