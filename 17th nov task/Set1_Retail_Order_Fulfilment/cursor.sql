USE day9_retail;
DELIMITER $$
CREATE PROCEDURE sp_create_old_order_followups()
BEGIN
 DECLARE v_done BOOLEAN DEFAULT FALSE; DECLARE v_order_id BIGINT;
 DECLARE cur CURSOR FOR SELECT order_id FROM orders WHERE status='PENDING' AND order_date<NOW()-INTERVAL 3 DAY;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
 OPEN cur;
 read_loop: LOOP
  FETCH cur INTO v_order_id; IF v_done THEN LEAVE read_loop; END IF;
  INSERT INTO order_followups(order_id,note) VALUES(v_order_id,'Pending for more than three days');
 END LOOP;
 CLOSE cur;
END$$
CREATE PROCEDURE sp_validate_order(IN p_order_id BIGINT)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM orders WHERE order_id=p_order_id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid order number'; END IF;
 SELECT 'Order exists' AS result;
END$$
DELIMITER ;
-- Set-based equivalent:
INSERT INTO order_followups(order_id,note) SELECT order_id,'Pending for more than three days' FROM orders WHERE status='PENDING' AND order_date<NOW()-INTERVAL 3 DAY;
-- Example: CALL sp_validate_order(999999);