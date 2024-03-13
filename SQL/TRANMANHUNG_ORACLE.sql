---- CÁC PHẦN CÓ TRONG CÁC TUẦN 2-3-4-5-6-8-9, RSA CỦA TRẦN MẠNH HÙNG
----DATABASE 
CREATE SEQUENCE tuDongTang_NhanVien START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE tuDongTang_DocGia START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE tuDongTang_Sach START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE tuDongTang_TheThuVien START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE tuDongTang_PhieuMuon START WITH 1 INCREMENT BY 1;

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
SELECT * FROM manhhung.SACH;


CREATE TABLE DocGia
(   MA_DG NVARCHAR2(10) NOT NULL PRIMARY KEY,
    TEN_DG NVARCHAR2(50) NOT NULL,
    NGAYSINH DATE,
    GIOITINH NVARCHAR2(50) NOT NULL,
    GMAIL NVARCHAR2(50) NOT NULL,
    SDT VARCHAR2(4000)
);

ALTER TABLE DocGia
MODIFY SDT VARCHAR2(4000);
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
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------TRIGGER TẠO , XÓA , UPDATE QUYỀN  TÀI KHOẢN LOGIN BẰNG TÀI KHOẢN VÀ MẬT KHẨU Ở BẢNG NHÂN VIÊN------------------------------------------
create or replace TRIGGER TAOTAIKHOAN
BEFORE INSERT OR DELETE OR UPDATE ON NHANVIEN
FOR EACH ROW
BEGIN
	DECLARE            
             TAIKHOAN1 VARCHAR2(20);
             MATKHAU1 VARCHAR2(2000);
             TYPE_acc INT DEFAULT 0;
             sl INT ;          
             
             BEGIN    
                    if INSERTING THEN 
                        BEGIN 
                            SELECT :new.taikhoan INTO TAIKHOAN1 FROM dual;
                            SELECT :new.matkhau INTO MATKHAU1 FROM dual;
                            SELECT :new.chucvu INTO TYPE_acc FROM dual; 
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
                            SELECT :new.chucvu INTO TYPE_acc FROM dual; 
                            
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
---------------------------------------------------------------------------------
--- KIỂM TRA ĐĂNG NHẬP ĐĂNG XUẤT
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

---------------------------------------------------------------------------------
--TẠO 1 BẢNG ĐỂ LƯU TRỮ CÁC KHÓA
CREATE TABLE key_store (

  key_name VARCHAR2(20) PRIMARY KEY,
  key_value VARCHAR2(4000) NOT NULL
);

--CÁCH TRÍCH XUẤT KHÓA INSERT VÀO BẢNG 
-- Tạo một khóa đối xứng bằng thuật toán DES
DECLARE
  l_key RAW(16); 
BEGIN
l_key := sys.DBMS_CRYPTO.randombytes (16);
  -- Lưu trữ khóa đối xứng vào một bảng an toàn
  INSERT INTO key_store (key_name, key_value) VALUES ('key_nv', l_key);
  COMMIT;
END;
/
------------------------------------------------------------------------------------------------
-----------------------TRÍCH XUẤT 2 KHÓA PUBLIC KEY VÀ PRIVATE KEY CỦA RSA

CREATE TABLE key_store (

  key_name VARCHAR2(20) PRIMARY KEY,
  key_value VARCHAR2(4000) NOT NULL
);
DECLARE
  v_result CLOB;
  v_public_key VARCHAR2(4000);
  v_private_key  VARCHAR2(4000);
