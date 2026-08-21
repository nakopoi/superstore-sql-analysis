-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 06_region_analysis.sql
-- PURPOSE: Analyze sales and profitability by region
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Region Performance
-- =====================================================

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin_pct,

    COUNT(DISTINCT order_id) AS total_orders

FROM orders_clean
GROUP BY region
ORDER BY total_sales DESC;