USE day9_insurance;
CREATE OR REPLACE VIEW vw_policy_due AS
SELECT p.policy_id,c.customer_name,c.email,p.policy_type,p.renewal_date,p.premium,p.status
FROM policies p JOIN customers c ON c.customer_id=p.customer_id
WHERE p.renewal_date BETWEEN CURDATE() AND CURDATE()+INTERVAL 30 DAY;
-- Claim details are intentionally not exposed in this view.