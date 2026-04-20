-- Q1)Write a procedure to display a message “Good Day to You”.
SQL> CREATE OR REPLACE PROCEDURE message
  2  IS
  3  BEGIN
  4     DBMS_OUTPUT.PUT_LINE('Good Day to You');
  5  END;
  6  /

SQL> set serveroutput on;
SQL> BEGIN
  2     message;
  3  END;
  4  /

-- Q2)Based on the University Database Schema in Lab 2, write a procedure which takes the dept_name as input parameter and lists all the instructors associated with the department as well as list all the courses offered by the department. Also, write an anonymous block with the procedure call.
SQL> CREATE OR REPLACE PROCEDURE display_q2 (p_dept_name VARCHAR2)
  2  IS
  3  BEGIN
  4     FOR x IN(
  5             SELECT ID, name
  6             FROM instructor
  7             WHERE dept_name = p_dept_name
  8     )
  9     LOOP
 10             DBMS_OUTPUT.PUT_LINE('Id: ' || x.id || ' Name: ' || x.name);
 11     END LOOP;
 12
 13     FOR y IN(
 14             SELECT course_id, title
 15             FROM course
 16             WHERE dept_name = p_dept_name
 17     )
 18     LOOP
 19             DBMS_OUTPUT.PUT_LINE('Course id: ' || y.course_id || ' Title: ' || y.title);
 20     END LOOP;
 21  END;
 22  /    

   SQL> BEGIN
  2  display_q2('Comp. Sci.');
  3  END;
  4  /
   
-- Q3)Based on the University Database Schema in Lab 2, write a Pl/Sql block of code that lists the most popular course (highest number of students take it) for each of the departments. It should make use of a procedure course_popular which finds the most popular course in the given department.
CREATE OR REPLACE PROCEDURE q3(p_dept_name VARCHAR2)
IS
	v_max NUMBER(10) := 0;
	v_most_popular VARCHAR2(20);
BEGIN
	FOR x IN (
		SELECT c.course_id , COUNT(distinct ID) as cnt
		FROM course c 
		JOIN takes t ON t.course_id = c.course_id
		WHERE c.dept_name = p_dept_name
		GROUP BY c.course_id
	)
	LOOP
		IF x.cnt > v_max THEN
			v_max := x.cnt;
			v_most_popular := x.course_id;
		END IF;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('Department: ' || p_dept_name || ', Most popular course: ' || v_most_popular);
END;
/


BEGIN
	FOR x IN(
		SELECT Distinct dept_name FROM department
	)
	LOOP
		q3(x.dept_name);
	END LOOP;
END;
/

-- Q4)
-- Based on the University Database Schema in Lab 2, write a procedure which takes
-- the dept-name as input parameter and lists all the students associated with the department as well as list all the courses offered by the department. Also, write an anonymous block with the procedure call.
SQL> CREATE OR REPLACE PROCEDURE display_q4(p_dept_name VARCHAR2)
  2  IS
  3  BEGIN
  4     FOR x IN(
  5             SELECT id, name
  6             FROM student
  7             WHERE dept_name = p_dept_name
  8     )
  9     LOOP
 10             DBMS_OUTPUT.PUT_LINE('Id: ' || x.id || ' Name: ' || x.name);
 11     END LOOP;
 12     FOR y IN(
 13             SELECT course_id, title
 14             FROM course
 15             WHERE dept_name = p_dept_name
 16     )
 17     LOOP
 18             DBMS_OUTPUT.PUT_LINE('course_id: ' || y.course_id || ' Title: ' || y.title);
 19     END LOOP;
 20  END;
 21  /

SQL> BEGIN
  2     display_q4('Comp. Sci.');
  3  END;
  4  /


-- Q5)Write a function to return the Square of a given number and call it from an anonymous block.

SQL> CREATE OR REPLACE FUNCTION display_q5(x number)
  2  return number as
  3  sq NUMBER;
  4  BEGIN
  5     sq := x*x;
  6     return sq;
  7  END;
  8  /

SQL> SET SERVEROUTPUT ON;
SQL> BEGIN
  2     DBMS_OUTPUT.PUT_LINE(display_q5(5));
  3  END;
  4  /

