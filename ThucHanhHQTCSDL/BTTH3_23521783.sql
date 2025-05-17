/*
Ten: Pham Hung Quoc Viet
MSSV: 23521783
*/

SET SERVEROUTPUT ON;
SET ECHO OFF;
--Bài tập cơ bản
--1. Viết đoạn chương trình nhập n, kiểm tra n có phải là số nguyên tố hay không?
DECLARE
 n number;
 i number:= 2;
 is_prime BOOLEAN := TRUE ;
 BEGIN
 n:= &n;
 IF n<2 THEN
    is_prime := FALSE;
 ELSE
    WHILE I <= SQRT(n) 
    LOOP
        IF  mod(n,i) = 0 
        THEN
        is_prime := FALSE;
        EXIT;
        END IF;
 i:= i+1;
 END LOOP;
 END IF;
 
 IF is_prime 
 THEN
 DBMS_OUTPUT.PUT_LINE('SNT!');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('KO LA SNT!');
  END IF;
  end;
  /*
  n=5
  SNT!


PL/SQL procedure successfully completed.
  */
--2. Viết đoạn chương trình nhập n, in ra n số nguyên tố.
DECLARE
  n INTEGER;
  count_primes INTEGER := 0;
  num INTEGER := 2;
  is_prime BOOLEAN;
  i INTEGER;
BEGIN
  -- Nhập giá trị n 
  n := &n;

  DBMS_OUTPUT.PUT_LINE('Danh sách ' || n || ' số nguyên tố đầu tiên:');

  WHILE count_primes < n LOOP
    is_prime := TRUE;
    IF num <= 1 THEN
      is_prime := FALSE;
    ELSE
      FOR i IN 2..TRUNC(SQRT(num)) LOOP
        IF num MOD i = 0 THEN
          is_prime := FALSE;
          EXIT;
        END IF;
      END LOOP;
    END IF;

    IF is_prime THEN
      DBMS_OUTPUT.PUT_LINE(num);
      count_primes := count_primes + 1;
    END IF;

    num := num + 1;
  END LOOP;
END;
/*
n=5
Danh sách 5 số nguyên tố đầu tiên:
2
3
5
7
11


PL/SQL procedure successfully completed.

*/
-----------------------

DECLARE
  num number :=2;
  count_primes INTEGER := 0;
  n number;
  i number;
  is_prime BOOLEAN := TRUE ;
BEGIN
  -- Nhập giá trị n 
  n := &n;

  DBMS_OUTPUT.PUT_LINE('Danh sách ' || n || ' số nguyên tố đầu tiên:');

  WHILE count_primes < n 
  
  LOOP
    is_prime := TRUE;
    IF num <= 1 THEN
      is_prime := FALSE;
    ELSE 
    i:=2;
    WHILE i <= SQRT(num) 
    LOOP
        IF  mod(num,i) = 0 
        THEN
        is_prime := FALSE;
        EXIT;
        END IF;
        i:= i+1;
    END LOOP;
    END IF;

    IF is_prime THEN
      DBMS_OUTPUT.PUT_LINE(num);
      count_primes := count_primes + 1;
    END IF;

    num := num + 1;
  END LOOP;
END;
/*

Danh sách 4 số nguyên tố đầu tiên:
2
3
5
7


PL/SQL procedure successfully completed.
*/


--3. Viết đoạn chương trình giải và biện luận phương trình bậc 2: ax2 + bx + c = 0
CREATE OR REPLACE FUNCTION GIAI_PT_BAC_2 (
    a IN NUMBER,
    b IN NUMBER,
    c IN NUMBER
) RETURN VARCHAR2 IS
    delta NUMBER;
    x1 NUMBER;
    x2 NUMBER;
    result VARCHAR2(200);
