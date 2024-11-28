CREATE TABLE Employees_2( 
	EmployeeID INT PRIMARY KEY, 
    Name VARCHAR(100), 
	Status VARCHAR(50)
); 

INSERT INTO Employees_2 VALUES(1, 'Vivek', 'Active');
INSERT INTO Employees_2 VALUES(2, 'Vinay', 'Active');
INSERT INTO Employees_2 VALUES(3, 'Manju', 'On Leave');
INSERT INTO Employees_2 VALUES(4, 'Manoj', 'Resigned');
INSERT INTO Employees_2 VALUES(5, 'Jake', 'Active');
INSERT INTO Employees_2 VALUES(6, 'Logan', 'On Leave');
INSERT INTO Employees_2 VALUES(7, 'Josh', 'Active');

SELECT * FROM Employees_2;

DO $$
DECLARE 
	rec Record;
BEGIN
	FOR rec in (SELECT * FROM Employees_2)
	LOOP
		IF rec.Status = 'On Leave' THEN
			CONTINUE;
		ELSE
			RAISE NOTICE 'Employee: % | Status: %', rec.Name, rec.Status;
		END IF;
	END LOOP;
END;
$$ LANGUAGE plpgsql;




