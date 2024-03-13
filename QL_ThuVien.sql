

CREATE ROLE R_NHANVIEN;
GRANT ALL ON manhhung.DOCGIA TO R_NHANVIEN;
GRANT ALL ON manhhung.SACH TO R_NHANVIEN;
GRANT ALL ON manhhung.THETHUVIEN TO R_NHANVIEN;
GRANT ALL ON manhhung.PHIEUMUON TO R_NHANVIEN;
-----create quyen cho roel dba
GRANT EXECUTE ANY PROCEDURE TO DBA;


-----create quyen cho roel R_NHANVIEN

GRANT SELECT  ON manhhung.NHANVIEN TO R_NHANVIEN;
---tren cac procedure cua bang docgia
GRANT EXECUTE ON ADD_DOCGIA TO R_NHANVIEN;
GRANT EXECUTE ON DELETE_DOCGIA TO R_NHANVIEN;
GRANT EXECUTE ON UPDATE_DOCGIA TO R_NHANVIEN;
GRANT EXECUTE ON TIM_DG TO R_NHANVIEN;
GRANT EXECUTE ON DS_DG TO R_NHANVIEN;

---tren cac procedure cua bang sach
GRANT EXECUTE ON ADD_SACH TO R_NHANVIEN;
GRANT EXECUTE ON DELETE_SACH TO R_NHANVIEN;
GRANT EXECUTE ON UPDATE_SACH TO R_NHANVIEN;
GRANT EXECUTE ON TIM_SACH TO R_NHANVIEN;
GRANT EXECUTE ON DS_SACH TO R_NHANVIEN;
---tren cac procedure cua bang ttv
GRANT EXECUTE ON ADD_TTV TO R_NHANVIEN;
GRANT EXECUTE ON DELETE_TTV TO R_NHANVIEN;
GRANT EXECUTE ON UPDATE_THETHUVIEN TO R_NHANVIEN;
GRANT EXECUTE ON TIM_TTV TO R_NHANVIEN;
GRANT EXECUTE ON DS_TTV TO R_NHANVIEN;

---tren cac procedure cua bang phieumuon
GRANT EXECUTE ON ADD_PM TO R_NHANVIEN;
GRANT EXECUTE ON DELETE_PM TO R_NHANVIEN;
GRANT EXECUTE ON UPDATE_PM TO R_NHANVIEN;
GRANT EXECUTE ON TIM_PM TO R_NHANVIEN;
GRANT EXECUTE ON DS_PM TO R_NHANVIEN;

--GRANT SELECT ON SACH TO R_XEMTHONGTIN;


-----------------------------------------------------------------------
---trigger-- tao user nv
create or replace TRIGGER TAOTAIKHOAN
BEFORE INSERT OR DELETE OR UPDATE ON NHANVIEN
FOR EACH ROW
BEGIN
	DECLARE            
             TAIKHOAN1 VARCHAR2(20);
             MATKHAU1 VARCHAR2(20);
             TYPE_acc INT DEFAULT 0;
             sl INT ;           
             BEGIN    
                    if INSERTING THEN 
                        BEGIN 
                            SELECT :new.taikhoan INTO TAIKHOAN1 FROM dual;
                            SELECT :new.matkhau INTO MATKHAU1 FROM dual;
                            SELECT :new.TYPE_NV INTO TYPE_acc FROM dual;                    
                            select count(*) into sl from nhanvien where taikhoan = TAIKHOAN1 ;    
                            
                            if sl > 0 then                                                
                                    RAISE_APPLICATION_ERROR(-20001, 'tai khoan nay da ton tai');   
                                    RETURN;
                            else    
                                    begin
                                    taouser(TAIKHOAN1,MATKHAU1);
                                    end;
                                    begin 
                                       
                                            if TYPE_acc = 2 then
                                                manhhung.capquyen_dba(TAIKHOAN1);                  
                                            elsif TYPE_acc = 1 then 
                                                manhhung.capquyen_nhanvien(TAIKHOAN1);                                        
                                            else 
                                                manhhung.capquyen_xemttxemtt(TAIKHOAN1);                                           
                                            end IF;                                                                    
                                    end ;                           
                            end if;                     
                        END;
                        
                    ELSIF DELETING THEN 
                        BEGIN
                            SELECT :OLD.taikhoan INTO TAIKHOAN1 FROM dual;
                            manhhung.drop_user(TAIKHOAN1);
                        END;
                        
                    ELSE 
                        BEGIN
                            SELECT :OLD.taikhoan INTO TAIKHOAN1 FROM dual;
                            SELECT :new.TYPE_NV INTO TYPE_acc FROM dual; 
                            
                            if TYPE_acc = 1 THEN
                                manhhung.thuhoiquyen_dba(TAIKHOAN1);  
                                manhhung.capquyen_nhanvien(TAIKHOAN1); 
                            ELSE 
                                 manhhung.capquyen_dba(TAIKHOAN1);      
                            END IF;
                        END;
            END IF;                                                          
    END;          
