/*1. Find courses that ran in Fall 2009 or in Spring 2010*/
SELECT title FROM course WHERE course_id IN 
    (
        SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009
    )
    UNION ALL
SELECT title FROM course WHERE course_id IN 
    (
        SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010
    );

/*2. Find courses that ran in Fall 2009 and in spring 2010*/

SELECT title FROM course WHERE course_id IN 
    (
        SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009
    )
    INTERSECT 
SELECT title FROM course WHERE course_id IN 
    (
        SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010
    );

/*3. Find courses that ran in Fall 2009 but not in Spring 2010*/
SELECT title FROM course WHERE course_id IN 
    (
        SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009
    )
    MINUS
SELECT title FROM course WHERE course_id IN 
    (
        SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010
    );
/*4. Find the name of the course for which none of the students registered.*/
SELECT title FROM course WHERE course_id NOT IN (
    SELECT course_id FROM takes WHERE course_id IS NOT NULL
);

/*Method 2:*/
SELECT title FROM course WHERE course_id IN(
    SELECT course_id FROM course MINUS SELECT course_id FROM takes
);

/*Method 3:*/
SELECT c.title FROM course c
WHERE NOT EXISTS(
    SELECT 1 FROM takes t WHERE t.course_id = c.course_id
);

/*5. Find courses offered in Fall 2009 and in Spring 2010.*/
SELECT title FROM course WHERE course_id IN(
    SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009
)
AND course_id IN(
    SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010
);
/*6. Find the total number of students who have taken course taught by the instructor
with ID 10101.*/
SELECT COUNT(DISTINCT ID) FROM student WHERE ID IN(
    SELECT ID FROM takes WHERE course_id IN(
        SELECT course_id FROM teaches WHERE id = '10101'
    )
);
/*7. Find courses offered in Fall 2009 but not in Spring 2010.*/
SELECT title FROM course WHERE course_id IN(
    SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009
)
AND course_id NOT IN(
    SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010
);
/*8. Find the names of all students whose name is same as the instructor’s name.*/
SELECT DISTINCT name FROM student WHERE name IN (
    SELECT name FROM instructor WHERE name IS NOT NULL
);
/*9. Find names of instructors with salary greater than that of some (at least one) instructor
in the Biology department.*/
SELECT name FROM instructor WHERE salary > SOME(
    SELECT salary FROM instructor WHERE dept_name = 'Biology'
);
/*10. Find the names of all instructors whose salary is greater than the salary of all
instructors in the Biology department.*/
SELECT name FROM instructor WHERE salary > ALL(
    SELECT salary FROM instructor WHERE dept_name = 'Biology'
);
/*11. Find the departments that have the highest average salary.*/

/*12. Find the names of those departments whose budget is lesser than the average salary
of all instructors.*/
SELECT dept_name FROM department WHERE budget < (SELECT AVG(salary) FROM instructor);

/*13. Find all courses taught in both the Fall 2009 semester and in the Spring 2010 semester.*/
SELECT c.title FROM course c WHERE EXISTS(
    SELECT 1 FROM section sec WHERE 
    sec.semester = 'Fall' 
    AND sec.year = 2009 
    AND c.course_id = sec.course_id
)
AND EXISTS(
    SELECT 1 FROM section sec WHERE 
    sec.semester = 'Spring' 
    AND sec.year = 2010 
    AND c.course_id = sec.course_id
);
/*14. Find all students who have taken all courses offered in the Biology department.*/
SELECT s.name, s.ID FROM student s WHERE NOT EXISTS(
    SELECT c.course_id
    FROM course c
    WHERE c.dept_name = 'Biology'
    AND NOT EXISTS(
        SELECT 1 
        FROM takes t WHERE t.ID = s.ID
        AND t.course_id = c.course_id
    )
);
/*15. Find all courses that were offered at most once in 2009.*/
SELECT course_id,title FROM course WHERE course_id NOT IN(
SELECT course_id
FROM section 
WHERE year = 2009 
GROUP BY course_id
HAVING count(course_id)>1);
/*16. Find all the students who have opted at least two courses offered by CSE department.*/
SELECT ID,COUNT(course_id) AS cnt
FROM takes 
WHERE course_id IN(
    SELECT course_id FROM course WHERE dept_name = 'Comp. Sci.'
) 
GROUP BY ID 
HAVING COUNT(course_id) >= 2;
/*17. Find the average instructors salary of those departments where the average salary is
greater than 42000*/
SELECT dept_name, AVG(salary) AS avg_salary 
FROM instructor 
GROUP BY dept_name 
HAVING AVG(salary) > 42000;
/*18. Create a view all_courses consisting of course sections offered by Physics
department in the Fall 2009, with the building and room number of each section.*/
CREATE view all_courses AS
SELECT course_id, building, room_number FROM section WHERE course_id IN(
    SELECT course_id  FROM section WHERE year = 2009 AND semester = 'Fall'
)
AND course_id IN(
    SELECT course_id FROM course WHERE dept_name = 'Physics'
);
/*19. Select all the courses from all_courses view.*/
SELECT * FROM all_courses;

/*20. Create a view department_total_salary consisting of department name and total
salary of that department.*/
CREATE view department_total_salary AS
SELECT dept_name, SUM(salary) AS tot_salary 
FROM instructor 
GROUP BY dept_name;

SELECT * FROM department_total_salary;

drop view department_total_salary;
