--Ten: Pham Hung Quoc Viet
--MSSV: 235217833
 select * from S_CUSTOMER where REGION_ID = 1;
 select *from S_PRODUCT WHERE SUGGESTED_WHLSL_PRICE > 10 ;
      
 --1.Display the user id for employee 23.
 select USERID from S_EMP WHERE ID =23;
/*
rpatel
*/
      
 --2.Display the first name, last name, and department number of the
--employees in departments 10 and 50 in alphabetical order of last name.
--Merge the first name and last name together, and title the column
--Employees. (Use ‘||’ to merge columns).

SELECT FIRST_NAME || ' ' || LAST_NAME AS Employees, DEPT_ID
FROM S_EMP
WHERE DEPT_ID IN (10, 50)
ORDER BY LAST_NAME ASC;
/*
Audry Ropeburn	50
Carmen Velasquez	50
Mark Quick-To-See	10
*/

--3. Display all employees whose last names contain an “s”.

SELECT * FROM S_EMP WHERE LAST_NAME LIKE '%s%';
/*
1	Velasquez	Carmen	cvelasqu	03-MAR-90			President	50	2500	
15	Dumas	Andre	adumas	09-OCT-91		3	Sales Representative	35	1450	17.5
24	Dancs	Bela	bdancs	17-MAR-91		10	Stock Clerk	45	860	
*/

--4. Display the user ids and start date of employees hired between May
--5,1990 and May 26, 1991. Order the query results by start date
--ascending order
--
--CACH 1:
SELECT USERID , START_DATE FROM S_EMP 
WHERE START_DATE BETWEEN TO_DATE('1990-05-05', 'YYYY-MM-DD') AND TO_DATE('1991-05-26', 'YYYY-MM-DD')
ORDER BY START_DATE ASC;
 -- CACH 2
SELECT USERID , START_DATE FROM S_EMP 
WHERE START_DATE BETWEEN '03-MAY-1990' AND '26-MAY-1991'
ORDER BY START_DATE ASC;
--
/*
rmenchu	14-MAY-90
cmagee	14-MAY-90
rpatel	17-OCT-90
echang	30-NOV-90
murguhar	18-JAN-91
anozaki	09-FEB-91
ysedeghi	18-FEB-91
mhavel	27-FEB-91
bdancs	17-MAR-91
sschwart	09-MAY-91
amarkari	26-MAY-91
*/

--5. Write a query to show the last name and salary of all employees who
--are not making between 1000 and 2500 per month
--CACH 1
SELECT LAST_NAME, SALARY FROM S_EMP 
WHERE SALARY  NOT BETWEEN 1000 AND 2500;
--CACH 2
SELECT LAST_NAME, SALARY FROM S_EMP 
WHERE SALARY <1000 OR SALARY >2500;
/*
Smith	940
Patel	795
Newman	750
Markarian	850
Chang	800
Patel	795
Dancs	860
*/

--6. List the last name and salary of employees who earn more than 1350
--who are in department 31, 42, or 50. Label the last name column
--Employee Name, and label the salary column Monthly Salary.

SELECT LAST_NAME AS Employee_Name, SALARY AS Monthly_Salary FROM S_EMP 
WHERE SALARY >1350 AND DEPT_ID IN ('31','42','50');
/*
Velasquez	2500
Nagayama	1400
Ropeburn	1550
Magee	1400
*/

--7 Display the last name and start date of every employee who was hired in 1991.

SELECT LAST_NAME, START_DATE FROM S_EMP
WHERE START_DATE BETWEEN '01-january-1991' AND '31-december-1991';

/*
Nagayama	17-JUN-91
Urguhart	18-JAN-91
Havel	27-FEB-91
Sedeghi	18-FEB-91
Dumas	09-OCT-91
Nozaki	09-FEB-91
Patel	06-AUG-91
Newman	21-JUL-91
Markarian	26-MAY-91
Dancs	17-MAR-91
Schwartz	09-MAY-91
*/

--8. Display the employee number, last name, and salary increased by 15%
--and expressed as a whole number
SELECT 
    ID , 
    last_name , 
    ROUND(salary * 1.15) AS "New Salary"
