-- 1. Based on the University database Schema in Lab 2, write a row trigger that records
-- along with the time any change made in the Takes (ID, course-id, sec-id, semester, year, grade) table in log_change_Takes (Time_Of_Change, ID, courseid,sec-id, semester, year, grade).

CREATE TABLE log_change_takes(
   time_of_change DATE,
   id VARCHAR2(10),
   course_id VARCHAR2(10),
   sec_id VARCHAR2(10),
   semester VARCHAR2(10),
   year NUMBER,
   grade VARCHAR2(2)
);


CREATE OR REPLACE TRIGGER trg_log_change_takes
AFTER INSERT OR UPDATE OR DELETE ON takes
FOR EACH ROW
BEGIN
	IF INSERTING THEN
	INSERT INTO log_change_takes
	VALUES(SYSDATE, :NEW.ID, :NEW.COURSE_ID, :NEW.SEC_ID, :NEW.SEMESTER, :NEW.YEAR, :NEW.GRADE);

	ELSIF UPDATING THEN
	INSERT INTO log_change_takes
	VALUES(SYSDATE, :NEW.ID, :NEW.COURSE_ID, :NEW.SEC_ID, :NEW.SEMESTER, :NEW.YEAR, :NEW.GRADE);	

	ELSIF DELETING THEN
	INSERT INTO log_change_takes
	VALUES(SYSDATE, :OLD.ID, :OLD.COURSE_ID, :OLD.SEC_ID, :OLD.SEMESTER, :OLD.YEAR, :OLD.GRADE);
	
	END IF;
END;
/

-- 2. Based on the University database schema in Lab: 2, write a row trigger to insert -- the existing values of the Instructor (ID, name, dept-name, salary)
-- table into a new table Old_ Data_Instructor (ID, name, dept-name, salary) when the salary table is updated.

CREATE TABLE OLD_DATA_INSTRUCTOR (
    ID        VARCHAR2(10),
    NAME      VARCHAR2(20),
    DEPT_NAME VARCHAR2(20),
    SALARY    NUMBER(10)
);

CREATE OR REPLACE TRIGGER trg_update_instructor 
AFTER UPDATE OF SALARY ON INSTRUCTOR
FOR EACH ROW
BEGIN
    INSERT INTO OLD_DATA_INSTRUCTOR VALUES (:OLD.ID, :OLD.NAME, :OLD.DEPT_NAME, :OLD.SALARY);
END;
/

--testing:
UPDATE INSTRUCTOR SET salary = 10000 WHERE id = '10101';

select * from OLD_DATA_INSTRUCTOR;


-- 3. Based on the University Schema, write a database trigger on Instructor that checks
-- the following:
--  The name of the instructor is a valid name containing only alphabets.  The salary of an instructor is not zero and is positive
--  The salary does not exceed the budget of the department to which the
-- instructor belongs

CREATE OR REPLACE TRIGGER triggu
BEFORE INSERT OR UPDATE ON instructor
FOR EACH ROW
DECLARE
	v_budget department.budget%type;
BEGIN
	IF NOT REGEXP_LIKE(:NEW.name, '^[A-Za-z ]+$') THEN
		RAISE_APPLICATION_ERROR(-20001, 'NAME SHOULD CONTAIN ONLY ALPHABETS');
	END IF;
	IF :NEW.salary <=0  THEN
		RAISE_APPLICATION_ERROR(-20002, 'salary should be positive nigga');
	END IF;
	SELECT budget into v_budget FROm department WHERE dept_name = :NEW.dept_name;
	IF :NEW.salary > v_budget THEN
		RAISE_APPLICATION_ERROR(-20003, 'salary should be less than budget');
	END IF;
END;
/

-- 4. Create a transparent audit system for a table Client_master (client_no, name,
-- address, Bal_due). The system must keep track of the records that are being deleted or updated. The functionality being when a record is deleted or modified the original record details and the date of operation are stored in the auditclient (client_no, name, bal_due, operation, userid, opdate) table, then the delete or update is allowed to go through.


CREATE OR REPLACE TRIGGER triggu
BEFORE UPDATE OR DELETE ON Client_master
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        INSERT INTO auditclient VALUES(:OLD.client_no, :OLD.name, :OLD.bal_due, 'UPDATE', USER , SYSDATE);
    END IF;

    IF DELETING THEN
        INSERT INTO auditclient VALUES(:OLD.client_no, :OLD.name, :OLD.bal_due, 'DELETE', USER, SYSDATE);
    END IF;
END;
/
