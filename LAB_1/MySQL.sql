/*schema:*/
  
CREATE TABLE employee(
    emp_no INT PRIMARY KEY,
    emp_name VARCHAR(50),
    emp_address VARCHAR(100)
);

INSERT INTO employee VALUES(1,'A','YOYO');
INSERT INTO employee VALUES(2,'B','AAAA');
INSERT INTO employee VALUES(3,'C','MANIPAL');
INSERT INTO employee VALUES(4,'D','MANGALORE');
INSERT INTO employee VALUES(5,'E','MANIPAL');
ALTER TABLE employee ADD (salary INT);
UPDATE employee SET salary = 50000 WHERE emp_no = 1;
UPDATE employee SET salary = 51000 WHERE emp_no = 2;
UPDATE employee SET salary = 52000 WHERE emp_no = 3;
UPDATE employee SET salary = 53000 WHERE emp_no = 4;
UPDATE employee SET salary = 54000 WHERE emp_no = 5;

RENAME TABLE employee TO employee1;


/*queries:*/

/*before renaming: 
SELECT * FROM employee;

SELECT emp_name FROM employee;

SELECT * FROM employee WHERE emp_address = 'MANIPAL';

DESCRIBE employee;*/

/*after renaming:*/ 
SELECT * FROM employee1;

SELECT emp_name FROM employee1;

SELECT * FROM employee1 WHERE emp_address = 'MANIPAL';

DESCRIBE employee1;
