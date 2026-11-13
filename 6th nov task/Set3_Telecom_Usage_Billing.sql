-- Day 6 Set 3: Telecom Usage and Billing
CREATE DATABASE IF NOT EXISTS day6_telecom; USE day6_telecom;
CREATE TABLE plans(plan_id INT PRIMARY KEY,plan_name VARCHAR(100),monthly_fee DECIMAL(10,2));
CREATE TABLE subscribers(subscriber_id INT PRIMARY KEY,subscriber_name VARCHAR(100),circle VARCHAR(60),data_limit_gb DECIMAL(8,2),plan_id INT);
CREATE TABLE call_records(call_id INT PRIMARY KEY,subscriber_id INT,call_date DATETIME,duration_minutes DECIMAL(8,2),FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id));
CREATE TABLE invoices(invoice_id INT PRIMARY KEY,subscriber_id INT,invoice_number VARCHAR(30),invoice_date DATE,due_date DATE,amount DECIMAL(10,2),paid_date DATE,FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id));
CREATE TABLE data_usage(usage_id INT PRIMARY KEY,subscriber_id INT,usage_date DATE,data_used_gb DECIMAL(8,2),FOREIGN KEY(subscriber_id) REFERENCES subscribers(subscriber_id));
INSERT INTO plans VALUES (1,'Basic',399),(2,'Plus',599),(3,'Unlimited',899);
INSERT INTO subscribers VALUES (1,'Arun','Chennai',2,1),(2,'Bala','Coimbatore',5,2),(3,'Charu','Chennai',10,3),(4,'Devi','Madurai',3,1);
INSERT INTO call_records VALUES (1,1,'2026-10-01 10:00:00',12),(2,1,'2026-10-02 11:00:00',8),(3,2,'2026-10-03 12:00:00',25),(4,3,'2026-10-05 09:00:00',40),(5,2,'2026-11-01 14:00:00',15);
INSERT INTO invoices VALUES (1,1,'INV-2026-001','2026-10-01','2026-10-16',399,'2026-10-10'),(2,2,'INV-2026-002','2026-10-01','2026-10-16',599,NULL),(3,3,'INV-2026-003','2026-10-01','2026-10-16',899,'2026-10-14'),(4,4,'INV-2026-004','2026-11-01','2026-11-16',399,NULL);
INSERT INTO data_usage VALUES (1,1,'2026-10-01',1.2),(2,1,'2026-10-02',1.1),(3,2,'2026-10-01',3.5),(4,2,'2026-10-02',2.0),(5,3,'2026-10-01',4.0);
-- 1 Call minutes by plan
SELECT p.plan_name,ROUND(SUM(cr.duration_minutes),2) total_call_minutes FROM plans p JOIN subscribers s ON s.plan_id=p.plan_id JOIN call_records cr ON cr.subscriber_id=s.subscriber_id GROUP BY p.plan_id,p.plan_name;
-- 2 Data limit overruns
SELECT s.subscriber_id,s.subscriber_name,s.data_limit_gb,ROUND(SUM(du.data_used_gb),2) used_gb FROM subscribers s JOIN data_usage du ON du.subscriber_id=s.subscriber_id GROUP BY s.subscriber_id,s.subscriber_name,s.data_limit_gb HAVING SUM(du.data_used_gb)>s.data_limit_gb;
-- 3 Monthly billed revenue
SELECT DATE_FORMAT(invoice_date,'%Y-%m') revenue_month,ROUND(SUM(amount),2) billed_revenue FROM invoices GROUP BY DATE_FORMAT(invoice_date,'%Y-%m') ORDER BY revenue_month;
-- 4 Unpaid invoices overdue >15 days
SELECT invoice_id,CONCAT('INVOICE-',SUBSTRING(invoice_number,-3)) display_invoice,due_date,DATEDIFF(CURRENT_DATE(),due_date) days_overdue FROM invoices WHERE paid_date IS NULL AND DATEDIFF(CURRENT_DATE(),due_date)>15;
-- 5 Subscribers without data usage
SELECT s.subscriber_id,s.subscriber_name FROM subscribers s LEFT JOIN data_usage du ON du.subscriber_id=s.subscriber_id WHERE du.usage_id IS NULL;
-- 6 ARPU by circle
SELECT s.circle,ROUND(SUM(i.amount)/COUNT(DISTINCT s.subscriber_id),2) arpu FROM subscribers s LEFT JOIN invoices i ON i.subscriber_id=s.subscriber_id GROUP BY s.circle;
-- 7 Plan popularity
SELECT p.plan_name,COUNT(s.subscriber_id) subscriber_count FROM plans p LEFT JOIN subscribers s ON s.plan_id=p.plan_id GROUP BY p.plan_id,p.plan_name ORDER BY subscriber_count DESC;
-- 8 Top data consumers
SELECT s.subscriber_id,s.subscriber_name,ROUND(SUM(du.data_used_gb),2) total_data_gb FROM subscribers s JOIN data_usage du ON du.subscriber_id=s.subscriber_id GROUP BY s.subscriber_id,s.subscriber_name ORDER BY total_data_gb DESC LIMIT 10;
-- NULL handling
SELECT s.subscriber_id,SUM(du.data_used_gb) raw_sum,AVG(du.data_used_gb) raw_average,COALESCE(SUM(du.data_used_gb),0) sum_with_zero,COALESCE(AVG(du.data_used_gb),0) average_with_zero FROM subscribers s LEFT JOIN data_usage du ON du.subscriber_id=s.subscriber_id GROUP BY s.subscriber_id;
-- Revenue by plan and circle
SELECT p.plan_name,s.circle,ROUND(SUM(i.amount),2) revenue FROM plans p JOIN subscribers s ON s.plan_id=p.plan_id JOIN invoices i ON i.subscriber_id=s.subscriber_id GROUP BY p.plan_id,p.plan_name,s.circle;
