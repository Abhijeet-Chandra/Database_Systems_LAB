/*==============================
  LEVEL 1 – INDEPENDENT TABLES
==============================*/

/* Department */
CREATE TABLE department (
    dept_name VARCHAR2(20) PRIMARY KEY,
    building  VARCHAR2(15),
    budget    NUMBER(12,2)
);

/* Classroom */
CREATE TABLE classroom (
    building     VARCHAR2(15),
    room_number  VARCHAR2(7),
    capacity     NUMBER(4),
    CONSTRAINT classroom_pk
        PRIMARY KEY (building, room_number)
);

/* Time Slot */
CREATE TABLE time_slot (
    time_slot_id VARCHAR2(4),
    day          VARCHAR2(1),
    start_time   DATE,
    end_time     DATE,
    CONSTRAINT time_slot_pk
        PRIMARY KEY (time_slot_id, day, start_time)
);



/*==============================
  LEVEL 2 – DEPEND ON LEVEL 1
==============================*/

/* Student */
CREATE TABLE student (
    ID        VARCHAR2(5) PRIMARY KEY,
    name      VARCHAR2(20) NOT NULL,
    dept_name VARCHAR2(20),
    tot_cred  NUMBER(3),
    CONSTRAINT student_dept_fk
        FOREIGN KEY (dept_name)
        REFERENCES department(dept_name)
        ON DELETE SET NULL
);

/* Instructor */
CREATE TABLE instructor (
    ID        VARCHAR2(5) PRIMARY KEY,
    name      VARCHAR2(20) NOT NULL,
    dept_name VARCHAR2(20),
    salary    NUMBER(8,2),
    CONSTRAINT instructor_dept_fk
        FOREIGN KEY (dept_name)
        REFERENCES department(dept_name)
        ON DELETE SET NULL
);

/* Course */
CREATE TABLE course (
    course_id VARCHAR2(8) PRIMARY KEY,
    title     VARCHAR2(50),
    dept_name VARCHAR2(20),
    credits   NUMBER(2),
    CONSTRAINT course_dept_fk
        FOREIGN KEY (dept_name)
        REFERENCES department(dept_name)
        ON DELETE SET NULL
);



/*==============================
  LEVEL 3 – DEPEND ON LEVEL 2
==============================*/

/* Section */
CREATE TABLE section (
    course_id    VARCHAR2(8),
    sec_id       VARCHAR2(8),
    semester     VARCHAR2(6),
    year         NUMBER(4),
    building     VARCHAR2(15),
    room_number  VARCHAR2(7),
    time_slot_id VARCHAR2(4),
    CONSTRAINT section_pk
        PRIMARY KEY (course_id, sec_id, semester, year),
    CONSTRAINT section_course_fk
        FOREIGN KEY (course_id)
        REFERENCES course(course_id)
        ON DELETE CASCADE,
    CONSTRAINT section_classroom_fk
        FOREIGN KEY (building, room_number)
        REFERENCES classroom(building, room_number)
        ON DELETE SET NULL
);

/* Takes */
CREATE TABLE takes (
    ID        VARCHAR2(5),
    course_id VARCHAR2(8),
    sec_id    VARCHAR2(8),
    semester  VARCHAR2(6),
    year      NUMBER(4),
    grade     VARCHAR2(2),
    CONSTRAINT takes_pk
        PRIMARY KEY (ID, course_id, sec_id, semester, year),
    CONSTRAINT takes_student_fk
        FOREIGN KEY (ID)
        REFERENCES student(ID)
        ON DELETE CASCADE,
    CONSTRAINT takes_section_fk
        FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
        ON DELETE CASCADE
);

/* Teaches */
CREATE TABLE teaches (
    ID        VARCHAR2(5),
    course_id VARCHAR2(8),
    sec_id    VARCHAR2(8),
    semester  VARCHAR2(6),
    year      NUMBER(4),
    CONSTRAINT teaches_pk
        PRIMARY KEY (ID, course_id, sec_id, semester, year),
    CONSTRAINT teaches_instructor_fk
        FOREIGN KEY (ID)
        REFERENCES instructor(ID)
        ON DELETE CASCADE,
    CONSTRAINT teaches_section_fk
        FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year)
        ON DELETE CASCADE
);

/* Advisor */
CREATE TABLE advisor (
    s_ID VARCHAR2(5) PRIMARY KEY,
    i_ID VARCHAR2(5),
    CONSTRAINT advisor_student_fk
        FOREIGN KEY (s_ID)
        REFERENCES student(ID)
        ON DELETE CASCADE,
    CONSTRAINT advisor_instructor_fk
        FOREIGN KEY (i_ID)
        REFERENCES instructor(ID)
        ON DELETE SET NULL
);