BEGIN
    IF a = 0 THEN
        IF b = 0 THEN
            IF c = 0 THEN
                result := 'Phương trình vô số nghiệm.';
            ELSE
                result := 'Phương trình vô nghiệm.';
            END IF;
        ELSE
            x1 := -c / b;
            result := 'Phương trình có một nghiệm: x = ' || TO_CHAR(x1);
        END IF;
    ELSE
        delta := b * b - 4 * a * c;
        IF delta > 0 THEN
            x1 := (-b + SQRT(delta)) / (2 * a);
            x2 := (-b - SQRT(delta)) / (2 * a);
            result := 'Phương trình có hai nghiệm phân biệt: x1 = ' || TO_CHAR(x1) || ', x2 = ' || TO_CHAR(x2);
        ELSIF delta = 0 THEN
            x1 := -b / (2 * a);
            result := 'Phương trình có nghiệm kép: x = ' || TO_CHAR(x1);
        ELSE
            result := 'Phương trình vô nghiệm thực.';
        END IF;
    END IF;

    RETURN result;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(GIAI_PT_BAC_2(1, -3, 2));
    DBMS_OUTPUT.PUT_LINE(GIAI_PT_BAC_2(1, 2, 1)); 
    DBMS_OUTPUT.PUT_LINE(GIAI_PT_BAC_2(0, 2, -4)); 
END;
/
/*

Function GIAI_PT_BAC_2 compiled

Phương trình có hai nghiệm phân biệt: x1 = 2, x2 = 1
Phương trình có nghiệm kép: x = -1
Phương trình có một nghiệm: x = 2


PL/SQL procedure successfully completed.
*/


--  4. Viết đoạn chương trình nhập 3 cạnh tam giác, kiểm tra tam giác có hợp lệ hay không? Nếu có
-- cho biết loại tam giác: đều, cân, vuông, vuông cân?
CREATE OR REPLACE FUNCTION PHAN_LOAI_TAM_GIAC (
    a IN NUMBER,
    b IN NUMBER,
    c IN NUMBER
) RETURN VARCHAR2 IS
    msg VARCHAR2(100);

    -- Hàm con kiểm tra tam giác vuông
    FUNCTION isRightTriangle(x NUMBER, y NUMBER, z NUMBER) RETURN BOOLEAN IS
    BEGIN
        RETURN ROUND(x*x + y*y, 5) = ROUND(z*z, 5);
    END;

BEGIN
    -- Kiểm tra điều kiện tồn tại tam giác
    IF (a + b <= c) OR (a + c <= b) OR (b + c <= a) THEN
        msg := 'Không phải là tam giác hợp lệ.';
    ELSE
        -- Tam giác đều
        IF a = b AND b = c THEN
            msg := 'Tam giác đều.';
        -- Tam giác cân
        ELSIF a = b OR a = c OR b = c THEN
            IF isRightTriangle(a, b, c) OR isRightTriangle(a, c, b) OR isRightTriangle(b, c, a) THEN
                msg := 'Tam giác vuông cân.';
            ELSE
                msg := 'Tam giác cân.';
            END IF;
        -- Tam giác vuông
        ELSIF isRightTriangle(a, b, c) OR isRightTriangle(a, c, b) OR isRightTriangle(b, c, a) THEN
            msg := 'Tam giác vuông.';
        ELSE
            msg := 'Tam giác thường.';
        END IF;
    END IF;

    RETURN msg;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE(PHAN_LOAI_TAM_GIAC(3, 4, 5)); 
    DBMS_OUTPUT.PUT_LINE(PHAN_LOAI_TAM_GIAC(2, 2, 2)); 
    DBMS_OUTPUT.PUT_LINE(PHAN_LOAI_TAM_GIAC(1, 2, 3)); 
END;
/
/*

Function PHAN_LOAI_TAM_GIAC compiled

Tam giác vuông.
Tam giác đều.
Không phải là tam giác hợp lệ.


PL/SQL procedure successfully completed.
*/

--Bài tập thực hành
--1. Viết một block PL/SQL để gán giá trị cho một biến và in giá trị đó ra màn hình.

DECLARE
    -- Khai báo biến
    my_variable VARCHAR2(50);
BEGIN
    -- Gán giá trị cho biến
    my_variable := '&my_variable';
    
    -- In giá trị của biến ra màn hình
    DBMS_OUTPUT.PUT_LINE('Giá trị của biến là: ' || my_variable);
END;
/
/*
hello vjt
Giá trị của biến là: hello vjt


PL/SQL procedure successfully completed.

*/

--2. Viết một block PL/SQL để kiểm tra một số là số lẻ hay số chẵn.

