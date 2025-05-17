SELECT SYS_CONTEXT('USERENV', 'DB_NAME') AS database_name,
       SYS_CONTEXT('USERENV', 'CON_NAME') AS container_name,
       SYS_CONTEXT('USERENV', 'SESSION_USER') AS session_user
FROM dual;
ALTER SESSION SET CONTAINER = orclpdb5;
/*
ORCLPDB5	ORCLPDB5	USER2
*/

--13. From user2, create the employees table: ID, NAME, SALARY, DESCRIPTION.

CREATE TABLE employees (
    ID NUMBER,
    NAME VARCHAR2(100),
    SALARY NUMBER,
    DESCRIPTION VARCHAR2(200)
);
/*
Table EMPLOYEES created.
*/
--14. From user2, insert 2 rows to employees table.
INSERT INTO employees (ID, NAME, SALARY, DESCRIPTION)
VALUES (1, 'John Doe', 50000, 'Software Engineer');

INSERT INTO employees (ID, NAME, SALARY, DESCRIPTION)
VALUES (2, 'Jane Smith', 60000, 'Data Analyst');


--15. From user2, grant programing role to user3 and grant update (name,
--salary) on employees table to user3.

GRANT programming TO user3;

GRANT UPDATE (NAME, SALARY) ON employees TO user3;
/*
Grant succeeded.


Grant succeeded.
*/

--16. From user3, grant programing role to user1.
connect user3/user3@localhost:1521/orclpdb5
/*
Connected.
Connection created by CONNECT script command disconnected
*/
GRANT programming TO user1;
/*

Error starting at line : 47 in command -
GRANT programming TO user1
Error report -
ORA-01932: ADMIN option not granted for role 'PROGRAMMING'

https://docs.oracle.com/error-help/db/ora-01932/01932. 00000 -  "Role \"%s\" has not been granted with WITH ADMIN OPTION"
*Cause:    A role can be granted to another user or role only if the role has
           been granted WITH ADMIN OPTION.
*Action:   Grant the privilege or role to the user WITH ADMIN OPTION and retry
           the operation.
*/

--17. From user3, show privilege of user3.

 SELECT * FROM user_role_privs;
 /*
 USER3	PROGRAMMING	NO	NO	YES	NO	NO	NO
 */
 --18. From user3, query data from employees table.
 SELECT * FROM user2.employees;
 
 --19. From sys, grant select on employees to user1.
 GRANT SELECT ON user2.employees TO user1;
 /*
 
SQL> GRANT SELECT ON user2.employees TO user1;

Grant succeeded.
*/
--23. From user3, create table students (id, fullname, birthday)
CREATE TABLE students (
    id NUMBER,
    fullname VARCHAR2(100),
    birthday DATE
);
/*
Table STUDENTS created.
*/

--24. From user3, Create sequence named student_seq
CREATE SEQUENCE student_seq
START WITH 1
INCREMENT BY 1;
/*
Sequence STUDENT_SEQ created.
*/

SELECT * FROM user_sequences ;

--25. From user3, insert data into students table with ID is generated from the sequence.
INSERT INTO students (id, fullname, birthday)
VALUES (student_seq.NEXTVAL, 'Nguyen Van A', DATE '2000-05-10');

INSERT INTO students (id, fullname, birthday)
VALUES (student_seq.NEXTVAL, 'Tran Thi B', DATE '2001-12-25');
/*
1 row inserted.


1 row inserted.
*/
--26. How can user4 insert data into students table of user3?
/*
SQL> GRANT INSERT ON students TO user4;

Grant succeeded.
*/

--27. How can user4 delete data from students table of user3?
/*
SQL> GRANT DELETE ON students TO user4;

Grant succeeded.
*/
