--Ten: Pham Hung Quoc Viet
--MSSV: 23521783

--1. Display all information from the customer table whose state is null
SELECT * 
FROM s_customer 
WHERE state IS NULL;
/*
201	Unisports	55-2066101	72 Via Bahia	Sao Paolo		Brazil		EXCELLENT	12	2	Customer usually orders large amounts and has a high order total.  This is okay as long as the credit rating remains excellent.
202	Simms Athletics	81-20101	6741 Takashi Blvd.	Osaka		Japan		POOR	14	4	Customer should always pay by cash until his credit rating improves.
203	Delhi Sports	91-10351	11368 Chanakya	New Delhi		India		GOOD	14	4	Customer specializes in baseball equipment and is the largest retailer in India.
205	Kam's Sporting Goods	852-3692888	15 Henessey Road	Hong Kong				EXCELLENT	15	4	
206	Sportique	33-2257201	172 Rue de Rivoli	Cannes		France		EXCELLENT	15	5	Customer specializes in Soccer.  Likes to order accessories in bright colors.
207	Sweet Rock Sports	234-6036201	6 Saint Antoine	Lagos		Nigeria		GOOD		3	
208	Muench Sports	49-527454	435 Gruenestrasse	Stuttgart		Germany		GOOD	15	5	Customer usually pays small orders by cash and large orders on credit.
209	Beisbol Si!	809-352689	792 Playa Del Mar	San Pedro de Macon's		Dominican Republic		EXCELLENT	11	1	
210	Futbol Sonora	52-404562	3 Via Saguaro	Nogales		Mexico		EXCELLENT	12	2	Customer is difficult to reach by phone.  Try mail.
211	Kuhn's Sports	42-111292	7 Modrany	Prague		Czechoslovakia		EXCELLENT	15	5	
212	Hamada Sport	20-1209211	57A Corniche	Alexandria		Egypt		EXCELLENT	13	3	Customer orders sea and water equipment.
215	Sporta Russia	7-3892456	6000 Yekatamina	Saint Petersburg		Russia		POOR	15	5	This customer is very friendly, but has difficulty paying bills.  Insist upon cash.
*/


--2. Display the Employee Id, Lastname, Firstname, and start_date from the S_emp
--table who started working in Feb, 1991

SELECT 
    id AS employee_id, 
    last_name, 
    first_name, 
    start_date
FROM s_emp
WHERE TO_CHAR(start_date, 'MM-YYYY') = '02-1991';

/*
10	Havel	Marta	27-FEB-91
13	Sedeghi	Yasmin	18-FEB-91
18	Nozaki	Akira	09-FEB-91
*/

--3. Display Employee Firstname whose title is 'Stock Clerk '
SELECT first_name
FROM s_emp
WHERE title = 'Stock Clerk';
/*
Elena
George
Akira
Vikram
Chad
Alexander
Eddie
Radha
Bela
Sylvie
*/

--4. Display Products that name starts with the letter "B".
SELECT * 
FROM s_product
WHERE name LIKE 'B%';
/*
20512	Black Hawk Elbow Pads	Elbow pads, pair	8	
20510	Black Hawk Knee Pads	Knee pads, pair	9	
10011	Bunny Boot	Beginner's ski boot	150	
10021	Bunny Ski Pole	Beginner's ski pole	16.25	
*/

--5. Display Employees whose Firstname contains 'd' in the Fourth position.
SELECT * 
FROM s_emp
WHERE first_name LIKE '___d%';

/*
20	Newman	Chad	cnewman	21-JUL-91		8	Stock Clerk	43	750	
*/

--6. Display Employees Firstname and Lastname Concatenated
SELECT first_name ||' '|| last_name AS full_name
FROM s_emp;

/*
Carmen Velasquez
LaDoris Ngao
Midori Nagayama
Mark Quick-To-See
Audry Ropeburn
Molly Urguhart
Roberta Menchu
Ben Biri
Antoinette Catchpole
Marta Havel
Colin Magee
Henry Giljum
Yasmin Sedeghi
Mai Nguyen
Andre Dumas
Elena Maduro
George Smith
Akira Nozaki
Vikram Patel
Chad Newman
Alexander Markarian
Eddie Chang
Radha Patel
Bela Dancs
Sylvie Schwartz
*/

--7. Display Employees Firstname, Start_date whose start_date falls in the month of Jan.
SELECT first_name, start_date
FROM s_emp
WHERE TO_CHAR(start_date, 'MM') = '01';
/*
Molly	18-JAN-91
Henry	18-JAN-92
Mai	22-JAN-92
*/
SELECT first_name, start_date
FROM s_emp
WHERE EXTRACT(MONTH FROM start_date) = '01';
/*
Molly	18-JAN-91
Henry	18-JAN-92
Mai	22-JAN-92
*/

