--Q1 Retrieve the birth date and address of the employee(s) whose name is ‘John B.
-- Smith’. Retrieve the name and address of all employees who work for the ‘Research’ department.
SELECT Bdate, address
FROM employee
WHERE Fname = 'John'
AND minit = 'B'
AND Lname = 'Smith'


SELECT Fname, minit, Lname, address 
FROM employee WHERE Dno IN(
	SELECT Dnumber FROM department WHERE Dname = 'Research'
);

--Q2 For every project located in ‘Stanford’, list the project number, the controlling department number, and the department manager’s last name, address, and birth date.
SELECT p.Pnumber, p.Plocation, p.Dnum, e.Lname, e.Address, e.Bdate
FROM Project p
JOIN department d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn
WHERE p.Plocation = 'Stanford';
-- WILL GIVE NO ROWS SELECTED BECUASE THERE IS NO LOCATION NAMED STANFORD, INSTEAD IF WE DO STAFFORD, THE FOLLOWING IS DISPLAYED AS OUTPUT:
SELECT p.Pnumber, p.Plocation, p.Dnum, e.Lname, e.Address, e.Bdate
FROM Project p
JOIN department d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn
-- WHERE p.Plocation = 'Stafford';
--    PNUMBER PLOCATION             DNUM LNAME
-- ---------- --------------- ---------- ---------------
-- ADDRESS                        BDATE
-- ------------------------------ ---------
--         10 Stafford                 4 Wallace
-- 291 Berry, Bellaire, TX        20-JUN-41

  
--Q3 For each employee, retrieve the employee’s first and last name and the first and last name of his or her immediate supervisor.
SELECT e.Fname as emp_fname, e.Lname as emp_lname, sup.Fname as sup_fname, sup.Lname as sup_lname
FROM employee e
JOIN employee sup
ON e.Super_ssn = sup.ssn;

-- Q4 Make a list of all project numbers for projects that involve an employee whose last name is ‘Smith’, either as a worker or as a manager of the department that controls the project.

SELECT p.Pnumber
FROM Project p 
JOIN works_on w ON p.Pnumber = w.Pno
JOIN employee e ON w.Essn = e.Ssn
WHERE e.Lname = 'Smith'
UNION
SELECT p.Pnumber
FROM Project p
JOIN department d ON p.Dnum = d.Dnumber
JOIN employee e ON d.Mgr_ssn = e.Ssn
WHERE e.Lname = 'Smith'

--Q5 Show the resulting salaries if every employee working on the ‘ProductX’ project is given a 10 percent raise.
SELECT e.Fname, e.minit, e.Lname, e.salary, e.salary*1.1 as raised
FROM Project p
JOIN works_on w ON p.Pnumber = w.Pno
JOIN employee e ON w.Essn = e.Ssn
WHERE p.Pname = 'ProductX';

--Q6 Retrieve a list of employees and the projects they are working on, ordered by department and, within each department, ordered alphabetically by last name, then first name.
SELECT e.Fname, e.Lname, d.Dname, p.Pname 
FROM Project p
JOIN works_on w ON p.Pnumber = w.Pno
JOIN employee e ON w.Essn = e.Ssn
JOIN department d ON p.Dnum = d.Dnumber
ORDER BY d.Dname, e.Lname, e.Fname;

-- Q7 Retrieve the name of each employee who has a dependent with the same first name and is the same sex as the employee.
SELECT e.Fname, e.Minit, e.Lname, d.dependent_name
FROM employee e
JOIN dependent d ON e.Ssn = d.Essn
WHERE e.Fname = d.Dependent_name
AND e.sex = d.sex;

-- Q8 Retrieve the names of employees who have no dependents
SELECT Ssn, Fname, Minit, Lname
FROM employee WHERE Ssn IN(
SELECT Ssn FROM employee MINUS SELECT Essn FROM dependent);

-- Q9 List the names of managers who have at least one dependent.
SELECT Ssn, Fname, minit, Lname
FROM employee WHERE Ssn IN(
	SELECT d.Mgr_ssn
	FROM Department d
	JOIN dependent de ON d.Mgr_ssn = de.Essn
	JOIN employee e ON d.Mgr_ssn = e.Ssn
	GROUP BY d.Mgr_ssn
	HAVING COUNT(DISTINCT de.Essn)>=1
);

--Q10 Find the sum of the salaries of all employees, the maximum salary, the minimum salary, and the average salary.
SELECT SUM(salary) as sum,
MAX(salary) as max_sal,
MIN(salary) as min_sal,
AVG(salary) as avg_sal
FROM employee;

-- Q11 For each project, retrieve the project number, the project name, and the number of employees who work on that project.
SELECT p.Pnumber, p.Pname, COUNT(DISTINCT w.Essn)
FROM project p
JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, p.Pname;

--Q12 For each project on which more than two employees work, retrieve the project number, the project name, and the number of employees who work on the project.
SELECT p.Pnumber, p.Pname, COUNT(DISTINCT w.Essn)
FROM project p
JOIN works_on w ON p.Pnumber = w.Pno
GROUP BY p.Pnumber, p.Pname
HAVING COUNT(DISTINCT w.Essn) > 2;

--Q13 For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than 40,000
SELECT dno, COUNT(DISTINCT Ssn) as count
FROM employee
WHERE salary > 40000
GROUP BY dno
HAVING COUNT(DISTINCT Ssn) > 5;
