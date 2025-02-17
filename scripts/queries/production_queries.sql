-- select database for queries
USE Bikestores
GO

-- total stocks quantity for each store
SELECT
    stk.store_id,
    sr.store_name,
    sr.city,
    sr.state,
    SUM(quantity) AS stock_quantity
FROM production.stocks as stk
LEFT OUTER JOIN sales.stores AS sr
    ON stk.store_id = sr.store_id
GROUP by stk.store_id, sr.store_name, sr.city, sr.state
ORDER by stock_quantity DESC
GO

-- total stocks quantity for each category
-- check creation of production_join at scripts\views\production_join.sql
SELECT TOP (10)
    store_id, 
    store_name,
    category_name,
    SUM(stock_quantity) AS stock_quantity
FROM custom.production_join
GROUP BY store_id, store_name, category_name
ORDER BY stock_quantity DESC
GO