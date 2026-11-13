-- Day 6 Set 1: Retail Sales Reporting
CREATE DATABASE IF NOT EXISTS day6_retail; USE day6_retail;
CREATE TABLE customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(100) NOT NULL,city VARCHAR(60),email VARCHAR(120),created_at DATE);
CREATE TABLE products(product_id INT PRIMARY KEY,product_name VARCHAR(100) NOT NULL,category VARCHAR(60),unit_price DECIMAL(10,2) NOT NULL);
CREATE TABLE orders(order_id INT PRIMARY KEY,customer_id INT NOT NULL,order_date DATE NOT NULL,payment_status VARCHAR(20),FOREIGN KEY(customer_id) REFERENCES customers(customer_id));
CREATE TABLE order_items(order_item_id INT PRIMARY KEY,order_id INT NOT NULL,product_id INT NOT NULL,quantity INT NOT NULL,unit_price DECIMAL(10,2) NOT NULL,FOREIGN KEY(order_id) REFERENCES orders(order_id),FOREIGN KEY(product_id) REFERENCES products(product_id));
INSERT INTO customers VALUES (1,'Ananya Rao','Chennai','ananya@example.com','2025-01-10'),(2,'Karthik Kumar','Bengaluru','karthik@example.com','2025-02-15'),(3,'Meera Shah','Chennai','meera@example.com','2025-03-20'),(4,'Arjun Nair','Kochi','arjun@example.com','2025-04-05'),(5,'Divya Iyer','Madurai','divya@example.com','2025-05-12');
INSERT INTO products VALUES (101,'Wireless Mouse','Accessories',799),(102,'Mechanical Keyboard','Accessories',2499),(103,'USB-C Hub','Electronics',1899),(104,'Laptop Stand','Accessories',1299),(105,'Webcam','Electronics',3299);
INSERT INTO orders VALUES (1001,1,'2026-10-01','PAID'),(1002,1,'2026-10-05','PENDING'),(1003,2,'2026-10-05','PAID'),(1004,2,'2026-10-12','PAID'),(1005,3,'2026-10-12','UNPAID'),(1006,1,'2026-11-01','PAID'),(1007,4,'2026-11-02','PAID'),(1008,2,'2026-11-02','PAID');
INSERT INTO order_items VALUES (1,1001,101,2,799),(2,1001,102,1,2499),(3,1002,103,1,1899),(4,1003,101,1,799),(5,1003,104,2,1299),(6,1004,105,1,3299),(7,1005,103,2,1899),(8,1006,102,1,2499),(9,1006,101,1,799),(10,1007,104,1,1299),(11,1008,105,2,3299);
-- 1 Top products
SELECT p.product_id,p.product_name,ROUND(SUM(oi.quantity*oi.unit_price),2) revenue FROM products p JOIN order_items oi ON oi.product_id=p.product_id GROUP BY p.product_id,p.product_name ORDER BY revenue DESC LIMIT 5;
-- 2 Monthly sales
SELECT DATE_FORMAT(o.order_date,'%Y-%m') sales_month,ROUND(SUM(oi.quantity*oi.unit_price),2) monthly_sales FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY DATE_FORMAT(o.order_date,'%Y-%m') ORDER BY sales_month;
-- 3 Customers with >3 orders
SELECT c.customer_id,UPPER(c.customer_name) customer_name,COUNT(o.order_id) order_count FROM customers c JOIN orders o ON o.customer_id=c.customer_id GROUP BY c.customer_id,c.customer_name HAVING COUNT(o.order_id)>3;
-- 4 Average basket value by city
SELECT c.city,ROUND(AVG(x.order_value),2) avg_basket_value FROM customers c JOIN (SELECT o.order_id,o.customer_id,SUM(oi.quantity*oi.unit_price) order_value FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY o.order_id,o.customer_id) x ON x.customer_id=c.customer_id GROUP BY c.city ORDER BY avg_basket_value DESC;
-- 5 Unpaid orders
SELECT o.order_id,CONCAT('ORDER-',o.order_id) order_reference,o.order_date,o.payment_status FROM orders o LEFT JOIN order_items oi ON oi.order_id=o.order_id WHERE o.payment_status IS NULL OR o.payment_status<>'PAID' GROUP BY o.order_id,o.order_date,o.payment_status;
-- 6 Customers without orders
SELECT c.customer_id,c.customer_name FROM customers c LEFT JOIN orders o ON o.customer_id=c.customer_id WHERE o.order_id IS NULL;
-- 7 Category revenue share
SELECT p.category,ROUND(SUM(oi.quantity*oi.unit_price),2) category_revenue,ROUND(100*SUM(oi.quantity*oi.unit_price)/(SELECT SUM(quantity*unit_price) FROM order_items),2) revenue_share_percent FROM products p JOIN order_items oi ON oi.product_id=p.product_id GROUP BY p.category;
-- 8 Highest-sales day
SELECT o.order_date,ROUND(SUM(oi.quantity*oi.unit_price),2) daily_sales FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY o.order_date ORDER BY daily_sales DESC LIMIT 1;
-- NULL handling
SELECT COUNT(*) customer_rows,COUNT(t.order_value) customers_with_orders,SUM(t.order_value) sum_ignoring_nulls,AVG(t.order_value) avg_ignoring_nulls,SUM(COALESCE(t.order_value,0)) sum_after_coalesce FROM customers c LEFT JOIN (SELECT o.customer_id,SUM(oi.quantity*oi.unit_price) order_value FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY o.customer_id) t ON t.customer_id=c.customer_id;
