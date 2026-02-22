--q1: Write a PL/SQL block to display the GPA of given student.
DECLARE
   v_rollno StudentTable.roll_no%TYPE;
   v_gpa    StudentTable.gpa%TYPE;
BEGIN
   v_rollno := '&rollno';

   SELECT gpa
   INTO v_gpa
   FROM StudentTable
   WHERE roll_no = v_rollno;

   DBMS_OUTPUT.PUT_LINE('GPA: ' || v_gpa);
END;
/

--q2: Write a PL/SQL block to display the letter grade(0-4: F; 4-5: E; 5-6: D; 6-7: C; 7-8: B; 8-9: A; 9-10: A+} of given student.
DECLARE
	v_rollno StudentTable.roll_no%Type;
	v_grade VARCHAR(2);
	v_gpa StudentTable.gpa%Type;
BEGIN
	v_rollno := '&Roll_No';
	SELECT gpa INTO v_gpa
	FROM StudentTable
	WHERE roll_no = v_rollno;
	IF v_gpa >=0 AND v_gpa < 4 THEN
	v_grade := 'F';
	ELSIF v_gpa >=4 AND v_gpa < 5 THEN
	v_grade := 'E';
	ELSIF v_gpa >=5 AND v_gpa < 6 THEN
	v_grade := 'D';
	ELSIF v_gpa >=6 AND v_gpa < 7 THEN
	v_grade := 'C';
	ELSIF v_gpa >=7 AND v_gpa < 8 THEN
	v_grade := 'B';
	ELSIF v_gpa >=8 AND v_gpa < 9 THEN
	v_grade := 'A';
	ELSIF v_gpa >= 9 AND v_gpa <= 10 THEN
	v_grade := 'A+';
	END IF;
	DBMS_OUTPUT.PUT_LINE('Grade: ' || v_grade);
END;
/
-- q3: Input the date of issue and date of return for a book. Calculate and display the fine with the appropriate message using a PL/SQL block. The fine is charged as per the table 8.1:
-- | Late Period        | Fine              |
-- |--------------------|------------------|
-- | 0 – 7 days         | NIL              |
-- | 8 – 15 days        | Rs. 1 per day    |
-- | 16 – 30 days       | Rs. 2 per day    |
-- | After 30 days      | Rs. 5.00 (fixed) |
  
DECLARE 
	v_issue DATE;
	v_return DATE;
	v_days NUMBER(10);
	v_fine NUMERIC(10,2) := 0;
BEGIN
	v_issue := TO_DATE('&issue_date', 'DD-MM-YYYY');
	v_return := TO_DATE('&return_date', 'DD-MM-YYYY');
	v_days := v_return-v_issue;
	IF v_days <= 7 THEN
		v_fine := 0.00;
	ELSIF v_days > 7 AND v_days <=15 THEN
		v_fine := v_days*1.00;
	ELSIF v_days > 15 AND v_days <=30 THEN
		v_fine := v_days*2.00;
	ELSIF v_days > 30  THEN
		v_fine := 5.00;
	END IF;
	DBMS_OUTPUT.PUT_LINE('Late Days: ' || v_days);
	DBMS_OUTPUT.PUT_LINE('Fine Amount: Rs. ' || v_fine);
END;
/

-- q4: Write a PL/SQL block to print the letter grade of all the students(RollNo: 1 - 5).
DECLARE
	v_rollno StudentTable.roll_no%Type;
	v_gpa StudentTable.gpa%Type;
	v_grade VARCHAR(2);
	v_counter NUMBER := 1;
BEGIN
	LOOP
		SELECT gpa INTO v_gpa
		FROM StudentTable
		WHERE roll_no = v_counter;

		IF v_gpa >=0 AND v_gpa < 4 THEN
		v_grade := 'F';
		ELSIF v_gpa >=4 AND v_gpa < 5 THEN
		v_grade := 'E';
		ELSIF v_gpa >=5 AND v_gpa < 6 THEN
		v_grade := 'D';
		ELSIF v_gpa >=6 AND v_gpa < 7 THEN
		v_grade := 'C';
		ELSIF v_gpa >=7 AND v_gpa < 8 THEN
		v_grade := 'B';
		ELSIF v_gpa >=8 AND v_gpa < 9 THEN
		v_grade := 'A';
		ELSIF v_gpa >= 9 AND v_gpa <= 10 THEN
		v_grade := 'A+';
		END IF;
		
		DBMS_OUTPUT.PUT_LINE('Roll no: ' || v_counter);
		DBMS_OUTPUT.PUT_LINE('GPA: ' || v_gpa);
		DBMS_OUTPUT.PUT_LINE('Grade: ' || v_grade);
		v_counter := v_counter+1;
		EXIT WHEN v_counter > 5;
	END LOOP;
