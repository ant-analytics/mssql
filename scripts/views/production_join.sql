USE Bikestores
GO

-- THis create a for store customised views and procedures
-- CREATE SCHEMA custom;
-- GO

-- create a view table for production schema
CREATE OR ALTER VIEW custom.production_join AS
SELECT
    stk.store_id,
    s.store_name,
    s.state,
    s.city,
    stk.product_id,
    p.product_name,
    c.category_name,
    b.brand_name,
    stk.quantity AS stock_quantity
FROM production.stocks AS stk
LEFT OUTER JOIN production.products AS p
    ON stk.product_id = p.product_id
LEFT OUTER JOIN production.categories AS c
    ON p.category_id = c.category_id
LEFT OUTER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT OUTER JOIN sales.stores as s
    ON stk.store_id = s.store_id
GO