BEGIN
  v_result := sys.CRYPTO.RSA_GENERATE_KEYS(1024);

  -- Trích xuất giá trị khóa công khai
  v_public_key := SUBSTR(v_result, INSTR(v_result, 'publicKey start') + LENGTH('publicKey start'), INSTR(v_result, '****publicKey end') - (INSTR(v_result, 'publicKey start') + LENGTH('publicKey start')));
  v_public_key := REPLACE(v_public_key, '*****', '');
  v_public_key := TRIM(v_public_key);
  -- Trích xuất giá trị khóa riêng tư
  v_private_key := SUBSTR(v_result, INSTR(v_result, 'privateKey start') + LENGTH('privateKey start'), INSTR(v_result, 'privateKey end') - (INSTR(v_result, 'privateKey start') + LENGTH('privateKey start')));
  v_private_key := REPLACE(v_private_key, '****', '');
  v_private_key := TRIM(v_private_key);
  -- In giá trị khóa công khai và khóa riêng tư
  DBMS_OUTPUT.PUT_LINE('Public Key: ' || v_public_key);
  DBMS_OUTPUT.PUT_LINE('Private Key: ' || v_private_key);
   --Insert khóa công khai vào bảng key_store
  INSERT INTO key_store (key_name, key_value) VALUES ('public_key',v_public_key);

  --Insert khóa riêng tư vào bảng key_store
  INSERT INTO key_store (key_name, key_value) VALUES ('private_key', v_private_key);
END;
/
--------------------------------------------------------------------------------
--CÁC PROCEDURE 
--procedure add_nv
create or replace PROCEDURE ADD_NHANVIEN(
  
    TEN_NV1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    TAIKHOAN1 IN NVARCHAR2,
    MATKHAU1 IN VARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN NUMBER,
    CHUCVU1 IN NUMBER,
    LUONG1 IN NUMBER
    )
AS
BEGIN
         DECLARE
          l_key RAW(16);
          mahoamk Raw(2000);
          l_encrypted_Gm RAW(2000);
        BEGIN
      -- Lấy khóa đối xứng từ bảng an toàn 
          SELECT key_value INTO l_key FROM key_store WHERE key_name = 'key_nv';
      
      -- Mã hóa mật khẩu bằng hàm DBMS_CRYPTO.ENCRYPT
          l_encrypted_Gm := DBMS_CRYPTO.ENCRYPT(
            src => UTL_RAW.CAST_TO_RAW(GMAIL1),
            typ => DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
            key => l_key
          );
          mahoamk := DBMS_CRYPTO.ENCRYPT(
            src => UTL_RAW.CAST_TO_RAW(MATKHAU1),
            typ => DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
            key => l_key
          );
          INSERT INTO manhhung.NHANVIEN(MA_NV,TEN_NV,NGAYSINH,GIOITINH,TAIKHOAN,MATKHAU,GMAIL,SDT,CHUCVU,LUONG) 
          VALUES
         (CONCAT('NV',TO_CHAR(tuDongTang_NhanVien.NEXTVAL,'000')),TEN_NV1,TO_DATE(NGAYSINH1,'YYYY-MM-DD'),GIOITINH1,TAIKHOAN1,mahoamk,l_encrypted_Gm,SDT1,CHUCVU1,LUONG1);
    
        COMMIT;
