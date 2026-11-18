USE day9_insurance;
DELIMITER $$
CREATE PROCEDURE sp_mark_lapsed_cursor(INOUT p_processed INT)
BEGIN
 DECLARE v_done BOOLEAN DEFAULT FALSE; DECLARE v_policy_id INT;
 DECLARE cur CURSOR FOR SELECT policy_id FROM policies WHERE status='ACTIVE' AND renewal_date<CURDATE();
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done=TRUE;
 OPEN cur;
 lapse_loop: LOOP
  FETCH cur INTO v_policy_id; IF v_done THEN LEAVE lapse_loop; END IF;
  UPDATE policies SET status='LAPSED' WHERE policy_id=v_policy_id;
  INSERT INTO policy_lapse_log(policy_id,message) VALUES(v_policy_id,'Policy marked LAPSED by renewal check');
  SET p_processed=p_processed+1;
 END LOOP;
 CLOSE cur;
END$$
DELIMITER ;
-- Set-based equivalent: run instead of cursor version for production
START TRANSACTION;
INSERT INTO policy_lapse_log(policy_id,message) SELECT policy_id,'Policy marked LAPSED by renewal check' FROM policies WHERE status='ACTIVE' AND renewal_date<CURDATE();
UPDATE policies SET status='LAPSED' WHERE status='ACTIVE' AND renewal_date<CURDATE();
COMMIT;
SET @processed=0; CALL sp_mark_lapsed_cursor(@processed); SELECT @processed AS policies_processed;