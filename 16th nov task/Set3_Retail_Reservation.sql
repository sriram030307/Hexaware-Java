-- Set 3: Retail inventory reservation
CREATE DATABASE IF NOT EXISTS retail_day8;
USE retail_day8;
CREATE TABLE IF NOT EXISTS products(product_id INT PRIMARY KEY,product_name VARCHAR(80),
 category VARCHAR(50),stock INT NOT NULL CHECK(stock>=0),price DECIMAL(10,2));
CREATE TABLE IF NOT EXISTS orders(order_id BIGINT AUTO_INCREMENT PRIMARY KEY,customer_id INT,
 order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,status VARCHAR(20));
CREATE TABLE IF NOT EXISTS order_lines(order_id BIGINT,product_id INT,qty INT,unit_price DECIMAL(10,2),
 PRIMARY KEY(order_id,product_id),FOREIGN KEY(order_id) REFERENCES orders(order_id),
 FOREIGN KEY(product_id) REFERENCES products(product_id));
INSERT IGNORE INTO products VALUES(1,'Keyboard','Accessories',20,1200),
 (2,'Mouse','Accessories',8,500),(3,'Monitor','Displays',5,9000);

-- Reservation: inspect ROW_COUNT() after stock update; rollback if 0.
START TRANSACTION;
UPDATE products SET stock=stock-3 WHERE product_id=1 AND stock>=3;
-- If affected rows != 1: ROLLBACK and report insufficient stock.
INSERT INTO orders(customer_id,status) VALUES(101,'PENDING');
SET @oid=LAST_INSERT_ID();
INSERT INTO order_lines VALUES(@oid,1,3,1200);
-- Payment failure: ROLLBACK (stock, order and line all undone).
-- Payment success:
UPDATE orders SET status='CONFIRMED' WHERE order_id=@oid;
COMMIT;

-- For multi-item orders, conditionally update each stock row, check each
-- ROW_COUNT(), and ROLLBACK the entire transaction if any item fails.
