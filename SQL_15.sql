CREATE OR REPLACE FUNCTION Employee_Salary_Trigger()
RETURNS TRIGGER AS $$
DECLARE
	min_salary NUMERIC := 25000;
BEGIN
	IF NEW.Salary < min_salary THEN
		RAISE EXCEPTION 'New salary cannot be less than the minimum salary threshold!';
	ELSE
		IF TG_OP = 'INSERT' THEN
			INSERT INTO Employees_Audit (
            Employee_id, Operation, Change_date,
            Old_name, Old_position, Old_salary,
            New_name, New_position, New_salary
        ) VALUES (
            NEW.Employee_id,
            TG_OP,
            CURRENT_DATE,
            NULL, NULL, NULL,
            NEW.Name, NEW.Position, NEW.Salary
        );
		
		ELSIF TG_OP = 'UPDATE' THEN
			INSERT INTO Employees_Audit (
            Employee_id, Operation, Change_date,
            Old_name, Old_position, Old_salary,
            New_name, New_position, New_salary
        ) VALUES (
            NEW.Employee_id,
            TG_OP,
            CURRENT_DATE,
            OLD.Name, OLd.Position, OLD.Salary,
            NEW.Name, NEW.Position, NEW.Salary
        );
		
		END IF;
	END IF;
		
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


select * from employees;
select * from employees_audit;

UPDATE Employees SET Salary = 40000 WHERE employee_id = 2;
INSERT INTO Employees VALUES(4, 'Jake', 'IT', 200000);