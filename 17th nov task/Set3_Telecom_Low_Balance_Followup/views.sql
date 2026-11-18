USE day9_telecom;
CREATE OR REPLACE VIEW vw_prepaid_subscribers AS
SELECT subscriber_id,subscriber_name,balance,plan_name,validity_end FROM subscribers WHERE subscriber_type='PREPAID';
CREATE OR REPLACE VIEW vw_recharge_summary AS
SELECT s.subscriber_id,s.subscriber_name,COUNT(r.recharge_id) recharge_count,COALESCE(SUM(r.amount),0) total_recharged,MAX(r.recharged_at) last_recharge
FROM subscribers s LEFT JOIN recharge_history r ON r.subscriber_id=s.subscriber_id
WHERE s.subscriber_type='PREPAID' GROUP BY s.subscriber_id,s.subscriber_name;