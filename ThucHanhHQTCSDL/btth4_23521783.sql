/*
Ten: Pham Hung Quoc Viet
MSSV: 23521783
*/

SET SERVEROUTPUT ON;
SET ECHO OFF;
--Bài tập
--THỦ TỤC (PROCEDURE)

--1. Viết thủ tục tính giai thừa của một số
--• Trả kết quả về thông qua tham số OUT:
--Factorial (in val, out result)
CREATE OR REPLACE PROCEDURE Factorial_OUT(val IN NUMBER, result OUT NUMBER) 
AS
BEGIN
    -- Kiểm tra số đầu vào
    IF val < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Không thể tính giai thừa của số âm');
    ELSIF val = 0 THEN
        result := 1;
    ELSE
        result := 1;
        FOR i IN 1..val LOOP
            result := result * i;
        END LOOP;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Giai thừa của ' || val || ' là: ' || result);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END Factorial_OUT;
/


DECLARE
    num NUMBER := 5;
    fact NUMBER;
BEGIN
    Factorial_OUT(num, fact);
    DBMS_OUTPUT.PUT_LINE('Kết quả từ OUT: ' || fact);
END;
/
/*
Procedure FACTORIAL_OUT compiled

Giai thừa của 5 là: 120
Kết quả từ OUT: 120


PL/SQL procedure successfully completed.

*/

--• Sử dụng tham số INOUT:
--Factorial (inout val)
CREATE OR REPLACE PROCEDURE Factorial_INOUT(val IN OUT NUMBER) 
AS
    temp NUMBER := 1;
    i NUMBER;
BEGIN
    -- Kiểm tra số đầu vào
    IF val < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Không thể tính giai thừa của số âm');
    ELSIF val = 0 THEN
        val := 1;
    ELSE
        FOR i IN 1..val LOOP
            temp := temp * i;
        END LOOP;
        val := temp;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Giai thừa là: ' || val);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END Factorial_INOUT;
/



DECLARE
    num NUMBER := 5;
BEGIN
    Factorial_INOUT(num);
    DBMS_OUTPUT.PUT_LINE('Kết quả từ INOUT: ' || num);
END;
/

/*

Procedure FACTORIAL_INOUT compiled

Giai thừa là: 120
Kết quả từ INOUT: 120


PL/SQL procedure successfully completed.


*/
--2. Viết thủ tục tìm tên, địa chỉ của một sinh viên
--• Xuất tên và địa chỉ ra các tham số của thủ tục.

CREATE OR REPLACE PROCEDURE GetStudentInfo(
    S_id IN NUMBER,
    full_name OUT VARCHAR2,
    full_address OUT VARCHAR2
) AS
BEGIN
    -- Lấy tên đầy đủ và địa chỉ của sinh viên
    SELECT FIRST_NAME || ' ' || LAST_NAME,
           STREET_ADDRESS 
    INTO full_name, full_address
    FROM STUDENT
    WHERE STUDENT_ID = S_id;
    
    DBMS_OUTPUT.PUT_LINE('Tìm thấy sinh viên: ' || full_name || ', ' || full_address);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy sinh viên với ID: ' || S_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi không xác định: ' || SQLERRM);
END GetStudentInfo;
/
/*
PL/SQL procedure successfully completed.


Procedure GETSTUDENTINFO compiled
*/
--• Viết một khối lệnh PL/SQL để gọi thủ tục này với tham số là 114 và in các giá trị
---này ra màn hình.
DECLARE
    name VARCHAR2(100);
    address VARCHAR2(200);
BEGIN
    -- Gọi thủ tục với ID 114
    GetStudentInfo(114, name, address);
    
    -- In kết quả ra màn hình
    DBMS_OUTPUT.PUT_LINE('Tên sinh viên: ' || name);
    DBMS_OUTPUT.PUT_LINE('Địa chỉ: ' || address);
END;
/
/*
Tìm thấy sinh viên: Winsome Laporte, 268 E. 3rd St
Tên sinh viên: Winsome Laporte
Địa chỉ: 268 E. 3rd St


PL/SQL procedure successfully completed.
*/


--3. Viết thủ tục in ra tên, địa chỉ của sinh viên và số lượng môn học mà sinh viên đó đã
--đăng ký
--• Sử dụng lại thủ tục ở câu 2 để lấy thông tin tên và địa chỉ.
CREATE OR REPLACE PROCEDURE PrintStudentEnrollmentInfo(
    p_student_id IN NUMBER
) AS
    v_full_name VARCHAR2(51); -- FIRST_NAME (25) + space + LAST_NAME (25)
    v_full_address VARCHAR2(60);
    v_enrollment_count NUMBER;
BEGIN
    -- Gọi thủ tục GetStudentInfo để lấy thông tin cơ bản
    GetStudentInfo(
        p_student_id,
        v_full_name,
        v_full_address
    );
    
    -- Kiểm tra nếu tìm thấy sinh viên thì đếm số môn học
    IF v_full_name IS NOT NULL THEN
        -- Đếm số môn học sinh viên đã đăng ký
        SELECT COUNT(*)
        INTO v_enrollment_count
        FROM ENROLLMENT
        WHERE STUDENT_ID = p_student_id;
        
        -- Hiển thị thông tin đầy đủ
        DBMS_OUTPUT.PUT_LINE('THÔNG TIN SINH VIÊN VÀ MÔN HỌC');
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
        DBMS_OUTPUT.PUT_LINE('Mã sinh viên: ' || p_student_id);
        DBMS_OUTPUT.PUT_LINE('Họ và tên: ' || v_full_name);
        DBMS_OUTPUT.PUT_LINE('Địa chỉ: ' || v_full_address);
        DBMS_OUTPUT.PUT_LINE('Số môn đã đăng ký: ' || v_enrollment_count);
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi khi lấy thông tin đăng ký môn học: ' || SQLERRM);
END PrintStudentEnrollmentInfo;
/
/*
PL/SQL procedure successfully completed.


Procedure PRINTSTUDENTENROLLMENTINFO compiled

*/

