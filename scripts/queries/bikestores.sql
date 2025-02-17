USE Bikestores
GO
-- drop the view if it exists
IF OBJECT_ID(sales.check_order_null) IS NOT NULL
    DROP VIEW sales.check_order_null
GO

-- create view to check nul value in sals.orders table
CREATE VIEW sales.check_order_null AS
SELECT *
FROM sales.orders
WHERE order_id IS NULL OR staff_id IS NULL
GO

-- drop the view if it exists
IF OBJECT_ID(sales.check_order_duplicate) IS NOT NULL
    DROP VIEW sales.check_order_duplicate
GO

-- create view to check duplicate value in sales.orders table
CREATE VIEW sales.check_order_duplicate AS
SELECT 
    order_id,
    COUNT(*) AS total_order
FROM sales.orders
GROUP BY order_id
HAVING COUNT(*) > 1
GO

-- -- check null value in sales.orders table
IF EXISTS (SELECT 1 FROM sales.check_order_null)
BEGIN
    SELECT *
    FROM sales.check_order_null
END
ELSE
BEGIN
    PRINT 'No null values found in order_id and staff_id columns.'
END
GO

-- check duplicate value in sales.orders table
IF EXISTS (SELECT 1 FROM sales.check_order_duplicate)
BEGIN
    SELECT *
    FROM sales.check_order_duplicate
END
ELSE    
    PRINT 'No duplicate values found in order_id column.'
GO

-- reomove duplicate use distinct
SELECT DISTINCT order_id
FROM sales.orders
GO

-- select top and top percent
SELECT TOP 10 * -- return top 10 rows
-- SELECT TOP 10 PERCENT * -- return top 10 percent rows
FROM sales.orders
ORDER BY order_id
GO

SELECT *
FROM sales.orders
ORDER BY order_id
OFFSET 100 ROWS FETCH NEXT 10 ROWS ONLY -- skip 100 rows and return next 10 rows
GO