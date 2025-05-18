

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


SELECT * FROM S_EMP;
SELECT * FROM s_ord;


DECLARE 
 CURSOR EMP_DUYET IS
 SELECT E.ID, E.LAST_NAME,
     EXTRACT(YEAR FROM date_ordered) AS order_year, 
    COUNT(o.id) AS total_orders, 
    SUM(total) AS total_revenue
 from 
 s_ord o join s_emp e on o.sales_rep_id = e.id
 group by e.last_name, e.id , EXTRACT(YEAR FROM date_ordered) 
 order by e.last_name, e.id , EXTRACT(YEAR FROM date_ordered) ;
 
  v_last_name s_emp.last_name%type;
 v_id s_emp.id%type;
 Begin 
 FOR EMP_RECORD IN  EMP_DUYET LOOP
 v_last_name:= EMP_RECORD.LAST_NAME;
  v_id := EMP_RECORD.ID;
 DBMS_OUTPUT.PUT_LINE('Nhan vien: ' || v_last_name || ' (MANV: ' || v_id || ')');
 DBMS_OUTPUT.PUT_LINE(EMP_RECORD.order_year || ':');
            DBMS_OUTPUT.PUT_LINE('------- Tổng số hoá đơn lập là: ' || EMP_RECORD.total_orders);
            DBMS_OUTPUT.PUT_LINE('------- Tổng trị giá các hoá đơn lập là: ' || EMP_RECORD.total_revenue);
  DBMS_OUTPUT.PUT_LINE(''); -- Dòng trống để phân biệt nhân viên
    END LOOP;
    END;
 
 
 
/////////////////
--CAU 2 BAI TAP CHUONG 2 gpt
DECLARE 
    CURSOR emp_cursor IS 
        SELECT id, last_name 
        FROM s_emp;  -- Lấy danh sách nhân viên

    CURSOR invoice_cursor(p_emp_id NUMBER) IS 
        SELECT EXTRACT(YEAR FROM date_ordered) AS order_year, 
               COUNT(id) AS total_orders, 
               SUM(total) AS total_revenue
        FROM s_ord
        WHERE sales_rep_id = p_emp_id
        GROUP BY EXTRACT(YEAR FROM date_ordered)
        ORDER BY order_year;

    v_emp_id s_emp.id%TYPE;
    v_last_name s_emp.last_name%TYPE;

BEGIN
    FOR emp_record IN emp_cursor LOOP
        v_emp_id := emp_record.id;
        v_last_name := emp_record.last_name;

        DBMS_OUTPUT.PUT_LINE('Nhan vien: ' || v_last_name || ' (MANV: ' || v_emp_id || ')');

        FOR invoice_record IN invoice_cursor(v_emp_id) LOOP
            DBMS_OUTPUT.PUT_LINE(invoice_record.order_year || ':');
            DBMS_OUTPUT.PUT_LINE('------- Tổng số hoá đơn lập là: ' || invoice_record.total_orders);
            DBMS_OUTPUT.PUT_LINE('------- Tổng trị giá các hoá đơn lập là: ' || invoice_record.total_revenue);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(''); -- Dòng trống để phân biệt nhân viên
    END LOOP;
END;
////////
CREATE OR REPLACE
FUNCTION LAYTENNV (
p_ID IN NUMBER
)
RETURN VARCHAR2 IS p_name VARCHAR2(25 BYTE);
BEGIN
SELECT last_name into p_name FROM S_EMP
WHERE S_EMP.ID = p_ID;
return p_name;
end;

select LAYTENNV (3) from dual;
SELECT * FROM S_EMP;