--8. Display employee that have worked more than 31 years
SELECT * 
FROM s_emp
WHERE (MONTHS_BETWEEN(SYSDATE, start_date) / 12) > 31;
/*
1	Velasquez	Carmen	cvelasqu	03-MAR-90			President	50	2500	
2	Ngao	LaDoris	lngao	08-MAR-90		1	VP, Operations	41	1450	
3	Nagayama	Midori	mnagayam	17-JUN-91		1	VP, Sales	31	1400	
4	Quick-To-See	Mark	mquickto	07-APR-90		1	VP, Finance	10	1450	
5	Ropeburn	Audry	aropebur	04-MAR-90		1	VP, Administration	50	1550	
6	Urguhart	Molly	murguhar	18-JAN-91		2	Warehouse Manager	41	1200	
7	Menchu	Roberta	rmenchu	14-MAY-90		2	Warehouse Manager	42	1250	
8	Biri	Ben	bbiri	07-APR-90		2	Warehouse Manager	43	1100	
9	Catchpole	Antoinette	acatchpo	09-FEB-92		2	Warehouse Manager	44	1300	
10	Havel	Marta	mhavel	27-FEB-91		2	Warehouse Manager	45	1307	
11	Magee	Colin	cmagee	14-MAY-90		3	Sales Representative	31	1400	10
12	Giljum	Henry	hgiljum	18-JAN-92		3	Sales Representative	32	1490	12.5
13	Sedeghi	Yasmin	ysedeghi	18-FEB-91		3	Sales Representative	33	1515	10
14	Nguyen	Mai	mnguyen	22-JAN-92		3	Sales Representative	34	1525	15
15	Dumas	Andre	adumas	09-OCT-91		3	Sales Representative	35	1450	17.5
16	Maduro	Elena	emaduro	07-FEB-92		6	Stock Clerk	41	1400	
17	Smith	George	gsmith	08-MAR-90		6	Stock Clerk	41	940	
18	Nozaki	Akira	anozaki	09-FEB-91		7	Stock Clerk	42	1200	
19	Patel	Vikram	vpatel	06-AUG-91		7	Stock Clerk	42	795	
20	Newman	Chad	cnewman	21-JUL-91		8	Stock Clerk	43	750	
21	Markarian	Alexander	amarkari	26-MAY-91		8	Stock Clerk	43	850	
22	Chang	Eddie	echang	30-NOV-90		9	Stock Clerk	44	800	
23	Patel	Radha	rpatel	17-OCT-90		9	Stock Clerk	34	795	
24	Dancs	Bela	bdancs	17-MAR-91		10	Stock Clerk	45	860	
25	Schwartz	Sylvie	sschwart	09-MAY-91		10	Stock Clerk	45	1100	
*/
SELECT * 
FROM s_emp
WHERE (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM start_date)) > 31;
/*
1	Velasquez	Carmen	cvelasqu	03-MAR-90			President	50	2500	
2	Ngao	LaDoris	lngao	08-MAR-90		1	VP, Operations	41	1450	
3	Nagayama	Midori	mnagayam	17-JUN-91		1	VP, Sales	31	1400	
4	Quick-To-See	Mark	mquickto	07-APR-90		1	VP, Finance	10	1450	
5	Ropeburn	Audry	aropebur	04-MAR-90		1	VP, Administration	50	1550	
6	Urguhart	Molly	murguhar	18-JAN-91		2	Warehouse Manager	41	1200	
7	Menchu	Roberta	rmenchu	14-MAY-90		2	Warehouse Manager	42	1250	
8	Biri	Ben	bbiri	07-APR-90		2	Warehouse Manager	43	1100	
9	Catchpole	Antoinette	acatchpo	09-FEB-92		2	Warehouse Manager	44	1300	
10	Havel	Marta	mhavel	27-FEB-91		2	Warehouse Manager	45	1307	
11	Magee	Colin	cmagee	14-MAY-90		3	Sales Representative	31	1400	10
12	Giljum	Henry	hgiljum	18-JAN-92		3	Sales Representative	32	1490	12.5
13	Sedeghi	Yasmin	ysedeghi	18-FEB-91		3	Sales Representative	33	1515	10
14	Nguyen	Mai	mnguyen	22-JAN-92		3	Sales Representative	34	1525	15
15	Dumas	Andre	adumas	09-OCT-91		3	Sales Representative	35	1450	17.5
16	Maduro	Elena	emaduro	07-FEB-92		6	Stock Clerk	41	1400	
17	Smith	George	gsmith	08-MAR-90		6	Stock Clerk	41	940	
18	Nozaki	Akira	anozaki	09-FEB-91		7	Stock Clerk	42	1200	
19	Patel	Vikram	vpatel	06-AUG-91		7	Stock Clerk	42	795	
20	Newman	Chad	cnewman	21-JUL-91		8	Stock Clerk	43	750	
21	Markarian	Alexander	amarkari	26-MAY-91		8	Stock Clerk	43	850	
22	Chang	Eddie	echang	30-NOV-90		9	Stock Clerk	44	800	
23	Patel	Radha	rpatel	17-OCT-90		9	Stock Clerk	34	795	
24	Dancs	Bela	bdancs	17-MAR-91		10	Stock Clerk	45	860	
25	Schwartz	Sylvie	sschwart	09-MAY-91		10	Stock Clerk	45	1100	
*/

