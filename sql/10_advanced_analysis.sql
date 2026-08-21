-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 10_advanced_analysis.sql
-- PURPOSE: Perform advanced analysis using window functions
-- =====================================================


USE superstore_portfolio;


-- =====================================================
-- 1. Product Ranking Within Each Category
-- =====================================================

WITH product_sales AS (
    SELECT
        category,
        product_id,
        product_name,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM orders_clean
    GROUP BY
        category,
        product_id,
        product_name
),

product_ranking AS (
    SELECT
        category,
        product_id,
        product_name,
        total_sales,
        total_profit,

        RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS sales_rank

    FROM product_sales
)

SELECT
    category,
    product_id,
    product_name,
    total_sales,
    total_profit,
    sales_rank
FROM product_ranking
WHERE sales_rank <= 5
ORDER BY
    category,
    sales_rank;
    
    
    -- =====================================================
-- 2. Product Ranking by Profit Within Each Category
-- =====================================================

WITH product_profit AS (
    SELECT
        category,
        product_id,
        product_name,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM orders_clean
    GROUP BY
        category,
        product_id,
        product_name
),

profit_ranking AS (
    SELECT
        category,
        product_id,
        product_name,
        total_sales,
        total_profit,

        RANK() OVER (
            PARTITION BY category
            ORDER BY total_profit DESC
        ) AS profit_rank

    FROM product_profit
)

SELECT
    category,
    product_id,
    product_name,
    total_sales,
    total_profit,
    profit_rank
FROM profit_ranking
WHERE profit_rank <= 5
ORDER BY
    category,
    profit_rank;
    
    
    -- =====================================================
-- 3. Product Sales Contribution
-- =====================================================

WITH product_sales AS (
    SELECT
        product_id,
        product_name,
        category,
        SUM(sales) AS total_sales
    FROM orders_clean
    GROUP BY
        product_id,
        product_name,
        category
),

sales_contribution AS (
    SELECT
        product_id,
        product_name,
        category,
        total_sales,

        SUM(total_sales) OVER () AS company_total_sales,

        SUM(total_sales) OVER (
            ORDER BY total_sales DESC
        ) AS cumulative_sales

    FROM product_sales
)

SELECT
    product_id,
    product_name,
    category,

    ROUND(total_sales, 2) AS total_sales,

    ROUND(
        total_sales / company_total_sales * 100,
        2
    ) AS sales_contribution_pct,

    ROUND(
        cumulative_sales / company_total_sales * 100,
        2
    ) AS cumulative_sales_pct

FROM sales_contribution
ORDER BY total_sales DESC;