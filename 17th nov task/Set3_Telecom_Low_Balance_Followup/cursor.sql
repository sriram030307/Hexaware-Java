USE day9_telecom;
DELIMITER $$
CREATE PROCEDURE sp_notify_low_balance_cursor()
BEGIN
 DECLARE v_done BOOLEAN DEFAULT FALSE; DECLARE v_subscriber_id INT;
 DECLARE cur CURSOR FOR SELECT subscriber_id FROM subscribers WHERE subscriber_type='PREPAID' AND balance<50;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
 OPEN cur;
 notify_loop: LOOP
  FETCH cur INTO v_subscriber_id; IF v_done THEN LEAVE notify_loop; END IF;
  INSERT INTO subscriber_notifications(subscriber_id,message) VALUES(v_subscriber_id,'Your prepaid balance is below 50 units');
 END LOOP;
 CLOSE cur;
END$$
CREATE PROCEDURE sp_safe_recharge_check_demo(IN p_amount DECIMAL(10,2))
BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN SELECT 'Recharge operation failed; inspect the SQL error details' handled_error; RESIGNAL; END;
 IF p_amount<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Amount must be greater than zero'; END IF;
 SELECT 'Recharge amount accepted' AS result;
END$$
DELIMITER ;
-- Set-based equivalent; clear previous notifications before timing comparisons
INSERT INTO subscriber_notifications(subscriber_id,message)
SELECT subscriber_id,'Your prepaid balance is below 50 units' FROM subscribers WHERE subscriber_type='PREPAID' AND balance<50;
-- Examples: CALL sp_notify_low_balance_cursor(); CALL sp_safe_recharge_check_demo(-10);