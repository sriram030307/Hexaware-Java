USE day9_insurance;
DELIMITER $$
CREATE FUNCTION fn_premium_with_no_claim_discount(p_base_premium DECIMAL(10,2),p_no_claim_years INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
 DECLARE v_discount DECIMAL(5,2) DEFAULT 0;
 IF p_no_claim_years>=5 THEN SET v_discount=0.25;
 ELSEIF p_no_claim_years>=3 THEN SET v_discount=0.15;
 ELSEIF p_no_claim_years>=1 THEN SET v_discount=0.05; END IF;
 RETURN ROUND(p_base_premium*(1-v_discount),2);
END$$
CREATE PROCEDURE sp_renew_policy(IN p_policy_id INT)
BEGIN
 DECLARE v_status VARCHAR(20) DEFAULT NULL; DECLARE v_old_premium DECIMAL(10,2); DECLARE v_years INT; DECLARE v_new_premium DECIMAL(10,2);
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 SELECT status,premium,no_claim_years INTO v_status,v_old_premium,v_years FROM policies WHERE policy_id=p_policy_id FOR UPDATE;
 IF v_status IS NULL OR v_status<>'ACTIVE' THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Policy is not active or does not exist'; END IF;
 IF EXISTS(SELECT 1 FROM claims WHERE policy_id=p_policy_id AND claim_status='PENDING') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Policy has a pending claim'; END IF;
 SET v_new_premium=fn_premium_with_no_claim_discount(v_old_premium,v_years);
 UPDATE policies SET premium=v_new_premium,renewal_date=renewal_date+INTERVAL 1 YEAR WHERE policy_id=p_policy_id;
 INSERT INTO policy_audit(policy_id,action_name,old_premium,new_premium) VALUES(p_policy_id,'RENEWAL',v_old_premium,v_new_premium);
 COMMIT;
END$$
DELIMITER ;
SELECT policy_id,premium,no_claim_years,fn_premium_with_no_claim_discount(premium,no_claim_years) discounted_premium FROM policies;
-- Example: CALL sp_renew_policy(1);