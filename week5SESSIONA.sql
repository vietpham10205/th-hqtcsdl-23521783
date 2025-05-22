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

----------------------------------------------Transaction Processing in PL/SQL

CREATE TABLE accounts (account_id NUMBER(6), balance NUMBER (10,2),
			check (balance>=0));
INSERT INTO accounts VALUES (7715, 6350.00); 
INSERT INTO accounts VALUES (7720, 5100.50); 
COMMIT;
----
drop table accounts;
----

--------------------1.	Example: transfer money ($250) from account 7715 to 7720

--t0
SELECT * FROM accounts;
--t1
DECLARE
  transfer NUMBER(8,2) := 250;
BEGIN
  UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
  COMMIT;
END;
--t2
SELECT * FROM accounts;





---------------------2.	Example: Transfer money ($9000) from account 7715 to 7720
--t0
SELECT * FROM accounts;

--t1
DECLARE
  transfer NUMBER(8,2) := 9000;
BEGIN
  UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
  COMMIT;
END;

--t2
SELECT * FROM accounts;


-------------------------3.	Example: Transfer money ($9000) from account 7715 to 7720
--t0
SELECT * FROM accounts;
--t1
DECLARE
  transfer NUMBER(8,2) := 9000;
BEGIN
    UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
    UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  COMMIT;
END;
--t2
SELECT * FROM accounts;


-----------------------------4.	Example: Transfer money ($9000) from account 7715 to 7720

--t0
SELECT * FROM accounts;
--t1
DECLARE
  transfer NUMBER(8,2) := 9000;
BEGIN
    UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
    COMMIT;
    UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  COMMIT;
END;
--t2
SELECT * FROM accounts;



-----------------------------5.	Example: PL/SQL WITH EXCEPTION
--t0
SELECT * FROM accounts;
--t1
SET SERVEROUTPUT ON
DECLARE
  transfer NUMBER(8,2) := 9000;
BEGIN
    UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
    UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  COMMIT;
    EXCEPTION WHEN OTHERS THEN
        Dbms_output.put_line ('error!!!!!!!!! ');
END;
--t2
SELECT * FROM accounts;


------------------------------6.	Example: PL/SQL WITH EXCEPTION
--t0
SELECT * FROM accounts;
--t1
SET SERVEROUTPUT ON
DECLARE
  transfer NUMBER(8,2) := 9000;
BEGIN
    UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
    UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  COMMIT;
    EXCEPTION WHEN OTHERS THEN
        RAISE;        
END;
--t2
SELECT * FROM accounts;

------------------------------7.	Example: PL/SQL WITH EXCEPTION
--t0
SELECT * FROM accounts;
--t1
SET SERVEROUTPUT ON
DECLARE
  transfer NUMBER(8,2) := 9000;
BEGIN
    UPDATE accounts SET balance = balance + transfer WHERE account_id = 7720;
COMMIT;
    UPDATE accounts SET balance = balance - transfer WHERE account_id = 7715;
  
    EXCEPTION WHEN OTHERS THEN
        RAISE;        
END;

--t2
SELECT * FROM accounts;

/*

2. Điều khiển đồng thời
Connect to sys:
Sqlplus / as SYSDBA
Create a pluggable database:
CREATE PLUGGABLE DATABASE WEEK5PDB ADMIN USER lab IDENTIFIED BY userpass ROLES=(DBA) FILE_NAME_CONVERT=('PDBSEED','WEEK5PDB');
ALTER PLUGGABLE DATABASE WEEK5PDB OPEN;
--connect to system of week5pdb 
CONNECT system/password@localhost/WEEK5PDB
CREATE USER week5 identified by userpass;
GRANT DBA TO week5;

Using sqldeveloper to connect to week5:
From Sqldeveloper, open two independent session (Ctrl + Shift + N), called session A and session B.

*/
--I.	Locks, blocks and deadlocks
--1.	Blocked Inserts
--a.

---SESSION A 
SET AUTOCOMMIT OFF;

--
CREATE  TABLE  TEST (ID NUMBER PRIMARY KEY, NAME VARCHAR2(50), NOTE VARCHAR2(1000));
--
SELECT * FROM TEST;

INSERT INTO TEST VALUES (1, 'HELLO', NULL);

COMMIT;

SELECT * FROM TEST;

---------------------------b.
INSERT INTO TEST VALUES (2, 'HELLO SESSION A', NULL);

ROLLBACK;

SELECT * FROM TEST;

----------------2.	Blocked Updates, Deletes
--------a.

INSERT INTO TEST VALUES (3, 'JOHN', NULL);
COMMIT;

UPDATE TEST SET NOTE='UPDATED BY SESSION A' WHERE ID=3;

COMMIT;

SELECT * FROM TEST;



------b.
INSERT INTO TEST VALUES (4, 'SAMSUNG', NULL);
COMMIT;

SELECT * FROM TEST;

UPDATE TEST SET NAME='APPLE' WHERE ID=4;

COMMIT;

SELECT * FROM TEST;


-----c.

