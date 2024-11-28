-- Here we are referring to the Employee_3 and Performance_Rating Table for Bonus Calculation

SELECT * FROM Employees_3;
SELECT * FROM Performance_Rating;

CREATE OR REPLACE FUNCTION Employee_Bonus_Procedure() 
RETURNS VOID as $$
DECLARE
	rec RECORD;
	bonus DECIMAL(10, 2);
	emp_rating INT;
BEGIN
	FOR rec IN (SELECT * FROM Employees_3)
	LOOP
		bonus := rec.salary * (select bonus_percentage FROM Performance_Rating 
							   WHERE rating = rec.performance_rating)/100;
		RAISE NOTICE 'Employee: %	Salary: Rs. %	Bonus: Rs. %',rec.first_name,rec.salary,bonus;
	END LOOP;
END;
$$ LANGUAGE plpgsql


-- Calling the function with corresponding Employee ID whose bonus is to be found
SELECT * FROM Employee_Bonus_Procedure();