DECLARE 
    n NUMBER;
BEGIN
    n := &n;
    IF  mod(n,2)= 0
    THEN DBMS_OUTPUT.PUT_LINE('N LA SO CHAN!');
    ELSE
    DBMS_OUTPUT.PUT_LINE('N LA SO LE!');
    END IF;
END;
/
/*
N=5
N LA SO LE!


PL/SQL procedure successfully completed.
*/
--3. Viết một block PL/SQL để kiểm tra một số lớn hơn hay nhỏ hơn 0.
SET ECHO OFF;

DECLARE
    -- Khai báo biến
    my_number NUMBER;
BEGIN
    -- Gán giá trị cho biến (số có thể thay đổi)
    my_number := &my_number;
    
    -- Kiểm tra số lớn hơn, nhỏ hơn hoặc bằng 0
    IF my_number > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Số ' || my_number || ' lớn hơn 0.');
    ELSIF my_number < 0 THEN
        DBMS_OUTPUT.PUT_LINE('Số ' || my_number || ' nhỏ hơn 0.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Số ' || my_number || ' bằng 0.');
    END IF;
END;
/

/*
 NHAP 5
Số 5 lớn hơn 0.


PL/SQL procedure successfully completed.
*/

--4. Sử dụng cơ sở dữ liệu Quản lý Sinh viên, viết một block PL/SQL để kiểm tra có bao nhiêu
--sinh viên đang ghi danh vào lớp có section_id = 85. Nếu có từ 15 sinh viên trở lên, hiển thị
--thông báo rằng lớp đã đầy. Ngược lại, thông báo lớp chưa đầy.

DECLARE
numofstu number;
BEGIN
    SELECT COUNT(*) INTO numofstu
    FROM ENROLLMENT
    WHERE SECTION_ID = 85;
    
    IF numofstu >15 THEN 
    dbms_output.PUT_LINE('LOP DAY');
    ELSE 
    dbms_output.PUT_LINE('LOP CHUA DAY');
    END IF;
END;
/*
LOP CHUA DAY
*/
-----------------------

--5. Làm lại câu 4 nhưng sử dụng procedure có hai tham số: course number và section number.
--Viết một block PL/SQL để gọi procedure này với tham số section 85.

CREATE OR REPLACE PROCEDURE check_full_section(sectionid number)
AS
    numofstu number;
BEGIN
    SELECT COUNT(*) INTO numofstu
    from enrollment
    WHERE SECTION_ID = sectionid;
    
    IF numofstu >15 THEN
    dbms_output.PUT_LINE('LOP DAY');
    ELSE 
    dbms_output.PUT_LINE('LOP CHUA DAY');
    END IF;
END;

BEGIN
check_full_section(85);
end;
/*
LOP CHUA DAY
*/

--6. Viết một block PL/SQL sử dụng vòng lặp FOR để tính giai thừa của 10 (10! = 1 × 2 × 3 × ... ×10).

DECLARE
    -- Khai báo biến
    factorial NUMBER := 1;
    i NUMBER;
BEGIN
    -- Sử dụng vòng lặp FOR để tính giai thừa của 10
    FOR i IN 1..10 LOOP
        factorial := factorial * i; -- Cập nhật giá trị giai thừa
    END LOOP;
    
    -- In kết quả ra màn hình
    DBMS_OUTPUT.PUT_LINE('Giai thừa của 10 là: ' || factorial);
END;
/
/*

Giai thừa của 10 là: 3628800


PL/SQL procedure successfully completed.
*/


--7. Viết một procedure để tính giai thừa của một số. Viết một block PL/SQL để gọi procedure này.
CREATE OR REPLACE PROCEDURE giaithua( a in number)
AS
    factorial NUMBER:= 1;
    i NUMBER;
    
    
    BEGIN
       for i IN 1..a LOOP
       factorial := factorial * i;
       end loop;
       
       DBMS_OUTPUT.put_line('Giai thua cua ' || a || ' la: ' || factorial);
    end;
    
/

BEGIN
giaithua(9);
end;
/*
Giai thua cua 9 la: 362880


PL/SQL procedure successfully completed.
*/

