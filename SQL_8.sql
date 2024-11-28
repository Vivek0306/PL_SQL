CREATE TABLE Performance_Rating(
	Rating INT,
	Bonus_Percentage INT
);

INSERT INTO Performance_Rating VALUES (5, 25), (4, 15), (3, 10), (2, 5), (1, 0);


-- Here we are referring to the Employee_3 Table for Bonus Calculation

SELECT * FROM Employees_3;

CREATE OR REPLACE FUNCTION Employee_Bonus(
	Emp_ID INT
) RETURNS DECIMAL as $$
DECLARE
	bonus DECIMAL(10, 2);
	emp_rating INT;
BEGIN
	SELECT Performance_Rating INTO emp_rating FROM Employees_3 WHERE Employee_id = Emp_ID;
	bonus := (SELECT Bonus_Percentage FROM Performance_Rating WHERE Rating = emp_rating) / 100.0 * 
	(SELECT salary FROM Employees_3 WHERE Employee_id = Emp_ID);
	RETURN bonus;
END;
$$ LANGUAGE plpgsql


-- Calling the function with corresponding Employee ID whose bonus is to be found
SELECT * FROM Employee_Bonus(1);