--9. Display the product name, short_desc concatenated together and price is higher than 100
SELECT 
    name || ' - ' || short_desc AS product_details, 
    suggested_whlsl_price 
FROM s_product
WHERE suggested_whlsl_price > 100;

/*
Bunny Boot - Beginner's ski boot	150
Ace Ski Boot - Intermediate ski boot	200
Pro Ski Boot - Advanced ski boot	410
World Cup Net - World cup net	123
Grand Prix Bicycle - Road bicycle	1669
Himalaya Bicycle - Mountain bicycle	582
*/
--10. Display customers whose phone contains two zeros
SELECT * 
FROM s_customer
WHERE phone LIKE '%0%0%';
/*
201	Unisports	55-2066101	72 Via Bahia	Sao Paolo		Brazil		EXCELLENT	12	2	Customer usually orders large amounts and has a high order total.  This is okay as long as the credit rating remains excellent.
202	Simms Athletics	81-20101	6741 Takashi Blvd.	Osaka		Japan		POOR	14	4	Customer should always pay by cash until his credit rating improves.
204	Womansport	1-206-104-0103	281 King Street	Seattle	Washington	USA	98101	EXCELLENT	11	1	
207	Sweet Rock Sports	234-6036201	6 Saint Antoine	Lagos		Nigeria		GOOD		3	
212	Hamada Sport	20-1209211	57A Corniche	Alexandria		Egypt		EXCELLENT	13	3	Customer orders sea and water equipment.
*/
SELECT * 
FROM s_customer
WHERE LENGTH(REPLACE(phone, '0', '')) = LENGTH(phone) - 2;
/*
Unisports	55-2066101	72 Via Bahia	Sao Paolo		Brazil		EXCELLENT	12	2	Customer usually orders large amounts and has a high order total.  This is okay as long as the credit rating remains excellent.
Simms Athletics	81-20101	6741 Takashi Blvd.	Osaka		Japan		POOR	14	4	Customer should always pay by cash until his credit rating improves.
Sweet Rock Sports	234-6036201	6 Saint Antoine	Lagos		Nigeria		GOOD		3	
Hamada Sport	20-1209211	57A Corniche	Alexandria		Egypt		EXCELLENT	13	3	Customer orders sea and water equipment.
*/

--11. Retrieve the region number, region name, and the number of departments within
--each region. Order the data by the region name
SELECT 
    r.id AS region_id, 
    r.name AS region_name, 
    COUNT(d.id) AS department_count
FROM s_region r
LEFT JOIN s_dept d ON r.id = d.region_id
GROUP BY r.id, r.name
ORDER BY r.name;
/*
3	Africa / Middle East	2
4	Asia	2
5	Europe	2
1	North America	4
2	South America	23	Africa / Middle East	2
4	Asia	2
5	Europe	2
1	North America	4
2	South America	2
*/


--12. Display the product number and number of times it was ordered, labeled Times
--Ordered. Only show those products that have been ordered at least three times.
--Order the data by the number of products ordered.
SELECT 
    product_id, 
    COUNT(*) AS "Times Ordered"
FROM s_item
GROUP BY product_id
HAVING COUNT(*) >= 3
ORDER BY "Times Ordered" DESC;

/*
30321	4
20201	3
20108	3
20512	3
50273	3
30421	3
20106	3
20510	3
*/

--13. How many employees each manager has. Show manager id, name, and number employee.

SELECT 
    m.id,
    m.first_name || ' ' || m.last_name AS manager_name,
    COUNT(*) AS number_of_employees
FROM s_emp m 
JOIN  s_emp e
ON m.id= e.manager_id
GROUP BY m.id, m.first_name, m.last_name
ORDER BY m.id;
/*
1	Carmen Velasquez	4
2	LaDoris Ngao	5
3	Midori Nagayama	5
6	Molly Urguhart	2
7	Roberta Menchu	2
8	Ben Biri	2
9	Antoinette Catchpole	2
10	Marta Havel	2
*/

--14. Which regions have more than 3 customers
SELECT 
    r.id AS region_id, 
    r.name AS region_name,
    COUNT(c.id) AS customer_count
FROM s_region r
JOIN s_customer c ON r.id = c.region_id
GROUP BY r.id, r.name
HAVING COUNT(c.id) > 3;
/*
5	Europe	4
1	North America	4
*/





