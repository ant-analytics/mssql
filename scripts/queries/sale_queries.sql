USE Bikestores
GO

-- calculate sales for each store and the percentage of total sales of the company
SELECT
    store_id,
    store_name,
    store_state,
    store_city,
    SUM(quantity*list_price*(1-discount)) AS company_sale,
    (SUM(quantity*list_price*(1-discount))/(SELECT SUM(quantity*list_price*(1-discount)) FROM custom.sales_join))*100 AS store_sales_contribution
FROM custom.sales_join
GROUP by store_id, store_name, store_state, store_city
GO

-- cacluclate total sales of company and staff sales contribution
-- calculate average sale of each staff
SELECT
    staff_id,
    SUM(quantity*list_price*(1-discount)) AS staff_total_sales,
    COUNT(DISTINCT customer_id) AS total_customer,
    AVG(quantity*list_price*(1-discount)) AS staff_avg_sales,
    (SELECT SUM(quantity*list_price*(1-discount)) FROM custom.sales_join) AS company_sale,
    (SUM(quantity*list_price*(1-discount))/(SELECT SUM(quantity*list_price*(1-discount)) FROM custom.sales_join))*100 AS staff_sales_contribution,
    CASE
        WHEN (SUM(quantity*list_price*(1-discount))/(SELECT SUM(quantity*list_price*(1-discount)) FROM custom.sales_join))*100 > 30 THEN 'High'
        WHEN (SUM(quantity*list_price*(1-discount))/(SELECT SUM(quantity*list_price*(1-discount)) FROM custom.sales_join))*100 BETWEEN 10 AND 30 THEN 'Medium'
        ELSE 'Low'
    END AS sales_contribution_level
FROM custom.sales_join
GROUP BY staff_id
ORDER BY staff_sales_contribution DESC
GO

-- how many customer placed order and where are they from.
-- total sales from each state, city
-- sale person rate for each state, city
-- listing them from low to high
SELECT
    customer_state,
    customer_city,
    COUNT(DISTINCT customer_id) AS total_customer,
    SUM(quantity*list_price*(1-discount)) AS company_sale,
    SUM(quantity*list_price*(1-discount))/COUNT(DISTINCT customer_id) AS avg_sales_per_customer
FROM custom.sales_join
GROUP BY customer_city, customer_state
ORDER BY avg_sales_per_customer DESC
GO

-- top 10 model contribute most to the sales
SELECT TOP(10)
    sj.product_id,
    p.product_name,
    c.category_name,
    b.brand_name,
    SUM(sj.quantity) AS total_quantity,
    SUM(sj.quantity*sj.list_price*(1-sj.discount)) AS total_product_sales,
    (SELECT sum(quantity*list_price*(1-discount)) FROM custom.sales_join) AS company_sale,
    (SUM(sj.quantity*sj.list_price*(1-sj.discount))/(SELECT SUM(quantity*list_price*(1-discount)) FROM custom.sales_join))*100 AS product_sales_contribution
FROM custom.sales_join AS sj
LEFT OUTER JOIN production.products AS p
    ON sj.product_id = p.product_id
LEFT OUTER JOIN production.categories AS c
    ON p.category_id = c.category_id
LEFT OUTER JOIN production.brands AS b
    ON p.brand_id = b.brand_id

GROUP BY sj.product_id, p.product_name, c.category_name, b.brand_name
ORDER BY product_sales_contribution DESC --remove DESC to get the least sales
GO