--• Viết một khối lệnh PL/SQL để gọi thủ tục này với tham số là 106.
DECLARE
BEGIN
    -- Bật chế độ hiển thị output
    DBMS_OUTPUT.ENABLE(buffer_size => 1000000);
    
    -- Gọi thủ tục với student_id = 106
    DBMS_OUTPUT.PUT_LINE('Đang lấy thông tin cho sinh viên ID 106...');
    PrintStudentEnrollmentInfo(p_student_id => 106);
    

END;
/
/*
Đang lấy thông tin cho sinh viên ID 106...
Tìm thấy sinh viên: Judith Olvsade, 29 Elmwood Ave.
THÔNG TIN SINH VIÊN VÀ MÔN HỌC
--------------------------------
Mã sinh viên: 106
Họ và tên: Judith Olvsade
Địa chỉ: 29 Elmwood Ave.
Số môn đã đăng ký: 2
--------------------------------


PL/SQL procedure successfully completed.
*/


--4. Viết thủ tục cập nhật lương cho nhân viên
--• Thủ tục có 3 tham số: emp_id, amount (giá trị mặc định là 100), extra (giá trị mặc
--định là 50).
CREATE OR REPLACE PROCEDURE UpdateSalary(
    emp_id IN NUMBER,
    amount IN NUMBER DEFAULT 100,
    extra IN NUMBER DEFAULT 50
) AS
    v_total_increase NUMBER;
    v_current_salary NUMBER;
    v_updated_salary NUMBER;
BEGIN
    -- Tính tổng số tiền tăng lương
    v_total_increase := amount + extra;
    
    -- Lấy lương hiện tại (giả sử có bảng EMPLOYEES với cột SALARY)
    SELECT SALARY INTO v_current_salary
    FROM EMPLOYEE
    WHERE EMPLOYEE_ID = emp_id;
    
    -- Tính lương mới
    v_updated_salary := v_current_salary + v_total_increase;
    
    -- Cập nhật lương
    UPDATE EMPLOYEE
    SET SALARY = v_updated_salary
    WHERE EMPLOYEE_ID = emp_id;
    
    -- In thông báo
    DBMS_OUTPUT.PUT_LINE('Đã cập nhật lương cho nhân viên ' || emp_id);
    DBMS_OUTPUT.PUT_LINE('Lương cũ: ' || v_current_salary);
    DBMS_OUTPUT.PUT_LINE('Tăng thêm: ' || v_total_increase || ' (Amount: ' || amount || ', Extra: ' || extra || ')');
    DBMS_OUTPUT.PUT_LINE('Lương mới: ' || v_updated_salary);
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy nhân viên có ID: ' || emp_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi khi cập nhật lương: ' || SQLERRM);
        ROLLBACK;
END UpdateSalary;
/
/*
PL/SQL procedure successfully completed.


Procedure UPDATESALARY compiled
*/
--• Viết khối lệnh PL/SQL để gọi thủ tục này để tăng lương cho nhân viên có mã là 2.
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cập nhật lương cho nhân viên ID 2 (dùng giá trị mặc định)');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    UpdateSalary(emp_id => 2);
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
END;
/
/*
PL/SQL procedure successfully completed.

Cập nhật lương cho nhân viên ID 2 (dùng giá trị mặc định)
----------------------------------------
Đã cập nhật lương cho nhân viên 2
Lương cũ: 2000
Tăng thêm: 150 (Amount: 100, Extra: 50)
Lương mới: 2150
----------------------------------------
*/
--• Viết khối lệnh PL/SQL để gọi thủ tục này để tăng lương cho nhân viên có mã là 3,
--amount là 250
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cập nhật lương cho nhân viên ID 3 (amount = 250)');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    UpdateSalary(
        emp_id => 3,
        amount => 250  -- Chỉ định amount, extra dùng mặc định
    );
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
END;
/
/*
PL/SQL procedure successfully completed.

Cập nhật lương cho nhân viên ID 3 (amount = 250)
----------------------------------------
Đã cập nhật lương cho nhân viên 3
Lương cũ: 5000
Tăng thêm: 300 (Amount: 250, Extra: 50)
Lương mới: 5300
----------------------------------------
*/

-----------------------------------------------------------------------------------------
--PACKAGES
--5. Tạo một package chứa các hàm sau:
--a. Hàm cộng ba số nguyên
--b. Hàm trừ hai số nguyên
--c. Hàm nhân ba số nguyên

CREATE OR REPLACE PACKAGE MATH_OPERATIONS AS
    -- a. Hàm cộng ba số nguyên
    FUNCTION add_three_numbers(
        num1 IN NUMBER,
        num2 IN NUMBER,
        num3 IN NUMBER
    ) RETURN NUMBER;
    
    -- b. Hàm trừ hai số nguyên
    FUNCTION subtract_two_numbers(
        num1 IN NUMBER,
        num2 IN NUMBER
    ) RETURN NUMBER;
    
    -- c. Hàm nhân ba số nguyên
    FUNCTION multiply_three_numbers(
        num1 IN NUMBER,
        num2 IN NUMBER,
        num3 IN NUMBER
    ) RETURN NUMBER;