end;
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
create or replace PROCEDURE UPDATE_NHANVIEN(
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
AS
BEGIN
 DECLARE
          l_key RAW(16);
          l_encrypted_Gm RAW(2000);
        BEGIN
      -- Lấy khóa đối xứng từ bảng an toàn
          SELECT key_value INTO l_key FROM key_store WHERE key_name = 'key_nv';      
          l_encrypted_Gm := DBMS_CRYPTO.ENCRYPT(
            src => UTL_RAW.CAST_TO_RAW(GMAIL1),
            typ => DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
            key => l_key
          );
          
        UPDATE manhhung.NHANVIEN
        SET TEN_NV=TEN_NV1, NGAYSINH=TO_DATE(NGAYSINH1,'YYYY-MM-DD'),
            GIOITINH=GIOITINH1, TAIKHOAN=TAIKHOAN1,MATKHAU=MATKHAU1,GMAIL=l_encrypted_Gm ,
            SDT=SDT1,CHUCVU=CHUCVU1 ,LUONG=LUONG1 
        WHERE MA_NV=MA_NV1;
        COMMIT;
    end;
END;
-----------------------------------------------------------------------
------PROCEDURE TIM NV
create or replace PROCEDURE TIM_NHANVIEN(
    TEN_NV1 IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            SELECT  MA_NV, TEN_NV, NGAYSINH, GIOITINH, TAIKHOAN, giaima(MATKHAU)as MATKHAU,  /*GMAIL*/GIAIMA(GMAIL)as GMAIL, SDT, CHUCVU, LUONG  
            FROM manhhung.NHANVIEN 
            WHERE TEN_NV LIKE '%'||TEN_NV1||'%';
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thấy nhân viên có tên ' || TEN_NV1); 
    COMMIT;

END;
-----------------------------------------------------------------------
------PROCEDURE DS_NV
create or replace PROCEDURE DS_NHANVIEN(
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    DECLARE 
    mkmh VARCHAR2(20);
begin
  
    OPEN NV_LIST FOR
    SELECT MA_NV, TEN_NV, NGAYSINH, GIOITINH, TAIKHOAN, giaima(MATKHAU)as MATKHAU, GIAIMA(GMAIL)as GMAIL, SDT, CHUCVU, LUONG
    FROM manhhung.NHANVIEN;
    commit;
 
    end;
end DS_NHANVIEN;
-----doc gia ------------------------------------------------------------------
---add dg
create or replace PROCEDURE ADD_DOCGIA(
    TEN_DG1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN VARCHAR2
    )
IS
BEGIN
        DECLARE 
             MH_SDT VARCHAR2(4000);  
        BEGIN
        mahoa(SDT1,MH_SDT);
    INSERT INTO manhhung.DOCGIA(MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,SDT) 
    VALUES
    (CONCAT('DG',TO_CHAR(tuDongTang_DocGia.NEXTVAL,'000')),TEN_DG1,TO_DATE(NGAYSINH1,'YYYY-MM-DD'),GIOITINH1,GMAIL1,MH_SDT);
    COMMIT;
    END;
END;

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
create or replace PROCEDURE UPDATE_DOCGIA(
    MA_DG1 IN NVARCHAR2,
    TEN_DG1 IN NVARCHAR2,
    NGAYSINH1 IN NVARCHAR2,
    GIOITINH1 IN NVARCHAR2,
    GMAIL1 IN NVARCHAR2,
    SDT1 IN NUMBER
    )
IS
BEGIN
DECLARE
          
          l_encrypted_SDT RAW(2000);
    BEGIN
    mahoa(SDT1,l_encrypted_SDT);
    UPDATE manhhung.DOCGIA
    SET TEN_DG=TEN_DG1 , NGAYSINH=TO_DATE(NGAYSINH1,'YYYY-MM-DD'),
        GIOITINH=GIOITINH1, GMAIL=GMAIL1 , SDT=l_encrypted_SDT
    WHERE MA_DG = MA_DG1;

    COMMIT;
    END;
END;
----tim  dg
create or replace PROCEDURE TIM_DG(
    TEN_NV1 IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            SELECT  MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,giaima_rsarsa(SDT) as SDT
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
    SELECT MA_DG,TEN_DG,NGAYSINH,GIOITINH,GMAIL,giaima_rsarsa(SDT) as SDT
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

-----DELETE phieumuon --
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
------------PROC CAP QUYEN DC PROC
create or replace procedure add_quyensd_proc 
(
  USER1 in varchar2 ,
  PROC IN VARCHAR2
) as 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON ' ||PROC|| ' TO '||USER1;
    COMMIT;
end add_quyensd_proc;
--------------------PROC CAP QUYEN TREN BANG 
create or replace procedure cap_quyen 
(
    USER1 IN VARCHAR2,
    SRT_QUYEN IN VARCHAR2,
    TABLE1 IN VARCHAR2
)
as  
PRAGMA AUTONOMOUS_TRANSACTION;
begin 
    EXECUTE IMMEDIATE 'GRANT '||SRT_QUYEN || ' ON manhhung.'|| TABLE1||' TO '  || UPPER(USER1)    ;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        -- Xử lý các lỗi tại đây nếu cần thiết
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
END cap_quyen;
------------------CAP QUYEN DBA
create or replace procedure capquyen_dba 
(
  taikhoan in varchar2 
) as 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
    EXECUTE IMMEDIATE 'GRANT DBA TO '  || TAIKHOAN    ;
    COMMIT;
end capquyen_dba;
-----------------CAP QUYEN R-NHANVIEN
create or replace procedure capquyen_nhanvien 
(
  TAIKHOAN IN VARCHAR2
) AS 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
  EXECUTE IMMEDIATE 'GRANT R_NHANVIEN TO ' || TAIKHOAN;
  COMMIT;
end capquyen_nhanvien;
------------------CAP QUYEN R_XEMTT (BO SUNG)
create or replace procedure capquyen_xemttxemtt 
(
  taikhoan in varchar2 
) as 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
     EXECUTE IMMEDIATE 'GRANT R_XEMTHONGTIN TO ' || TAIKHOAN  ;
     COMMIT;
end capquyen_xemttxemtt;
------------PROC DROP USER
create or replace procedure drop_user 
(
  ten_user in varchar2 
) as 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
   EXECUTE IMMEDIATE 'DROP USER ' || ten_user  ;
end drop_user;
-----------DS_LOG_ON_OFF
create or replace procedure ds_log_on_off (
   NV_LIST OUT SYS_REFCURSOR
) as 

begin
   OPEN NV_LIST FOR 
   SELECT * FROM manhhung.log_trail ;
end ds_log_on_off;
------------------------DS_LOG TABLE
create or replace procedure ds_log_table(
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
     select SESSION_ID, TIMESTAMP ,DB_USER, OBJECT_SCHEMA, OBJECT_NAME ,POLICY_NAME, SQL_TEXT, STATEMENT_TYPE   
            from sys.dba_fga_audit_trail ;

end ds_log_table;
----------------PROCEDURE GIAMAMK
create or replace PROCEDURE giaimamk (chuoidauvao IN /*RAW*/varchar2, chuoigiaima_out OUT VARCHAR2) AS
    l_key RAW(16);
    chuoigiaima_raw raw(2000);
BEGIN
    -- Lấy khóa mã hóa từ bảng key_store
    SELECT key_value INTO l_key FROM key_store WHERE key_name = 'key_nv';
    -- Giải mã dữ liệu bằng hàm DBMS_CRYPTO
    chuoigiaima_raw := DBMS_CRYPTO.DECRYPT(
        src => chuoidauvao,
        typ => DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,
        key => l_key
    );
    -- Chuyển đổi dữ liệu đã giải mã từ kiểu RAW sang kiểu VARCHAR2
   chuoigiaima_out := UTL_RAW.CAST_TO_VARCHAR2(chuoigiaima_raw);
  
END giaimamk;
-------------LOAD DS PROC 
create or replace procedure load_propro (
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT object_name
    FROM all_procedures
    WHERE owner = 'MANHHUNG';


end load_propro;
-----------------------LOAD QUYEN USER IN TABLE
create or replace procedure load_quyen_user_in_tabletable  ( 
TEN_USER IN VARCHAR2,
NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
       SELECT  
        GRANTEE,
        TABLE_NAME,
        PRIVILEGE,
        TYPE
        FROM
        DBA_TAB_PRIVS
        WHERE
        GRANTEE = UPPER(TEN_USER) AND TYPE = 'TABLE';
end load_quyen_user_in_tabletable;
-----------------------LOAD  TABLE
create or replace procedure load_table (
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT table_name
    FROM dba_tables
    WHERE owner = 'MANHHUNG';


end load_table;
-----------------------LOAD USER 
create or replace procedure load_user (
    NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT username FROM dba_users ORDER BY username;

end load_user;
-----------------------LOAD QUYEN USER EXEC
create or replace procedure load_user_exe ( 
TEN_USER IN VARCHAR2,
NV_LIST OUT SYS_REFCURSOR
) AS 
BEGIN   
    OPEN NV_LIST FOR
    SELECT * 
    FROM DBA_TAB_PRIVS
    WHERE GRANTEE = UPPER(TEN_USER) AND PRIVILEGE = 'EXECUTE';
end load_user_exe;
-----------------------REVOKE QUYEN PROC
create or replace procedure revoke_quyen_proc(
  USER1 in varchar2 ,
  PROC IN VARCHAR2
) as 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
    EXECUTE IMMEDIATE 'REVOKE EXECUTE ON ' ||PROC|| ' FROM '||USER1;
    COMMIT;
end revoke_quyen_proc;
-----------------------PROC MA HOA RSA
create or replace procedure mahoa 
(
  chuoi in varchar2 ,
  chuoiout out varchar2
) as 
begin
     DECLARE public_key VARCHAR2(3000);
     begin
     select key_value  into public_key from  key_store where key_name ='public_key';
     DBMS_OUTPUT.PUT_LINE(public_key);
     SELECT sys.CRYPTO.RSA_ENCRYPT(chuoi,public_key) into chuoiout from dual;
     DBMS_OUTPUT.PUT_LINE(chuoiout);

end;

end mahoa;
-----------------------FUNCTION GIAIMA  RSA
create or replace function giaima_rsarsa (chuoidauvao in varchar2 ) 
return varchar2 
as 
private_key VARCHAR2(3000);
chuoigiaima_str varchar2(4000);
begin
     select key_value  into private_key from  key_store where key_name ='private_key';
     DBMS_OUTPUT.PUT_LINE(private_key);
     select sys.CRYPTO.RSA_DECRYPT(chuoidauvao,private_key) into chuoigiaima_str from dual;
     DBMS_OUTPUT.PUT_LINE(chuoigiaima_str);
     return  chuoigiaima_str;
end giaima_rsarsa;
-----------------------PROC TAO USER
create or replace PROCEDURE TAOUSER 
(
  TAIKHOAN IN VARCHAR2
, MATKHAU IN VARCHAR2
)
AS
PRAGMA AUTONOMOUS_TRANSACTION;
  v_sql1 VARCHAR2(200);
  v_sql2 VARCHAR2(200);
  mkmh VARCHAR2(20);
BEGIN

    IF TAIKHOAN IS NULL OR LENGTH(TAIKHOAN) = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'TAIKHOAN không được để trống');
    END IF;

    giaimamk(MATKHAU,mkmh);

    IF mkmh IS NULL OR LENGTH(mkmh) = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'MATKHAU không được để trống');
    END IF;
    DBMS_OUTPUT.PUT_LINE(mkmh);
    v_sql1:=  'CREATE USER '|| TAIKHOAN ||' IDENTIFIED BY   "'|| mkmh ||'"' ;
    v_sql2:=  'GRANT CONNECT, RESOURCE TO ' || TAIKHOAN; 
   
    EXECUTE IMMEDIATE  'CREATE USER '|| TAIKHOAN ||' IDENTIFIED BY  "'|| mkmh ||'"' ;
    EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO ' || TAIKHOAN; 

    
    DBMS_OUTPUT.PUT_LINE('Tao user thanh cong');
    COMMIT; 

    EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Loi khi tao user: '|| SQLERRM);
        ROLLBACK;
END TAOUSER;
--------THU HOI QUYEN DBA
create or replace procedure thuhoiquyen_dba 
(
  tk in varchar2 
) as 
PRAGMA AUTONOMOUS_TRANSACTION;
begin
    EXECUTE IMMEDIATE  'REVOKE DBA FROM ' ||tk ;

end thuhoiquyen_dba;
--------THU HOI QUYEN TABLE
create or replace procedure thuhoiquyen_table(
    USER1 IN VARCHAR2,
    SRT_QUYEN IN VARCHAR2,
    TABLE1 IN VARCHAR2
)
as  
PRAGMA AUTONOMOUS_TRANSACTION;
begin 
    EXECUTE IMMEDIATE 'REVOKE '||SRT_QUYEN || ' ON manhhung.'|| TABLE1||' FROM '  || UPPER(USER1)    ;
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        -- Xử lý các lỗi tại đây nếu cần thiết
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);

end thuhoiquyen_table;
----------------TIM LOG NAME
create or replace procedure tim_log_name (
    USER IN VARCHAR2   , 
    NV_LIST OUT SYS_REFCURSOR
    )
AS
BEGIN
            OPEN NV_LIST FOR
            
            select SESSION_ID, TIMESTAMP ,DB_USER, OBJECT_SCHEMA, OBJECT_NAME ,POLICY_NAME, SQL_TEXT, STATEMENT_TYPE   
            from sys.dba_fga_audit_trail
            WHERE DB_USER = USER  ;  
            
              EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Không tìm thấy nhân viên có tên ' || USER); 
    COMMIT;


end tim_log_name;
-------------FUNCTION CHECK ROLE USER
create or replace FUNCTION check_user_role (p_schema VARCHAR2, p_table VARCHAR2)
  RETURN VARCHAR2
AS
  v_chucvu NUMBER;
BEGIN
  SELECT CHUCVU INTO v_chucvu
  FROM manhhung.nhanvien
  WHERE TAIKHOAN = LOWER(SYS_CONTEXT('USERENV', 'SESSION_USER'));

  IF v_chucvu = 2 THEN
    RETURN '1=1'; -- Cho phép select toàn bộ bảng
  ELSIF v_chucvu = 1 THEN
    RETURN 'TAIKHOAN = LOWER(SYS_CONTEXT(''USERENV'', ''SESSION_USER''))'; -- Chỉ cho phép xem row của người dùng hiện tại
  ELSE
    RETURN '1=2'; -- Không cho phép select
  END IF;
END check_user_role;
-------FUNCTION GIAI MA DÉS
create or replace function GIAIMA (chuoidauvao in varchar2) return varchar2
as
 l_key RAW(16);
  chuoigiaima_str varchar2(4000);
BEGIN
      -- Lấy khóa đối xứng từ bảng an toàn
          SELECT key_value INTO l_key FROM key_store WHERE key_name = 'key_nv';
         chuoigiaima_str :=DBMS_CRYPTO.DECRYPT(
          src => chuoidauvao,
        typ => DBMS_CRYPTO.ENCRYPT_DES + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5,   
        key => l_key
      );
    return (utl_raw.cast_to_varchar2(chuoigiaima_str));

end GIAIMA;
---------FUNCTION GIAI MA RSA
create or replace function giaima_rsarsa (chuoidauvao in varchar2 ) 
return varchar2 
as 
private_key VARCHAR2(3000);
chuoigiaima_str varchar2(4000);
begin
     select key_value  into private_key from  key_store where key_name ='private_key';
     DBMS_OUTPUT.PUT_LINE(private_key);
     select sys.CRYPTO.RSA_DECRYPT(chuoidauvao,private_key) into chuoigiaima_str from dual;
     DBMS_OUTPUT.PUT_LINE(chuoigiaima_str);
     return  chuoigiaima_str;
end giaima_rsarsa;
---------FUNCTION RANG BUOC NHAN VIEN 
create or replace FUNCTION rangbuocnhanvien
  RETURN VARCHAR2
IS
  v_chucvu NUMBER;
BEGIN
  -- Lấy giá trị của cột CHUCVU từ bảng NHANVIEN cho người dùng hiện tại
  SELECT CHUCVU INTO v_chucvu
  FROM manhhung.NHANVIEN
  WHERE TAIKHOAN = LOWER(USER);

  IF v_chucvu = 2 THEN
    RETURN '1=1'; -- Cho phép xem tất cả dữ liệu
  ELSE
    RETURN 'TAIKHOAN = SYS_CONTEXT(''USERENV'', ''SESSION_USER'')'; -- Chỉ xem thông tin của chính mình
  END IF;
END rangbuocnhanvien;
--------------------role 
CREATE ROLE R_NHANVIEN;
GRANT ALL ON manhhung.DOCGIA TO R_NHANVIEN;
GRANT ALL ON manhhung.SACH TO R_NHANVIEN;
GRANT ALL ON manhhung.THETHUVIEN TO R_NHANVIEN;
GRANT ALL ON manhhung.PHIEUMUON TO R_NHANVIEN;
-----create quyen cho roel dba
GRANT EXECUTE ANY PROCEDURE TO DBA;
---------------------------------
GRANT ALTER, DELETE,INDEX, INSERT, SELECT, UPDATE, REFERENCES, READ, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK 
ON manhhung.NHANVIEN TO R_NHANVIEN;
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
------------POLICY 
-- Tạo chính sách kiểm tra cho tất cả các bảng trong cơ sở dữ liệu
---TẠO TỰ ĐỘNG CHÍNH SÁCH
BEGIN
  FOR cur_rec IN (SELECT table_name FROM user_tables) LOOP
    DBMS_FGA.ADD_POLICY(
      object_schema    => NULL,
      object_name      => cur_rec.table_name,
      policy_name      => 'ALL_TABLES_AUDIT_' || cur_rec.table_name,
      audit_condition  => NULL, -- Để đạt được tất cả các hoạt động
      audit_column     => NULL, -- Để đạt được tất cả các cột
      statement_types  => 'INSERT, UPDATE, DELETE, SELECT', -- Thêm tất cả các loại hoạt động
      handler_schema   => NULL,
      enable           => TRUE
    );
  END LOOP;
END;
/




BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'PHIEUMUON',
    policy_name   => 'ALL_TABLES_AUDIT_PHIEUMUON' -- Tên của chính sách bạn muốn xóa
  );
END;
/
BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'KEY_STORE',
    policy_name   => 'ALL_TABLES_AUDIT_KEY_STORE' -- Tên của chính sách bạn muốn xóa
  );
END;
/
BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'THETHUVIEN',
    policy_name   => 'ALL_TABLES_AUDIT_THETHUVIEN' -- Tên của chính sách bạn muốn xóa
  );
END;
/
BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'SACH',
    policy_name   => 'ALL_TABLES_AUDIT_SACH' -- Tên của chính sách bạn muốn xóa
  );
END;
/
BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'DOCGIA',
    policy_name   => 'ALL_TABLES_AUDIT_DOCGIA' -- Tên của chính sách bạn muốn xóa
  );
END;
/
BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'NHANVIEN',
    policy_name   => 'ALL_TABLES_AUDIT_NHANVIEN' -- Tên của chính sách bạn muốn xóa
  );
