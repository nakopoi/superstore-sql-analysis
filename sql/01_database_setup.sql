-- =====================================================
-- PROJECT: Superstore Sales Analysis
-- FILE: 01_database_setup.sql
-- PURPOSE: Create and select the project database
-- =====================================================


-- =====================================================
-- 1. Create Project Database
-- =====================================================

CREATE DATABASE IF NOT EXISTS superstore_portfolio;


-- =====================================================
-- 2. Select Project Database
-- =====================================================

USE superstore_portfolio;


-- =====================================================
-- 3. Confirm Active Database
-- =====================================================

SELECT DATABASE() AS active_database;
