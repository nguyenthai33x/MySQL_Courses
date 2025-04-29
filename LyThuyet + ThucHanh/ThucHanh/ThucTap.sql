CREATE DATABASE ThucTap;

USE ThucTap;

CREATE TABLE GiangVien (
    magv INT PRIMARY KEY,
    hoten VARCHAR(100),
    luong DECIMAL(10, 2)
);

CREATE TABLE SinhVien (
    masv INT PRIMARY KEY,
    hoten VARCHAR(100),
    namsinh YEAR,
    quequan VARCHAR(100)
);

CREATE TABLE DeTai (
    madt INT PRIMARY KEY,
    tendt VARCHAR(100),
    kinhphi DECIMAL(10, 2),
    Noithuctap VARCHAR(100)
);

CREATE TABLE HuongDan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    masv INT,
    madt INT,
    magv INT,
    ketqua VARCHAR(255),
    FOREIGN KEY (masv) REFERENCES SinhVien(masv) ON DELETE CASCADE,
    FOREIGN KEY (madt) REFERENCES DeTai(madt),
    FOREIGN KEY (magv) REFERENCES GiangVien(magv)
);

-- Insert ít nhất 3 bản ghi vào các bảng:

INSERT INTO GiangVien (magv, hoten, luong) VALUES
(1, 'Nguyen Thi Lan', 15000000),
(2, 'Tran Minh Tu', 18000000),
(3, 'Pham Quang Hieu', 20000000);

INSERT INTO SinhVien (masv, hoten, namsinh, quequan) VALUES
(1001, 'Le Thi Mai', 2000, 'Hanoi'),
(1002, 'Nguyen Hoang Nam', 1999, 'Danang'),
(1003, 'Tran Thanh Hoa', 2001, 'Hai Phong');

INSERT INTO DeTai (madt, tendt, kinhphi, Noithuctap) VALUES
(1, 'CONG NGHE SINH HOC', 5000000, 'Hanoi'),
(2, 'AI AND MACHINE LEARNING', 7000000, 'HCM'),
(3, 'ECONOMICS AND FINANCE', 3000000, 'Danang');


-- Question 2:
-- a) Lấy tất cả các sinh viên chưa có đề tài hướng dẫn:

SELECT s.masv, s.hoten
FROM SinhVien s
LEFT JOIN HuongDan h ON s.masv = h.masv
WHERE h.madt IS NULL;

-- b) Lấy ra số sinh viên làm đề tài 'CONG NGHE SINH HOC':
SELECT COUNT(DISTINCT h.masv) AS so_sinh_vien
FROM HuongDan h
JOIN DeTai d ON h.madt = d.madt
WHERE d.tendt = 'CONG NGHE SINH HOC';

-- Question 3:
-- Tạo view có tên là "SinhVienInfo" lấy các thông tin về học sinh bao gồm mã số, 
-- họ tên và tên đề tài. (Nếu sinh viên chưa có đề tài thì column tên đề tài sẽ in ra "Chưa có")
CREATE VIEW SinhVienInfo AS
SELECT s.masv, s.hoten, 
       COALESCE(d.tendt, 'Chưa có') AS tendt
FROM SinhVien s
LEFT JOIN HuongDan h ON s.masv = h.masv
LEFT JOIN DeTai d ON h.madt = d.madt;

-- Question 4:
-- Tạo trigger cho table SinhVien khi insert sinh viên có năm sinh <= 1900 thì hiện ra thông báo "năm sinh phải > 1900"
DELIMITER $$

CREATE TRIGGER CheckYearBeforeInsert
BEFORE INSERT ON SinhVien
FOR EACH ROW
BEGIN
    IF NEW.namsinh <= 1900 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Năm sinh phải > 1900';
    END IF;
END $$

DELIMITER ;

-- Question 5:
-- Cấu hình table sao cho khi xóa 1 sinh viên nào đó thì sẽ tất cả thông tin trong table HuongDan liên quan tới sinh viên đó sẽ bị xóa đi
-- Đã thực hiện trong khi tạo bảng HuongDan với ràng buộc ON DELETE CASCADE cho khóa ngoại masv:
-- CREATE TABLE HuongDan (
--     id INT PRIMARY KEY AUTO_INCREMENT,
--     masv INT,
--     madt INT,
--     magv INT,
--     ketqua VARCHAR(255),
--     FOREIGN KEY (masv) REFERENCES SinhVien(masv) ON DELETE CASCADE,
--     FOREIGN KEY (madt) REFERENCES DeTai(madt),
--     FOREIGN KEY (magv) REFERENCES GiangVien(magv)
-- );
-- Điều này đảm bảo rằng khi một sinh viên bị xóa, tất cả các bản ghi liên quan trong bảng HuongDan cũng sẽ bị xóa theo.




