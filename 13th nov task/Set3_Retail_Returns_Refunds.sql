CREATE DATABASE IF NOT EXISTS retail_day7; USE retail_day7;
CREATE TABLE IF NOT EXISTS customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(80)); CREATE TABLE IF NOT EXISTS stores(store_id INT PRIMARY KEY,store_name VARCHAR(80),region VARCHAR(50));
CREATE TABLE IF NOT EXISTS employees(employee_id INT PRIMARY KEY,employee_name VARCHAR(80),manager_id INT NULL,store_id INT,FOREIGN KEY(manager_id) REFERENCES employees(employee_id),FOREIGN KEY(store_id) REFERENCES stores(store_id));
CREATE TABLE IF NOT EXISTS orders(order_id INT PRIMARY KEY,customer_id INT,store_id INT,order_total DECIMAL(10,2),order_date DATE,FOREIGN KEY(customer_id) REFERENCES customers(customer_id),FOREIGN KEY(store_id) REFERENCES stores(store_id));
CREATE TABLE IF NOT EXISTS returns(return_id INT PRIMARY KEY,order_id INT,refund_amount DECIMAL(10,2),return_date DATE,refund_date DATE NULL,FOREIGN KEY(order_id) REFERENCES orders(order_id));
INSERT IGNORE INTO customers VALUES(1,'Ira'),(2,'Jay'),(3,'Kavi'),(4,'Latha'); INSERT IGNORE INTO stores VALUES(1,'Chennai Central','South'),(2,'Chennai North','South'),(3,'Bengaluru East','West');
INSERT IGNORE INTO employees VALUES(10,'Manager One',NULL,1),(11,'Staff A',10,1),(12,'Staff B',10,2),(13,'Manager Two',NULL,3);
INSERT IGNORE INTO orders VALUES(301,1,1,1000,'2026-01-01'),(302,2,1,2000,'2026-01-02'),(303,1,2,1500,'2026-01-03'),(304,3,3,2500,'2026-01-04'),(305,4,2,800,'2026-01-05');
INSERT IGNORE INTO returns VALUES(1,301,200,'2026-01-10','2026-01-12'),(2,302,500,'2026-01-11',NULL),(3,304,300,'2026-01-12','2026-01-15');
-- 1
SELECT o.order_id,c.customer_name,s.store_name,o.order_total FROM orders o JOIN customers c ON c.customer_id=o.customer_id JOIN stores s ON s.store_id=o.store_id;
-- 2
SELECT r.return_id,c.customer_name,s.store_name,r.refund_amount FROM returns r JOIN orders o ON o.order_id=r.order_id JOIN customers c ON c.customer_id=o.customer_id JOIN stores s ON s.store_id=o.store_id;
-- 3 return rate >10%
SELECT s.store_name,100*COUNT(DISTINCT r.return_id)/COUNT(DISTINCT o.order_id) rate_pct FROM stores s JOIN orders o ON o.store_id=s.store_id LEFT JOIN returns r ON r.order_id=o.order_id GROUP BY s.store_id,s.store_name HAVING COUNT(DISTINCT r.return_id)/COUNT(DISTINCT o.order_id)>0.10;
-- 4 return but no refund
SELECT DISTINCT c.customer_name FROM customers c JOIN orders o ON o.customer_id=c.customer_id JOIN returns r ON r.order_id=o.order_id WHERE r.refund_date IS NULL;
-- 5 highest refund store
SELECT s.store_name,SUM(r.refund_amount) total_refund FROM stores s JOIN orders o ON o.store_id=s.store_id JOIN returns r ON r.order_id=o.order_id GROUP BY s.store_id,s.store_name ORDER BY total_refund DESC LIMIT 1;
-- 6 employee-manager self join
SELECT e.employee_name,m.employee_name manager FROM employees e LEFT JOIN employees m ON e.manager_id=m.employee_id;
-- 7 all stores and orders
SELECT s.store_name,COUNT(o.order_id) orders_count FROM stores s LEFT JOIN orders o ON o.store_id=s.store_id GROUP BY s.store_id,s.store_name;
-- 8 customers without returns
SELECT c.customer_name FROM customers c WHERE NOT EXISTS(SELECT 1 FROM orders o JOIN returns r ON r.order_id=o.order_id WHERE o.customer_id=c.customer_id);
-- 9 ANY regional refund comparison
SELECT s.store_name,SUM(r.refund_amount) total FROM stores s JOIN orders o ON o.store_id=s.store_id JOIN returns r ON r.order_id=o.order_id GROUP BY s.store_id,s.store_name,s.region HAVING SUM(r.refund_amount)>ANY(SELECT SUM(r2.refund_amount) FROM stores s2 JOIN orders o2 ON o2.store_id=s2.store_id JOIN returns r2 ON r2.order_id=o2.order_id WHERE s2.region=s.region AND s2.store_id<>s.store_id GROUP BY s2.store_id);
-- 10 ALL regional refund comparison
SELECT s.store_name,SUM(r.refund_amount) total FROM stores s JOIN orders o ON o.store_id=s.store_id JOIN returns r ON r.order_id=o.order_id GROUP BY s.store_id,s.store_name,s.region HAVING SUM(r.refund_amount)>ALL(SELECT SUM(r2.refund_amount) FROM stores s2 JOIN orders o2 ON o2.store_id=s2.store_id JOIN returns r2 ON r2.order_id=o2.order_id WHERE s2.region=s.region AND s2.store_id<>s.store_id GROUP BY s2.store_id);
-- NOT IN pitfall: filter NULL from inner result
SELECT customer_id FROM customers WHERE customer_id NOT IN(SELECT customer_id FROM orders WHERE customer_id IS NOT NULL);
-- Safer
SELECT c.customer_id FROM customers c WHERE NOT EXISTS(SELECT 1 FROM orders o WHERE o.customer_id=c.customer_id);
-- nested: store refunds greater than average store refund
SELECT store_name FROM stores WHERE store_id IN(SELECT o.store_id FROM orders o JOIN returns r ON r.order_id=o.order_id GROUP BY o.store_id HAVING SUM(r.refund_amount)>(SELECT AVG(v) FROM(SELECT SUM(r2.refund_amount)v FROM orders o2 JOIN returns r2 ON r2.order_id=o2.order_id GROUP BY o2.store_id)x));
-- nested: customer with max refund
SELECT customer_name FROM customers c WHERE customer_id IN(SELECT o.customer_id FROM orders o JOIN returns r ON r.order_id=o.order_id WHERE r.refund_amount=(SELECT MAX(refund_amount) FROM returns));
