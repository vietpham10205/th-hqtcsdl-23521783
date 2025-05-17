--Exercise 1: Do the following things using sqlplus and write the results into your answer sheet.
--login pdb4
ALTER PLUGGABLE DATABASE orclpdb4 OPEN;

/*
ALTER PLUGGABLE DATABASE orclpdb4 OPEN
Error report -
ORA-65019: pluggable database ORCLPDB4 already open
*/
ALTER SESSION SET CONTAINER=orclpdb4;

/*
Session altered.
*/
SHOW CON_NAME
/*
CON_NAME 
------------------------------
ORCLPDB4

*/
connect adminpdb4/pdbpassword@localhost:1521/orclpdb4
/*
Connected.
Connection created by CONNECT script command disconnected
*/

SELECT SYS_CONTEXT('USERENV', 'DB_NAME') AS database_name,
       SYS_CONTEXT('USERENV', 'CON_NAME') AS container_name,
       SYS_CONTEXT('USERENV', 'SESSION_USER') AS session_user
FROM dual;
/*
ORCLPDB4	ORCLPDB4	ADMINPDB4
*/

--6. In this PDB, create 3 user: user1, user2, user3.
CREATE USER user1 IDENTIFIED BY user1;
/*
User USER1 created.
*/
CREATE USER user2 IDENTIFIED BY user2;
/*
User USER2 created.
*/
CREATE USER user3 IDENTIFIED BY user3;
/*
User USER3 created.
*/

--Exercise 2: Do the following things using sqlplus and write the results into your answer sheet.

--7. Connect to user1.

connect user1/user1@localhost:1521/orclpdb4;
/*
  connect ...
Error report -
Connection Failed
Connection failed
  USER          = user1
  URL           = jdbc:oracle:thin:@localhost:1521/orclpdb4
  Error Message = ORA-01045: user USER1 lacks CREATE SESSION privilege; logon denied

https://docs.oracle.com/error-help/db/ora-01045/
*/

--8. Connect to sys user (or ADMIN user) of PDB above.
connect adminpdb4/pdbpassword@localhost:1521/orclpdb4;
/*
Connected.
Connection created by CONNECT script command disconnected
*/
--9. Create a role named manager.
CREATE ROLE manager;
/*
Role MANAGER created.
*/

--10.Grant CREATE SESSION, CREATE TABLE to manager role WITH ADMIN OPTION.

GRANT CREATE SESSION, CREATE TABLE TO manager WITH ADMIN OPTION;
/*
Grant succeeded.
*/
--11. Grant manager role to user1.
GRANT manager TO user1;
/*
Grant succeeded.
*/

--12.Connect to user1.
connect user1/user1@localhost:1521/orclpdb4;
/*
Connected.
Connection created by CONNECT script command disconnected
*/

--13.Create a TEST table (ID NUMBER, NAME VARCHAR2(100))
CREATE TABLE TEST (
    ID NUMBER,
    NAME VARCHAR2(100)
);
/*
Table TEST created.
*/

--14. Grant manager role to user2.
GRANT manager TO user2; //Đang connect bằng user1 nên khong cấp role manager cho user2 được vì( lúc cấp cho user1 không có WITH ADMIN OPTION.)
/*
GRANT manager TO user2
Error report -
ORA-01932: ADMIN option not granted for role 'MANAGER'

https://docs.oracle.com/error-help/db/ora-01932/01932. 00000 -  "Role \"%s\" has not been granted with WITH ADMIN OPTION"
*Cause:    A role can be granted to another user or role only if the role has
           been granted WITH ADMIN OPTION.
*Action:   Grant the privilege or role to the user WITH ADMIN OPTION and retry
           the operation.
*/

--15. Grant CREATE SESSION privilege to user2;
GRANT CREATE SESSION TO user2;
/*
Grant succeeded.
*/

// Trước khi connect vào user2 thì phải thoát phiên làm việc của user1


--16. Connect to user 2, create a table.
connect user2/user2@localhost:1521/orclpdb4;
/*
Connected.
Connection created by CONNECT script command disconnected
*/

--17. From user2, grant CREATE SESSION privilege to user3.
GRANT CREATE SESSION TO user3;
// lỗi vì user2 không có quyền
/*
GRANT CREATE SESSION TO user3
Error report -
ORA-01031: insufficient privileges

https://docs.oracle.com/error-help/db/ora-01031/01031. 00000 -  "insufficient privileges"
*Document: YES
*Cause:    A database operation was attempted without the required
           privilege(s).
*Action:   Ask your database administrator or security administrator to grant
           you the required privilege(s).
*/

--18. Connect to SYS user of this PDB.
connect SYS/phamviet10022005@localhost:1521/orclpdb4 AS SYSDBA
// phải disconected khỏi connection đang sử dụng rồi connect lại bằng adminpdb4
/*
Connected.
Connection created by CONNECT script command disconnected
*/

--19. Grant manager role to user3 WITH ADMIN OPTION.
GRANT manager TO user3 WITH ADMIN OPTION;
/*
Grant succeeded.
*/

--20. Connect to user3.
connect user3/user3@localhost:1521/orclpdb4;
/*
Connected.
Connection created by CONNECT script command disconnected
*/

--21.Grant manager role to user2
GRANT manager TO user2;
/*
Grant succeeded.
*/

--22.From user3, how can you create a table in user2 schema?
-- Connect as SYS or another user with GRANT ANY TABLE privilege
GRANT CREATE ANY TABLE TO user3;
/*
Grant succeeded.
*/
CREATE TABLE user2.another_test_table (
    id NUMBER,
    description VARCHAR2(50)
);
/*
Table USER2.ANOTHER_TEST_TABLE created.
*/
--23.From user3, query the roles and privilege of current user.

SELECT role
FROM session_roles;
/*
MANAGER
*/
SELECT privilege
FROM session_privs;
/*
CREATE SESSION
CREATE TABLE
CREATE ANY TABLE
*/






