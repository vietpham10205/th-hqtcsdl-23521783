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




