--a.
-----------Session 2

-----------------------------------------t0

-----------------------------------------t1

-----------------------------------------t2

-----------------------------------------t3
Select * from project;
-----------------------------------------t4

-----------------------------------------t5
Select * from project;

--b.
-----------Session 2

-----------------------------------------t1

-----------------------------------------t2

-----------------------------------------t3
Select * from project;
-----------------------------------------t4

-----------------------------------------t5
Select * from project;


----2.	Compare data at time t3, t5 and t8

-----------------------------------------t0
SET TRANSACTION NAME 'cost_update7';
-----------------------------------------t1
Select * from project;
-----------------------------------------t2

-----------------------------------------t3
Select * from project;
-----------------------------------------t4
Insert into project values (5, 'mars', 14500);
-----------------------------------------t5
Select * from project;
-----------------------------------------t6

-----------------------------------------t7
Commit;
-----------------------------------------t8
Select * from project;


-----------------------------------------t0
SET TRANSACTION NAME 'cost_update9';
-----------------------------------------t1

-----------------------------------------t2
Select * from project;
-----------------------------------------t3
Update project set cost=298
Where pname='saturn';

-----------------------------------------t4
Select * from project;
-----------------------------------------t5

-----------------------------------------t6

-----------------------------------------t7
Select * from project;
-----------------------------------------t8
Commit;
-----------------------------------------t9
Select * from project;


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

---SESSION B
SET AUTOCOMMIT OFF;

---
SELECT * FROM TEST;

--
INSERT INTO TEST VALUES (1, 'GOODBYE', NULL);

SELECT * FROM TEST;

---------------------------b.

INSERT INTO TEST VALUES (2, 'HELLO SESSION B',  NULL);

COMMIT;

SELECT * FROM TEST;

-----------
----------------2.	Blocked Updates, Deletes
--------a.
UPDATE TEST SET NOTE='UPDATED BY SESSION B' WHERE ID=3;

COMMIT;

SELECT * FROM TEST;

-----b.

SELECT * FROM TEST;

DELETE FROM TEST WHERE ID=4;

COMMIT;

SELECT * FROM TEST;

--------------c.

SELECT * FROM TEST;

UPDATE TEST SET NAME='LAZADA' WHERE ID=5;

COMMIT;

SELECT * FROM TEST;


------------d.

SELECT * FROM TEST;

SELECT * FROM TEST WHERE ID=6 FOR UPDATE;

COMMIT;

------------e.

SELECT * FROM TEST WHERE ID=7 FOR UPDATE NOWAIT;


------------------------3.	TX Lock, TM Locks

SELECT * FROM TEST;

ALTER TABLE TEST MODIFY NOTE VARCHAR2(200);
--See what’s happening in session B.

DELETE FROM TEST WHERE ID=8;
--See what’s happening in session B.

--See what’s happening in session B.

COMMIT;


------------4.	Deadlook

SELECT * FROM TEST;

UPDATE TEST SET NOTE='HELLO RESOURCE 2' WHERE ID=91;

DELETE FROM TEST WHERE ID=90;


--1.	Read committed: Non-repeatable Read

select * from accounts;

select * from accounts;

select * from accounts;


-----------2.	Read committed: Phantom Read

select * from accounts
where balance>100;

select * from accounts
where balance>100;

--------------3.	Serializable Isolation Level: repeatable Read

COMMIT;
select * from accounts;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
select * from accounts;

select * from accounts;

update accounts set balance=40
where accid=7720;

select * from accounts

ROLLBACK;



------------------------4.	Serializable Isolation Level: non-Phantom Read

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
select * from accounts;

select * from accounts;

update accounts set balance=1111 where accid=7750;

INSERT INTO accounts VALUES (7750, 8000);

COMMIT;


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


--a.	Increase transaction isolation level

--b.	Pessimistic Locking

--c.	Optimistic Locking

BEGIN;

SELECT * FROM accounts WHERE owner_name='Scott'; -- trả về balance = 90 (do TX1 chưa commit)

UPDATE accounts SET balance=80 WHERE owner_name='Scott'; -- rút 10$

COMMIT;

------------
BEGIN;

-- Giảm số dư của tài khoản Tiger đi 100$
UPDATE accounts SET balance = balance - 100 WHERE owner_name='Tiger';

COMMIT;

----------------
BEGIN;

-- Thêm một tài khoản mới
INSERT INTO accounts VALUES (7135, 90, 'Sarah');

COMMIT;



----------------
BEGIN;

-- Bước 1: Trừ 500 từ tài khoản B
UPDATE accounts SET balance = balance - 500 WHERE accid = 7720;

-- Bước 2: Cộng 500 vào tài khoản A
UPDATE accounts SET balance = balance + 500 WHERE accid = 7715;

COMMIT;


