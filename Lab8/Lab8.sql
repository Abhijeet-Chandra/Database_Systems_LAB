-- Q1)
--   The HRD manager has decided to raise the salary of all the Instructors in a given
-- department number by 5%. Whenever, any such raise is given to the instructor, a record for the same is maintained in the salary_raise table. It includes the Instuctor Id, the date when the raise was given and the actual raise amount. Write a PL/SQL block to update the salary of each Instructor and insert a record in the salary_raise table.
-- salary_raise(Instructor_Id, Raise_date, Raise_amt)

DECLARE
	v_id INSTRUCTOR.ID%TYPE;
	v_name INSTRUCTOR.name%TYPE;
	v_dept_name INSTRUCTOR.dept_name%TYPE;
	v_salary INSTRUCTOR.salary%TYPE;
	v_raise NUMBER;
	CURSOR c1 IS SELECT * FROM INSTRUCTOR WHERE dept_name = v_dept_name;
BEGIN	
	v_dept_name := '&Department_name';

	OPEN c1;
	
	LOOP

	FETCH c1 INTO v_id, v_name, v_dept_name, v_salary;
	EXIT WHEN c1%NOTFOUND;

	v_raise := v_salary*0.05;
	v_salary := v_salary + v_raise;

	UPDATE instructor 
	SET SALARY = v_salary 
	WHERE id = v_id;

	INSERT INTO salary_raise 
	VALUES(v_id, SYSDATE, v_raise);

	END LOOP;

	CLOSE c1;
END;
/

-- Q2)
-- Write a PL/SQL block that will display the ID, name, dept_name and tot_cred of
-- the first 10 students with lowest total credit.
  
DECLARE 
	v_id STUDENT.ID%TYPE;
	v_name STUDENT.name%TYPE;
	v_dept STUDENT.dept_name%TYPE;
	v_cred STUDENT.tot_cred%TYPE;
	
	CURSOR c1 IS 
	SELECT * FROM student
	ORDER BY tot_cred ASC;
BEGIN
	OPEN c1;
	
	LOOP
		FETCH c1 INTO v_id, v_name, v_dept, v_cred;
		EXIT WHEN c1%NOTFOUND OR c1%ROWCOUNT>10;

		DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_name || ' ' || v_dept || ' ' || v_cred);
		
	END LOOP;
		
	CLOSE c1;
END;
/


-- Q3)
-- Print the Course details and the total number of students registered for each course
-- along with the course details - (Course-id, title, dept-name, credits, instructor_name, building, room-number, time-slot-id, tot_student_no )
  
DECLARE
	CURSOR c1 IS
	SELECT c.course_id, c.title, c.dept_name, c.credits, i.name, s.building, s.room_number, s.time_slot_id, COUNT(t.id) as tot_no_students
	FROM course c 

	JOIN section s ON
	c.course_id = s.course_id

	JOIN teaches te ON
	s.course_id = te.course_id
	AND s.sec_id = te.sec_id
	AND s.semester = te.semester
	AND s.year = te.year

	JOIN instructor i ON
	i.id = te.id

	LEFT JOIN takes t ON 
	t.course_id = s.course_id
	AND t.sec_id = s.sec_id
	AND t.semester = s.semester
	AND t.year = s.year

	GROUP BY c.course_id, c.title, c.dept_name, c.credits, i.name, s.building, s.room_number, s.time_slot_id, te.id;
BEGIN
	FOR rec IN c1 LOOP
		DBMS_OUTPUT.PUT_LINE(
            rec.course_id || ' | ' ||
            rec.title || ' | ' ||
            rec.dept_name || ' | ' ||
            rec.credits || ' | ' ||
            rec.name || ' | ' ||
            rec.building || ' | ' ||
            rec.room_number || ' | ' ||
            rec.time_slot_id || ' | ' ||
            rec.tot_no_students
        );
	END LOOP;
END;
/	

-- Q4) Find all students who take the course with Course-id: CS101 and if he/ she has
-- less than 30 total credit (tot-cred), deregister the student from that course. (Delete the entry in Takes table)
DECLARE
	CURSOR c1 IS
	SELECT t.course_id, t.id
	FROM student s JOIN
	takes t ON t.id = s.id
	WHERE t.course_id = 'CS-101'
	AND s.tot_cred < 30;
BEGIN
	FOR rec IN c1 LOOP
		DELETE FROM takes
		WHERE course_id = rec.course_id
		AND id = rec.id;
		DBMS_OUTPUT.PUT_LINE('Deleted: ' || rec.id);
	END LOOP;	
END;
/

-- Q5)
-- Alter StudentTable(refer Lab No. 8 Exercise) by resetting column LetterGrade to
-- F. Then write a PL/SQL block to update the table by mapping GPA to the corresponding letter grade for each student.
  
UPDATE StudentTable SET lettergrade = 'F';


DECLARE
	CURSOR c1 IS
	SELECT roll_no, gpa
	FROM studenttable
	FOR UPDATE;

	v_grade studenttable.lettergrade%type;
BEGIN
	FOR rec IN c1 LOOP
		IF rec.gpa >=0 AND rec.gpa < 4 THEN
		v_grade := 'F';
		ELSIF rec.gpa >=4 AND rec.gpa < 5 THEN
		v_grade := 'E';
		ELSIF rec.gpa >= 5 AND rec.gpa < 6 THEN
		v_grade := 'D';
		ELSIF rec.gpa >= 6 AND rec.gpa < 7 THEN
		v_grade := 'C';
		ELSIF rec.gpa >=7 AND rec.gpa < 8 THEN
		v_grade := 'B';
		ELSIF rec.gpa >=8 AND rec.gpa < 9 THEN
		v_grade := 'A';
		ELSIF rec.gpa >= 9 AND rec.gpa <= 10 THEN
		v_grade := 'A+';
		END IF;
		UPDATE studenttable set lettergrade = v_grade WHERE CURRENT OF c1;
	END LOOP;
END;
/

-- Q6) Write a PL/SQL block to print the list of Instructors teaching a specified course.

DECLARE
	v_course_name TEACHES.course_id%TYPE;
	CURSOR c1(p_course_id teaches.course_id%TYPE) IS
	SELECT name 
	FROM instructor i
	JOIN teaches t ON
	t.id = i.id
	WHERE t.course_id = p_course_id;
BEGIN
	v_course_name := '&course_name';
	FOR rec IN c1(v_course_name) LOOP
		DBMS_OUTPUT.PUT_LINE(rec.name);
	END LOOP;
END;
/
