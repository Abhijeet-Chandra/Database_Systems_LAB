
/* Schema Creation */
CREATE TABLE employee (
    emp_no NUMBER PRIMARY KEY,
    emp_name VARCHAR2(50),
    emp_address VARCHAR2(100)
);

/* Insert Records */
INSERT INTO employee VALUES (1,'A','YOYO');
INSERT INTO employee VALUES (2,'B','AAAA');
INSERT INTO employee VALUES (3,'C','MANIPAL');
INSERT INTO employee VALUES (4,'D','MANGALORE');
INSERT INTO employee VALUES (5,'E','MANIPAL');

/* Add New Column */
ALTER TABLE employee ADD (salary NUMBER);

/* Update Salaries */
UPDATE employee SET salary = 50000 WHERE emp_no = 1;
UPDATE employee SET salary = 51000 WHERE emp_no = 2;
UPDATE employee SET salary = 52000 WHERE emp_no = 3;
UPDATE employee SET salary = 53000 WHERE emp_no = 4;
UPDATE employee SET salary = 54000 WHERE emp_no = 5;

/* Commit Changes */
COMMIT;

DELETE FROM employee WHERE emp_address = 'MANGALORE';
COMMIT;

/* Rename Table */
RENAME employee TO employee1;

/* Queries */
SELECT * FROM employee1;

SELECT emp_name FROM employee1;

SELECT * FROM employee1 WHERE emp_address = 'MANIPAL';

DESC employee1;
