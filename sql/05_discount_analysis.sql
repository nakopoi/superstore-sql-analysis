-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 05_discount_analysis.sql
-- PURPOSE: Analyze the relationship between discount
--          and profitability in the Furniture category
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Average Discount by Furniture Sub-Category
-- =====================================================

SELECT
    sub_category,
    ROUND(AVG(discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
WHERE category = 'Furniture'
GROUP BY sub_category
ORDER BY avg_discount_pct DESC;


-- =====================================================
-- 2. Furniture Profitability by Discount Group
-- =====================================================

SELECT
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE 'Above 30%'
    END AS discount_group,

    COUNT(*) AS total_transactions,

    ROUND(SUM(sales), 2) AS total_sales,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin_pct

FROM orders_clean
WHERE category = 'Furniture'

GROUP BY
    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        ELSE 'Above 30%'
    END

ORDER BY MIN(discount);