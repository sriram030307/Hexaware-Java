CREATE DATABASE IF NOT EXISTS logistics_day7; USE logistics_day7;
CREATE TABLE IF NOT EXISTS customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(80));
CREATE TABLE IF NOT EXISTS carriers(carrier_id INT PRIMARY KEY,carrier_name VARCHAR(80));
CREATE TABLE IF NOT EXISTS hubs(hub_id INT PRIMARY KEY,hub_name VARCHAR(80));
CREATE TABLE IF NOT EXISTS employees(employee_id INT PRIMARY KEY,employee_name VARCHAR(80),supervisor_id INT NULL,hub_id INT,FOREIGN KEY(supervisor_id) REFERENCES employees(employee_id),FOREIGN KEY(hub_id) REFERENCES hubs(hub_id));
CREATE TABLE IF NOT EXISTS shipments(shipment_id INT PRIMARY KEY,customer_id INT,carrier_id INT,origin_hub INT,destination_hub INT,ship_date DATE,promised_date DATE,delivered_date DATE NULL,shipping_cost DECIMAL(10,2),FOREIGN KEY(customer_id) REFERENCES customers(customer_id),FOREIGN KEY(carrier_id) REFERENCES carriers(carrier_id),FOREIGN KEY(origin_hub) REFERENCES hubs(hub_id),FOREIGN KEY(destination_hub) REFERENCES hubs(hub_id));
INSERT IGNORE INTO customers VALUES(1,'Asha'),(2,'Bharat'),(3,'Cedar'); INSERT IGNORE INTO carriers VALUES(1,'Swift'),(2,'BlueLine'),(3,'Metro');
INSERT IGNORE INTO hubs VALUES(1,'Chennai'),(2,'Bengaluru'),(3,'Hyderabad'),(4,'Kochi'); INSERT IGNORE INTO employees VALUES(10,'Ravi',NULL,1),(11,'Meena',10,1),(12,'Arun',10,2);
INSERT IGNORE INTO shipments VALUES(101,1,1,1,2,'2026-01-01','2026-01-03','2026-01-06',500),(102,2,2,1,3,'2026-01-02','2026-01-05','2026-01-05',700),(103,1,1,2,3,'2026-01-04','2026-01-06','2026-01-09',450),(104,3,3,3,1,'2026-01-05','2026-01-08','2026-01-07',800),(105,2,2,2,4,'2026-01-07','2026-01-10',NULL,600);
-- 1
SELECT s.shipment_id,c.customer_name,ca.carrier_name,oh.hub_name origin,dh.hub_name destination FROM shipments s JOIN customers c ON c.customer_id=s.customer_id JOIN carriers ca ON ca.carrier_id=s.carrier_id JOIN hubs oh ON oh.hub_id=s.origin_hub JOIN hubs dh ON dh.hub_id=s.destination_hub;
-- 2
SELECT s.shipment_id,ca.carrier_name,DATEDIFF(s.delivered_date,s.promised_date) days_late FROM shipments s JOIN carriers ca ON ca.carrier_id=s.carrier_id WHERE s.delivered_date>s.promised_date AND DATEDIFF(s.delivered_date,s.promised_date)>2;
-- 3
SELECT h.hub_name,s.shipment_id FROM hubs h LEFT JOIN shipments s ON s.origin_hub=h.hub_id;
-- 4
SELECT ca.carrier_name,s.shipment_id FROM carriers ca RIGHT JOIN shipments s ON s.carrier_id=ca.carrier_id;
-- 5
SELECT h.hub_name FROM hubs h LEFT JOIN shipments s ON s.origin_hub=h.hub_id WHERE s.shipment_id IS NULL;
-- 6
SELECT e.employee_name,m.employee_name supervisor FROM employees e LEFT JOIN employees m ON e.supervisor_id=m.employee_id;
-- 7
SELECT c.customer_name,COUNT(s.shipment_id) cnt FROM customers c LEFT JOIN shipments s ON s.customer_id=c.customer_id GROUP BY c.customer_id,c.customer_name;
-- 8
SELECT a.origin_hub,a.destination_hub,COUNT(*) pairs FROM shipments a JOIN shipments b ON a.origin_hub=b.origin_hub AND a.destination_hub=b.destination_hub AND a.shipment_id<b.shipment_id GROUP BY a.origin_hub,a.destination_hub;
-- 9
SELECT c.customer_name,s.shipment_id,s.shipping_cost FROM customers c JOIN shipments s ON s.customer_id=c.customer_id;
-- 10
SELECT ca.carrier_name,COUNT(s.shipment_id) cnt FROM carriers ca LEFT JOIN shipments s ON s.carrier_id=ca.carrier_id GROUP BY ca.carrier_id,ca.carrier_name;
-- all hubs per customer
SELECT c.customer_name FROM customers c WHERE NOT EXISTS(SELECT 1 FROM hubs h WHERE NOT EXISTS(SELECT 1 FROM shipments s WHERE s.customer_id=c.customer_id AND s.destination_hub=h.hub_id));
-- carrier avg delay > overall
SELECT ca.carrier_name,AVG(DATEDIFF(s.delivered_date,s.promised_date)) avg_delay FROM carriers ca JOIN shipments s ON s.carrier_id=ca.carrier_id WHERE s.delivered_date IS NOT NULL GROUP BY ca.carrier_id,ca.carrier_name HAVING AVG(DATEDIFF(s.delivered_date,s.promised_date))>(SELECT AVG(DATEDIFF(delivered_date,promised_date)) FROM shipments WHERE delivered_date IS NOT NULL);
SELECT shipment_id FROM shipments WHERE shipping_cost>ANY(SELECT shipping_cost FROM shipments WHERE destination_hub=3);
SELECT shipment_id FROM shipments WHERE shipping_cost>ALL(SELECT shipping_cost FROM shipments WHERE destination_hub=2);
SELECT DISTINCT c.customer_id FROM customers c JOIN shipments s ON s.customer_id=c.customer_id;
SELECT customer_id FROM customers WHERE customer_id IN(SELECT customer_id FROM shipments);
-- second-highest per hub
SELECT h.hub_name,x.cost FROM hubs h JOIN(SELECT destination_hub,MAX(shipping_cost) cost FROM shipments s WHERE shipping_cost<(SELECT MAX(s2.shipping_cost) FROM shipments s2 WHERE s2.destination_hub=s.destination_hub) GROUP BY destination_hub)x ON x.destination_hub=h.hub_id;