FROM S_EMP;
/*
1	Velasquez	2875
2	Ngao	1668
3	Nagayama	1610
4	Quick-To-See	1668
5	Ropeburn	1783
6	Urguhart	1380
7	Menchu	1438
8	Biri	1265
9	Catchpole	1495
10	Havel	1503
11	Magee	1610
12	Giljum	1714
13	Sedeghi	1742
14	Nguyen	1754
15	Dumas	1668
16	Maduro	1610
17	Smith	1081
18	Nozaki	1380
19	Patel	914
20	Newman	863
21	Markarian	978
22	Chang	920
23	Patel	914
24	Dancs	989
25	Schwartz	1265
*/

--9. Display the employee last name and title in parentheses for all
--employees. The report should look like the output below.
SET SERVEROUTPUT ON;

DECLARE 
    v_last_name s_emp.last_name%TYPE;
    v_title s_emp.title%TYPE;
    
    -- Cursor to fetch employee last name and title
    CURSOR emp_cursor IS 
        SELECT last_name, title FROM s_emp;
        
BEGIN
    DBMS_OUTPUT.PUT_LINE('EMPLOYEE');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- Open cursor and fetch data
    FOR emp_record IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' (' || emp_record.title || ')');
    END LOOP;
END;
/*
EMPLOYEE
----------------------------------------------------
Velasquez (President)
Ngao (VP, Operations)
Nagayama (VP, Sales)
Quick-To-See (VP, Finance)
Ropeburn (VP, Administration)
Urguhart (Warehouse Manager)
Menchu (Warehouse Manager)
Biri (Warehouse Manager)
Catchpole (Warehouse Manager)
Havel (Warehouse Manager)
Magee (Sales Representative)
Giljum (Sales Representative)
Sedeghi (Sales Representative)
Nguyen (Sales Representative)
Dumas (Sales Representative)
Maduro (Stock Clerk)
Smith (Stock Clerk)
Nozaki (Stock Clerk)
Patel (Stock Clerk)
Newman (Stock Clerk)
Markarian (Stock Clerk)
Chang (Stock Clerk)
Patel (Stock Clerk)
Dancs (Stock Clerk)
Schwartz (Stock Clerk)

*/

--10.Display the product name for products that have “ski” in the name
SELECT name FROM S_PRODUCT P WHERE NAME  LIKE '%Ski%';
/*
Ace Ski Boot
Ace Ski Pole
Bunny Ski Pole
Pro Ski Boot
Pro Ski Pole
*/


--11.For each employee, calculate the number of months between today and
--the date the employee was hired. Order your result by the number of
--months employed. Round the number of months up to the closest whole
--number. (use the MONTHS_BETWEEN and ROUND function)

SELECT id AS employee_id, 
                last_name, 
                ROUND(MONTHS_BETWEEN(SYSDATE, start_date)) AS months_employed
FROM s_emp
ORDER BY months_employed DESC;

/*
1	Velasquez	421
2	Ngao	420
17	Smith	420
5	Ropeburn	420
8	Biri	419
4	Quick-To-See	419
11	Magee	418
7	Menchu	418
23	Patel	413
22	Chang	412
6	Urguhart	410
10	Havel	409
13	Sedeghi	409
18	Nozaki	409
24	Dancs	408
21	Markarian	406
25	Schwartz	406
3	Nagayama	405
20	Newman	404
19	Patel	403
15	Dumas	401
12	Giljum	398
14	Nguyen	398
16	Maduro	397
9	Catchpole	397
*/

--12.Display the highest and lowest order totals in the S_ORD. Label the
--columns Highest and Lowest, respectively.

SELECT * FROM S_ORD;
SELECT 
    MAX(total) AS Highest, 
    MIN(total) AS Lowest
FROM s_ord;

/*
1020935	377
*/
--13.Display the product name, product number, and quantity ordered of all
--items in order number 101. Label the quantity column ORDERED
SELECT 
    p.name AS product_name, 
    p.id AS product_number, 
    i.quantity AS ORDERED
FROM s_item i
JOIN s_product p ON i.product_id = p.id
WHERE i.ord_id = 101;
/*

Cabrera Bat	50530	50
Grand Prix Bicycle Tires	30421	15
Griffey Glove	50417	27
Major League Baseball	50169	40
Pro Curling Bar	40422	30
Prostar 10 Pound Weight	41010	20
Prostar 100 Pound Weight	41100	35

*/

