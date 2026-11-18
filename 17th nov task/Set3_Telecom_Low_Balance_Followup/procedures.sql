USE day9_telecom;
DELIMITER $$
CREATE FUNCTION fn_validity_days_left(p_validity_end DATE) RETURNS INT DETERMINISTIC
BEGIN RETURN GREATEST(DATEDIFF(p_validity_end,CURDATE()),0); END$$
CREATE PROCEDURE sp_recharge(IN p_subscriber_id INT,IN p_amount DECIMAL(10,2),IN p_plan_name VARCHAR(50),OUT p_new_balance DECIMAL(10,2))
BEGIN
 DECLARE v_balance DECIMAL(10,2) DEFAULT NULL; DECLARE v_type VARCHAR(20);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 SET p_new_balance=NULL;
 IF p_amount<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Recharge amount must be positive'; END IF;
 IF p_plan_name NOT IN('BASIC','DATA','UNLIMITED') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid recharge plan'; END IF;
 START TRANSACTION;
 SELECT balance,subscriber_type INTO v_balance,v_type FROM subscribers WHERE subscriber_id=p_subscriber_id FOR UPDATE;
 IF v_type IS NULL OR v_type<>'PREPAID' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Prepaid subscriber not found'; END IF;
 SET p_new_balance=v_balance+p_amount;
 UPDATE subscribers SET balance=p_new_balance,plan_name=p_plan_name,validity_end=GREATEST(validity_end,CURDATE())+INTERVAL 30 DAY WHERE subscriber_id=p_subscriber_id;
 INSERT INTO recharge_history(subscriber_id,amount,plan_name,balance_after) VALUES(p_subscriber_id,p_amount,p_plan_name,p_new_balance);
 COMMIT;
END$$
CREATE PROCEDURE sp_safe_recharge_check(IN p_amount DECIMAL(10,2))
BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN SELECT 'Recharge operation failed; inspect the SQL error details' handled_error; RESIGNAL; END;
 IF p_amount<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Amount must be greater than zero'; END IF;
 SELECT 'Recharge amount accepted' AS result;
END$$
DELIMITER ;
SELECT subscriber_id,subscriber_name,fn_validity_days_left(validity_end) days_left FROM vw_prepaid_subscribers;
-- CALL sp_recharge(1,100,'BASIC',@balance_after); SELECT @balance_after;
-- CALL sp_safe_recharge_check(-10);