-- Q6)Based on the University Database Schema in Lab 2, write a Pl/Sql block of code that lists the highest paid Instructor in each of the Department. It should make use of a function department_highest which returns the highest paid Instructor for the given branch.

CREATE OR REPLACE FUNCTION department_highest(p_dept_name varchar2) RETURN VARCHAR2
IS
	v_highest_paid VARCHAR2(20);
	v_max_pay NUMBER(10) := 0;
BEGIN
	FOR x IN (
		SELECT salary,name from instructor WHERE dept_name  = p_dept_name
	)
	LOOP
		IF x.salary > v_max_pay THEN
			v_max_pay := x.salary;
			v_highest_paid := x.name;
		END IF;
	END LOOP;
	
	RETURN v_highest_paid;
END;
/


BEGIN
	FOR d IN (select distinct dept_name from department) LOOP
		DBMS_OUTPUT.PUT_LINE(' Dept: ' || d.dept_name || ', Highest paid: ' || department_highest(d.dept_name));
	END LOOP;
END;
/


-- 7. Based on the University Database Schema in Lab 2, create a package to include
-- the following:
-- a) A named procedure to list the instructor_names of given department b) A function which returns the max salary for the given department
-- c) Write a PL/SQL block to demonstrate the usage of above package components


	  SQL> CREATE OR REPLACE PACKAGE univ_pkg AS
  2     PROCEDURE list(p_dept VARCHAR2);
  3     FUNCTION max_sal(p_dept VARCHAR2) RETURN NUMBER;
  4  END univ_pkg;
  5  /

Package created.

SQL>
SQL>
SQL> CREATE OR REPLACE PACKAGE BODY univ_pkg AS
  2     PROCEDURE list(p_dept VARCHAR2) AS
  3     BEGIN
  4             FOR x IN(
  5                     SELECT name FROM instructor
  6                     WHERE dept_name = p_dept
  7             )LOOP
  8                     DBMS_OUTPUT.PUT_LINE(x.name ||' ');
  9             END LOOP;
 10     END list;
 11
 12     FUNCTION max_sal(p_dept VARCHAR2) RETURN NUMBER
 13     AS
 14             maxx NUMBER;
 15     BEGIN
 16             SELECT max(salary) INTO maxx
 17             FROM instructor
 18             WHERE dept_name = p_dept;
 19
 20             RETURN maxx;
 21     END max_sal;
 22  END univ_pkg;
 23  /

Package body created.

SQL>
SQL> DECLARE
  2     v_dept VARCHAR2(50);
  3     v_max NUMBER;
  4  BEGIN
  5     v_dept := '&department';
  6     univ_pkg.list(v_dept);
  7     v_max := univ_pkg.max_sal(v_dept);
  8     DBMS_OUTPUT.PUT_LINE('Max salary for ' || v_dept || ' is: '||v_max);
  9  END;
 10  /

-- Q8)Write a PL/SQL procedure to return simple and compound interest (OUT parameters) along with the Total Sum (IN OUT) i.e. Sum of Principle and Interest taking as input the principle, rate of interest and number of years (IN parameters). Call this procedure from an anonymous block.

SQL> CREATE or REPLACE PROCEDURE calc(
  2     P IN NUMBER,
  3     R IN NUMBER,
  4     T IN NUMBER,
  5     SI OUT NUMBER,
  6     CI OUT NUMBER,
  7     tot IN OUT NUMBER
  8  )
  9  IS
 10  BEGIN
 11     SI := (P*R*T)/100;
 12     CI := P*(POWER(1 + R/100, T)-1);
 13     tot := P + CI;
 14  END;
 15  /

Procedure created.
   
SQL> DECLARE
  2     P NUMBER;
  3     R NUMBER;
  4     T NUMBER;
  5     SI NUMBER;
  6     CI NUMBER;
  7     tot NUMBER;
  8  BEGIN
  9     P := '&Principal';
 10     R := '&Rate';
 11     T := '&Time';
 12     calc(P,R,T,SI,CI,tot);
 13     DBMS_OUTPUT.PUT_LINE('SI: ' || SI || ' CI: ' || CI || ' Tot: ' || tot);
 14  END;
 15  /