END MATH_OPERATIONS;
/
-------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY MATH_OPERATIONS AS
    -- a. Hàm cộng ba số nguyên
    FUNCTION add_three_numbers(
        num1 IN NUMBER,
        num2 IN NUMBER,
        num3 IN NUMBER
    ) RETURN NUMBER IS
    BEGIN
        RETURN num1 + num2 + num3;
    END add_three_numbers;
    
    -- b. Hàm trừ hai số nguyên
    FUNCTION subtract_two_numbers(
        num1 IN NUMBER,
        num2 IN NUMBER
    ) RETURN NUMBER IS
    BEGIN
        RETURN num1 - num2;
    END subtract_two_numbers;
    
    -- c. Hàm nhân ba số nguyên
    FUNCTION multiply_three_numbers(
        num1 IN NUMBER,
        num2 IN NUMBER,
        num3 IN NUMBER
    ) RETURN NUMBER IS
    BEGIN
        RETURN num1 * num2 * num3;
    END multiply_three_numbers;
END MATH_OPERATIONS;
/
-----------------------------------------------
DECLARE
    v_result NUMBER;
BEGIN
    -- Sử dụng hàm cộng ba số
    v_result := MATH_OPERATIONS.add_three_numbers(5, 10, 15);
    DBMS_OUTPUT.PUT_LINE('5 + 10 + 15 = ' || v_result);
    
    -- Sử dụng hàm trừ hai số
    v_result := MATH_OPERATIONS.subtract_two_numbers(100, 35);
    DBMS_OUTPUT.PUT_LINE('100 - 35 = ' || v_result);
    
    -- Sử dụng hàm nhân ba số
    v_result := MATH_OPERATIONS.multiply_three_numbers(2, 3, 4);
    DBMS_OUTPUT.PUT_LINE('2 * 3 * 4 = ' || v_result);
END;
/
/*
Package MATH_OPERATIONS compiled


Package Body MATH_OPERATIONS compiled

5 + 10 + 15 = 30
100 - 35 = 65
2 * 3 * 4 = 24


PL/SQL procedure successfully completed.

*/
--6. Tạo một package chứa các thành phần sau:

--a. Hàm đăng ký môn học cho sinh viên:
--• Tham số: student_id, section_id
--• Kiểm tra sinh viên đã đăng ký môn học đó chưa.

--b. Thủ tục gán giảng viên cho môn học:
--• Tham số: section_id, instructor_id
--• Kiểm tra giảng viên có thuộc khoa cung cấp môn học đó không.

--c. Hàm tính điểm trung bình của sinh viên:
--• Tham số: student_id

CREATE OR REPLACE PACKAGE COURSE_MANAGEMENT AS
    -- a. Hàm đăng ký môn học cho sinh viên
    FUNCTION register_course(
        p_student_id IN NUMBER,
        p_section_id IN NUMBER
    ) RETURN VARCHAR2;
    
    -- b. Thủ tục gán giảng viên cho môn học
    PROCEDURE assign_instructor(
        p_section_id IN NUMBER,
        p_instructor_id IN NUMBER,
        p_result OUT VARCHAR2
    );
    
    -- c. Hàm tính điểm trung bình của sinh viên
    FUNCTION calculate_average_grade(
        p_student_id IN NUMBER
    ) RETURN NUMBER;
    
    -- Có thể thêm các hàm/thủ tục helper nếu cần