--14.Display the customer number and the last name of their sales
--representative. Order the list by last name
SELECT 
    c.id AS customer_number, 
    e.last_name AS sales_rep_last_name
FROM s_customer c
JOIN s_emp e ON c.sales_rep_id = e.id
ORDER BY e.last_name;

/*
208	Dumas
206	Dumas
215	Dumas
211	Dumas
205	Dumas
201	Giljum
210	Giljum
204	Magee
209	Magee
213	Magee
214	Magee
202	Nguyen
203	Nguyen
212	Sedeghi
*/

--15.Display the customer number, customer name, and order number of all
--customers and their orders. Display the customer number and name,
--even if they have not placed an order.

SELECT 
    c.id AS customer_number, 
    c.name AS customer_name, 
    o.id AS order_number
FROM s_customer c
LEFT JOIN s_ord o ON c.id = o.customer_id
ORDER BY c.id;

/*
201	Unisports	97
202	Simms Athletics	98
203	Delhi Sports	99
204	Womansport	100
204	Womansport	111
205	Kam's Sporting Goods	101
206	Sportique	102
207	Sweet Rock Sports	
208	Muench Sports	103
208	Muench Sports	104
209	Beisbol Si!	105
210	Futbol Sonora	112
210	Futbol Sonora	106
211	Kuhn's Sports	107
212	Hamada Sport	108
213	Big John's Sports Emporium	109
214	Ojibway Retail	110
215	Sporta Russia	
*/

--16.Display all employees by last name and employee number along with
--their manager’s last name and manager number

SELECT a.last_name,a.id ,b.last_name as manger_id,b.id as manager_id
FROM S_EMP a LEFT JOIN s_emp b
ON a.manager_id = b.id
ORDER BY a.ID ASC;
/*
Velasquez	1		
Ngao	2	Velasquez	1
Nagayama	3	Velasquez	1
Quick-To-See	4	Velasquez	1
Ropeburn	5	Velasquez	1
Urguhart	6	Ngao	2
Menchu	7	Ngao	2
Biri	8	Ngao	2
Catchpole	9	Ngao	2
Havel	10	Ngao	2
Magee	11	Nagayama	3
Giljum	12	Nagayama	3
Sedeghi	13	Nagayama	3
Nguyen	14	Nagayama	3
Dumas	15	Nagayama	3
Maduro	16	Urguhart	6
Smith	17	Urguhart	6
Nozaki	18	Menchu	7
Patel	19	Menchu	7
Newman	20	Biri	8
Markarian	21	Biri	8
Chang	22	Catchpole	9
Patel	23	Catchpole	9
Dancs	24	Havel	10
Schwartz	25	Havel	10
*/
   
--17.Display all customers and the product number and quantities they
--ordered for those customers whose order totaled more than 100000.

  
SELECT c.NAME, i.product_id, i.quantity 
FROM  s_customer c
JOIN s_ord o ON c.id = o.customer_id
JOIN s_item i ON i.ORD_ID = o.ID
where o.total > 100000;
/*
Womansport	10011	500
Womansport	10013	400
Womansport	10021	500
Womansport	30326	600
Womansport	41010	250
Womansport	30433	450
Womansport	10023	400
Kuhn's Sports	20106	50
Kuhn's Sports	20201	130
Kuhn's Sports	30421	55
Kuhn's Sports	30321	75
Kuhn's Sports	20108	22
Hamada Sport	20510	9
Hamada Sport	41080	50
Hamada Sport	41100	42
Hamada Sport	32861	57
Hamada Sport	20512	18
Hamada Sport	32779	60
Hamada Sport	30321	85
Big John's Sports Emporium	10011	150
Big John's Sports Emporium	30426	500
Big John's Sports Emporium	50418	43
Big John's Sports Emporium	32861	50
Big John's Sports Emporium	30326	1500
Big John's Sports Emporium	10012	600
Big John's Sports Emporium	10022	300
*/

--18.Display the id, full name of all employees with no manager
SELECT * FROM s_emp 
where manager_id is null;
/*
1	Velasquez	Carmen	cvelasqu	03-MAR-90			President	50	2500	1	Velasquez	Carmen	cvelasqu	03-MAR-90			President	50	2500	
*/