--8. Viết một function để tính giai thừa của một số. Viết một block PL/SQL để gọi function này

CREATE OR REPLACE FUNCTION giaithuafunction(a IN NUMBER)
RETURN NUMBER
IS
    factorial NUMBER := 1;
    i NUMBER;
BEGIN
    FOR i IN 1..a LOOP
        factorial := factorial * i;
    END LOOP;
    
    RETURN factorial;
END;
/

DECLARE
    so NUMBER := 5;  -- có thể thay bằng số khác
    ketqua NUMBER;
BEGIN
    ketqua := giaithuafunction(so);
    DBMS_OUTPUT.put_line('Giai thua cua ' || so || ' la: ' || ketqua);
END;

/*
Function GIAITHUAFUNCTION compiled

Giai thua cua 5 la: 120


PL/SQL procedure successfully completed.
*/

--9. Viết một procedure để tính và in kết quả của một phép chia. Nếu mẫu số bằng 0, xử lý ngoại
--lệ. Viết một block PL/SQL để gọi procedure này.
--• EXCEPTION
--o WHEN ZERO_DIVIDE THEN
--▪ DBMS_OUTPUT.PUT_LINE('Không thể chia một số cho 0.');


CREATE OR REPLACE PROCEDURE phepchia(a in number, b in number)
AS
    KETQUA NUMBER;
    CHIA_0 EXCEPTION;
    
BEGIN
    IF(b = 0) then
     RAISE CHIA_0;
    ELSE
     KETQUA := a/b;
     DBMS_OUTPUT.PUT_LINE('KET QUA PHEP CHIA LA : '||KETQUA);
    END IF;
EXCEPTION
    WHEN CHIA_0 THEN
                    KETQUA:=NULL;
                    DBMS_OUTPUT.PUT_LINE('KHONG THE CHIA CHO 0 !');
END;
/*
PL/SQL procedure successfully completed.


Procedure PHEPCHIA compiled
*/
BEGIN
phepchia(6,6);
END;
/*

KET QUA PHEP CHIA LA : 1


PL/SQL procedure successfully completed.
*/




--10. Viết một function để tính kết quả của một phép chia. Viết một block PL/SQL để gọi function
--này.
CREATE OR REPLACE FUNCTION phepchiafunction(a in number, b in number)
RETURN NUMBER
IS 
KETQUA NUMBER;
CHIA_0 EXCEPTION;

BEGIN
IF(b = 0) then
     RAISE CHIA_0;
    ELSE
     KETQUA := a/b;
    RETURN KETQUA;
    END IF;
EXCEPTION
    WHEN CHIA_0 THEN
                    KETQUA:=NULL;
                    
    RETURN KETQUA;
END;


/
DECLARE
    so1 NUMBER := 10; -- bạn có thể thay đổi
    so2 NUMBER := 2;  -- thử với 0 để kiểm tra chia cho 0
    ketqua NUMBER;
BEGIN
    ketqua := phepchiafunction(so1, so2);
    
    -- Nếu muốn hiển thị thêm kết quả ở đây (tùy)
    IF ketqua IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Ket qua tra ve tu function: ' || ketqua);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Function tra ve NULL do chia cho 0');
    END IF;
END;
/*
Function PHEPCHIAFUNCTION compiled

Ket qua tra ve tu function: 5


PL/SQL procedure successfully completed.
*/

--11. Sử dụng cơ sở dữ liệu Quản lý Sinh viên, viết một procedure để hiển thị tên sinh viên và
--địa chỉ. Nếu không có sinh viên nào với student_id do người dùng nhập vào, ngoại lệ
--NO_DATA_FOUND sẽ được kích hoạt.
--• Viết một block PL/SQL để gọi procedure với student_id = 25, 105.
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE hienthisv( id IN NUMBER )
    AS
        name VARCHAR2(25);
        adr  VARCHAR2(50);
       
    BEGIN
        SELECT LAST_NAME ,  STREET_ADDRESS 
        into name, adr
        FROM STUDENT
        WHERE STUDENT_ID = id ;
         DBMS_OUTPUT.PUT_LINE('Ten sinh vien: ' || name);
         DBMS_OUTPUT.PUT_LINE('Dia chi: ' || adr);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Khong tim thay sinh vien co ID = ' || id);
    END;
    /
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('----- SINH VIEN ID = 25 -----');
    hienthisv(25);

    DBMS_OUTPUT.PUT_LINE('----- SINH VIEN ID = 105 -----');
    hienthisv(105);