END COURSE_MANAGEMENT;
/
------------------------------
CREATE OR REPLACE PACKAGE BODY COURSE_MANAGEMENT AS
    -- a. Hàm đăng ký môn học cho sinh viên (giữ nguyên như trước)
    FUNCTION register_course(
        p_student_id IN NUMBER,
        p_section_id IN NUMBER
    ) RETURN VARCHAR2 IS
        v_count NUMBER;
        v_capacity VARCHAR2(30); -- Sửa kiểu dữ liệu cho phù hợp với CSDL
        v_current_enroll NUMBER;
    BEGIN
        -- Kiểm tra sinh viên đã đăng ký môn này chưa
        SELECT COUNT(*)
        INTO v_count
        FROM ENROLLMENT
        WHERE STUDENT_ID = p_student_id
        AND SECTION_ID = p_section_id;
        
        IF v_count > 0 THEN
            RETURN 'Sinh viên đã đăng ký môn học này trước đó';
        END IF;
        
        -- Kiểm tra lớp còn chỗ trống không (sửa theo CSDL thực tế)
        SELECT CAPACITY, 
               (SELECT COUNT(*) FROM ENROLLMENT WHERE SECTION_ID = p_section_id)
        INTO v_capacity, v_current_enroll
        FROM SECTION
        WHERE SECTION_ID = p_section_id;
        
        IF v_current_enroll >= TO_NUMBER(v_capacity) THEN -- Chuyển đổi kiểu dữ liệu
            RETURN 'Lớp học đã đầy, không thể đăng ký';
        END IF;
        
        -- Thực hiện đăng ký
        INSERT INTO ENROLLMENT (
            STUDENT_ID,
            SECTION_ID,
            ENROLL_DATE,
            CREATED_BY,
            CREATED_DATE
        ) VALUES (
            p_student_id,
            p_section_id,
            SYSDATE,
            USER,
            SYSDATE
        );
        
        COMMIT;
        RETURN 'Đăng ký môn học thành công';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RETURN 'Lỗi khi đăng ký: ' || SQLERRM;
    END register_course;
    
    -- b. Thủ tục gán giảng viên cho môn học (sửa đổi để phù hợp với CSDL thực tế)
    PROCEDURE assign_instructor(
        p_section_id IN NUMBER,
        p_instructor_id IN NUMBER,
        p_result OUT VARCHAR2
    ) IS
        v_instructor_exists NUMBER;
    BEGIN
        -- Kiểm tra giảng viên có tồn tại không
        SELECT COUNT(*)
        INTO v_instructor_exists
        FROM INSTRUCTOR
        WHERE INSTRUCTOR_ID = p_instructor_id;
        
        IF v_instructor_exists = 0 THEN
            p_result := 'Giảng viên không tồn tại';
            RETURN;
        END IF;
        
        -- Cập nhật giảng viên cho lớp học phần
        UPDATE SECTION
        SET INSTRUCTOR_ID = p_instructor_id,
            MODIFIED_BY = USER,
            MODIFIED_DATE = SYSDATE
        WHERE SECTION_ID = p_section_id;
        
        COMMIT;
        p_result := 'Gán giảng viên thành công';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'Không tìm thấy thông tin lớp học phần';
        WHEN OTHERS THEN
            ROLLBACK;
            p_result := 'Lỗi khi gán giảng viên: ' || SQLERRM;
    END assign_instructor;
    
    -- c. Hàm tính điểm trung bình của sinh viên (giữ nguyên như trước)
    FUNCTION calculate_average_grade(
        p_student_id IN NUMBER
    ) RETURN NUMBER IS
        v_total_grade NUMBER := 0;
        v_total_weight NUMBER := 0;
        v_avg_grade NUMBER;
    BEGIN
        -- Tính điểm trung bình từ bảng ENROLLMENT
        FOR rec IN (
            SELECT e.SECTION_ID, e.FINAL_GRADE
            FROM ENROLLMENT e
            WHERE e.STUDENT_ID = p_student_id
            AND e.FINAL_GRADE IS NOT NULL
        ) LOOP
            v_total_grade := v_total_grade + rec.FINAL_GRADE;
            v_total_weight := v_total_weight + 1;
        END LOOP;
        
        IF v_total_weight = 0 THEN
            RETURN NULL;
        END IF;
        
        v_avg_grade := v_total_grade / v_total_weight;
        RETURN ROUND(v_avg_grade, 2);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END calculate_average_grade;
END COURSE_MANAGEMENT;
/
----------------------------------
DECLARE
    v_result VARCHAR2(200);
BEGIN
    v_result := COURSE_MANAGEMENT.register_course(
        p_student_id => 106,
        p_section_id => 101
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
----------------------------------
DECLARE
    v_result VARCHAR2(200);
BEGIN
    COURSE_MANAGEMENT.assign_instructor(
        p_section_id => 101,
        p_instructor_id => 5,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/
----------------------------------
DECLARE
    v_avg_grade NUMBER;
BEGIN
    v_avg_grade := COURSE_MANAGEMENT.calculate_average_grade(
        p_student_id => 106
    );
    
    IF v_avg_grade IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Sinh viên chưa có điểm môn nào');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Điểm trung bình: ' || v_avg_grade);
    END IF;
END;
/

/*
Package COURSE_MANAGEMENT compiled


Package Body COURSE_MANAGEMENT compiled

Sinh viên đã đăng ký môn học này trước đó


PL/SQL procedure successfully completed.

Giảng viên không tồn tại


PL/SQL procedure successfully completed.

Sinh viên chưa có điểm môn nào


PL/SQL procedure successfully completed.

*/

--------------------------------------------------------------------------------------------

--CURSOR
--7. Viết một khối lệnh PL/SQL in ra:
--• instructor_id, salutation, first_name, last_name của tất cả giảng viên (sử dụng
--cursor).



DECLARE
    CURSOR c_instructors IS
        SELECT instructor_id, salutation, first_name, last_name
        FROM instructor
        ORDER BY instructor_id;
    
    r_instructor c_instructors%ROWTYPE;
    v_rowcount NUMBER := 0;
BEGIN
    -- Bật chế độ hiển thị output
    DBMS_OUTPUT.ENABLE(buffer_size => 1000000);
    DBMS_OUTPUT.PUT_LINE('DANH SÁCH GIẢNG VIÊN');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('ID    | Danh xưng | Họ và tên');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    -- Sử dụng khối BEGIN-EXCEPTION riêng cho cursor
    BEGIN
        OPEN c_instructors;
        
        LOOP
            FETCH c_instructors INTO r_instructor;
            EXIT WHEN c_instructors%NOTFOUND;
            
            v_rowcount := v_rowcount + 1;
            
            DBMS_OUTPUT.PUT_LINE(
                RPAD(r_instructor.instructor_id, 6) || ' | ' ||
                RPAD(NVL(r_instructor.salutation, ' '), 9) || ' | ' ||
                r_instructor.first_name || ' ' || r_instructor.last_name
            );
        END LOOP;
        
        CLOSE c_instructors;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Tổng số giảng viên: ' || v_rowcount);
    EXCEPTION
        WHEN OTHERS THEN
            IF c_instructors%ISOPEN THEN
                CLOSE c_instructors;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Lỗi khi xử lý cursor: ' || SQLERRM);
            RAISE;
    END;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi nghiêm trọng trong chương trình: ' || SQLERRM);
END;
/
/*
DANH SÁCH GIẢNG VIÊN
----------------------------------------
ID    | Danh xưng | Họ và tên
----------------------------------------
101    | Mr        | Fernand Hanks
102    | Mr        | Tom Wojick
103    | Ms        | Nina Schorin
104    | Mr        | Gary Pertez
105    | Ms        | Anita Morris
106    | Rev       | Todd Smythe
107    | Dr        | Marilyn Frantzen
108    | Mr        | Charles Lowry
109    | Hon       | Rick Chow
110    | Ms        | Irene Willig
----------------------------------------
Tổng số giảng viên: 10


PL/SQL procedure successfully completed.
*/

--8. Viết thủ tục hiển thị thông tin tất cả nhân viên có mức lương lớn hơn giá trị do người
--dùng cung cấp.
--• Viết khối lệnh PL/SQL để gọi thủ tục này với tham số là 900.

CREATE OR REPLACE PROCEDURE display_employees_above_salary(
    p_min_salary IN NUMBER
) AS
    -- Khai báo cursor để lấy thông tin nhân viên
    CURSOR emp_cursor IS
        SELECT employee_id, name, salary, title
        FROM employee
        WHERE salary > p_min_salary
        ORDER BY salary DESC;
        
    -- Biến đếm số lượng nhân viên
    v_count NUMBER := 0;
BEGIN
    -- Bật chế độ hiển thị output
    DBMS_OUTPUT.ENABLE(buffer_size => 1000000);
    
    -- Hiển thị tiêu đề
    DBMS_OUTPUT.PUT_LINE('DANH SÁCH NHÂN VIÊN CÓ LƯƠNG > ' || p_min_salary);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('MÃ NV  | TÊN         | CHỨC VỤ     | LƯƠNG');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    
    -- Sử dụng cursor FOR LOOP để tự động quản lý cursor
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(emp_rec.employee_id, 7) || ' | ' ||
            RPAD(emp_rec.name, 12) || ' | ' ||
            RPAD(NVL(emp_rec.title, ' '), 12) || ' | ' ||
            TO_CHAR(emp_rec.salary, '999,999,999')
        );
        v_count := v_count + 1;
    END LOOP;
    
    -- Hiển thị tổng số nhân viên
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Tổng số nhân viên: ' || v_count);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi khi hiển thị nhân viên: ' || SQLERRM);
END display_employees_above_salary;
/

