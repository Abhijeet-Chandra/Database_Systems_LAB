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
SQL> CREATE OR REPLACE PROCEDURE display_q3 (dept_name VARCHAR2)
  2  IS
  3  BEGIN
  4     FOR c IN(
  5             SELECT c.course_id
  6             FROM course c
  7             JOIN takes t ON c.course_id = t.course_id
  8             WHERE c.dept_name = dept_name
  9             GROUP BY c.course_id
 10             HAVING COUNT(*) >= ALL(
 11                     SELECT COUNT(*)
 12                     FROM course c
 13                     JOIN takes t ON c.course_id = t.course_id
 14                     WHERE c.dept_name = dept_name
 15                     GROUP BY c.course_id
 16             )
 17     )
 18     LOOP
 19             DBMS_OUTPUT.PUT_LINE(c.course_id);
 20     END LOOP;
 21  END;
 22  /

SQL> set SERVEROUTPUT ON;
SQL> BEGIN
  2     display_q3('Biology');
  3  END;
  4  /


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

SQL> CREATE OR REPLACE FUNCTION display_q6(p_dept_name VARCHAR2)
  2  return VARCHAR2 as
  3  highest instructor.name%type;
  4  BEGIN
  5     SELECT name INTO highest
  6     FROM instructor
  7     WHERE dept_name = p_dept_name
  8     AND salary = (
  9             SELECT MAX(salary) FROM instructor
 10             WHERE dept_name = p_dept_name
 11     );
 12
 13     RETURN highest;
 14  END;
 15  /

Function created.

SQL>
SQL> BEGIN
  2     FOR x IN (select DISTINCT dept_name FROM instructor)
  3     LOOP
  4             DBMS_OUTPUT.PUT_LINE(x.dept_name || ' -> ' || display_q6(x.dept_name));
  5     END LOOP;
  6  END;
  7  /
