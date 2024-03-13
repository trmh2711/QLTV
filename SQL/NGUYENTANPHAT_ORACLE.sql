-- Tao Tablespace 

CREATE TABLESPACE sach_data DATAFILE 'D:\ki 7\BM HTTT\sach_data.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M;


CREATE TABLESPACE sach_data2 DATAFILE 'sach_data.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M;



-- Qu?n Lý Tablespace

ALTER TABLESPACE sach_data ADD DATAFILE 'D:\ki 7\BM HTTT\sach_data2.dbf' SIZE 50M;


--Xem tablespace

SELECT table_name, tablespace_name
FROM all_tables
WHERE tablespace_name = 'sach_data';

--T?o Profile

CREATE PROFILE nhanvien_profile LIMIT
SESSIONS_PER_USER 1 --gioi han so phien ket noi
CPU_PER_SESSION 100 -- gioi han tong so thoi gian CPU ma moi phien co the su dung (miligiay)
CONNECT_TIME 1; -- gioi han phien co the ton tai (phut)

--T?o Profile

CREATE PROFILE nhanvien_profile3 LIMIT
SESSIONS_PER_USER 5 --gioi han so phien ket noi
CPU_PER_SESSION 100 -- gioi han tong so thoi gian CPU ma moi phien co the su dung (miligiay)
CONNECT_TIME 10; -- gioi han phien co the ton tai (phut)

--Gán Profile cho ng??i dùng

ALTER USER hung1233 PROFILE nhanvien_profile3;

SELECT * FROM all_roles;

SELECT * FROM all_users;


GRANT SELECT ON SACH TO ngan123;

select * from NhanVien;

alter user hung123 identified by 123;
--xem tat ca cac phien ket noi
SELECT sid, serial# 
FROM v$session 