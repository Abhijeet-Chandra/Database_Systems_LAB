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
