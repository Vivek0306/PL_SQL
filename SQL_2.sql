CREATE TABLE Orders(
	Order_id INT PRIMARY KEY,
	Customer_id INT,
	Order_Date DATE,
	Status VARCHAR(50),
	Total_Amount INT
);

-- FUNCTION TO CHANGE AND UPDATE PRODUCT STATUS BASED ON THE VALUES PROVIDED
CREATE OR REPLACE FUNCTION Order_Status_Update(
    P_Order_id INT,
    Payment_Received BOOLEAN,
    Shipment_Made BOOLEAN,
    Delivery_Confirmed BOOLEAN
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    Current_Status VARCHAR(50);
    P_Order_Date DATE;
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE Order_id = P_Order_id) THEN
        RAISE NOTICE 'Order with ID % does not exist.', Order_id;
        RETURN;
    END IF;
    
    SELECT Status, Order_date INTO Current_Status, P_Order_Date FROM Orders WHERE Order_id = P_Order_id;
    
    IF Current_Status = 'Pending' AND Payment_Received THEN
        UPDATE Orders SET Status = 'Processed' WHERE Order_id = P_Order_id;
        RAISE NOTICE 'Order status updated to Processed.';
        
    ELSIF Current_Status = 'Processed' AND Shipment_Made THEN
        UPDATE Orders SET Status = 'Shipped' WHERE Order_id = P_Order_id;
        RAISE NOTICE 'Order status updated to Shipped.';
    
    ELSIF Current_Status = 'Shipped' AND Delivery_Confirmed THEN
        UPDATE Orders SET Status = 'Delivered' WHERE Order_id = P_Order_id;
        RAISE NOTICE 'Order status updated to Delivered.';
        
    ELSIF Current_Status = 'Pending' AND CURRENT_DATE - P_Order_Date > 7 THEN
        UPDATE Orders SET Status = 'Cancelled' WHERE Order_id = P_Order_id;
        RAISE NOTICE 'Order status updated to Cancelled due to overdue.';
        
    ELSE
        RAISE NOTICE 'No Status Change Required for Order %.', P_Order_id;
    END IF;
END;
$$;

-- INSERT QUERIES
INSERT INTO Orders (Order_id, Customer_id, Order_Date, Status, Total_Amount)
VALUES (1, 101, '2024-11-25', 'Pending', 1500);

INSERT INTO Orders (Order_id, Customer_id, Order_Date, Status, Total_Amount)
VALUES (2, 102, '2024-11-24', 'Processed', 2500);

INSERT INTO Orders (Order_id, Customer_id, Order_Date, Status, Total_Amount)
VALUES (3, 103, '2024-11-23', 'Shipped', 2000);

INSERT INTO Orders (Order_id, Customer_id, Order_Date, Status, Total_Amount)
VALUES (4, 104, '2024-11-21', 'Delivered', 3000);

INSERT INTO Orders (Order_id, Customer_id, Order_Date, Status, Total_Amount)
VALUES (5, 105, '2024-11-25', 'Pending', 1200);

INSERT INTO Orders (Order_id, Customer_id, Order_Date, Status, Total_Amount)
VALUES (6, 106, '2024-11-10', 'Pending', 1800);

-- Operations
SELECT Order_Status_Update(1, TRUE, FALSE, FALSE) -- Status changed to Processed
SELECT Order_Status_Update(1, TRUE, TRUE, FALSE) -- Status changed to Shipped
SELECT Order_Status_Update(1, TRUE, TRUE, TRUE) -- Status changed to Processed
SELECT Order_Status_Update(6, FALSE, FALSE, FALSE)

-- Viewing the orders
SELECT * FROM Orders;