--19.Alphabetically display all products having a name beginning with Pro.
SELECT name FROM s_product
where name like 'Pro%'
order by name asc;
/*
Pro Curling Bar
Pro Ski Boot
Pro Ski Pole
Prostar 10 Pound Weight
Prostar 100 Pound Weight
Prostar 20 Pound Weight
Prostar 50 Pound Weight
Prostar 80 Pound Weight
*/

--20.Display all product ids, names and short descriptions (short_desc) for
--all descriptions containing the word bicycle.
SELECT ID, NAME, SHORT_DESC FROM s_product
WHERE SHORT_DESC LIKE '%bicycle%';
/*
30321	Grand Prix Bicycle	Road bicycle
30326	Himalaya Bicycle	Mountain bicycle
30421	Grand Prix Bicycle Tires	Road bicycle tires
30426	Himalaya Tires	Mountain bicycle tires
*/


--21.Determine the number of managers without listing them

SELECT COUNT(DISTINCT manager_id) AS number_of_managers
FROM s_emp
WHERE manager_id IS NOT NULL;
/*
8
*/

--22.Display the customer name, phone, and the number of orders for each
--customer.
SELECT c.name,c.phone, count(o.id)
FROM s_customer c
JOIN s_ord o on c.id= o.customer_id
Group by c.name,c.phone;
/*
Unisports	55-2066101	1
Kam's Sporting Goods	852-3692888	1
Sportique	33-2257201	1
Futbol Sonora	52-404562	2
Simms Athletics	81-20101	1
Kuhn's Sports	42-111292	1
Big John's Sports Emporium	1-415-555-6281	1
Ojibway Retail	1-716-555-7171	1
Delhi Sports	91-10351	1
Womansport	1-206-104-0103	2
Muench Sports	49-527454	2
Hamada Sport	20-1209211	1
Beisbol Si!	809-352689	1
*/

--23.Display the employee number, first name, last name, and user name for
--all employees with salaries above the average salary
SELECT 
    id AS employee_number, 
    first_name, 
    last_name, 
    userid AS user_name
FROM s_emp
WHERE salary > (SELECT AVG(salary) FROM s_emp);


/*
1	Carmen	Velasquez	cvelasqu
2	LaDoris	Ngao	lngao
3	Midori	Nagayama	mnagayam
4	Mark	Quick-To-See	mquickto
5	Audry	Ropeburn	aropebur
9	Antoinette	Catchpole	acatchpo
10	Marta	Havel	mhavel
11	Colin	Magee	cmagee
12	Henry	Giljum	hgiljum
13	Yasmin	Sedeghi	ysedeghi
14	Mai	Nguyen	mnguyen
15	Andre	Dumas	adumas
16	Elena	Maduro	emaduro
*/

--24.Display the employee number, first name, and last name for all
--employees with a salary above the average salary and that work with
--any employee with a last name that contains a “t”.

SELECT e1.id AS employee_number, 
       e1.first_name, 
       e1.last_name
FROM s_emp e1
WHERE e1.salary > (SELECT AVG(salary) FROM s_emp)
AND e1.dept_id IN (
    SELECT DISTINCT e2.dept_id 
    FROM s_emp e2 
    WHERE LOWER(e2.last_name) LIKE '%t%'
);

/*
4	Mark	Quick-To-See
2	LaDoris	Ngao
16	Elena	Maduro
9	Antoinette	Catchpole
14	Mai	Nguyen
10	Marta	Havel
*/

--25.Write a query to display the minimum, maximum, and average salary
--for each job type ordered alphabetically
SELECT 
    title AS job_title, 
    MIN(salary) AS min_salary, 
    MAX(salary) AS max_salary, 
    ROUND(AVG(salary), 2) AS avg_salary
FROM s_emp
GROUP BY title
ORDER BY job_title;
/*
President	2500	2500	2500
Sales Representative	1400	1525	1476
Stock Clerk	750	1400	949
VP, Administration	1550	1550	1550
VP, Finance	1450	1450	1450
VP, Operations	1450	1450	1450
VP, Sales	1400	1400	1400
Warehouse Manager	1100	1307	1231.4
*/





SELECT SYS_CONTEXT('USERENV', 'DB_NAME') AS database_name,
       SYS_CONTEXT('USERENV', 'CON_NAME') AS container_name,
       SYS_CONTEXT('USERENV', 'SESSION_USER') AS session_user
FROM dual;




