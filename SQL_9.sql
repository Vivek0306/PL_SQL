CREATE TABLE Orders_3 (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE Order_Items (
    order_id INT,
    item_id INT,
    quantity INT,
    PRIMARY KEY (order_id, item_id)
);

CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock_level INT,
    price NUMERIC(10, 2)
);

CREATE TABLE Order_Logs (
    log_id INT PRIMARY KEY,
    order_id INT,
    log_message VARCHAR(255),
    log_date DATE
);

CREATE SEQUENCE order_logs_seq
START WITH 1
INCREMENT BY 1
NO CYCLE;


-- Creation of Procedure Part
CREATE OR REPLACE FUNCTION Process_Customer_Order(p_order_id INT)
RETURNS VOID as $$
DECLARE
	rec RECORD;
	p_item_id INT;
	p_quantity INT;
	p_stock_level INT;
	p_price NUMERIC(10, 2);
	p_total_price NUMERIC(10, 2) := 0;
	p_order_exists BOOLEAN;
BEGIN
	SELECT EXISTS (SELECT 1 FROM Orders_3 WHERE Order_Id = p_order_id)
	INTO p_order_exists;
	
	IF NOT p_order_exists THEN
	 RAISE EXCEPTION 'Invalid Order ID: %', p_order_id;
	END IF;
	
	FOR rec in (SELECT * FROM Order_Items WHERE order_id = p_order_id)
	LOOP
		p_item_id:= rec.item_id;
		p_quantity := rec.quantity;
		
		SELECT stock_level, price into p_stock_level, p_price 
		FROM Inventory 
		WHERE item_id = p_item_id;
		
		IF p_stock_level < p_quantity THEN
			RAISE EXCEPTION 'Insufficient stock for item ID: %', p_item_id;
		END IF;
		
		UPDATE Inventory
		SET stock_level = stock_level - p_quantity
		WHERE item_id = p_item_id;
		
		p_total_price := p_total_price + (p_quantity * p_price);
	END LOOP;
	
	INSERT INTO Order_Logs VALUES(
		NEXTVAL('order_logs_seq'),
		p_order_id,
		'Order processed successfully. Total Value: ' || p_total_price,
		CURRENT_DATE
	);
	
	RAISE NOTICE 'Order processed successfully. Total Value: %', p_total_price;
	
	EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO order_logs
        VALUES (NEXTVAL('order_logs_seq'), p_order_id, 'Error processing order: ' || SQLERRM, CURRENT_DATE);
        RAISE NOTICE 'Error processing order ID %: %', p_order_id, SQLERRM;
	
END;
$$ LANGUAGE plpgsql;

-- Inserting sample orders
INSERT INTO orders_3 VALUES (1, 1, CURRENT_DATE);
INSERT INTO orders_3 VALUES (2, 2, CURRENT_DATE);


-- Inserting sample order items
INSERT INTO order_items (order_id, item_id, quantity) VALUES (1, 101, 2);
INSERT INTO order_items (order_id, item_id, quantity) VALUES (1, 102, 1);
INSERT INTO order_items (order_id, item_id, quantity) VALUES (2, 101, 5);
INSERT INTO order_items (order_id, item_id, quantity) VALUES (2, 102, 3);


-- Inserting sample inventory
INSERT INTO inventory (item_id, item_name, stock_level, price) VALUES (101, 'Item A', 10, 20.00);
INSERT INTO inventory (item_id, item_name, stock_level, price) VALUES (102, 'Item B', 5, 15.00);


SELECT * FROM Orders_3;
SELECT * FROM Order_Items;
SELECT * FROM Inventory;


SELECT Process_Customer_Order(2);
SELECT * FROM Order_Logs;