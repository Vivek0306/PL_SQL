CREATE TABLE ORDERS (
    ORDER_ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER NOT NULL,
    ORDER_DATE DATE NOT NULL
);

CREATE TABLE ORDER_LINES (
    ORDER_LINE_ID NUMBER PRIMARY KEY,
    ORDER_ID NUMBER NOT NULL,
    PRODUCT_ID NUMBER NOT NULL,
    QUANTITY NUMBER NOT NULL,
    UNIT_PRICE NUMBER(10, 2) NOT NULL
);

-- Create the package specification
CREATE OR REPLACE PACKAGE order_mgmt AS
    PROCEDURE create_order(
        p_customer_id IN NUMBER,
        p_order_date IN DATE,
        p_order_items IN SYS_REFCURSOR
    );

    FUNCTION calculate_order_total(
        p_order_id IN NUMBER
    ) RETURN NUMBER;
END order_mgmt;
/

-- Create the package body
CREATE OR REPLACE PACKAGE BODY order_mgmt AS

    -- Procedure to create a new order
    PROCEDURE create_order(
        p_customer_id IN NUMBER,
        p_order_date IN DATE,
        p_order_items IN SYS_REFCURSOR
    ) IS
        v_order_id NUMBER;
        v_product_id NUMBER;
        v_quantity NUMBER;
        v_unit_price NUMBER;
        v_order_line_id NUMBER := 1; -- Order Line ID counter

    BEGIN
        -- Generate a new order ID (using a sequence or max + 1)
        SELECT NVL(MAX(ORDER_ID), 0) + 1 INTO v_order_id FROM ORDERS;

        INSERT INTO ORDERS (ORDER_ID, CUSTOMER_ID, ORDER_DATE)
        VALUES (v_order_id, p_customer_id, p_order_date);

        LOOP
            FETCH p_order_items INTO v_product_id, v_quantity, v_unit_price;
            EXIT WHEN p_order_items%NOTFOUND;

            INSERT INTO ORDER_LINES (ORDER_LINE_ID, ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE)
            VALUES (v_order_line_id, v_order_id, v_product_id, v_quantity, v_unit_price);

            v_order_line_id := v_order_line_id + 1;
        END LOOP;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Order created successfully with Order ID: ' || v_order_id);

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20001, 'Error occurred while creating the order: ' || SQLERRM);
    END create_order;

    FUNCTION calculate_order_total(
        p_order_id IN NUMBER
    ) RETURN NUMBER IS
        v_total_amount NUMBER := 0;
    BEGIN
        SELECT SUM(QUANTITY * UNIT_PRICE)
        INTO v_total_amount
        FROM ORDER_LINES
        WHERE ORDER_ID = p_order_id;

        RETURN NVL(v_total_amount, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error calculating order total: ' || SQLERRM);
    END calculate_order_total;

END order_mgmt;
/



-- USING THE FUNCTIONS

DECLARE
    v_order_items SYS_REFCURSOR;
BEGIN
    -- Open a cursor with order items data
    OPEN v_order_items FOR
        SELECT 101 AS PRODUCT_ID, 2 AS QUANTITY, 50 AS UNIT_PRICE FROM DUAL
        UNION ALL
        SELECT 102, 1, 100 FROM DUAL;

    -- Call the create_order procedure
    order_mgmt.create_order(
        p_customer_id => 123,
        p_order_date => SYSDATE,
        p_order_items => v_order_items
    );
END;
/


DECLARE
    v_total NUMBER;
BEGIN
    v_total := order_mgmt.calculate_order_total(1);
    DBMS_OUTPUT.PUT_LINE('Total Order Amount: ' || v_total);
END;
/
