Q1:
SQL> CREATE TABLE employee(
  2  emp_no NUMBER(10) PRIMARY KEY,
  3  emp_name VARCHAR(50) NOT NULL,
  4  gender CHAR(1) NOT NULL,
  5  CHECK (gender IN('M','F')),
  6  salary NUMBER(10) NOT NULL,
  7  address VARCHAR(50) NOT NULL,
  8  DNo NUMBER(10) NOT NULL);
Q2:

SQL> CREATE TABLE department(
  2  dept_no NUMBER(10) PRIMARY KEY,
  3  dept_name VARCHAR(50) UNIQUE NOT NULL);

Table created.

Q3:
SQL> ALTER TABLE employee
  2  ADD(
  3  CONSTRAINT fk_emp_dept FOREIGN KEY (DNo) REFERENCES department(dept_no));

Q4:
SQL> INSERT INTO department VALUES(10,'HR');

1 row created.

SQL> INSERT INTO department VALUES(20,'IT');

1 row created.

SQL> INSERT INTO department VALUES(30, 'Finance');

1 row created.

SQL> INSERT INTO department VALUES(40, 'MARKETING');

1 row created.


SQL> INSERT INTO employee VALUES(101, 'Albert' ,'M', 50000, 'Delhi', 20);

1 row created. 

SQL> INSERT INTO employee VALUES(102, 'Joseph' ,'M', 56000, 'Lucknow', 40);

1 row created.

SQL> INSERT INTO employee VALUES(103, 'Clara' ,'F', 58000, 'Hyderabad', 20);

1 row created.

SQL> INSERT INTO employee VALUES(104, 'Marie' ,'F', 60000, 'Mangalore', 30);

1 row created


Q5:

SQL> INSERT INTO employee VALUES(101, 'John' ,'M', 65000, 'Mangalore', 10);
INSERT INTO employee VALUES(101, 'John' ,'M', 65000, 'Mangalore', 10)
*
ERROR at line 1:
ORA-00001: unique constraint (SYS.SYS_C008336) violated


SQL> INSERT INTO employee VALUES(105, 'John' ,'X', 65000, 'Mangalore', 10);
INSERT INTO employee VALUES(105, 'John' ,'X', 65000, 'Mangalore', 10)
*
ERROR at line 1:
ORA-02290: check constraint (SYS.SYS_C008335) violated


SQL> INSERT INTO employee VALUES(105, '' ,'M', 65000, 'Mangalore', 10);
INSERT INTO employee VALUES(105, '' ,'M', 65000, 'Mangalore', 10)
                                 *
ERROR at line 1:
ORA-01400: cannot insert NULL into ("SYS"."EMPLOYEE"."EMP_NAME")



Q6:

SQL> DELETE FROM department WHERE dept_no = 20;
DELETE FROM department WHERE dept_no = 20
*
ERROR at line 1:
ORA-02292: integrity constraint (SYS.FK_EMP_DEPT) violated - child record found


SQL> UPDATE employee SET DNo = 21 WHERE emp_no = 101;
UPDATE employee SET DNo = 21 WHERE emp_no = 101
*
ERROR at line 1:
ORA-02291: integrity constraint (SYS.FK_EMP_DEPT) violated - parent key not
found


Q7:

SQL> ALTER TABLE employee DROP CONSTRAINT fk_emp_dept;

Table altered.

SQL> ALTER TABLE employee
  2  ADD(
  3  CONSTRAINT cascade_emp_dept FOREIGN KEY (DNo) REFERENCES department (dept_no) ON DELETE CASCADE);

Table altered.

Q8:

SQL> ALTER TABLE employee MODIFY salary DEFAULT 10000;

Table altered.
