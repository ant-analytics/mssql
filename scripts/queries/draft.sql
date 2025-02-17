SET NUMERIC_ROUNDABORT OFF;  
SET LANGUAGE English; -- Adjust based on your region  

USE Bikestores
GO

-- return top 10 products that have lowest stock quantity
SELECT TOP(10) -- return top 10 rows
    p.product_id,
    p.category_id,
    c.category_name, -- category name from categories table
    p.brand_id,
    p.product_name,
    b.brand_name, -- brand name from brands table
    p.model_year,
    p.list_price,
    s.store_id,
    s.quantity AS stock_quantity
FROM production.products AS p
LEFT OUTER JOIN production.brands AS b
    ON p.brand_id = b.brand_id
LEFT OUTER JOIN production.categories AS c
    ON p.category_id = c.category_id
LEFT OUTER JOIN production.stocks AS s
    ON p.product_id = s.product_id
ORDER BY stock_quantity
GO

PRINT '----------------------------------------'
GO

-- counting unique values in a column
SELECT
    (SELECT COUNT(DISTINCT product_id) FROM production.products) AS product_total_product_id,
    (SELECT COUNT(DISTINCT product_id) FROM production.stocks) AS stocks_total_product_id
GO

SELECT 
    (SELECT COUNT(DISTINCT city) FROM sales.customers) AS total_city,
    (SELECT COUNT(DISTINCT state) FROM sales.customers) AS total_state
GO

-- select most recent order for each customer
SELECT
    order_id, customer_id, order_date, required_date, shipped_date
FROM sales.orders as o1
WHERE order_id = (SELECT MAX(order_id) FROM sales.orders as o2 WHERE o1.customer_id = o2.customer_id)
ORDER BY customer_id
GO

-- calculate total sales for each staff between 2016 and 2018
SELECT
    st.staff_id,
    st.first_name,
    st.last_name,
    YEAR(o.order_date) AS order_year,
    SUM(oi.quantity*oi.list_price*(1-oi.discount)) AS total_sales
FROM sales.orders AS o
INNER JOIN sales.order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN sales.staffs AS st
    ON o.staff_id = st.staff_id
WHERE YEAR(o.order_date) BETWEEN 2016 and 2018
GROUP BY st.staff_id, st.first_name, st.last_name, YEAR(o.order_date)
ORDER BY total_sales DESC
GO

-- calculate total sales each store between 2016 and 2018
SELECT
    sr.store_id,
    sr.store_name,
    sr.state,
    YEAR(order_date) AS order_year,
    SUM(oi.quantity*oi.list_price*(1-oi.discount)) AS total_sales
FROM sales.stores AS sr
INNER JOIN sales.orders AS o
    ON sr.store_id = o.store_id
INNER JOIN sales.order_items AS oi
    on o.order_id = oi.order_id
WHERE YEAR(o.order_date) BETWEEN 2016 and 2018
GROUP BY sr.store_id, sr.store_name, sr.state, YEAR(order_date)
ORDER BY total_sales DESC
GO

-- listing stock of product for each store classified by category
SELECT
    sr.store_id,
    sr.store_name,
    sr.state,
    p.category_id,
    p.product_name,
    stk.quantity AS stock_quantity
FROM production.stocks AS stk
LEFT OUTER JOIN sales.stores AS sr
    ON stk.store_id = sr.store_id
LEFT OUTER JOIN production.products AS p
    ON stk.product_id = p.product_id
GO

-- calculate total sale for each store in each year and total of all years and rank for each store
SELECT 
    sr.store_id,
    sr.store_name,
    sr.state,
    YEAR(o.order_date) AS order_year,
    o.order_id AS order_id,
    sum(oi.quantity*oi.list_price*(1-oi.discount)) OVER() AS company_total_sales,
    sum(oi.quantity*oi.list_price*(1-oi.discount)) OVER(PARTITION BY sr.store_name) AS store_total_sale, -- calculate total sales for each store
    sum(oi.quantity*oi.list_price*(1-oi.discount)) OVER(PARTITION BY sr.store_name ORDER BY o.order_date) AS store_total_sale_year -- calculate total sales for each store cumulative by year
    -- sum(oi.quantity*oi.list_price*(1-oi.discount)) OVER(PARTITION BY o.customer_id) AS total_sale_per_customer --calculate totral sales for each customer

FROM sales.order_items AS oi
LEFT OUTER JOIN sales.orders AS o
    ON oi.order_id = o.order_id
LEFT OUTER JOIN sales.stores AS sr
    ON o.store_id = sr.store_id
-- ORDER BY total_sale_per_customer DESC
GO