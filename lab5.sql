/*
Tên: Phạm Hùng Quốc Việt
MSSV: 23521783
*/ 


ALTER PLUGGABLE DATABASE orclpdb OPEN;

SET AUTOCOMMIT OFF;

SET SERVEROUTPUT ON;

SET ECHO OFF;


CREATE TABLE PRODUCT (ID NUMBER PRIMARY KEY, QUANTITY INT, PRICE NUMBER);
INSERT INTO PRODUCT VALUES (1, 20, 90);
COMMIT;

SELECT * FROM PRODUCT WHERE ID=1;


------------------------------------------1. Rollback

create table Project (id number primary key,
                        pname varchar2(50),
                        cost    number);
insert into project values (1, 'jupiter', 2000);
insert into project values (2, 'saturn', 1000);
insert into project values (3, 'mercury', 15000);
commit;

select * from Project;
---------------------------------------t0
COMMIT;

---------------------------------------t1
SET TRANSACTION NAME 'cost_update';

---------------------------------------t2
SELECT XID, name, STATUS FROM V$TRANSACTION;
---------------------------------------t3
UPDATE project
    SET cost = 8000 
    WHERE id = 1;
----------------------------------------t4
SELECT XID, name, STATUS FROM V$TRANSACTION;
----------------------------------------t5
SELECT * FROM project;
----------------------------------------t6
ROLLBACK;

----------------------------------------t7
SELECT * FROM project;

----------------------------------------t8
SELECT XID, name, STATUS FROM V$TRANSACTION;

-------------------------------------------------2. Commit

----------------------------------------t1
COMMIT;
----------------------------------------t2
SELECT XID, name, STATUS FROM V$TRANSACTION;

-----------------------------------------t3
UPDATE project
    SET cost = 6000 
    WHERE id = 2;
-----------------------------------------t4
SELECT XID, name, STATUS FROM V$TRANSACTION;
-----------------------------------------t5
Insert into project values (4, 'neptune', 19000);
-----------------------------------------t6
SELECT XID, name, STATUS FROM V$TRANSACTION;
-----------------------------------------t7
COMMIT;
-----------------------------------------t8
SELECT * FROM project;
-----------------------------------------t9
SELECT XID, name, STATUS FROM V$TRANSACTION;
-------------------------------------------------3. Savepoint

-----------------------------------------t0
COMMIT;
-----------------------------------------t1
Select * from project;

-----------------------------------------t2
Update project set cost=400000
where pname='jupiter';

-----------------------------------------t3
SAVEPOINT after_jupiter_cost;
-----------------------------------------t4
Update project set cost=130
where pname='jupiter';

-----------------------------------------t5
SAVEPOINT after_mercury_cost;
-----------------------------------------t6
ROLLBACK TO SAVEPOINT after_jupiter_cost;


-----------------------------------------t7
Select * from project;
-----------------------------------------t8
Update project set cost=170
where pname='mercury';

-----------------------------------------t9
ROLLBACK;
-----------------------------------------t10
Select * from project;


-------------------------------------------------4. DDL

-----------------------------------------t0
COMMIT;

-----------------------------------------t1
Select * from project;
-----------------------------------------t2
SET TRANSACTION NAME 'cost_update2';
-----------------------------------------t3
Update project set cost=12300
where pname='jupiter';

-----------------------------------------t4
Select * from project;
-----------------------------------------t5
--DDL statement
Create table test (id number);

-----------------------------------------t6
Insert into test values (26);
-----------------------------------------t7
Rollback;
-----------------------------------------t8
Select * from project;
Select * from test;


/*
From SQLDeveloper: 
You can right click on a connection and chose 'Open SQL Worksheet' it will create another window for the existing session. (Use Alt + F10and select the connection from the list). 
If you need to create another independent session you can use Ctrl + Shift + N for an ongoing session.

Open two session (Ctrl + Shift + N) and do the following things.
1.	 Compare data at time t3 and t5
a.
*/

----------Session 1

-----------------------------------------t0
SET TRANSACTION NAME 'cost_update3';

-----------------------------------------t1
Select * from project;
-----------------------------------------t2
Update project set cost=467
where pname='jupiter';

-----------------------------------------t3
Select * from project;
-----------------------------------------t4
Rollback;
-----------------------------------------t5
Select * from project;


--b.

----------Session 1


-----------------------------------------t1
SET TRANSACTION NAME 'cost_update5';
-----------------------------------------t2
Update project set cost=1900
where pname='jupiter';


-----------------------------------------t3
Select * from project;
-----------------------------------------t4
Commit;
-----------------------------------------t5
Select * from project;


----2.	Compare data at time t3, t5 and t8

----------Session 1

-----------------------------------------t0
SET TRANSACTION NAME 'cost_update6';
-----------------------------------------t1
Select * from project;
-----------------------------------------t2
Update project set cost=3456
where pname='mercury';

-----------------------------------------t3
Select * from project;
-----------------------------------------t4

-----------------------------------------t5
Select * from project;
-----------------------------------------t6
Rollback;
-----------------------------------------t7

-----------------------------------------t8
Select * from project;




-------------

-----------------------------------------t0
SET TRANSACTION NAME 'cost_update8';
-----------------------------------------t1
Update project set cost=3490 where pname='mercury';
-----------------------------------------t2
Select * from project;
-----------------------------------------t3

-----------------------------------------t4
Select * from project;
-----------------------------------------t5
Create table test1 (id number);
-----------------------------------------t6
Rollback;
-----------------------------------------t7
Select * from project;
-----------------------------------------t8

-----------------------------------------t9
Select * from project;







