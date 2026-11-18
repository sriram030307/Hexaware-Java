USE day9_retail;
DELIMITER $$
CREATE FUNCTION fn_order_total_with_tax(p_order_id BIGINT) RETURNS DECIMAL(12,2) READS SQL DATA
BEGIN
 DECLARE v_subtotal DECIMAL(12,2);
 SELECT COALESCE(SUM(quantity*unit_price),0) INTO v_subtotal FROM order_lines WHERE order_id=p_order_id;
 RETURN ROUND(v_subtotal*1.18,2);
END$$
CREATE PROCEDURE sp_place_order(IN p_customer_name VARCHAR(120),IN p_product_id INT,IN p_quantity INT,OUT p_order_number BIGINT)
BEGIN
 DECLARE v_stock INT DEFAULT NULL; DECLARE v_price DECIMAL(10,2); DECLARE v_order_id BIGINT;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 SET p_order_number=NULL;
 IF p_quantity<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quantity must be positive'; END IF;
 START TRANSACTION;
 SELECT stock_qty,selling_price INTO v_stock,v_price FROM products WHERE product_id=p_product_id FOR UPDATE;
 IF v_stock IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Product does not exist'; END IF;
 IF v_stock<p_quantity THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insufficient stock'; END IF;
 INSERT INTO orders(customer_name) VALUES(p_customer_name); SET v_order_id=LAST_INSERT_ID();
 INSERT INTO order_lines(order_id,product_id,quantity,unit_price) VALUES(v_order_id,p_product_id,p_quantity,v_price);
 UPDATE products SET stock_qty=stock_qty-p_quantity WHERE product_id=p_product_id;
 COMMIT; SET p_order_number=v_order_id;
END$$
DELIMITER ;
CALL sp_place_order('Asha',1,2,@new_order_no);
SELECT @new_order_no AS created_order_number,fn_order_total_with_tax(@new_order_no) AS total_with_tax;