END;
--procedure add_nv
CREATE OR REPLACE PROCEDURE ADD_NHANVIEN(
  
    TEN_NV1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    TAIKHOAN1 IN NVARCHAR2,
    MATKHAU1 IN NVARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN NUMBER,
    CHUCVU1 IN NUMBER,
    LUONG1 IN NUMBER
    )
IS
BEGIN
    INSERT INTO manhhung.NHANVIEN(MA_NV,TEN_NV,NGAYSINH,GIOITINH,TAIKHOAN,MATKHAU,GMAIL,SDT,CHUCVU,LUONG) 
    VALUES
    (CONCAT('NV',TO_CHAR(tuDongTang_NhanVien.NEXTVAL,'000')),TEN_NV1,TO_DATE(NGAYSINH1,'YYYY-MM-DD'),GIOITINH1,TAIKHOAN1,MATKHAU1,GMAIL1,SDT1,CHUCVU1,LUONG1);
  
    COMMIT;
END;
-----------------------------------------------------------------------
----procedure xoa nv
CREATE OR REPLACE PROCEDURE DELETE_NHANVIEN(
  
    MA_NV1 IN NVARCHAR2
    )
IS
BEGIN
    DELETE FROM manhhung.NHANVIEN
    WHERE MA_NV = MA_NV1;
    COMMIT;
END;
-----------------------------------------------------------------------
----procedure SUA nv
CREATE OR REPLACE PROCEDURE UPDATE_NHANVIEN(
    MA_NV1 IN NVARCHAR2,
    TEN_NV1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    TAIKHOAN1 IN NVARCHAR2,
    MATKHAU1 IN NVARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN NUMBER,
    CHUCVU1 IN NUMBER,
    LUONG1 IN NUMBER
    )
IS
BEGIN
    UPDATE manhhung.NHANVIEN
    SET TEN_NV=TEN_NV1, NGAYSINH=TO_DATE(NGAYSINH1,'YYYY-MM-DD'),
        GIOITINH=GIOITINH1, TAIKHOAN=TAIKHOAN1,MATKHAU=MATKHAU1,GMAIL=GMAIL1 ,
        SDT=SDT1,CHUCVU=CHUCVU1 ,LUONG=LUONG1 
    WHERE MA_NV=MA_NV1;
  
    COMMIT;
END;
-----------------------------------------------------------------------
------PROCEDURE TIM NV
CREATE OR REPLACE PROCEDURE TIM_NHANVIEN(
    TEN_NV1 IN VARCHAR2   , 
    T out manhhung.NHANVIEN%ROWTYPE
    )
AS
BEGIN
            SELECT *
            INTO T
            FROM manhhung.NHANVIEN 
            WHERE TEN_NV LIKE '%'||TEN_NV1||'%';
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thấy nhân viên có tên ' || TEN_NV1); 
    COMMIT;
  
END;


-----------------------------------------------------------------------

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----doc gia ------------------------------------------------------------------
---add dg
CREATE OR REPLACE PROCEDURE ADD_DOCGIA(
    TEN_DG1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN NUMBER
    )
IS
BEGIN
    INSERT INTO manhhung.DOCGIA(MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,SDT) 
    VALUES
    (CONCAT('DG',TO_CHAR(tuDongTang_DocGia.NEXTVAL,'000')),TEN_DG1,TO_DATE(NGAYSINH1,'YYYY-MM-DD'),GIOITINH1,GMAIL1,SDT1);
    COMMIT;
