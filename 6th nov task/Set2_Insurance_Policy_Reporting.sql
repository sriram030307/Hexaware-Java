-- Day 6 Set 2: Insurance Policy Reporting
CREATE DATABASE IF NOT EXISTS day6_insurance; USE day6_insurance;
CREATE TABLE customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(100),date_of_birth DATE);
CREATE TABLE agents(agent_id INT PRIMARY KEY,agent_name VARCHAR(100));
CREATE TABLE products(product_id INT PRIMARY KEY,product_name VARCHAR(100));
CREATE TABLE policies(policy_id INT PRIMARY KEY,policy_number VARCHAR(30),customer_id INT,product_id INT,agent_id INT,start_date DATE,end_date DATE,premium_amount DECIMAL(10,2),status VARCHAR(20),FOREIGN KEY(customer_id) REFERENCES customers(customer_id),FOREIGN KEY(product_id) REFERENCES products(product_id),FOREIGN KEY(agent_id) REFERENCES agents(agent_id));
CREATE TABLE claims(claim_id INT PRIMARY KEY,policy_id INT,claim_amount DECIMAL(10,2),claim_date DATE,FOREIGN KEY(policy_id) REFERENCES policies(policy_id));
INSERT INTO customers VALUES (1,'Asha Menon','1988-04-12'),(2,'Rahul Das','1975-08-21'),(3,'Nila Joseph','1998-11-02'),(4,'Vikram Rao','1965-02-14');
INSERT INTO agents VALUES (1,'Priya Agent'),(2,'Sanjay Agent'),(3,'Farah Agent');
INSERT INTO products VALUES (1,'Health'),(2,'Life'),(3,'Motor');
INSERT INTO policies VALUES (101,'POL-2026-001',1,1,1,'2025-12-01','2026-12-01',18000,'ACTIVE'),(102,'POL-2026-002',1,2,1,'2026-01-10','2027-01-10',25000,'ACTIVE'),(103,'POL-2026-003',2,1,2,'2026-02-01','2026-11-25',22000,'ACTIVE'),(104,'POL-2026-004',3,3,3,'2026-03-15','2027-03-15',12000,'ACTIVE'),(105,'POL-2026-005',4,2,2,'2024-06-01','2025-06-01',30000,'EXPIRED');
INSERT INTO claims VALUES (1,101,9000,'2026-05-01'),(2,103,15000,'2026-07-10'),(3,104,2000,'2026-08-15');
-- 1 Expiring within 30 days
SELECT policy_id,CONCAT('***',SUBSTRING(policy_number,-4)) masked_policy,end_date,DATEDIFF(end_date,CURRENT_DATE()) days_to_expiry FROM policies WHERE end_date BETWEEN CURRENT_DATE() AND DATE_ADD(CURRENT_DATE(),INTERVAL 30 DAY) AND status='ACTIVE';
-- 2 Premium by product
SELECT pr.product_name,ROUND(SUM(p.premium_amount),2) total_premium FROM products pr JOIN policies p ON p.product_id=pr.product_id GROUP BY pr.product_id,pr.product_name;
-- 3 Customers with multiple active policies
SELECT c.customer_id,c.customer_name,COUNT(*) active_policy_count FROM customers c JOIN policies p ON p.customer_id=c.customer_id WHERE p.status='ACTIVE' GROUP BY c.customer_id,c.customer_name HAVING COUNT(*)>1;
-- 4 Claim ratio by product (preaggregate claims)
SELECT pr.product_name,ROUND(100*SUM(COALESCE(pc.claim_total,0))/NULLIF(SUM(p.premium_amount),0),2) claim_ratio_percent FROM products pr JOIN policies p ON p.product_id=pr.product_id LEFT JOIN (SELECT policy_id,SUM(claim_amount) claim_total FROM claims GROUP BY policy_id) pc ON pc.policy_id=p.policy_id GROUP BY pr.product_id,pr.product_name;
-- 5 Policies without claims
SELECT p.policy_id,p.policy_number FROM policies p LEFT JOIN claims cl ON cl.policy_id=p.policy_id WHERE cl.claim_id IS NULL;
-- 6 Average premium by age band
SELECT CASE WHEN TIMESTAMPDIFF(YEAR,c.date_of_birth,CURRENT_DATE())<30 THEN 'Under 30' WHEN TIMESTAMPDIFF(YEAR,c.date_of_birth,CURRENT_DATE())<45 THEN '30-44' WHEN TIMESTAMPDIFF(YEAR,c.date_of_birth,CURRENT_DATE())<60 THEN '45-59' ELSE '60+' END age_band,ROUND(AVG(p.premium_amount),2) average_premium FROM customers c JOIN policies p ON p.customer_id=c.customer_id GROUP BY age_band;
-- 7 Monthly policies
SELECT DATE_FORMAT(start_date,'%Y-%m') policy_month,COUNT(*) new_policies FROM policies GROUP BY DATE_FORMAT(start_date,'%Y-%m') ORDER BY policy_month;
-- 8 Top agents
SELECT a.agent_id,UPPER(a.agent_name) agent_name,ROUND(SUM(p.premium_amount),2) premium_sold FROM agents a JOIN policies p ON p.agent_id=a.agent_id GROUP BY a.agent_id,a.agent_name ORDER BY premium_sold DESC LIMIT 5;
-- Products with claim ratio >60%
SELECT pr.product_name,ROUND(100*SUM(COALESCE(pc.claim_total,0))/NULLIF(SUM(p.premium_amount),0),2) ratio_percent FROM products pr JOIN policies p ON p.product_id=pr.product_id LEFT JOIN (SELECT policy_id,SUM(claim_amount) claim_total FROM claims GROUP BY policy_id) pc ON pc.policy_id=p.policy_id GROUP BY pr.product_id,pr.product_name HAVING SUM(COALESCE(pc.claim_total,0))/NULLIF(SUM(p.premium_amount),0)>0.60;
-- CROSS JOIN product x reporting years
SELECT pr.product_name,yr.report_year FROM products pr CROSS JOIN (SELECT 2025 report_year UNION ALL SELECT 2026) yr;
