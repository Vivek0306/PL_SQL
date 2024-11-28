CREATE TABLE Employees_3(
	Employee_id INT PRIMARY KEY,
	First_Name VARCHAR(50),
	Last_Name VARCHAR(50),
	Salary NUMERIC(10, 2),
	Performance_Rating INT CHECK(Performance_Rating BETWEEN 1 AND 5)
);

CREATE TABLE Salary_Adjustments(
	Rating INT,
	Adjustment_Percentage INT
);

INSERT INTO Salary_Adjustments VALUES (5, 20), (4, 10), (3, 5), (2, 0), (1, -5);
SELECT * FROM Salary_Adjustments;

INSERT INTO Employees_3 VALUES(1, 'Vivek', 'Nair', 45000, 5);
INSERT INTO Employees_3 VALUES(2, 'Vinay', 'Nair', 15000, 1);
INSERT INTO Employees_3 VALUES(3, 'Jake', 'Paul', 6200, 4);
INSERT INTO Employees_3 VALUES(4, 'Logan', 'Paul', 68000, 3);
INSERT INTO Employees_3 VALUES(5, 'Linkin', 'Park', 32000, 2);
INSERT INTO Employees_3 VALUES(6, 'Bruno', 'Mars', 73000, 1);
INSERT INTO Employees_3 VALUES(7, 'John', 'Doe', 85000, 4);
INSERT INTO Employees_3 VALUES(8, 'Josh', 'Rich', 21000, 3);
SELECT * FROM Employees_3;


-- PROCEDURE CREATION
CREATE OR REPLACE FUNCTION Employee_Salary_Adjustments()
RETURNS VOID AS $$
DECLARE
	emp_rating INT;
	salary_diff NUMERIC(10, 2);
	rec RECORD;
BEGIN	
	FOR rec in (SELECT * FROM Employees_3)
	LOOP
		SELECT Adjustment_Percentage/100.0 INTO salary_diff FROM Salary_Adjustments 
		WHERE Rating = rec.Performance_Rating;		
		UPDATE Employees_3
		SET Salary = Salary + salary_diff * Salary
		WHERE Employee_id = rec.Employee_id;
		
	END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Employee_Salary_Adjustments();
SELECT * FROM Employees_3;