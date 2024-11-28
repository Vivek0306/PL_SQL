CREATE TABLE Students(
	Student_id INT PRIMARY KEY,
	Name VARCHAR(100),
	Score INT
)

-- INSERT QUERIES
INSERT INTO Students (Student_id, Name, Score)
VALUES (1, 'Alice', 85);

INSERT INTO Students (Student_id, Name, Score)
VALUES (2, 'Bob', 92);

INSERT INTO Students (Student_id, Name, Score)
VALUES (3, 'Charlie', 78);

INSERT INTO Students (Student_id, Name, Score)
VALUES (4, 'David', 88);

INSERT INTO Students (Student_id, Name, Score)
VALUES (5, 'Eva', 95);

INSERT INTO Students (Student_id, Name, Score)
VALUES (6, 'Frank', 80);

INSERT INTO Students (Student_id, Name, Score)
VALUES (7, 'Grace', 91);

INSERT INTO Students (Student_id, Name, Score)
VALUES (8, 'Hannah', 74);

INSERT INTO Students (Student_id, Name, Score)
VALUES (9, 'Ivy', 89);

INSERT INTO Students (Student_id, Name, Score)
VALUES (10, 'Jack', 82);


SELECT * FROM Students


-- PROCEDURE PART

CREATE OR REPLACE FUNCTION Student_Grade()
RETURNS VOID as $$
DECLARE 
	record Students%ROWTYPE;
BEGIN
	ALTER TABLE Students ADD COLUMN Grade VARCHAR(50);
	ALTER TABLE Students ADD COLUMN Remarks VARCHAR(50);
	FOR record in (SELECT * FROM Students)
	LOOP
		UPDATE Students
			SET Grade = 
				CASE
					WHEN Score >= 90 THEN 'A'
					WHEN Score BETWEEN 80 AND 89 THEN 'B'
					WHEN Score BETWEEN 70 AND 79 THEN 'C'
					WHEN Score BETWEEN 60 AND 69 THEN 'D'
					ELSE 'F'
				END,
			Remarks = 
				CASE
					WHEN Score >= 90 THEN 'Excellent'
					WHEN Score BETWEEN 80 AND 89 THEN 'Good Job'
					WHEN Score BETWEEN 70 and 79 THEN 'Fair Effort'
					WHEN Score < 60 THEN 'Needs Improvement'
					ELSE ''
				END
		WHERE Student_id = record.Student_id;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT Student_Grade();

SELECT * FROM Students
