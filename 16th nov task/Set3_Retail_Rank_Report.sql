-- Set 3: Retail correlated subquery, category ranking, monthly trend
USE retail_day8;
-- Products below their category's average stock
SELECT p.product_id,p.product_name,p.category,p.stock
FROM products p
WHERE p.stock<(SELECT AVG(x.stock) FROM products x WHERE x.category=p.category);

-- Top 3 products per category by confirmed units sold
WITH ranked AS (
 SELECT p.category,p.product_id,p.product_name,SUM(ol.qty) units_sold,
 ROW_NUMBER() OVER(PARTITION BY p.category ORDER BY SUM(ol.qty) DESC,p.product_id) rn
 FROM products p JOIN order_lines ol ON ol.product_id=p.product_id
 JOIN orders o ON o.order_id=ol.order_id AND o.status='CONFIRMED'
 GROUP BY p.category,p.product_id,p.product_name
)
SELECT category,product_id,product_name,units_sold FROM ranked WHERE rn<=3 ORDER BY category,rn;

CREATE TABLE IF NOT EXISTS sales(product_id INT,sale_month DATE,units INT,
 PRIMARY KEY(product_id,sale_month));
-- Month-over-month using LAG and LEAD
SELECT product_id,sale_month,units,
 LAG(units) OVER(PARTITION BY product_id ORDER BY sale_month) previous_month,
 units-LAG(units) OVER(PARTITION BY product_id ORDER BY sale_month) change_value,
 LEAD(units) OVER(PARTITION BY product_id ORDER BY sale_month) next_month
FROM sales ORDER BY product_id,sale_month;