INSERT INTO TEST VALUES (5, 'TIKI', NULL);
COMMIT;

SELECT * FROM TEST;

DELETE FROM TEST WHERE ID=5;

ROLLBACK;

SELECT * FROM TEST;

--------d.
DELETE FROM TEST;
INSERT INTO TEST VALUES (6, 'FAHASA', NULL);
COMMIT;

SELECT * FROM TEST;

UPDATE TEST SET NOTE='HELLO FAHASA' WHERE ID=6;

COMMIT;

UPDATE TEST SET NOTE='UPDATED BY SESSION A' WHERE ID=6;

COMMIT;


-----------e.

INSERT INTO TEST VALUES (7, 'LENOVO', NULL);
COMMIT;

UPDATE TEST SET NOTE='HELLO LENOVO' WHERE ID=7;

COMMIT;

--------------------3.	TX Lock, TM Locks


INSERT INTO TEST VALUES (8, 'FORD', NULL);
COMMIT;

SELECT * FROM TEST;

UPDATE TEST SET NOTE='HELLO FORD' WHERE ID=8;
--(WHICH LOCK HERE: TX? TM LOCK?)

COMMIT;

UPDATE TEST SET NOTE='HELLO FORD' WHERE ID=8;

COMMIT;

-------------4.	Deadlook
DELETE FROM TEST;
INSERT INTO TEST VALUES (90, 'RESOURCE 1', NULL);
INSERT INTO TEST VALUES (91, 'RESOURCE 2', NULL);
COMMIT;

SELECT * FROM TEST;

UPDATE TEST SET NOTE='HELLO RESOURCE 1' WHERE ID=90;

DELETE FROM TEST WHERE ID=91;

-----------Isolation levels
DROP TABLE accounts;
CREATE TABLE accounts (accid NUMBER(6) primary key, 
			balance NUMBER (10,2),
			check (balance>=0));
INSERT INTO accounts VALUES (7715, 7000); 
INSERT INTO accounts VALUES (7720, 5100); 
COMMIT;

--1.	Read committed: Non-repeatable Read
select * from accounts;

update accounts 
set balance=balance-2000
where accid=7715;

Commit;

select * from accounts;

-----------2.	Read committed: Phantom Read
select * from accounts
where balance>100;

INSERT INTO accounts VALUES (7740, 3000);
Commit;


--------------3.	Serializable Isolation Level: repeatable Read\
DELETE FROM ACCOUNTS;
INSERT INTO accounts VALUES (7715, 7000); 
INSERT INTO accounts VALUES (7720, 5100); 
COMMIT;


COMMIT;
select * from accounts;

update accounts set balance=8000
where accid=7720;

COMMIT;

select * from accounts;


------------------4.	Serializable Isolation Level: non-Phantom Read

select * from accounts;

INSERT INTO accounts VALUES (7750, 3000);

COMMIT;

select * from accounts;



/*
Các vấn đề trong xử lý đồng thời
DROP TABLE accounts;
CREATE TABLE accounts (accid NUMBER(6) primary key, 
			balance NUMBER (10,2),
			owner_name varchar2(30),
			check (balance>=0));
INSERT INTO accounts VALUES (7715, 90, 'Scott'); 
INSERT INTO accounts VALUES (7720, 5100, 'Tiger'); 
INSERT INTO accounts VALUES (7725, 20, 'Helen');
INSERT INTO accounts VALUES (7730, 49, 'John');
COMMIT;

*/

--1.	Lost update
--Viết hai transaction rút tiền thể hiện tình trạng lost update theo như sơ đồ trên. Nêu các cách tránh lost update.
--TX1
BEGIN;

SELECT * FROM accounts WHERE owner_name='Scott'; -- trả về balance = 90

UPDATE accounts SET balance=40 WHERE owner_name='Scott'; -- rút 50$

COMMIT;

--a.	Increase transaction isolation level

--b.	Pessimistic Locking

--c.	Optimistic Locking




BEGIN;

-- Lần đầu lấy tổng số dư
SELECT SUM(balance) FROM accounts;
-- => Kết quả: 12169$

-- ... giả sử đang xử lý dữ liệu để viết báo cáo ...

-- Lần hai lại truy vấn tổng số dư
SELECT SUM(balance) FROM accounts;
-- => Kết quả: 12069$  ❗ (bị thay đổi)

COMMIT;

-------------
BEGIN;

-- Lần 1 đếm số tài khoản
SELECT COUNT(*) FROM accounts;
-- => Kết quả: 4

-- (giả sử thực hiện các xử lý trung gian)

-- Lần 2 đếm lại số tài khoản
SELECT COUNT(*) FROM accounts;
-- => Kết quả: 5 ❗ (do có bản ghi mới được thêm)

COMMIT;

-------------
BEGIN;

-- Bước 1: Trừ 2000 từ tài khoản A
UPDATE accounts SET balance = balance - 2000 WHERE accid = 7715;

-- Bước 2: Cộng 2000 vào tài khoản B
UPDATE accounts SET balance = balance + 2000 WHERE accid = 7720;

COMMIT;



