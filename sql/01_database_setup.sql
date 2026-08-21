-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 01_database_setup.sql
-- PURPOSE: Database setup and initial validation
-- =====================================================


-- 1. Create project database
CREATE DATABASE IF NOT EXISTS superstore_portfolio;


-- 2. Select project database
USE superstore_portfolio;


-- 3. Check active database
SELECT DATABASE() AS active_database;


-- 4. Check raw dataset
SELECT COUNT(*) AS total_raw_rows
FROM superstore_portfolio.orders_raw;


-- 5. Check cleaned dataset
SELECT COUNT(*) AS total_clean_rows
FROM superstore_portfolio.orders_clean;