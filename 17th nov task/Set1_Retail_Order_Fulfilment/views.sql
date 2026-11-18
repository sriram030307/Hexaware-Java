USE day9_retail;
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT o.order_id,o.customer_name,o.order_date,o.status,SUM(ol.quantity*ol.unit_price) order_total
FROM orders o LEFT JOIN order_lines ol ON ol.order_id=o.order_id
GROUP BY o.order_id,o.customer_name,o.order_date,o.status;
CREATE OR REPLACE VIEW vw_low_stock AS
SELECT product_id,product_name,selling_price,stock_qty FROM products WHERE stock_qty<10;
CREATE OR REPLACE VIEW vw_products_for_restock AS
SELECT product_id,product_name,selling_price,stock_qty FROM products WHERE stock_qty<10 WITH CHECK OPTION;
UPDATE vw_products_for_restock SET stock_qty=9 WHERE product_id=2;