END;

/*

Procedure HIENTHISV compiled

----- SINH VIEN ID = 25 -----
Khong tim thay sinh vien co ID = 25
----- SINH VIEN ID = 105 -----
Ten sinh vien: Moskowitz
Dia chi: 320 John St.


PL/SQL procedure successfully completed.

*/

--12. Làm lại câu 11 nhưng sử dụng function để trả về thông tin sinh viên (dùng biến kiểu
--ROWTYPE). Viết một block PL/SQL để gọi function này và in tên sinh viên, địa chỉ, số điện
--thoại.
CREATE OR REPLACE FUNCTION hienthisvc12(p_id IN NUMBER)
RETURN STUDENT%ROWTYPE
IS
    sv_record STUDENT%ROWTYPE;
BEGIN
    SELECT * INTO sv_record
    FROM STUDENT
    WHERE STUDENT_ID = p_id;

    RETURN sv_record;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay sinh vien co ID = ' || p_id);
        RETURN NULL;
END;
/

DECLARE
    sv STUDENT%ROWTYPE;
BEGIN
    sv := hienthisvc12(105);  

    IF sv.STUDENT_ID IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Ten: ' || sv.LAST_NAME);
        DBMS_OUTPUT.PUT_LINE('Dia chi: ' || sv.STREET_ADDRESS);
        DBMS_OUTPUT.PUT_LINE('So dien thoai: ' || sv.PHONE);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Khong co du lieu de hien thi');
    END IF;
END;
/*

PL/SQL procedure successfully completed.


Function HIENTHISVC12 compiled

Ten: Moskowitz
Dia chi: 320 John St.
So dien thoai: 201-555-5555


PL/SQL procedure successfully completed.

*/

--13. Viết một procedure để kiểm tra sinh viên có đăng ký môn học không.
--• Nếu không có bản ghi nào trong bảng ENROLLMENT với student_id do người dùng
--nhập, kích hoạt ngoại lệ NO_DATA_FOUND.
--• Nếu có nhiều hơn một bản ghi, kích hoạt ngoại lệ TOO_MANY_ROWS.
--• Viết một block PL/SQL để gọi procedure trên với các giá trị student_id = 102, 103, 319.

CREATE OR REPLACE PROCEDURE kiemtra_dangky(p_student_id IN NUMBER)
AS
    v_course_id VARCHAR2(10);  -- sửa lỗi ở đây
BEGIN
    SELECT SECTION_ID INTO v_course_id
    FROM ENROLLMENT
    WHERE STUDENT_ID = p_student_id;

    DBMS_OUTPUT.PUT_LINE('Sinh vien ID ' || p_student_id || ' da dang ky mon: ' || v_course_id);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay dang ky nao cho sinh vien ID = ' || p_student_id);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Sinh vien ID ' || p_student_id || ' da dang ky nhieu hon mot mon hoc.');
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST STUDENT_ID = 102 ---');
    kiemtra_dangky(102);

    DBMS_OUTPUT.PUT_LINE('--- TEST STUDENT_ID = 103 ---');
    kiemtra_dangky(103);

    DBMS_OUTPUT.PUT_LINE('--- TEST STUDENT_ID = 319 ---');
    kiemtra_dangky(319);
END;

/*
Procedure KIEMTRA_DANGKY compiled

--- TEST STUDENT_ID = 102 ---
Sinh vien ID 102 da dang ky nhieu hon mot mon hoc.
--- TEST STUDENT_ID = 103 ---
Sinh vien ID 103 da dang ky mon: 81
--- TEST STUDENT_ID = 319 ---
Khong tim thay dang ky nao cho sinh vien ID = 319


PL/SQL procedure successfully completed.
*/

--14. Viết một procedure để tìm tên đầy đủ của giảng viên với instructor_id do người dùng nhập vào.
--• Viết một block PL/SQL để gọi procedure trên với instructor_id = 107, 120.

