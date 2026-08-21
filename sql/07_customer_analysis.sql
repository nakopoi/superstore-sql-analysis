-- =====================================================
-- 1. Customer Segment Performance
-- =====================================================

SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) / SUM(sales) * 100,
        2
    ) AS profit_margin_pct,

    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders

FROM orders_clean
GROUP BY segment
ORDER BY total_sales DESC;


-- =====================================================
-- 2. Top 10 Customers by Sales
-- =====================================================

SELECT
    customer_id,
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_clean
GROUP BY
    customer_id,
    customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- =====================================================
-- 3. Top 10 Customers by Profit
-- =====================================================

SELECT
    customer_id,
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_clean
GROUP BY
    customer_id,
    customer_name
ORDER BY total_profit DESC
LIMIT 10;