-- Set 1: Bank statement with CTE, ROW_NUMBER and LAG
USE bank_day8;
WITH ledger AS (
 SELECT account_id,txn_id,txn_time,
        CASE WHEN from_id=account_id THEN -amount ELSE amount END delta
 FROM bank_txns JOIN (SELECT 1 account_id UNION SELECT 2) a
 ON account_id IN(from_id,to_id)
), balances AS (
 SELECT account_id,txn_id,txn_time,delta,
        10000+SUM(delta) OVER(PARTITION BY account_id ORDER BY txn_time,txn_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_balance,
        ROW_NUMBER() OVER(PARTITION BY account_id ORDER BY txn_time,txn_id) txn_no
 FROM ledger
)
SELECT account_id,txn_no,txn_time,delta,running_balance,
 LAG(running_balance) OVER(PARTITION BY account_id ORDER BY txn_time,txn_no) previous_balance
FROM balances ORDER BY account_id,txn_no;

-- Monthly net movement (adapt account list/opening balance as needed)
SELECT account_id,DATE_FORMAT(txn_time,'%Y-%m') txn_month,
 SUM(CASE WHEN from_id=account_id THEN -amount
          WHEN to_id=account_id THEN amount ELSE 0 END) net_change
FROM bank_txns JOIN (SELECT 1 account_id UNION SELECT 2) a
 ON account_id IN(from_id,to_id)
GROUP BY account_id,DATE_FORMAT(txn_time,'%Y-%m')
ORDER BY account_id,txn_month;