CREATE OR REPLACE PROCEDURE tim_ten_giang_vien(p_id IN NUMBER)
AS
    v_fullname VARCHAR2(100);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME
    INTO v_fullname
    FROM INSTRUCTOR
    WHERE INSTRUCTOR_ID = p_id;

    DBMS_OUTPUT.PUT_LINE('Ten giang vien (ID ' || p_id || '): ' || v_fullname);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay giang vien co ID = ' || p_id);
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Giang vien ID = 107 ---');
    tim_ten_giang_vien(107);

    DBMS_OUTPUT.PUT_LINE('--- Giang vien ID = 120 ---');
    tim_ten_giang_vien(120);
END;
/*
PL/SQL procedure successfully completed.


Procedure TIM_TEN_GIANG_VIEN compiled

--- Giang vien ID = 107 ---
Ten giang vien (ID 107): Marilyn Frantzen
--- Giang vien ID = 120 ---
Khong tim thay giang vien co ID = 120


PL/SQL procedure successfully completed.
*/

--15. Viết một function để trả về tên đầy đủ của giảng viên dựa trên instructor_id. Viết một block
--PL/SQL để gọi function này
CREATE OR REPLACE FUNCTION lay_ten_giang_vienFUNCTION(p_id IN NUMBER)
RETURN VARCHAR2
IS
    v_fullname VARCHAR2(100);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME
    INTO v_fullname
    FROM INSTRUCTOR
    WHERE INSTRUCTOR_ID = p_id;

    RETURN v_fullname;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Khong tim thay giang vien voi ID = ' || p_id;
END;
/
DECLARE
    ten_gv VARCHAR2(100);
BEGIN
    ten_gv := lay_ten_giang_vienFUNCTION(107);
    DBMS_OUTPUT.PUT_LINE('Ten giang vien ID 107: ' || ten_gv);

    ten_gv := lay_ten_giang_vienFUNCTION(120);
    DBMS_OUTPUT.PUT_LINE('Ten giang vien ID 120: ' || ten_gv);
END;
/*
PL/SQL procedure successfully completed.


Function LAY_TEN_GIANG_VIENFUNCTION compiled

Ten giang vien ID 107: Marilyn Frantzen
Ten giang vien ID 120: Khong tim thay giang vien voi ID = 120


PL/SQL procedure successfully completed.

*/
--16. Viết một procedure để tìm tên sinh viên và số lượng khóa học mà sinh viên đã đăng ký. In
--kết quả ra màn hình. Viết một block PL/SQL để gọi procedure này
CREATE OR REPLACE PROCEDURE sinhvien_thongtin_dangky(p_student_id IN NUMBER)
AS
    v_name     VARCHAR2(100);
    v_so_khoa  NUMBER;
BEGIN
    -- Lấy tên sinh viên
    SELECT FIRST_NAME || ' ' || LAST_NAME
    INTO v_name
    FROM STUDENT
    WHERE STUDENT_ID = p_student_id;

    -- Đếm số môn đã đăng ký
    SELECT COUNT(*)
    INTO v_so_khoa
    FROM ENROLLMENT
    WHERE STUDENT_ID = p_student_id;

    -- In kết quả
    DBMS_OUTPUT.PUT_LINE('Sinh vien: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('So luong khoa hoc da dang ky: ' || v_so_khoa);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay sinh vien voi ID = ' || p_student_id);
END;
/

BEGIN
    sinhvien_thongtin_dangky(101); -- Bạn thay bằng ID thật trong DB
    sinhvien_thongtin_dangky(102);
END;

/*
PL/SQL procedure successfully completed.


Procedure SINHVIEN_THONGTIN_DANGKY compiled

Khong tim thay sinh vien voi ID = 101
Sinh vien: Fred Crocitto
So luong khoa hoc da dang ky: 2


PL/SQL procedure successfully completed.
*/

--17. Viết một function để tính số khóa học mà sinh viên đã đăng ký (dựa vào student_id).
--• Viết một procedure để tìm tên sinh viên và số lượng khóa học họ đã đăng ký.
--• Viết một block PL/SQL để gọi procedure này với student_id = 109, 530.

