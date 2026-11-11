-- Day 5 Set 1: Retail Inventory Management
CREATE DATABASE IF NOT EXISTS retail_inventory;
USE retail_inventory;
CREATE TABLE IF NOT EXISTS suppliers(supplier_id INT PRIMARY KEY,supplier_name VARCHAR(100) NOT NULL,supplier_phone VARCHAR(20) NOT NULL);
CREATE TABLE IF NOT EXISTS categories(category_id INT PRIMARY KEY,category_name VARCHAR(80) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS warehouses(warehouse_id INT PRIMARY KEY,warehouse_name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS products(sku VARCHAR(20) PRIMARY KEY,product_name VARCHAR(100) NOT NULL,category_id INT NOT NULL,supplier_id INT NOT NULL,reorder_level INT NOT NULL DEFAULT 10 CHECK(reorder_level>=0),FOREIGN KEY(category_id) REFERENCES categories(category_id),FOREIGN KEY(supplier_id) REFERENCES suppliers(supplier_id));
CREATE TABLE IF NOT EXISTS inventory(sku VARCHAR(20),warehouse_id INT,quantity INT NOT NULL DEFAULT 0 CHECK(quantity>=0),PRIMARY KEY(sku,warehouse_id),FOREIGN KEY(sku) REFERENCES products(sku),FOREIGN KEY(warehouse_id) REFERENCES warehouses(warehouse_id));
INSERT IGNORE INTO suppliers VALUES (1,'Fresh Suppliers','9888800001'),(2,'Metro Wholesale','9888800002'),(3,'Green Farms','9888800003'),(4,'Prime Foods','9888800004'),(5,'Daily Supply','9888800005'),(6,'North Traders','9888800006'),(7,'City Distributors','9888800007'),(8,'Sunrise Foods','9888800008'),(9,'Value Mart','9888800009'),(10,'Global Supply','9888800010');
INSERT IGNORE INTO categories VALUES (1,'Produce'),(2,'Dairy'),(3,'Bakery'),(4,'Beverages'),(5,'Snacks'),(6,'Grains'),(7,'Frozen'),(8,'Household'),(9,'Personal Care'),(10,'Canned');
INSERT IGNORE INTO warehouses VALUES (1,'Chennai Central'),(2,'Madipakkam'),(3,'Velachery'),(4,'Tambaram'),(5,'Guindy'),(6,'Porur'),(7,'Ambattur'),(8,'Avadi'),(9,'OMR'),(10,'Pallavaram');
INSERT IGNORE INTO products VALUES ('SKU001','Apple',1,1,15),('SKU002','Milk',2,2,20),('SKU003','Bread',3,3,10),('SKU004','Juice',4,4,12),('SKU005','Chips',5,5,15),('SKU006','Rice',6,6,25),('SKU007','Ice Cream',7,7,8),('SKU008','Detergent',8,8,10),('SKU009','Soap',9,9,10),('SKU010','Beans',10,10,12);
INSERT IGNORE INTO inventory VALUES ('SKU001',1,100),('SKU002',1,80),('SKU003',2,60),('SKU004',3,50),('SKU005',4,75),('SKU006',5,120),('SKU007',6,30),('SKU008',7,40),('SKU009',8,90),('SKU010',9,65);
-- Invalid examples (uncomment individually): duplicate SKU; missing FK; negative quantity; NULL required field
-- INSERT INTO products VALUES ('SKU001','Duplicate',1,1,10);
-- INSERT INTO products VALUES ('SKU999','Missing parent',99,99,10);
-- INSERT INTO inventory VALUES ('SKU010',10,-1);
-- INSERT INTO suppliers VALUES (11,NULL,'123');
SELECT * FROM suppliers WHERE supplier_id=1;
UPDATE suppliers SET supplier_phone='9888800001' WHERE supplier_id=1;
SELECT * FROM suppliers WHERE supplier_id=1;
SELECT * FROM products WHERE sku='SKU010';
DELETE FROM inventory WHERE sku='SKU010'; DELETE FROM products WHERE sku='SKU010';
SELECT * FROM products WHERE sku='SKU010';
SELECT TABLE_NAME,ENGINE,TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA='retail_inventory' AND TABLE_TYPE='BASE TABLE';
