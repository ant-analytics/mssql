USE Bikestores
GO

-- create a view table for the sales schema
-- the view include information about where are, what did they buy and how much did they pay
-- where did they buy: store name, city, state and who was sellers.
CREATE OR ALTER VIEW custom.sales_join AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_date,
    o.required_date,
    o.shipped_date,
    o.store_id,
    o.staff_id,
    c.city AS customer_city,
    c.state AS customer_state,
    sr.store_name,
    sr.city AS store_city,
    sr.state AS store_state,
    oi.product_id,
    oi.quantity,
    oi.list_price,
    oi.discount
FROM sales.orders AS o
LEFT OUTER JOIN sales.customers AS c
    ON o.customer_id = c.customer_id
LEFT OUTER JOIN sales.staffs AS s
    ON o.staff_id = s.staff_id
LEFT OUTER JOIN sales.stores AS sr
    ON o.store_id = sr.store_id
LEFT OUTER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
GO