CREATE OR REPLACE FUNCTION so_khoa_hoc_dang_ky(p_student_id IN NUMBER)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM ENROLLMENT
    WHERE STUDENT_ID = p_student_id;

    RETURN v_count;
END;
/

CREATE OR REPLACE PROCEDURE thong_tin_sinh_vien(p_student_id IN NUMBER)
AS
    v_name  VARCHAR2(100);
    v_soluong NUMBER;
BEGIN
    -- Lấy tên sinh viên
    SELECT FIRST_NAME || ' ' || LAST_NAME
    INTO v_name
    FROM STUDENT
    WHERE STUDENT_ID = p_student_id;

    -- Gọi function để lấy số lượng khóa học
    v_soluong := so_khoa_hoc_dang_ky(p_student_id);

    -- In kết quả
    DBMS_OUTPUT.PUT_LINE('Sinh vien: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('So khoa hoc da dang ky: ' || v_soluong);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Khong tim thay sinh vien voi ID = ' || p_student_id);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Sinh vien ID = 109 ---');
    thong_tin_sinh_vien(109);

    DBMS_OUTPUT.PUT_LINE('--- Sinh vien ID = 530 ---');
    thong_tin_sinh_vien(530);
END;

/*


Function SO_KHOA_HOC_DANG_KY compiled


Procedure THONG_TIN_SINH_VIEN compiled

--- Sinh vien ID = 109 ---
Sinh vien: Larry Walter
So khoa hoc da dang ky: 2
--- Sinh vien ID = 530 ---
Khong tim thay sinh vien voi ID = 530


PL/SQL procedure successfully completed.
*/

--18. Viết một procedure để đếm số sinh viên đăng ký vào một lớp cụ thể (section của một khóa học).
--• Nếu số sinh viên lớn hơn 10, hiển thị thông báo lỗi rằng lớp này đã có quá nhiều sinh
--viên (dùng RAISE_APPLICATION_ERROR).
CREATE OR REPLACE PROCEDURE kiemtra_so_sinhvien_section(p_section_id IN NUMBER)
AS
    v_soluong NUMBER;
BEGIN
    -- Đếm số sinh viên trong lớp (section)
    SELECT COUNT(*)
    INTO v_soluong
    FROM ENROLLMENT
    WHERE SECTION_ID = p_section_id;

    -- Nếu lớn hơn 10 → thông báo lỗi
    IF v_soluong > 10 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lop nay da co qua nhieu sinh vien: ' || v_soluong);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Section ID: ' || p_section_id || ' co ' || v_soluong || ' sinh vien.');
    END IF;
END;
/
BEGIN
    kiemtra_so_sinhvien_section(201); -- Thay 201 bằng ID của lớp cụ thể bạn muốn kiểm tra
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Loi: ' || SQLERRM);
END;
/
BEGIN
    kiemtra_so_sinhvien_section(85); -- Thay 201 bằng ID của lớp cụ thể bạn muốn kiểm tra
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Loi: ' || SQLERRM);
END;
/*


Procedure KIEMTRA_SO_SINHVIEN_SECTION compiled


Section ID: 201 co 0 sinh vien.


PL/SQL procedure successfully completed.

Section ID: 85 co 5 sinh vien.


PL/SQL procedure successfully completed.
*/


--19. Viết một block PL/SQL để gọi procedure ở câu 18 với:
--• section_id = 89
--• section_id = 155

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Kiem tra section_id = 89 ---');
    kiemtra_so_sinhvien_section(89);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Loi xay ra o section 89: ' || SQLERRM);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Kiem tra section_id = 155 ---');
    kiemtra_so_sinhvien_section(155);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Loi xay ra o section 155: ' || SQLERRM);
END;
/

/*
--- Kiem tra section_id = 89 ---
Loi xay ra o section 89: ORA-20001: Lop nay da co qua nhieu sinh vien: 12


PL/SQL procedure successfully completed.

--- Kiem tra section_id = 155 ---
Section ID: 155 co 5 sinh vien.


PL/SQL procedure successfully completed.

*/

SELECT sys_context('USERENV', 'DB_NAME') AS db_name FROM dual;

ALTER PLUGGABLE DATABASE orcl OPEN;