END;

   call manhhung.ADD_DOCGIA('hung','1990/01/01','Nam','hdd@gmail.com',231456789);
-----------------------------------------------------------------------
----delete dg
CREATE OR REPLACE PROCEDURE DELETE_DOCGIA(
  
    MA_DG1 IN NVARCHAR2
    )
IS
BEGIN
    DELETE  FROM manhhung.DOCGIA
    WHERE MA_DG = MA_DG1;
    
    COMMIT;
END;
-----------------------------------------------------------------------
---update dg
CREATE OR REPLACE PROCEDURE UPDATE_DOCGIA(
    MA_DG1 IN NVARCHAR2,
    TEN_DG1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN NUMBER
    )
IS
BEGIN
    UPDATE manhhung.DOCGIA
    SET TEN_DG=TEN_DG1 , NGAYSINH=TO_DATE(NGAYSINH1,'YYYY-MM-DD'),
        GIOITINH=GIOITINH1, GMAIL=GMAIL1 , SDT=SDT1
    WHERE MA_DG = MA_DG1;
  
    COMMIT;
END;
----tim  dg
create or replace PROCEDURE TIM_DG(
    TEN_NV1 IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            SELECT  MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,SDT
            FROM manhhung.DOCGIA 
            WHERE TEN_DG LIKE '%'||TEN_NV1||'%';
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thấy độc giả có tên  ' || TEN_NV1); 
    COMMIT;

END;
---ds  dg
create or replace PROCEDURE DS_DG(
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,SDT
    FROM manhhung.DOCGIA;
end DS_DG;

-----sach ------------------------------------------------------------------
---add sach
CREATE OR REPLACE PROCEDURE ADD_SACH(

    TENSACH1 IN NVARCHAR2,
    SOLUONGTON1 IN NUMBER,
    NhaXB1 IN NVARCHAR2
    )
IS
BEGIN
    INSERT INTO manhhung.SACH
    VALUES
    (CONCAT('S',TO_CHAR(tuDongTang_Sach.NEXTVAL,'000')),TENSACH1,SOLUONGTON1,NhaXB1);
    COMMIT;
END;

-----delect sach --
CREATE OR REPLACE PROCEDURE DELETE_SACH(
  
    MASACH1 IN NVARCHAR2
    )
IS
BEGIN
    DELETE  FROM manhhung.SACH
    WHERE MASACH = MASACH1;
    
    COMMIT;
END;

---update sach
CREATE OR REPLACE PROCEDURE UPDATE_SACH(
    MASACH1 IN NVARCHAR2,
    TENSACH1 IN NVARCHAR2,
    SOLUONGTON1 IN NUMBER,
    NhaXB1 IN NVARCHAR2
    )
IS
BEGIN
    UPDATE manhhung.SACH
    SET TENSACH=TENSACH1 , SOLUONGTON=SOLUONGTON1,
        NhaXB1=NhaXB1
    WHERE MASACH = MASACH1;
  
    COMMIT;
END;
---tim sach
create or replace PROCEDURE TIM_SACH(
    TEN_NV1 IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            SELECT  MASACH,TENSACH,SOLUONGTON,NhaXB
            FROM manhhung.SACH 
            WHERE TENSACH LIKE '%'||TEN_NV1||'%';
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thấy sách có tên  ' || TEN_NV1); 
    COMMIT;

END;
-----------ds  sach
create or replace PROCEDURE DS_SACH(
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT MASACH,TENSACH,SOLUONGTON,NhaXB
    FROM manhhung.SACH;
end DS_SACH;


--------the thu vien-------------------------------------------------------------------
----add  ttv
CREATE OR REPLACE PROCEDURE ADD_TTV(   
    NGAYCAP in NVARCHAR2,
    NGAYHETHAN in NVARCHAR2,
    MA_DG in NVARCHAR2
    )
IS
BEGIN
    INSERT INTO manhhung.TheThuVien
    VALUES
    (CONCAT('TTV',TO_CHAR(tuDongTang_TheThuVien.NEXTVAL,'000')),TO_DATE(NGAYCAP,'YYYY-MM-DD'),TO_DATE(NGAYHETHAN,'YYYY-MM-DD'),MA_DG);
    COMMIT;
END;


-----------------------------------------------------------------------
----delete ttv
CREATE OR REPLACE PROCEDURE DELETE_TTV(
  
    MA_TTV1 IN NVARCHAR2
    )
IS
BEGIN
    DELETE  FROM manhhung.THETHUVIEN
    WHERE MA_THE = MA_TTV1;
    
    COMMIT;
END;
-----------------------------------------------------------------------
---update ttv
CREATE OR REPLACE PROCEDURE UPDATE_THETHUVIEN(
    MA_THE1 IN NVARCHAR2,
    NGAYCAP1 in NVARCHAR2,
    NGAYHETHAN1 in NVARCHAR2,
    MA_DG1 in NVARCHAR2
    )
IS
BEGIN
    UPDATE manhhung.THETHUVIEN
    SET NGAYCAP=TO_DATE(NGAYCAP1,'YYYY-MM-DD'),NGAYHETHAN=TO_DATE(NGAYHETHAN1,'YYYY-MM-DD'),
        MA_DG=MA_DG1
    WHERE MA_THE = MA_THE1;
  
    COMMIT;
END;
----tim  ttv
create or replace PROCEDURE TIM_TTV(
    MA_TTV IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            SELECT  MA_THE,NGAYCAP,NGAYHETHAN,MA_DG
            FROM manhhung.THETHUVIEN 
            WHERE MA_THE = MA_TTV ;
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thẻ thu viên này  ' || MA_TTV); 
    COMMIT;

END;
---ds  ttv
create or replace PROCEDURE DS_TTV(
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT MA_THE,NGAYCAP,NGAYHETHAN,MA_DG
    FROM manhhung.THETHUVIEN;
end DS_TTV;


-----phieumuon ------------------------------------------------------------------

---add phieumuon
CREATE OR REPLACE PROCEDURE ADD_PM(
    NGAYCAP IN NVARCHAR2,
    NGAYHETHAN IN NVARCHAR2,
    TRANGTHAI NUMBER,
    MASACH IN NVARCHAR2,
    MA_THE IN NVARCHAR2,
    MA_NV IN NVARCHAR2
    )
IS
BEGIN
    INSERT INTO manhhung.PhieuMuon
    VALUES
    (CONCAT('PM',TO_CHAR(tuDongTang_PhieuMuon.NEXTVAL,'000')),TO_DATE(NGAYCAP,'YYYY-MM-DD'),TO_DATE(NGAYHETHAN,'YYYY-MM-DD'),TRANGTHAI,MASACH,MA_THE,MA_NV);
    COMMIT;
END;

-----delect phieumuon --
CREATE OR REPLACE PROCEDURE DELETE_PM(
  
    MAPM IN NVARCHAR2
    )
IS
BEGIN
    DELETE  FROM manhhung.PhieuMuon
    WHERE MA_PM = MAPM;
    
    COMMIT;
END;

---update phieumuon
CREATE OR REPLACE PROCEDURE UPDATE_PM(
    MA_PM1 IN NVARCHAR2,
    --NGAYCAP1 IN NVARCHAR2,
    NGAYHETHAN1 IN NVARCHAR2,
    TRANGTHAI1 NUMBER,
    MASACH1 IN NVARCHAR2,
    MA_THE1 IN NVARCHAR2,
    MA_NV1 IN NVARCHAR2
    )
IS
BEGIN
    UPDATE manhhung.PhieuMuon
    SET /*NGAYCAP=TO_DATE(NGAYCAP1,'YYYY-MM-DD'),*/NGAYHETHAN=TO_DATE(NGAYHETHAN1,'YYYY-MM-DD'),
        TRANGTHAI=TRANGTHAI1,MASACH=MASACH1,
        MA_THE=MA_THE1,MA_NV=MA_NV1
   
    WHERE MA_PM = MA_PM1;
  
    COMMIT;
END;
---tim phieumuon
create or replace PROCEDURE TIM_PM(
    MA_the1 IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            SELECT  MA_PM,NGAYCAP,NGAYHETHAN,TRANGTHAI,MASACH,MA_THE,MA_NV
            FROM manhhung.PhieuMuon 
            WHERE MA_THE = MA_the1;
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thấy sách có tên  ' || MA_the1); 
    COMMIT;

END;
-----------ds  phieumuon
create or replace PROCEDURE DS_PM(
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT  MA_PM,NGAYCAP,NGAYHETHAN,TRANGTHAI,MASACH,MA_THE,MA_NV
    FROM manhhung.PhieuMuon;
end DS_PM;




-----------------------------------------------------------------------
---tg log off
create or replace TRIGGER tr_logoff
BEFORE LOGOFF ON DATABASE
BEGIN
    INSERT INTO log_trail VALUES (
        tuDongTang_log.nextval,
        USER, -- Tên người dùng
        SYSDATE, -- Thời gian hiện tại
        'LOGOFF' -- Hành động đăng xuất
    );
    COMMIT;
END tr_logoff;
-----------------------------------------------------------------------
---tg log on
create or replace TRIGGER tr_logon
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO log_trail VALUES (
        tuDongTang_log.nextval,
        USER, -- Tên người dùng
        SYSDATE, -- Thời gian hiện tại
        'LOGON' -- Hành động đăng nhập
    );
    COMMIT;
END tr_logon;

select * from log_trail;
-----------------------------------------------------------------------

CREATE TABLE NhanVien
(
    MA_NV NVARCHAR2(10) NOT NULL PRIMARY KEY,
    TEN_NV NVARCHAR2(50) NOT NULL,
    NGAYSINH DATE,
    GIOITINH NVARCHAR2(50),
    TAIKHOAN VARCHAR2(50),
    MATKHAU VARCHAR2(50),
    GMAIL NVARCHAR2(50) NOT NULL,
    SDT NUMBER NOT NULL,
    CHUCVU NUMBER,
    LUONG NUMBER
);
ALTER TABLE NhanVien
MODIFY GMAIL VARCHAR2(4000);
ALTER TABLE NhanVien
MODIFY MATKHAU VARCHAR2(4000);
INSERT INTO NHANVIEN (MA_NV,TEN_NV,NGAYSINH,GIOITINH,TAIKHOAN,MATKHAU,GMAIL,SDT,CHUCVU,LUONG)
VALUES
(CONCAT('NV',TO_CHAR(tuDongTang_NhanVien.NEXTVAL,'000')), 'Manh Hung', TO_DATE('1990/01/01', 'YYYY/MM/DD'), 'Nam', 'hung', 'hung','TRANMANHHUNG@GMAIL.COM',0392943233, 2,100000);

CREATE TABLE Sach
(
    MASACH NVARCHAR2(10) NOT NULL PRIMARY KEY,
    TENSACH NVARCHAR2(50) NOT NULL,
    SOLUONGTON INT,
    NhaXB NVARCHAR2(50)
);
INSERT 
INTO manhhung.SACH/*(MASACH,TENSACH,SOLUONGTON,NhaXB)*/
VALUES 
(CONCAT('S',TO_CHAR(tuDongTang_Sach.NEXTVAL,'000')),N'Nhà Giả Kim',12,N'Paulo Coelho');
INSERT  INTO manhhung.SACH(MASACH,TENSACH,SOLUONGTON,NhaXB)
VALUES 
(CONCAT('S',TO_CHAR(tuDongTang_Sach.NEXTVAL,'000')),N'Cách nghĩ để thành công ',16,N'Napoleon Hill');
INSERT  INTO manhhung.SACH(MASACH,TENSACH,SOLUONGTON,NhaXB)
VALUES 
(CONCAT('S',TO_CHAR(tuDongTang_Sach.NEXTVAL,'000')),N'Đắc Nhân Tâm',2,N'Dale Carnegie');
INSERT INTO manhhung.SACH(MASACH,TENSACH,SOLUONGTON,NhaXB)
VALUES 
(CONCAT('S',TO_CHAR(tuDongTang_Sach.NEXTVAL,'000')),N' Hạt giống tâm hồn',2,N'Nhiều Người');
SELECT * FROM manhhung.SACH


CREATE TABLE DocGia
(   MA_DG NVARCHAR2(10) NOT NULL PRIMARY KEY,
    TEN_DG NVARCHAR2(50) NOT NULL,
    NGAYSINH DATE,
    GIOITINH NVARCHAR2(50) NOT NULL,
    GMAIL NVARCHAR2(50) NOT NULL,
    SDT NUMBER
);
 INSERT INTO manhhung.DOCGIA(MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,SDT) 
    VALUES
    (CONCAT('DG',TO_CHAR(tuDongTang_DocGia.NEXTVAL,'000')),'Trần Mạnh Hùng', TO_DATE('2002/11/27', 'YYYY/MM/DD'),'Nam','hhgh@gmail.com',321356987);
    
    SELECT MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,SDT FROM manhhung.DOCGIA;
    select * from docgia;
CREATE TABLE TheThuVien
(
    MA_THE NVARCHAR2(10)  NOT NULL PRIMARY KEY,
    NGAYCAP DATE,
    NGAYHETHAN DATE,
    MA_DG NVARCHAR2(10),
    FOREIGN KEY (MA_DG) REFERENCES DocGia(MA_DG) ON DELETE CASCADE
);
INSERT INTO manhhung.TheThuVien(MA_THE,NGAYCAP,NGAYHETHAN,MA_DG) VALUES
(CONCAT('TTV',TO_CHAR(tuDongTang_TheThuVien.NEXTVAL,'000')), TO_DATE('2023/05/12','YYYY/MM/DD'),TO_DATE('2024/05/12','YYYY/MM/DD'),'DG 043');
DELETE FROM DOCGIA WHERE MA_DG = 'DG 043';

select * from docgia
SELECT * FROM TheThuVien
 DROP TABLE TheThuVien  
 DELETE FROM TheThuVien


CREATE TABLE PhieuMuon
(
    MA_PM NVARCHAR2(10) NOT NULL PRIMARY KEY,
    NGAYCAP DATE,
    NGAYHETHAN DATE,
    TRANGTHAI NUMBER,
    MASACH NVARCHAR2(10),
    MA_THE NVARCHAR2(10),
    MA_NV NVARCHAR2(10),
    FOREIGN KEY (MASACH) REFERENCES Sach(MASACH) ,
    FOREIGN KEY (MA_THE) REFERENCES TheThuVien(MA_THE),
    FOREIGN KEY (MA_NV) REFERENCES NhanVien(MA_NV) 
);
drop table phieumuon
delete from phieumuon where ma_pm = 'PM 003'



--- log
CREATE OR REPLACE TRIGGER audit_login_logout
AFTER LOGON ON DATABASE
DECLARE
  LOGOFF VARCHAR2(10) := 'LOGOFF';
  EVENT VARCHAR2(10);
BEGIN
  -- Ghi lại thông tin đăng nhập
  INSERT INTO audit_trail (user_name, login_time)
  VALUES (CURRENT_USER, SYSDATE);

  -- Ghi lại thông tin đăng xuất
  EVENT := LOGOFF;
  IF EVENT = LOGOFF THEN
    INSERT INTO audit_trail (user_name, logout_time)
    VALUES (CURRENT_USER, SYSDATE);
  END IF;
END;

-- Tạo một bảng để lưu trữ các thông tin về đăng nhập và đăng xuất
CREATE SEQUENCE tuDongTang_log START WITH 1 INCREMENT BY 1;
CREATE TABLE log_trail (
    id_log INT DEFAULT tuDongTang_log.NEXTVAL NOT NULL PRIMARY KEY,
    name VARCHAR2 (30),
    time TIMESTAMP,
    action VARCHAR2 (10)
);

-- Tạo một trigger để ghi lại thời gian và tên người dùng khi đăng nhập
CREATE OR REPLACE TRIGGER tr_logon
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO log_trail VALUES (
        tuDongTang_log.nextval,
        USER, -- Tên người dùng
        SYSDATE, -- Thời gian hiện tại
        'LOGON' -- Hành động đăng nhập
    );
    COMMIT;
END tr_logon;

-- Tạo một trigger để ghi lại thời gian và tên người dùng khi đăng xuất
CREATE OR REPLACE TRIGGER tr_logoff
BEFORE LOGOFF ON DATABASE
BEGIN
    INSERT INTO log_trail VALUES (
        tuDongTang_log.nextval,
        USER, -- Tên người dùng
        SYSDATE, -- Thời gian hiện tại
        'LOGOFF' -- Hành động đăng xuất
    );
    COMMIT;
END tr_logoff;  

