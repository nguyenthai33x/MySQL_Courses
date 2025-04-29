Create Database Geography_Management;
use Geography_Management;

-- Tạo bảng Country
CREATE TABLE Country (
    country_id CHAR(5) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Tạo bảng Location
CREATE TABLE Location (
    location_id CHAR(6) PRIMARY KEY,
    street_address VARCHAR(150),
    postal_code VARCHAR(20),
    country_id CHAR(5),
    FOREIGN KEY (country_id) REFERENCES Country(country_id)
);

-- Tạo bảng Employee
CREATE TABLE Employee (
    employee_id CHAR(7) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    location_id CHAR(6),
    FOREIGN KEY (location_id) REFERENCES Location(location_id)
        ON DELETE SET NULL
);

-- Country
INSERT INTO Country VALUES 
('CTRVN', 'Việt Nam'),
('CTRJP', 'Nhật Bản'),
('CTRKR', 'Hàn Quốc');

-- Location
INSERT INTO Location VALUES 
('LOCVN1', '123 Lê Lợi, Q1', '700000', 'CTRVN'),
('LOCJP2', '45 Tokyo Mid St', '100-0001', 'CTRJP'),
('LOCKR9', '88 Seoul Gangnam', '06100', 'CTRKR');

-- Employee
INSERT INTO Employee VALUES
('EMPX01Z', 'Trần Nhật Long', 'tnlong@gmail.com', 'LOCVN1'),
('EMPY77W', 'Yuki Tanaka', 'yukita@gmail.com', 'LOCJP2'),
('EMPZ98T', 'Nguyễn Ngọc Nữ', 'nn03@gmail.com', 'LOCVN1');


-- a) Lấy tất cả nhân viên thuộc Việt Nam:
SELECT e.*
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
WHERE c.country_name = 'Việt Nam';

-- b) Tên quốc gia của nhân viên có email "nn03@gmail.com":
SELECT c.country_name
FROM Employee e
JOIN Location l ON e.location_id = l.location_id
JOIN Country c ON l.country_id = c.country_id
WHERE e.email = 'nn03@gmail.com';

-- c) Thống kê mỗi country và location có bao nhiêu employee:
SELECT 
    c.country_name,
    l.street_address,
    COUNT(e.employee_id) AS employee_count
FROM Country c
JOIN Location l ON c.country_id = l.country_id
LEFT JOIN Employee e ON l.location_id = e.location_id
GROUP BY c.country_name, l.street_address;

-- Question 3: Trigger giới hạn 10 nhân viên mỗi quốc gia: 
DELIMITER $$

CREATE TRIGGER trg_limit_employee_per_country
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    DECLARE emp_count INT;

    SELECT COUNT(*)
    INTO emp_count
    FROM Employee e
    JOIN Location l ON e.location_id = l.location_id
    WHERE l.country_id = (SELECT country_id FROM Location WHERE location_id = NEW.location_id);

    IF emp_count >= 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mỗi quốc gia chỉ được tối đa 10 nhân viên!';
    END IF;
END;
$$

DELIMITER ;

-- Question 4: Khi xóa location, set location_id = null cho employee
-- Trong phần tạo bảng Employee đã có:
-- FOREIGN KEY (location_id) REFERENCES Location(location_id) ON DELETE SET NULL



