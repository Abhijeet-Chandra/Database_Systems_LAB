# **Q1**



SQL> CREATE TABLE employee(

&nbsp; 2  emp\_no NUMBER(10) PRIMARY KEY,

&nbsp; 3  emp\_name VARCHAR(50) NOT NULL,

&nbsp; 4  gender CHAR(1) NOT NULL,

&nbsp; 5  CHECK (gender IN ('M','F'))

&nbsp; 6  );



Table created.



SQL> DESC employee;

&nbsp;Name                                      Null?    Type

&nbsp;----------------------------------------- -------- ----------------------------

&nbsp;EMP\_NO                                    NOT NULL NUMBER(10)

&nbsp;EMP\_NAME                                  NOT NULL VARCHAR2(50)

&nbsp;GENDER                                    NOT NULL CHAR(1)





# **Q2**



SQL> CREATE TABLE department(

&nbsp; 2  dept\_no NUMBER(10) PRIMARY KEY,

&nbsp; 3  dept\_name VARCHAR(50) UNIQUE NOT NULL);





# **Q3**

SQL> ALTER TABLE employee ADD DNo NUMBER(10);



SQL> ALTER TABLE employee

&nbsp; 2  ADD (

&nbsp; 3    CONSTRAINT fk\_emp\_dept

&nbsp; 4    FOREIGN KEY (dno)

&nbsp; 5    REFERENCES department(dept\_no)

&nbsp; 6  );









# **Q4**

SQL> INSERT INTO department VALUES(10,'HR');



1 row created.



SQL> INSERT INTO department VALUES(20,'IT');



1 row created.



SQL> INSERT INTO department VALUES(30, 'Finance');



1 row created.



SQL> INSERT INTO department VALUES(40, 'MARKETING');



1 row created.





SQL> INSERT INTO employee VALUES (101, 'Albert', 'M', 20);



1 row created.

&nbsp;                                               

SQL> INSERT INTO employee VALUES (102, 'Joseph', 'M', 10);



1 row created.



SQL> INSERT INTO employee VALUES (103, 'Clara', 'F', 30);



1 row created.



SQL> INSERT INTO employee VALUES (104, 'Marie', 'F', 20);



1 row created.





SQL> select \* from employee;



&nbsp;   EMP\_NO EMP\_NAME                                           G        DNO

---------- -------------------------------------------------- - ----------

&nbsp;      101 Albert                                             M         20

&nbsp;      102 Joseph                                             M         10

&nbsp;      103 Clara                                              F         30

&nbsp;      104 Marie                                              F         20



SQL> select \* from department

&nbsp; 2  ;



&nbsp;  DEPT\_NO DEPT\_NAME

---------- --------------------------------------------------

&nbsp;       10 HR

&nbsp;       20 IT

&nbsp;       30 Finance

&nbsp;       40 MARKETING



# **Q5**



## **PRIMARY KEY CONSTRAINT VIOLATION:**



SQL> INSERT INTO employee VALUES (***104***, 'John', 'M', 10);

INSERT INTO employee VALUES (104, 'John', 'M', 10)

\*

ERROR at line 1:

ORA-00001: unique constraint (SYS.SYS\_C008324) violated



## **CHECK CONSTRAINT VIOLATION:**



SQL> INSERT INTO employee VALUES (105, 'Marie', 'X', 20);

INSERT INTO employee VALUES (105, 'Marie', ***'X'***, 20)

\*

ERROR at line 1:

ORA-02290: check constraint (SYS.SYS\_C008323) violated





## **NULL CONSTRAINT VIOLATION:**



SQL> INSERT INTO employee VALUES (105, '', 'F', 20);

INSERT INTO employee VALUES (105, '', 'F', 20)

&nbsp;                                 \*

ERROR at line 1:

ORA-01400: cannot insert NULL into ("SYS"."EMPLOYEE"."EMP\_NAME")





# **Q6**



## **UPDATING FOREIGN KEY TO A WRONG VALUE:**

SQL> UPDATE employee SET DNo = 21 WHERE emp\_no = 101;

UPDATE employee SET DNo = 21 WHERE emp\_no = 101

\*

ERROR at line 1:

ORA-02291: integrity constraint (SYS.FK\_EMP\_DEPT) violated - parent key not

found



### **DELETING ENTRY FROM PARENT WHOSE DATA/TUPLE IS STILL BEING USED BY ITS CHILD:**

SQL> DELETE FROM department WHERE dept\_no = 20;

DELETE FROM department WHERE dept\_no = 20

\*

ERROR at line 1:

ORA-02292: integrity constraint (SYS.FK\_EMP\_DEPT) violated - child record found





# **Q7**

//first delete foreign key:



**SQL> ALTER TABLE employee DROP CONSTRAINT fk\_emp\_dept;**



//now build it again



**SQL> ALTER TABLE employee**

  **2  ADD(**

  **3  CONSTRAINT fk\_emp\_dept FOREIGN KEY (DNo)**

  **4  REFERENCES department(dept\_no)**

  **5  ON DELETE CASCADE**

  **6  );**



Table altered.



**SQL> DELETE from department WHERE dept\_no = 30;**



1 row deleted.



**SQL> SELECT \* from employee;**



&nbsp;   EMP\_NO EMP\_NAME                                           G        DNO

---------- -------------------------------------------------- - ----------

&nbsp;      101 Albert                                             M        20

&nbsp;      102 Joseph                                             M        10

&nbsp;      104 Marie                                              F        20





# Q8



ALTER TABLE employee ADD salary NUMBER(10) DEFAULT 10000;















