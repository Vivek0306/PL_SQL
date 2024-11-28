CREATE TABLE EMPLOYEES (
    Employee_id NUMBER PRIMARY KEY,
    First_Name VARCHAR2(100),
    Last_Name VARCHAR2(100),
    Hire_date DATE,
    Salary NUMBER(10, 2),
    Department_id NUMBER
);


-- Create the package specification
CREATE OR REPLACE PACKAGE employee_mgmt_pkg AS
    -- Procedure to add a new employee
    PROCEDURE add_employee(
        p_employee_id IN EMPLOYEES.Employee_id%TYPE,
        p_first_name IN EMPLOYEES.First_Name%TYPE,
        p_last_name IN EMPLOYEES.Last_Name%TYPE,
        p_hire_date IN EMPLOYEES.Hire_date%TYPE,
        p_salary IN EMPLOYEES.Salary%TYPE,
        p_department_id IN EMPLOYEES.Department_id%TYPE
    );

    -- Procedure to update employee salary
    PROCEDURE update_employee(
        p_employee_id IN EMPLOYEES.Employee_id%TYPE,
        p_salary IN EMPLOYEES.Salary%TYPE
    );

    -- Function to retrieve employee details
    FUNCTION get_employee_details(
        p_employee_id IN EMPLOYEES.Employee_id%TYPE
    ) RETURN EMPLOYEES%ROWTYPE;
END employee_mgmt_pkg;
/


-- Create the package body
CREATE OR REPLACE PACKAGE BODY employee_mgmt_pkg AS

    -- Procedure to add a new employee
    PROCEDURE add_employee(
        p_employee_id IN EMPLOYEES.Employee_id%TYPE,
        p_first_name IN EMPLOYEES.First_Name%TYPE,
        p_last_name IN EMPLOYEES.Last_Name%TYPE,
        p_hire_date IN EMPLOYEES.Hire_date%TYPE,
        p_salary IN EMPLOYEES.Salary%TYPE,
        p_department_id IN EMPLOYEES.Department_id%TYPE
    ) IS
    BEGIN
        INSERT INTO EMPLOYEES
        VALUES (p_employee_id, p_first_name, p_last_name, p_hire_date, p_salary, p_department_id);
        DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
    END add_employee;

    -- Procedure to update employee salary
    PROCEDURE update_employee(
        p_employee_id IN EMPLOYEES.Employee_id%TYPE,
        p_salary IN EMPLOYEES.Salary%TYPE
    ) IS
    BEGIN
        UPDATE EMPLOYEES
        SET Salary = p_salary
        WHERE Employee_id = p_employee_id;

        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with the given ID.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Employee salary updated successfully.');
        END IF;
    END update_employee;

    -- Function to retrieve employee details
    FUNCTION get_employee_details(
        p_employee_id IN EMPLOYEES.Employee_id%TYPE
    ) RETURN EMPLOYEES%ROWTYPE IS
        v_employee EMPLOYEES%ROWTYPE;
    BEGIN
        SELECT *
        INTO v_employee
        FROM EMPLOYEES
        WHERE Employee_id = p_employee_id;

        RETURN v_employee;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with the given ID.');
            RETURN NULL;
    END get_employee_details;

END employee_mgmt_pkg;
/

BEGIN
    employee_mgmt_pkg.add_employee(101, 'John', 'Doe', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 50000, 10);
    employee_mgmt_pkg.add_employee(102, 'Jane', 'Smith', TO_DATE('2023-03-10', 'YYYY-MM-DD'), 60000, 20);
    employee_mgmt_pkg.add_employee(103, 'Josh', 'Peralta', TO_DATE('2023-02-22', 'YYYY-MM-DD'), 90000, 10);
    employee_mgmt_pkg.add_employee(104, 'Jimmy', 'Neutron', TO_DATE('2023-06-03', 'YYYY-MM-DD'), 55500, 10);
END;
/

BEGIN
    employee_mgmt_pkg.update_employee(101, 55000);
END;
/

DECLARE
    emp_details EMPLOYEES%ROWTYPE;
BEGIN
    emp_details := employee_mgmt_pkg.get_employee_details(101);
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_details.First_Name || ' ' || emp_details.Last_Name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || emp_details.Salary);
END;
/
