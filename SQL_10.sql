SELECT * FROM Employee_4;


CREATE OR REPLACE FUNCTION update_employee_salary(
    emp_id INT, 
    new_salary NUMERIC
) RETURNS VOID AS
$$
DECLARE
    v_current_salary NUMERIC;
	min_salary_threshold NUMERIC;
BEGIN
    SELECT salary 
    INTO v_current_salary
    FROM Employee_4 
    WHERE employee_id = emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Error: Employee with ID % not found.', emp_id;
    END IF;

    IF new_salary < min_salary_threshold THEN
        RAISE EXCEPTION 'Error: The new salary % is below the minimum allowed threshold of %.', new_salary, min_salary_threshold;
    END IF;

    UPDATE Employee_4
    SET salary = new_salary
    WHERE employee_id = emp_id;

    RAISE NOTICE 'Employee salary updated successfully to %.', new_salary;

END;
$$ LANGUAGE plpgsql;


SELECT update_employee_salary(4, 55000);
SELECT update_employee_salary(8, 55000);