/* Prereq */
CREATE TABLE prereq (
    course_id VARCHAR2(8),
    prereq_id VARCHAR2(8),
    CONSTRAINT prereq_pk
        PRIMARY KEY (course_id, prereq_id),
    CONSTRAINT prereq_course_fk
        FOREIGN KEY (course_id)
        REFERENCES course(course_id)
        ON DELETE CASCADE,
    CONSTRAINT prereq_prereq_fk
        FOREIGN KEY (prereq_id)
        REFERENCES course(course_id)
);

/*==============================
  LEVEL 1 – INDEPENDENT TABLES
==============================*/

/* Department */
INSERT INTO department VALUES ('CSE',  'Block-A', 500000);
INSERT INTO department VALUES ('ECE',  'Block-B', 400000);
INSERT INTO department VALUES ('MECH', 'Block-C', 300000);

/* Classroom */
INSERT INTO classroom VALUES ('Block-A', '101', 60);
INSERT INTO classroom VALUES ('Block-B', '202', 50);
INSERT INTO classroom VALUES ('Block-C', '303', 40);

/* Time Slot */
INSERT INTO time_slot VALUES ('T1', 'M', TO_DATE('09:00','HH24:MI'), TO_DATE('10:00','HH24:MI'));
INSERT INTO time_slot VALUES ('T1', 'W', TO_DATE('09:00','HH24:MI'), TO_DATE('10:00','HH24:MI'));
INSERT INTO time_slot VALUES ('T2', 'T', TO_DATE('10:00','HH24:MI'), TO_DATE('11:00','HH24:MI'));



/*==============================
  LEVEL 2 – DEPEND ON LEVEL 1
==============================*/

/* Student */
INSERT INTO student VALUES ('12345', 'Ananya', 'CSE',  90);
INSERT INTO student VALUES ('12346', 'Riya',   'CSE',  75);
INSERT INTO student VALUES ('12347', 'Neha',   'ECE',  80);
INSERT INTO student VALUES ('12348', 'Kavya',  'MECH', 60);

/* Instructor */
INSERT INTO instructor VALUES ('I101', 'Sharma', 'CSE',  85000);
INSERT INTO instructor VALUES ('I102', 'Mehta',  'CSE',  60000);
INSERT INTO instructor VALUES ('I103', 'Rao',    'ECE',  45000);
INSERT INTO instructor VALUES ('I104', 'Singh',  'MECH', 95000);
INSERT INTO instructor VALUES ('I105', 'Patel',  'CSE',  30000);

/* Course */
INSERT INTO course VALUES ('CS101', 'Data Structures', 'CSE',  3);
INSERT INTO course VALUES ('CS102', 'Algorithms',     'CSE',  3);
INSERT INTO course VALUES ('CS103', 'DBMS',           'CSE',  4);
INSERT INTO course VALUES ('EC101', 'Signals',        'ECE',  3);



/*==============================
  LEVEL 3 – DEPEND ON LEVEL 2
==============================*/

/* Section */
INSERT INTO section VALUES ('CS101', 'S1', 'Fall',   2015, 'Block-A', '101', 'T1');
INSERT INTO section VALUES ('CS102', 'S1', 'Spring', 2015, 'Block-C', '303', 'T2');
INSERT INTO section VALUES ('EC101', 'S1', 'Fall',   2016, 'Block-B', '202', 'T1');

/* Takes */
INSERT INTO takes VALUES ('12345', 'CS101', 'S1', 'Fall',   2015, 'A');
INSERT INTO takes VALUES ('12345', 'CS102', 'S1', 'Spring', 2015, 'B');
INSERT INTO takes VALUES ('12346', 'CS101', 'S1', 'Fall',   2015, 'A');
INSERT INTO takes VALUES ('12347', 'EC101', 'S1', 'Fall',   2016, 'B');

/* Teaches */
INSERT INTO teaches VALUES ('I101', 'CS101', 'S1', 'Fall',   2015);
INSERT INTO teaches VALUES ('I102', 'CS102', 'S1', 'Spring', 2015);
INSERT INTO teaches VALUES ('I103', 'EC101', 'S1', 'Fall',   2016);

/* Advisor */
INSERT INTO advisor VALUES ('12345', 'I101');
INSERT INTO advisor VALUES ('12346', 'I102');

/* Prereq */
INSERT INTO prereq VALUES ('CS102', 'CS101');
INSERT INTO prereq VALUES ('CS103', 'CS102');

COMMIT;
