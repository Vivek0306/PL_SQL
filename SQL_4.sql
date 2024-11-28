CREATE TABLE Students_2(
	Student_id INT PRIMARY KEY,
	Name VARCHAR(100),
	Score INT
);
CREATE TABLE audit_log (
    log_id INT PRIMARY KEY,
    student_id INT,
    log_message VARCHAR(255),
    log_date DATE
);

CREATE SEQUENCE audit_log_seq
START WITH 1
INCREMENT BY 1
NO CYCLE;

-- INSERT QUERIES
-- INSERT QUERIES
INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (1, 'Alice', 85);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (2, 'Bob', 92);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (3, 'Charlie', 78);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (4, 'David', 70);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (5, 'Eva', 68);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (6, 'Frank', 80);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (7, 'Grace', 21);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (8, 'Hannah', 74);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (9, 'Ivy', 89);

INSERT INTO Students_2 (Student_id, Name, Score)
VALUES (10, 'Jack', 43);


-- CREATING THE PROCEDURE
ALTER TABLE Students_2 ADD COLUMN Grade VARCHAR(50);

CREATE OR REPLACE FUNCTION Student_Grade_Log()
RETURNS VOID AS $$
DECLARE
	rec RECORD;
	s_grade VARCHAR(2);
	s_log VARCHAR(100);
BEGIN
	FOR rec in (SELECT * FROM Students_2)
	LOOP
		IF rec.Score >= 90 THEN
			s_grade := 'A';
		ELSIF rec.Score BETWEEN 80 AND 89 THEN
			s_grade := 'B';
		ELSIF rec.Score BETWEEN 70 AND 79 THEN
			s_grade := 'C';
		ELSIF rec.Score BETWEEN 60 AND 69 THEN
			s_grade := 'D';
		ELSE 
			s_grade := 'F';
		END IF;
		
		UPDATE Students_2 SET Grade = s_grade WHERE Student_id = rec.Student_id;
		s_log := 'Student with ID ' || rec.Student_id || ' assigned Grade: ' || s_grade;
		INSERT INTO audit_log(
			log_id, student_id, log_message, log_date
		) VALUES(
			NEXTVAL('audit_log_seq'), rec.Student_id, s_log, CURRENT_DATE
		);
	END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT Student_Grade_Log();

SELECT * FROM Students_2;
SELECT * FROM audit_log;

