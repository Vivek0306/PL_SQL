CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees_5 (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    salary NUMERIC
);


INSERT INTO departments (department_id, department_name) VALUES (1, 'Human Resources');
INSERT INTO departments (department_id, department_name) VALUES (2, 'Finance');
INSERT INTO departments (department_id, department_name) VALUES (3, 'IT');
INSERT INTO departments (department_id, department_name) VALUES (4, 'Marketing');
INSERT INTO departments (department_id, department_name) VALUES (5, 'Operations');


INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (1, 'Alice', 1, 60000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (2, 'Bob', 2, 75000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (3, 'Charlie', 3, 80000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (4, 'Diana', 4, 50000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (5, 'Ethan', 5, 70000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (6, 'Fiona', 3, 85000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (7, 'George', 2, 62000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (8, 'Hannah', 4, 58000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (9, 'Ian', 1, 63000);
INSERT INTO employees_5 (employee_id, name, department_id, salary) VALUES (10, 'Julia', 5, 69000);


DO $$
DECLARE
	rec RECORD;
	total_salary NUMERIC;
BEGIN
	FOR rec in (SELECT * FROM departments)
	LOOP
		SELECT COALESCE(SUM(salary), 0)
		INTO total_salary
		FROM employees_5
		WHERE department_id = rec.department_id;
		
		RAISE NOTICE 'Department: % -- Total Salary: %',rec.department_name, total_salary;
	END LOOP;
END;
$$ LANGUAGE plpgsql;





