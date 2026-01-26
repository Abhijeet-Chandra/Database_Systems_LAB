-- 1. Find the number of students in each course.
SELECT course_id, COUNT(DISTINCT ID) AS num_students
FROM takes
GROUP BY course_id;

-- 2. Find those departments where the average number of students are greater than 10.
SELECT c.dept_name
FROM course c
JOIN takes t ON c.course_id = t.course_id
GROUP BY c.dept_name 
HAVING COUNT(t.ID)*1.0/COUNT(DISTINCT c.course_id) > 10;

-- 3. Find the total number of courses in each department.
SELECT dept_name, COUNT(DISTINCT course_id) as num_courses
FROM course
GROUP BY dept_name;

-- 4. Find the names and average salaries of all departments whose average salary is greater than 42000.
SELECT dept_name, AVG(salary) as average_salary
FROM instructor 
GROUP BY dept_name 
HAVING AVG(salary)>42000;

-- 5. Find the enrolment of each section that was offered in Spring 2009.
SELECT sec.course_id,sec.sec_id, COUNT(DISTINCT t.ID) AS num_students
FROM section sec  
LEFT JOIN takes t
ON sec.sec_id = t.sec_id
AND sec.course_id = t.course_id 
AND sec.semester = t.semester
AND sec.year = t.year
WHERE sec.year = 2009 
AND sec.semester = 'Spring'
GROUP BY sec.sec_id, sec.course_id;

-- 6. List all the courses with prerequisite courses, then display course id in increasing
-- order.

SELECT course_id, prereq_id
FROM prereq
ORDER BY course_id;

-- 7. Display the details of instructors sorting the salary in decreasing order.

SELECT * FROM instructor 
ORDER BY salary DESC;

-- 8. Find the maximum total salary across the departments.
SELECT dept_name, SUM(salary) as tot
FROM instructor 
GROUP BY dept_name 
HAVING SUM(salary) >= ALL(
    SELECT SUM(salary)
    FROM instructor 
    GROUP BY dept_name 
);

-- 9. Find the average instructors’ salaries of those departments where the average salary is greater than 42000.
SELECT dept_name, AVG(salary) as avg_dept_salary
FROM instructor
GROUP BY dept_name
HAVING AVG(salary) > 42000;

-- 10. Find the sections that had the maximum enrolment in Spring 2010
SELECT course_id,sec_id, COUNT(DISTINCT ID)
FROM takes 
WHERE semester = 'Spring' AND year = 2010
GROUP BY course_id, sec_id
HAVING COUNT(DISTINCT ID)>=ALL(
    SELECT COUNT(DISTINCT ID)
    FROM takes
    WHERE semester = 'Spring' AND year = 2010
    GROUP BY course_id, sec_id
);

-- 11. Find the names of all instructors who teach all students that belong to ‘CSE’ department.
-- SELECT ID, name
-- FROM 

-- 12. Find the average salary of those department where the average salary is greater than 50000 and total number of instructors in the department are more than 5.

SELECT dept_name, AVG(salary) as avg_dept_salary,  COUNT(DISTINCT ID) as num_instructors
FROM instructor 
GROUP BY dept_name
HAVING AVG(salary)>50000
AND COUNT(DISTINCT ID)>5;

-- 13. Find all departments with the maximum budget.
WITH t1 AS(
    SELECT MAX(budget) as max_budget FROM department
)
SELECT dept_name,budget,max_budget FROM department,t1 WHERE budget = (SELECT max_budget FROM t1);

-- 14. Find all departments where the total salary is greater than the average of the total salary at all departments.
WITH t2 AS(
    SELECT dept_name,SUM(salary) AS tot_dept_sal
    FROM instructor 
    GROUP BY dept_name
),
t3 AS(
    SELECT AVG(tot_dept_sal) AS avg_tot_dept_sal FROM t2
)
SELECT dept_name, tot_dept_sal
FROM t2 
WHERE tot_dept_sal> (
    SELECT avg_tot_dept_sal FROM t3
);

-- 15. Transfer all the students from CSE department to IT department.

-- NOTE: IT DEPARTMENT IS NOT EVEN PRESENT, IF I WRITE 'IT' THEN IT THROWS AN ERROR:
-- ORA-02291: integrity constraint (SCHEMA_E544L.STUDENT_DEPT_FK) violated - parent key not found
-- THAT IS WHY I USED ELEC. ENG.

SAVEPOINT svpt;
-- before updation:
SELECT * FROM student;

UPDATE student SET dept_name = 'Elec. Eng.' WHERE dept_name = 'Comp. Sci.';

-- after updation
SELECT * FROM student;

ROLLBACK;

-- after rollback

SELECT * FROM student;

-- 16. Increase salaries of instructors whose salary is over $100,000 by 3%, and all
-- others receive a 5% raise

SAVEPOINT s1;

--before updation:
SELECT name,salary FROM instructor;

UPDATE instructor SET salary = 1.03*salary 
WHERE salary>=100000;
UPDATE instructor SET salary = 1.05*salary 
WHERE salary<100000;

-- after updation:
SELECT name,salary FROM instructor;

ROLLBACK;

-- after rollback:
SELECT name,salary FROM instructor;