END;
/
BEGIN
  DBMS_FGA.DROP_POLICY(
    object_schema => null,
    object_name   => 'LOG_TRAIL',
    policy_name   => 'ALL_TABLES_AUDIT_LOG_TRAIL' -- Tên của chính sách bạn muốn xóa
  );
END;
Grant delete on dba_fga_audit_trail to manhhung;


---------------------------POLICY CHỈ CHO XEM ROW TRÊN TABLE NHANVIEN NẾU LÀ CHỨC VỤ NHÂN VIÊN
-- Tạo policy cho bảng NhanVien
BEGIN
  DBMS_RLS.ADD_POLICY(
    object_schema     => 'manhhung', -- Thay thế bằng schema của bạn
    object_name       => 'NHANVIEN',
    policy_name       => 'NhanVien_Policy',
    function_schema   => 'manhhung', -- Thay thế bằng schema của bạn
    policy_function   => 'check_user_role',
   -- statement_types   => 'SELECT,EXECUTE',
    update_check      => FALSE,
    enable            => TRUE
  );
END;
/
BEGIN
   DBMS_RLS.DROP_POLICY(
    object_schema => null,
    object_name   => 'NHANVIEN',
    policy_name   => 'NhanVien_Policy' -- Tên của chính sách bạn muốn xóa
  );
END;