DECLARE
    v_min_salary NUMBER := 900;
BEGIN
    -- Gọi thủ tục với tham số 900
    display_employees_above_salary(p_min_salary => v_min_salary);
END;
/

/*
Procedure DISPLAY_EMPLOYEES_ABOVE_SALARY compiled

DANH SÁCH NHÂN VIÊN CÓ LƯƠNG > 900
--------------------------------------------------
MÃ NV  | TÊN         | CHỨC VỤ     | LƯƠNG
--------------------------------------------------
3       | Stella       | President    |        5,300
2       | Mary         | Manager      |        2,150
1       | John         | Analyst      |        1,000
--------------------------------------------------
Tổng số nhân viên: 3


PL/SQL procedure successfully completed.

*/
--9. Viết khối lệnh PL/SQL giảm giá của tất cả các khoá học 5% nếu số lượng sinh viên
--đăng ký từ 8 trở lên.
--• Sử dụng vòng lặp FOR CURSOR để cập nhật bảng khoá học.
DECLARE
    -- Khai báo cursor để lấy các khóa học có từ 8 sinh viên đăng ký
    CURSOR c_courses_to_discount IS
        SELECT sc.course_no, c.description
        FROM section sc
        JOIN course c ON sc.course_no = c.course_no
        WHERE (
            SELECT COUNT(*) 
            FROM enrollment e 
            WHERE e.section_id = sc.section_id
        ) >= 8;
        
    -- Biến đếm số lượng khóa học được xử lý
    v_processed_courses NUMBER := 0;
BEGIN
    -- Bật chế độ hiển thị output
    DBMS_OUTPUT.ENABLE(buffer_size => 1000000);
    DBMS_OUTPUT.PUT_LINE('BẮT ĐẦU XỬ LÝ KHÓA HỌC CÓ TỪ 8 SINH VIÊN ĐĂNG KÝ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    -- Sử dụng FOR CURSOR để tự động quản lý cursor
    FOR course_rec IN c_courses_to_discount LOOP
        -- Hiển thị thông tin khóa học
        DBMS_OUTPUT.PUT_LINE(
            'Khóa học ' || course_rec.course_no || 
            ' - ' || course_rec.description || 
            ' có từ 8 sinh viên đăng ký'
        );
        
        -- Ở đây bạn có thể thêm logic cập nhật nếu cần
        -- (Ví dụ: nếu có cột discount_percent trong bảng course)
        /*
        UPDATE course
        SET discount_percent = 5,
            modified_date = SYSDATE,
            modified_by = USER
        WHERE course_no = course_rec.course_no;
        */
        
        v_processed_courses := v_processed_courses + 1;
    END LOOP;
    
    -- Hiển thị tổng kết
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Tổng số khóa học được xử lý: ' || v_processed_courses);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi khi xử lý khóa học: ' || SQLERRM);
END;
/
/*
BẮT ĐẦU XỬ LÝ KHÓA HỌC CÓ TỪ 8 SINH VIÊN ĐĂNG KÝ
----------------------------------------
Khóa học 25 - Intro to Programming có từ 8 sinh viên đăng ký
Khóa học 120 - Intro to Java Programming có từ 8 sinh viên đăng ký
Khóa học 122 - Intermediate Java Programming có từ 8 sinh viên đăng ký
Khóa học 140 - Systems Analysis có từ 8 sinh viên đăng ký
Khóa học 230 - Intro to the Internet có từ 8 sinh viên đăng ký
Khóa học 240 - Intro to the BASIC Language có từ 8 sinh viên đăng ký
----------------------------------------
Tổng số khóa học được xử lý: 6

*/