END;
/

-- 5. Alter StudentTable by appending an additional column LetterGrade Varchar2(2) Then write a PL/SQL block to update the table with letter grade of each student.

ALTER TABLE StudentTable ADD LetterGrade Varchar2(2);

DECLARE 
	v_gpa StudentTable.gpa%Type;
	v_counter NUMBER := 1;
	v_grade VARCHAR2(2);
BEGIN
	WHILE v_counter < 6 LOOP
		SELECT gpa INTO v_gpa
		FROM StudentTable 
		WHERE roll_no = v_counter;

		IF v_gpa >=0 AND v_gpa < 4 THEN
		v_grade := 'F';
		ELSIF v_gpa >=4 AND v_gpa < 5 THEN
		v_grade := 'E';
		ELSIF v_gpa >=5 AND v_gpa < 6 THEN
		v_grade := 'D';
		ELSIF v_gpa >=6 AND v_gpa < 7 THEN
		v_grade := 'C';
		ELSIF v_gpa >=7 AND v_gpa < 8 THEN
		v_grade := 'B';
		ELSIF v_gpa >=8 AND v_gpa < 9 THEN
		v_grade := 'A';
		ELSIF v_gpa >= 9 AND v_gpa <= 10 THEN
		v_grade := 'A+';
		END IF;

		UPDATE StudentTable
		SET LetterGrade = v_grade
		WHERE roll_no = v_counter;
		v_counter := v_counter+1;
	END LOOP;
END;
/

-- q6: Write a PL/SQL block to find the student with max. GPA without using aggregate function.

DECLARE
	v_gpa StudentTable.gpa%Type;
	v_max_gpa StudentTable.gpa%Type := 0;
	v_max_gpa_roll NUMBER := 1;
BEGIN
	FOR i in 1..5 LOOP
		SELECT gpa INTO v_gpa
		FROM StudentTable
		WHERE roll_no = i;
		
		IF v_gpa > v_max_gpa THEN
			v_max_gpa := v_gpa;
			v_max_gpa_roll := i;
		END IF;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Roll no: ' || v_max_gpa_roll);
	DBMS_OUTPUT.PUT_LINE('GPA: ' || v_max_gpa);
END;
/

-- q7: 7. Implement lab exercise 4 using GOTO.
DECLARE
	v_rollno StudentTable.roll_no%Type;
	v_gpa StudentTable.gpa%Type;
	v_grade VARCHAR(2);
	v_counter NUMBER := 1;
BEGIN
	<<start_p>>
	SELECT gpa INTO v_gpa
	FROM StudentTable
	WHERE roll_no = v_counter;
	IF v_gpa >=0 AND v_gpa < 4 THEN
	v_grade := 'F';
	ELSIF v_gpa >=4 AND v_gpa < 5 THEN
	v_grade := 'E';
	ELSIF v_gpa >=5 AND v_gpa < 6 THEN
	v_grade := 'D';
	ELSIF v_gpa >=6 AND v_gpa < 7 THEN
	v_grade := 'C';
	ELSIF v_gpa >=7 AND v_gpa < 8 THEN
	v_grade := 'B';
	ELSIF v_gpa >=8 AND v_gpa < 9 THEN
	v_grade := 'A';
	ELSIF v_gpa >= 9 AND v_gpa <= 10 THEN
	v_grade := 'A+';
	END IF;	
	DBMS_OUTPUT.PUT_LINE('Roll no: ' || v_counter);
	DBMS_OUTPUT.PUT_LINE('GPA: ' || v_gpa);
	DBMS_OUTPUT.PUT_LINE('Grade: ' || v_grade);
	v_counter := v_counter+1;
	IF v_counter <= 5  THEN
		 GOTO start_p;
	END IF;
END;
/
