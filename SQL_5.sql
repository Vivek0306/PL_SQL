CREATE TABLE Orders_2(
	Order_id INT PRIMARY KEY,
	Customer_id INT,
	Order_Date DATE,
	Total_Amount NUMERIC(10, 2),
	Discounted_Amount NUMERIC(10, 2)
);

INSERT INTO Orders_2 (Order_id, Customer_id, Order_Date, Total_Amount)
VALUES (1, 101, '2024-11-25', 700);

INSERT INTO Orders_2 (Order_id, Customer_id, Order_Date, Total_Amount)
VALUES (2, 102, '2024-11-20', 300);


INSERT INTO Orders_2 (Order_id, Customer_id, Order_Date, Total_Amount)
VALUES (3, 103, '2024-11-25', 200);


INSERT INTO Orders_2 (Order_id, Customer_id, Order_Date, Total_Amount)
VALUES (4, 104, '2024-11-20', 499.99);


INSERT INTO Orders_2 (Order_id, Customer_id, Order_Date, Total_Amount)
VALUES (5, 105, '2024-11-10', 199.99);

select * from Orders_2


-- PROCEDURE PART
CREATE OR REPLACE FUNCTION Order_Discount()
RETURNS VOID AS $$
DECLARE
	order_count INT;
	order_no INT;
	discount NUMERIC(10, 2);
	total_amt NUMERIC(10, 2);
BEGIN
	SELECT COUNT(*) INTO order_count FROM Orders_2;
	order_no := 1;
	WHILE order_no <= order_count
	LOOP
		SELECT Total_Amount into total_amt FROM Orders_2 WHERE Order_id=order_no;
		
		UPDATE Orders_2
		SET Discounted_Amount = 
			CASE
				WHEN total_amt >= 500 THEN total_amt - 0.2 * total_amt
				WHEN total_amt BETWEEN 200 AND 499.99 THEN total_amt - 0.1 * total_amt
				WHEN total_amt < 200 THEN total_amt
			END
		WHERE Order_id = order_no;
		
		order_no := order_no + 1;
		
	END LOOP;
END;
$$ LANGUAGE plpgsql

SELECT Order_Discount();

select * from Orders_2