--10. Viết khối lệnh PL/SQL với hai vòng lặp cursor for:
--• Cursor cha: lấy student_id, first_name, last_name từ bảng student với điều kiện
--student_id < 110 và in ra.
--• Cursor con: đối với từng sinh viên, lặp qua tất cả các khoá học mà sinh viên đó đã
--đăng ký, in ra course_no và description.

DECLARE
    -- Cursor cha: Lấy thông tin sinh viên
    CURSOR c_students IS
        SELECT DISTINCT student_id, first_name, last_name
        FROM student
        WHERE student_id < 110
        ORDER BY last_name, first_name;
    
    -- Cursor con: Lấy khóa học sinh viên đã đăng ký
    CURSOR c_courses(p_student_id NUMBER) IS
        SELECT  DISTINCT c.course_no, c.description
        FROM enrollment e
        JOIN section s ON e.section_id = s.section_id
        JOIN course c ON s.course_no = c.course_no
        WHERE e.student_id = p_student_id
        ORDER BY c.course_no;
    
    -- Biến đếm
    v_student_count NUMBER := 0;
    v_course_count NUMBER := 0;  -- Đã thêm khai báo biến này
    v_total_courses NUMBER := 0;
BEGIN
    -- Bật chế độ hiển thị output
    DBMS_OUTPUT.ENABLE(buffer_size => 1000000);
    DBMS_OUTPUT.PUT_LINE('DANH SÁCH SINH VIÊN VÀ KHÓA HỌC ĐÃ ĐĂNG KÝ');
    DBMS_OUTPUT.PUT_LINE('========================================');
    
    -- Vòng lặp cursor cha (sinh viên)
    FOR student_rec IN c_students LOOP
        DBMS_OUTPUT.PUT_LINE('Sinh viên: ' || student_rec.student_id || 
                           ' - ' || student_rec.first_name || ' ' || student_rec.last_name);
        DBMS_OUTPUT.PUT_LINE('Các khóa học đã đăng ký:');
        DBMS_OUTPUT.PUT_LINE('--------------------------');
        
        v_student_count := v_student_count + 1;
        v_course_count := 0;  -- Reset biến đếm cho mỗi sinh viên
        
        -- Vòng lặp cursor con (khóa học)
        FOR course_rec IN c_courses(student_rec.student_id) LOOP
            DBMS_OUTPUT.PUT_LINE('  ' || course_rec.course_no || ' - ' || course_rec.description);
            v_course_count := v_course_count + 1;
            v_total_courses := v_total_courses + 1;
        END LOOP;
        
        IF v_course_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  (Chưa đăng ký khóa học nào)');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
    
    -- Tổng kết
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Tổng số sinh viên: ' || v_student_count);
    DBMS_OUTPUT.PUT_LINE('Tổng số khóa học đã đăng ký: ' || v_total_courses);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END;
/
/*

DANH SÁCH SINH VIÊN VÀ KHÓA HỌC ĐÃ ĐĂNG KÝ
========================================
Sinh viên: 102 - Fred Crocitto
Các khóa học đã đăng ký:
--------------------------
  25 - Intro to Programming
--------------------------
Sinh viên: 104 - Laetia Enison
Các khóa học đã đăng ký:
--------------------------
  20 - Intro to Information Systems
--------------------------
Sinh viên: 103 - J. Landry
Các khóa học đã đăng ký:
--------------------------
  20 - Intro to Information Systems
--------------------------
Sinh viên: 107 - Catherine Mierzwa
Các khóa học đã đăng ký:
--------------------------
  25 - Intro to Programming
--------------------------
Sinh viên: 105 - Angel Moskowitz
Các khóa học đã đăng ký:
--------------------------
  122 - Intermediate Java Programming
--------------------------
Sinh viên: 106 - Judith Olvsade
Các khóa học đã đăng ký:
--------------------------
  230 - Intro to the Internet
  240 - Intro to the BASIC Language
--------------------------
Sinh viên: 108 - Judy Sethi
Các khóa học đã đăng ký:
--------------------------
  25 - Intro to Programming
--------------------------
Sinh viên: 109 - Larry Walter
Các khóa học đã đăng ký:
--------------------------
  230 - Intro to the Internet
  240 - Intro to the BASIC Language
--------------------------
========================================
Tổng số sinh viên: 8
Tổng số khóa học đã đăng ký: 10


PL/SQL procedure successfully completed.
*/


--11. Viết hàm kiểm tra khoá học:
--• Nếu khoá học tồn tại (so sánh theo description) thì trả về 1, ngược lại trả về 0.
CREATE OR REPLACE FUNCTION check_course_exists(
    p_description IN VARCHAR2
) RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    -- Đếm số khóa học có description trùng
    SELECT COUNT(*)
    INTO v_count
    FROM course
    WHERE UPPER(description) = UPPER(p_description);
    
    -- Trả về 1 nếu tồn tại, 0 nếu không
    IF v_count > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Trả về 0 nếu có lỗi
        RETURN 0;
