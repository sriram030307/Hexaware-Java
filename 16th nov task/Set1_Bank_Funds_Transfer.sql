-- Set 1: Bank Funds Transfer | MySQL 8.4 | InnoDB
CREATE DATABASE IF NOT EXISTS bank_day8;
USE bank_day8;
CREATE TABLE IF NOT EXISTS accounts(account_id INT PRIMARY KEY,holder VARCHAR(80),
 balance DECIMAL(12,2) NOT NULL CHECK(balance>=0),
 status ENUM('ACTIVE','BLOCKED') NOT NULL) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS bank_txns(txn_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 from_id INT,to_id INT,amount DECIMAL(12,2),txn_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 description VARCHAR(100)) ENGINE=InnoDB;
INSERT IGNORE INTO accounts VALUES(1,'Asha',10000,'ACTIVE'),(2,'Bala',5000,'ACTIVE');

-- Successful transfer: validate rows/status/balance and ROW_COUNT() in client.
START TRANSACTION;
SELECT account_id,balance,status FROM accounts WHERE account_id IN(1,2)
 ORDER BY account_id FOR UPDATE;
UPDATE accounts SET balance=balance-1000 WHERE account_id=1 AND status='ACTIVE' AND balance>=1000;
-- If affected rows != 1, ROLLBACK in client.
UPDATE accounts SET balance=balance+1000 WHERE account_id=2 AND status='ACTIVE';
INSERT INTO bank_txns(from_id,to_id,amount,description) VALUES(1,2,1000,'Transfer');
COMMIT;

-- Rollback demonstration: execute this section separately.
START TRANSACTION;
SELECT account_id,balance FROM accounts WHERE account_id IN(1,2);
UPDATE accounts SET balance=balance-500 WHERE account_id=1 AND balance>=500;
UPDATE accounts SET balance=balance+500 WHERE account_id=999;
-- Destination update affects 0 rows; client detects this and runs:
ROLLBACK;
SELECT account_id,balance FROM accounts WHERE account_id IN(1,2);

-- SAVEPOINT: transfer stays; fee step is undone.
START TRANSACTION;
UPDATE accounts SET balance=balance-1000 WHERE account_id=1 AND balance>=1000;
UPDATE accounts SET balance=balance+1000 WHERE account_id=2;
INSERT INTO bank_txns(from_id,to_id,amount,description) VALUES(1,2,1000,'Transfer');
SAVEPOINT before_fee;
UPDATE accounts SET balance=balance-25 WHERE account_id=1;
ROLLBACK TO SAVEPOINT before_fee;
RELEASE SAVEPOINT before_fee;
COMMIT;
