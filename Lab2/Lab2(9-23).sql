/*9*/
SELECT name, dept_name FROM STUDENT;
/*10*/
SELECT name FROM INSTRUCTOR WHERE dept_name = 'CSE';
/*11*/
SELECT title from course WHERE credits = 3 AND dept_name = 'CSE';
/*12*/
SELECT course_id, title FROM course WHERE course_id IN
(SELECT course_id FROM takes WHERE id = '12345');
/*13*/
SELECT name FROM instructor WHERE salary > 40000 AND salary <90000;
/*14*/
SELECT id from instructor WHERE id  NOT IN
(SELECT id FROM teaches);
/*but this will cause problem if id in teaches table is null, so alternate way:*/

SELECT i.id FROM instructor i WHERE NOT EXISTS
(
    SELECT 1 FROM teaches t WHERE t.id = i.id
);

/*15*/
SELECT s.name, c.title, sec.year FROM
student  s, course  c, section  sec, takes t
WHERE
sec.course_id = c.course_id
AND c.course_id = t.course_id
AND sec.semester = t.semester
AND sec.year = t.year
AND sec.sec_id = t.sec_id
AND s.id = t.id
AND sec.room_number = '303';

/*16*/
SELECT s.name, c.course_id, c.title AS c_name
FROM student s, course c, takes t
WHERE
t.year = 2015
AND t.course_id = c.course_id
AND t.id = s.id;

/*17*/
SELECT name, salary AS inst_salary from instructor WHERE salary > ANY 
(
    SELECT salary FROM instructor WHERE dept_name = 'CSE'
);

/*18*/
SELECT name FROM instructor WHERE dept_name LIKE '%ch%';

/*19*/
SELECT name, LENGTH(name) as name_length FROM student;

/*20*/
SELECT dept_name, SUBSTR(dept_name,3,3) as col FROM department;

/*21*/
SELECT UPPER(name) as upper_name FROM instructor;

/*22*/
SELECT time_slot_id,NVL(time_slot_id, 'N/A') as time_slot_status FROM section;

/*23*/
SELECT salary, Round(salary/3,2) as compressed FROM instructor;