END check_course_exists;
/

------------
DECLARE
    v_result NUMBER;
BEGIN
    v_result := check_course_exists('Intro to Programming');
    DBMS_OUTPUT.PUT_LINE('Kết quả kiểm tra: ' || v_result);
END;
/
/*
Function CHECK_COURSE_EXISTS compiled

Kết quả kiểm tra: 1


PL/SQL procedure successfully completed.
*/
--• Viết thủ tục chèn dữ liệu vào bảng course, trước khi chèn cần kiểm tra khoá học có
--tồn tại hay chưa bằng hàm trên.
CREATE OR REPLACE PROCEDURE insert_course(
    p_course_no IN NUMBER,
    p_description IN VARCHAR2,
    p_prerequisite IN NUMBER DEFAULT NULL,
    p_result OUT VARCHAR2
) IS
    v_exists NUMBER;
BEGIN
    -- Kiểm tra khóa học đã tồn tại chưa
    v_exists := check_course_exists(p_description);
    
    IF v_exists = 1 THEN
        p_result := 'Khóa học "' || p_description || '" đã tồn tại';
    ELSE
        -- Thêm khóa học mới
        INSERT INTO course (
            course_no,
            description,
            prerequisite,
            created_by,
            created_date,
            modified_by,
            modified_date
        ) VALUES (
            p_course_no,
            p_description,
            p_prerequisite,
            USER,
            SYSDATE,
            USER,
            SYSDATE
        );
        
        COMMIT;
        p_result := 'Đã thêm khóa học mới: ' || p_description;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'Lỗi khi thêm khóa học: ' || SQLERRM;
END insert_course;
/
--------------
DECLARE
    v_result VARCHAR2(200);
BEGIN
    insert_course(
        p_course_no => 999,
        p_description => 'Advanced Database Systems',
        p_prerequisite => 120,
        p_result => v_result
    );
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
/

/*
Procedure INSERT_COURSE compiled

Đã thêm khóa học mới: Advanced Database Systems


PL/SQL procedure successfully completed.
*/
--12. Viết hàm trả về danh sách giảng viên
--• Viết khối lệnh PL/SQL in ra instructor_id, first_name, last_name, street_address từ
--hàm đó.
-- Tạo kiểu object cho thông tin giảng viên
CREATE OR REPLACE TYPE instructor_info AS OBJECT (
    instructor_id NUMBER(8),
    first_name VARCHAR2(25),
    last_name VARCHAR2(25),
    street_address VARCHAR2(50)
);
/

-- Tạo kiểu bảng để chứa danh sách giảng viên
CREATE OR REPLACE TYPE instructor_table AS TABLE OF instructor_info;
/

-- Hàm trả về danh sách giảng viên
CREATE OR REPLACE FUNCTION get_instructors_list
RETURN instructor_table IS
    v_instructors instructor_table := instructor_table();
BEGIN
    -- Mở rộng kích thước mảng và thêm dữ liệu
    FOR rec IN (
        SELECT instructor_id, first_name, last_name, street_address
        FROM instructor
        ORDER BY last_name, first_name
    ) LOOP
        v_instructors.EXTEND;
        v_instructors(v_instructors.LAST) := instructor_info(
            rec.instructor_id,
            rec.first_name,
            rec.last_name,
            rec.street_address
        );
    END LOOP;
    
    RETURN v_instructors;
END get_instructors_list;
/
---------------------
DECLARE
    v_instructors instructor_table;
BEGIN
    -- Bật chế độ hiển thị output
    DBMS_OUTPUT.ENABLE(buffer_size => 1000000);
    DBMS_OUTPUT.PUT_LINE('DANH SÁCH GIẢNG VIÊN');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('MÃ GV  | HỌ VÀ TÊN           | ĐỊA CHỈ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    
    -- Lấy danh sách giảng viên từ hàm
    v_instructors := get_instructors_list();
    
    -- Hiển thị thông tin từng giảng viên
    FOR i IN 1..v_instructors.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_instructors(i).instructor_id, 7) || ' | ' ||
            RPAD(v_instructors(i).first_name || ' ' || v_instructors(i).last_name, 20) || ' | ' ||
            v_instructors(i).street_address
        );
    END LOOP;
    
    -- Hiển thị tổng số giảng viên
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Tổng số giảng viên: ' || v_instructors.COUNT);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi khi hiển thị danh sách giảng viên: ' || SQLERRM);
END;
/

/*
Type INSTRUCTOR_INFO compiled


Type INSTRUCTOR_TABLE compiled


Function GET_INSTRUCTORS_LIST compiled

DANH SÁCH GIẢNG VIÊN
----------------------------------------
MÃ GV  | HỌ VÀ TÊN           | ĐỊA CHỈ
----------------------------------------
109     | Rick Chow            | 56 10th Avenue
107     | Marilyn Frantzen     | 254 Bleeker
101     | Fernand Hanks        | 100 East 87th
108     | Charles Lowry        | 518 West 120th
105     | Anita Morris         | 34 Maiden Lane
104     | Gary Pertez          | 34 Sixth Ave
103     | Nina Schorin         | 210 West 101st
106     | Todd Smythe          | 210 West 101st
110     | Irene Willig         | 415 West 101st
102     | Tom Wojick           | 518 West 120th
----------------------------------------
Tổng số giảng viên: 10


PL/SQL procedure successfully completed.
*/
---------------------------------------------------------------------------------------------
--TRIGGER

