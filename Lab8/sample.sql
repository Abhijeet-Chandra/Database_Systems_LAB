-- 1. 🏆 Highest Paid Instructor per Department
-- 👉 For each department, find the instructor with the highest salary and print:
-- Dept | Instructor Name | Salary


SQL> BEGIN
  2     FOR x IN(
  3             SELECT i.dept_name, i.name, i.salary
  4             FROM instructor i
  5             WHERE i.salary = (
  6                     SELECT MAX(salary) as max_sal
  7                     FROM instructor j
  8                     where i.dept_name = j.dept_name
  9             )
 10     )
 11     LOOP
 12             DBMS_OUTPUT.PUT_LINE('Dept: ' || x.dept_name || ' Name: ' || x.name ||' Max sal: ' || x.salary);
 13     END LOOP;
 14  END;
 15  /
Dept: Finance Name: Wu Max sal: 90000
Dept: Music Name: Mozart Max sal: 40000
Dept: Physics Name: Einstein Max sal: 95000
Dept: History Name: Califieri Max sal: 62000
Dept: Biology Name: Crick Max sal: 72000
Dept: Comp. Sci. Name: Brandt Max sal: 92000
Dept: Elec. Eng. Name: Kim Max sal: 80000

PL/SQL procedure successfully completed.

-- 2. 📚 Students Taking More Than 2 Courses
SQL> DECLARE
  2     CURSOR c IS
  3     SELECT ID, COUNT(DISTINCT course_id) as cnt
  4     FROM takes
  5     GROUP BY ID
  6     HAVING COUNT(DISTINCT course_id) > 2;
  7  BEGIN
  8     FOR x IN c
  9     LOOP
 10             DBMS_OUTPUT.PUT_LINE('ID: ' || x.id || ' Count: ' || x.cnt);
 11     END LOOP;
 12  END;
 13  /
ID: 12345 Count: 4

PL/SQL procedure successfully complete


-- 3. 🎓 Advisor–Student Mapping (With Count)
-- 👉 For each instructor, print:
-- Instructor name
-- Number of students she advises

  2     CURSOR c IS
  3     SELECT i.name, i.id, COUNT(DISTINCT a.s_id) as cnt
  4     FROM instructor i
  5     LEFT JOIN advisor a
  6     ON a.i_id = i.id
  7     GROUP BY i.id, i.name;
  8  BEGIN
  9     FOR x IN c
 10     LOOP
 11             DBMS_OUTPUT.PUT_LINE('Name: ' || x.name || ' Count: ' || x.cnt);
 12     END LOOP;
 13  END;
 14  /
Name: Katz Count: 2
Name: Srinivasan Count: 1
Name: Singh Count: 1
Name: Einstein Count: 2
Name: Kim Count: 2
Name: Crick Count: 1
Name: Wu Count: 0
Name: Mozart Count: 0
Name: Brandt Count: 0
Name: Califieri Count: 0
Name: El Said Count: 0
Name: Gold Count: 0

PL/SQL procedure successfully completed.

-- 4. 💸 Department Budget vs Salary Check
-- 👉 For each department:
-- Calculate total salary of instructors
-- Compare with department budget
-- Print:
-- Dept | Total Salary | Budget | Status (Within/Exceeded)


SQL> DECLARE
  2     v_status VARCHAR2(10);
  3     CURSOR c IS
  4     SELECT d.dept_name, SUM(i.salary) as tot_sal, d.budget
  5     FROM department d JOIN
  6     instructor i ON d.dept_name = i.dept_name
  7     GROUP BY d.dept_name, d.budget;
  8  BEGIN
  9     FOR x in c
 10     LOOP
 11             IF x.budget >= x.tot_sal THEN
 12                     v_status := 'OK';
 13             ELSE
 14                     v_status := 'NOT OK';
 15             END IF;
 16
 17             DBMS_OUTPUT.PUT_LINE(
 18                     'Department: '
 19                     || x.dept_name ||
 20                     ', Total sal: '
 21                     || x.tot_sal ||
 22                     ', Budget: '
 23                     || x.budget ||
 24                     ', Status: ' || v_status
 25             );
 26     END LOOP;
 27  END;
 28  /
Department: Biology, Total sal: 72000, Budget: 90000, Status: OK
Department: Comp. Sci., Total sal: 232000, Budget: 100000, Status: NOT OK
Department: Elec. Eng., Total sal: 80000, Budget: 85000, Status: OK
Department: Finance, Total sal: 170000, Budget: 120000, Status: NOT OK
Department: History, Total sal: 122000, Budget: 50000, Status: NOT OK
Department: Music, Total sal: 40000, Budget: 80000, Status: OK
Department: Physics, Total sal: 182000, Budget: 70000, Status: NOT OK

PL/SQL procedure successfully completed.
