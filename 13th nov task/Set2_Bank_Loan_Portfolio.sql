CREATE DATABASE IF NOT EXISTS bank_day7; USE bank_day7;
CREATE TABLE IF NOT EXISTS branches(branch_id INT PRIMARY KEY,branch_name VARCHAR(80)); CREATE TABLE IF NOT EXISTS customers(customer_id INT PRIMARY KEY,customer_name VARCHAR(80));
CREATE TABLE IF NOT EXISTS loans(loan_id INT PRIMARY KEY,customer_id INT,branch_id INT,loan_amount DECIMAL(12,2),installments_due INT,installments_paid INT,loan_date DATE,FOREIGN KEY(customer_id) REFERENCES customers(customer_id),FOREIGN KEY(branch_id) REFERENCES branches(branch_id));
CREATE TABLE IF NOT EXISTS repayments(repayment_id INT PRIMARY KEY,loan_id INT,repayment_date DATE,amount DECIMAL(10,2),FOREIGN KEY(loan_id) REFERENCES loans(loan_id));
CREATE TABLE IF NOT EXISTS guarantors(loan_id INT,guarantor_customer_id INT,PRIMARY KEY(loan_id,guarantor_customer_id),FOREIGN KEY(loan_id) REFERENCES loans(loan_id),FOREIGN KEY(guarantor_customer_id) REFERENCES customers(customer_id));
INSERT IGNORE INTO branches VALUES(1,'Central'),(2,'North'),(3,'South'); INSERT IGNORE INTO customers VALUES(1,'Ananya'),(2,'Bala'),(3,'Charan'),(4,'Deepa');
INSERT IGNORE INTO loans VALUES(201,1,1,500000,12,8,'2025-01-01'),(202,2,1,300000,10,10,'2025-03-01'),(203,1,2,200000,8,4,'2025-06-01'),(204,3,2,700000,15,12,'2025-02-01');
INSERT IGNORE INTO repayments VALUES(1,201,'2026-10-01',25000),(2,202,'2026-10-20',30000),(3,203,'2026-07-01',20000),(4,204,'2026-09-01',45000); INSERT IGNORE INTO guarantors VALUES(201,2),(202,1),(203,4),(204,2);
-- 1
SELECT l.loan_id,c.customer_name,b.branch_name,l.loan_amount FROM loans l JOIN customers c ON c.customer_id=l.customer_id JOIN branches b ON b.branch_id=l.branch_id;
-- 2
SELECT l.loan_id,c.customer_name,l.installments_due-l.installments_paid overdue FROM loans l JOIN customers c ON c.customer_id=l.customer_id WHERE l.installments_due-l.installments_paid>3;
-- 3
SELECT c.customer_name,COUNT(DISTINCT l.branch_id) branches FROM customers c JOIN loans l ON l.customer_id=c.customer_id GROUP BY c.customer_id,c.customer_name HAVING COUNT(DISTINCT l.branch_id)>1;
-- 4 guarantor is also borrower
SELECT DISTINCT c.customer_name FROM guarantors g JOIN customers c ON c.customer_id=g.guarantor_customer_id JOIN loans l ON l.customer_id=g.guarantor_customer_id;
-- 5
SELECT b.branch_name FROM branches b LEFT JOIN loans l ON l.branch_id=b.branch_id WHERE l.loan_id IS NULL;
-- 6 correlated branch average
SELECT c.customer_name,l.loan_amount FROM loans l JOIN customers c ON c.customer_id=l.customer_id WHERE l.loan_amount>(SELECT AVG(x.loan_amount) FROM loans x WHERE x.branch_id=l.branch_id);
-- 7 no repayment in last 60 days
SELECT DISTINCT c.customer_name FROM customers c JOIN loans l ON l.customer_id=c.customer_id WHERE NOT EXISTS(SELECT 1 FROM repayments r WHERE r.loan_id=l.loan_id AND r.repayment_date>=CURRENT_DATE-INTERVAL 60 DAY);
-- 8 exposure
SELECT c.customer_name,COALESCE(SUM(l.loan_amount),0) exposure FROM customers c LEFT JOIN loans l ON l.customer_id=c.customer_id GROUP BY c.customer_id,c.customer_name;
-- 9 nested branch maxima
SELECT b.branch_name,MAX(l.loan_amount) max_loan FROM branches b JOIN loans l ON l.branch_id=b.branch_id GROUP BY b.branch_id,b.branch_name HAVING MAX(l.loan_amount)>(SELECT AVG(m) FROM(SELECT MAX(loan_amount)m FROM loans GROUP BY branch_id)q);
-- 10 repayment totals
SELECT l.loan_id,COALESCE(SUM(r.amount),0) repaid FROM loans l LEFT JOIN repayments r ON r.loan_id=l.loan_id GROUP BY l.loan_id;
SELECT customer_name FROM customers WHERE customer_id IN(SELECT customer_id FROM loans);
SELECT branch_name FROM branches b WHERE EXISTS(SELECT 1 FROM loans l WHERE l.branch_id=b.branch_id);
SELECT loan_id FROM loans WHERE loan_amount>ANY(SELECT loan_amount FROM loans WHERE branch_id=1);
SELECT loan_id FROM loans WHERE loan_amount>ALL(SELECT loan_amount FROM loans WHERE branch_id=1);