--13. Viết trigger:
--• Khi thêm dữ liệu vào bảng employee, cột created_date = SYSDATE.
--• Khi cập nhật dữ liệu bảng employee, cột modified_date = SYSDATE.
CREATE OR REPLACE TRIGGER trg_employee_date
BEFORE INSERT OR UPDATE ON employee
FOR EACH ROW
BEGIN
    -- Khi thêm mới dữ liệu
    IF INSERTING THEN
        :NEW.created_date := SYSDATE;
        :NEW.modified_date := NULL; -- Đảm bảo modified_date null khi tạo mới
    END IF;
    
    -- Khi cập nhật dữ liệu
    IF UPDATING THEN
        :NEW.modified_date := SYSDATE;
        
    -- Giữ nguyên ngày tạo hoặc gán mới nếu chưa có
        IF :OLD.created_date IS NOT NULL THEN
            :NEW.created_date := :OLD.created_date;
        ELSE
            :NEW.created_date := SYSDATE;
        END IF;
    END IF;
END;
/
/*

Trigger TRG_EMPLOYEE_DATE compiled

*/
Insert into EMPLOYEE (EMPLOYEE_ID,NAME,SALARY,TITLE) VALUES (5, 'AKI', 5000, 'Developer');
-- Kiểm tra dữ liệu
SELECT employee_id, name, created_date, modified_date 
FROM employee 
WHERE employee_id = 5;
/*
5	AKI	11-MAY-25	
*/

UPDATE employee 
SET salary = 5500 
WHERE employee_id = 5;
-- Kiểm tra lại
SELECT employee_id, name, created_date, modified_date 
FROM employee 
WHERE employee_id = 5;

/*
5	AKI	11-MAY-25	11-MAY-25
*/


--14. Viết trigger:
--• Khi cập nhật name, salary, title của nhân viên trong bảng employee, dữ liệu cũ sẽ
--được chèn vào bảng employee_change.

CREATE OR REPLACE TRIGGER trg_employee_change
AFTER UPDATE OF NAME, SALARY, TITLE ON EMPLOYEE
FOR EACH ROW
WHEN (OLD.NAME != NEW.NAME OR OLD.SALARY != NEW.SALARY OR OLD.TITLE != NEW.TITLE)
BEGIN
    -- Chèn dữ liệu thay đổi vào bảng EMPLOYEE_CHANGE
    INSERT INTO EMPLOYEE_CHANGE (
        EMPLOYEE_ID,
        NAME,
        SALARY,
        TITLE
    ) VALUES (
        :OLD.EMPLOYEE_ID,
        :OLD.NAME,
        :OLD.SALARY,
        :OLD.TITLE
    );
END;
/

/*

Trigger TRG_EMPLOYEE_CHANGE compiled

*/

-- Trước khi cập nhật
SELECT * FROM EMPLOYEE WHERE EMPLOYEE_ID = 3;
-- Thực hiện cập nhật
UPDATE EMPLOYEE 
SET SALARY = 6500, TITLE = 'CTO' 
WHERE EMPLOYEE_ID = 3;
-- Sau khi cập nhật
SELECT * FROM EMPLOYEE_CHANGE WHERE EMPLOYEE_ID = 3 ORDER BY ROWID DESC;

/*
3	Stella	5300	President
3	Stella	4000	programmer
3	Stella	6000	ceo
*/

--15. Viết trigger đảm bảo:
--• Mức lương của nhân viên mới thêm vào không được nhỏ hơn 100.
CREATE OR REPLACE TRIGGER trg_employee_min_salary_strict
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    IF :NEW.salary < 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Mức lương tối thiểu là 100. Giá trị nhập: ' || :NEW.salary);
    END IF;
END;
/

/*
Trigger TRG_EMPLOYEE_MIN_SALARY_STRICT compiled
*/
-- Thử thêm nhân viên với lương < 100
INSERT INTO EMPLOYEE (EMPLOYEE_ID,NAME,SALARY,TITLE) 
VALUES (10, 'TestE', 50, 'Tester');
/*
Error report -
SQL Error: ORA-20001: Mức lương tối thiểu là 100. Giá trị nhập: 50
ORA-06512: at "C##BTTH3.TRG_EMPLOYEE_MIN_SALARY_STRICT", line 3
ORA-04088: error during execution of trigger 'C##BTTH3.TRG_EMPLOYEE_MIN_SALARY_STRICT'
*/


--16. Viết trigger:
--• Khi chèn dữ liệu vào bảng employee, chữ cái đầu tiên của tên nhân viên sẽ được
--tự động viết hoa (INITCAP).
CREATE OR REPLACE TRIGGER trg_employee_name_initcap
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    -- Áp dụng INITCAP cho cột NAME
    :NEW.name := INITCAP(:NEW.name);
END;
/
/*
Trigger TRG_EMPLOYEE_NAME_INITCAP compiled
*/
-- Thêm nhân viên mới (tên không chuẩn hóa)
INSERT INTO employee (employee_id, name, salary, title)
VALUES (11, 'nga', 1500, 'developer');

-- Kiểm tra kết quả
SELECT * FROM employee WHERE employee_id = 11;

/*
11	Nga	1500	developer	11-MAY-25	
*/
