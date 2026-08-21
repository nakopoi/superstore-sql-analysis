-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 09_sales_trend_analysis.sql
-- PURPOSE: Analyze sales and profit trends over time
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Yearly Sales Performance
-- =====================================================

SELECT
    YEAR(order_date) AS year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_clean
GROUP BY YEAR(order_date)
ORDER BY year;


-- =====================================================
-- 2. Monthly Sales Trend
-- =====================================================

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_clean
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    year,
    month;
    
    -- =====================================================
-- 3. Month-over-Month Sales Growth
-- =====================================================

WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        MONTHNAME(order_date) AS month_name,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM orders_clean
    GROUP BY
        YEAR(order_date),
        MONTH(order_date),
        MONTHNAME(order_date)
),

sales_with_previous_month AS (
    SELECT
        year,
        month,
        month_name,
        total_sales,
        total_profit,

        LAG(total_sales) OVER (
            ORDER BY year, month
        ) AS previous_month_sales

    FROM monthly_sales
)

SELECT
    year,
    month,
    month_name,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(
        previous_month_sales,
        2
    ) AS previous_month_sales,

    ROUND(
        (total_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0) * 100,
        2
    ) AS mom_growth_pct,

    ROUND(total_profit, 2) AS total_profit

FROM sales_with_previous_month
ORDER BY
    year,
    month;
    
    
    -- =====================================================
-- 4. Highest and Lowest Monthly Sales Growth
-- =====================================================

WITH monthly_sales AS (
    SELECT
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        MONTHNAME(order_date) AS month_name,
        SUM(sales) AS total_sales
    FROM orders_clean
    GROUP BY
        YEAR(order_date),
        MONTH(order_date),
        MONTHNAME(order_date)
),

monthly_growth AS (
    SELECT
        year,
        month,
        month_name,
        total_sales,

        LAG(total_sales) OVER (
            ORDER BY year, month
        ) AS previous_month_sales

    FROM monthly_sales
),

growth_calculation AS (
    SELECT
        year,
        month,
        month_name,
        total_sales,

        ROUND(
            (total_sales - previous_month_sales)
            / NULLIF(previous_month_sales, 0) * 100,
            2
        ) AS mom_growth_pct

    FROM monthly_growth
)

SELECT
    year,
    month_name,
    ROUND(total_sales, 2) AS total_sales,
    mom_growth_pct
FROM growth_calculation
WHERE mom_growth_pct IS NOT NULL
ORDER BY mom_growth_pct DESC;