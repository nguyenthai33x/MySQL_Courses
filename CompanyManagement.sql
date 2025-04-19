DROP DATABASE IF EXISTS CompanyDB;
Create Database CompanyDB;
USE CompanyDB;

-- Bảng phòng ban
CREATE TABLE Department (
    departmentId INT AUTO_INCREMENT PRIMARY KEY,
    departmentName VARCHAR(100) NOT NULL
);

-- Bảng nhân viên
CREATE TABLE Employee (
    employeeId INT AUTO_INCREMENT PRIMARY KEY,
    employeeName VARCHAR(100),
    email VARCHAR(100),
    salary DECIMAL(10,2),
    hireDate DATE,
    departmentId INT,
    managerId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(departmentId),
    FOREIGN KEY (managerId) REFERENCES Employee(employeeId)
);

-- Bảng dự án
CREATE TABLE Project (
    projectId INT AUTO_INCREMENT PRIMARY KEY,
    projectName VARCHAR(100),
    startDate DATE,
    endDate DATE
);

-- Bảng phân công nhân viên vào dự án
CREATE TABLE EmployeeProject (
    employeeId INT,
    projectId INT,
    assignedDate DATE,
    PRIMARY KEY (employeeId, projectId),
    FOREIGN KEY (employeeId) REFERENCES Employee(employeeId),
    FOREIGN KEY (projectId) REFERENCES Project(projectId)
);
-- Chèn dữ liệu vào bảng Department
INSERT INTO Department (departmentName) VALUES 
('Phát triển phần mềm'),
('Tiếp thị và Bán hàng'),
('Tài chính và Kế toán'),
('Nhân sự'),
('Hỗ trợ khách hàng'),
('Nghiên cứu và Phát triển'),
('Quản lý dự án');

-- Chèn dữ liệu vào bảng Employee
INSERT INTO Employee (employeeName, email, salary, hireDate, departmentId, managerId) VALUES 
('Nguyễn Thị Mai', 'mai.nguyen@example.com', 85000.00, '2020-01-15', 1, NULL),
('Trần Văn Hùng', 'hung.tran@example.com', 72000.00, '2019-03-22', 2, 1),
('Lê Thị Lan', 'lan.le@example.com', 60000.00, '2021-05-10', 3, 1),
('Phạm Văn An', 'an.pham@example.com', 55000.00, '2022-07-30', 4, 2),
('Ngô Thị Bích', 'bich.ngo@example.com', 90000.00, '2021-11-01', 1, 1),
('Đỗ Văn Tài', 'tai.do@example.com', 48000.00, '2023-02-15', 5, 3),
('Bùi Thị Hòa', 'hoa.bui@example.com', 75000.00, '2020-09-05', 6, 1),
('Vũ Văn Kiên', 'kien.vu@example.com', 67000.00, '2022-12-20', 2, 2),
('Nguyễn Văn Phúc', 'phuc.nguyen@example.com', 80000.00, '2021-04-18', 3, 1),
('Trần Thị Ngọc', 'ngoc.tran@example.com', 52000.00, '2023-01-10', 5, 4);

-- Chèn dữ liệu vào bảng Project
INSERT INTO Project (projectName, startDate, endDate) VALUES 
('Hệ thống quản lý bán hàng', '2021-02-01', '2021-12-31'),
('Ứng dụng di động cho khách hàng', '2022-03-15', '2023-03-15'),
('Nâng cấp hệ thống kế toán', '2020-06-01', '2021-06-01'),
('Phát triển website mới', '2023-01-01', '2023-06-30'),
('Dự án nghiên cứu thị trường', '2022-05-01', '2022-11-30'),
('Hệ thống hỗ trợ khách hàng tự động', '2023-02-01', '2023-12-31');

-- Chèn dữ liệu vào bảng EmployeeProject
INSERT INTO EmployeeProject (employeeId, projectId, assignedDate) VALUES 
(1, 1, '2020-01-20'),
(2, 1, '2019-03-25'),
(3, 3, '2021-05-15'),
(4, 2, '2022-03-20'),
(5, 1, '2021-11-05'),
(6, 4, '2023-01-15'),
(7, 5, '2022-06-10'),
(8, 2, '2022-12-01'),
(9, 3, '2021-05-15'),
(10, 6, '2023-03-01');

-- 1. Liệt kê tất cả các nhân viên trong công ty.
SELECT * FROM Employee;
-- 2. Hiển thị tên và email của các nhân viên thuộc phòng ban "Phát triển phần mềm".
SELECT employeeName, email 
FROM Employee 
WHERE departmentId = (SELECT departmentId FROM Department WHERE departmentName = 'Phát triển phần mềm');
-- 3. Lấy danh sách các dự án đã bắt đầu trong năm 2022.
SELECT * FROM Project WHERE startDate >= '2022-01-01' AND startDate < '2023-01-01';
-- 4. Tìm các nhân viên được thuê sau ngày 01/01/2021.
SELECT * FROM Employee WHERE hireDate > '2021-01-01';
-- 5. Hiển thị tất cả phòng ban có trong công ty.
SELECT * FROM Department;
-- 6. Lấy tên nhân viên và mức lương của họ.
SELECT employeeName, salary FROM Employee;
-- 7. Đếm số lượng nhân viên trong mỗi phòng ban.
SELECT departmentId, COUNT(*) AS employeeCount 
FROM Employee 
GROUP BY departmentId;
-- 8. Tìm tất cả các dự án có ngày kết thúc sau '2023-01-01'.
SELECT * FROM Project WHERE endDate > '2023-01-01';
-- 9. Lấy danh sách nhân viên có lương lớn hơn 70,000.
SELECT * FROM Employee WHERE salary > 70000;
-- 10. Liệt kê các nhân viên chưa có người quản lý (manager).
SELECT * FROM Employee WHERE managerId IS NULL;
-- 11. Tính tổng lương của nhân viên trong từng phòng ban.
SELECT departmentId, SUM(salary) AS totalSalary 
FROM Employee 
GROUP BY departmentId;
-- 12. Liệt kê các dự án mà nhân viên có ID = 2 đang tham gia.
SELECT p.* 
FROM Project p 
JOIN EmployeeProject ep ON p.projectId = ep.projectId 
WHERE ep.employeeId = 2;
-- 13. Hiển thị tên nhân viên và tên phòng ban của họ.
SELECT e.employeeName, d.departmentName 
FROM Employee e 
JOIN Department d ON e.departmentId = d.departmentId;
-- 14. Tìm nhân viên có mức lương cao nhất trong mỗi phòng ban.
SELECT departmentId, MAX(salary) AS maxSalary 
FROM Employee 
GROUP BY departmentId;
-- 15. Liệt kê các nhân viên tham gia vào hơn 1 dự án.
SELECT ep.employeeId, COUNT(ep.projectId) AS projectCount 
FROM EmployeeProject ep 
GROUP BY ep.employeeId 
HAVING projectCount > 1;
-- 16. Lấy tên dự án và số lượng nhân viên tham gia mỗi dự án.
SELECT p.projectName, COUNT(ep.employeeId) AS employeeCount 
FROM Project p 
LEFT JOIN EmployeeProject ep ON p.projectId = ep.projectId 
GROUP BY p.projectId;
-- 17. Liệt kê các nhân viên thuộc phòng "HR" và có lương trên 60,000
SELECT e.* 
FROM Employee e 
JOIN Department d ON e.departmentId = d.departmentId 
WHERE d.departmentName = 'Nhân sự' AND e.salary > 50000;
-- 18. Hiển thị các dự án mà không có nhân viên nào tham gia.
SELECT * 
FROM Project p 
WHERE NOT EXISTS (SELECT 1 FROM EmployeeProject ep WHERE ep.projectId = p.projectId);
-- 19. Liệt kê tất cả nhân viên cùng với người quản lý của họ.
SELECT e.employeeName AS Employee, m.employeeName AS Manager 
FROM Employee e 
LEFT JOIN Employee m ON e.managerId = m.employeeId;
-- 20. Tìm các nhân viên làm việc trong phòng ban bất kì nhưng không tham gia bất kỳ dự án nào.
SELECT e.* 
FROM Employee e 
WHERE e.departmentId = (SELECT departmentId FROM Department WHERE departmentName = 'Quản lý dự án') 
AND e.employeeId NOT IN (SELECT ep.employeeId FROM EmployeeProject ep);
-- 21. Liệt kê tên nhân viên và tên dự án họ tham gia, cùng ngày được phân công.
SELECT e.employeeName, p.projectName, ep.assignedDate 
FROM Employee e 
JOIN EmployeeProject ep ON e.employeeId = ep.employeeId 
JOIN Project p ON ep.projectId = p.projectId;
-- 22. Tìm các dự án có ít nhất 3 nhân viên đang tham gia.
SELECT p.projectId, p.projectName 
FROM Project p 
JOIN EmployeeProject ep ON p.projectId = ep.projectId 
GROUP BY p.projectId 
HAVING COUNT(ep.employeeId) >= 3;
-- 23. Tìm nhân viên làm việc trong dự án "Website Redesign" và "Mobile App".
SELECT ep.employeeId 
FROM EmployeeProject ep 
JOIN Project p ON ep.projectId = p.projectId 
WHERE p.projectName IN ('Hệ thống quản lý bán hàng') 
GROUP BY ep.employeeId 
HAVING COUNT(DISTINCT p.projectName) = 1;
-- 24. Liệt kê tất cả nhân viên có cùng người quản lý 
SELECT e.* 
FROM Employee e 
WHERE e.managerId = (SELECT managerId FROM Employee WHERE employeeName = 'Đỗ Văn Tài');
-- 25. Hiển thị tên phòng ban và mức lương trung bình của nhân viên trong phòng ban đó, chỉ với các phòng ban có hơn 1 nhân viên.
SELECT d.departmentName, AVG(e.salary) AS averageSalary 
FROM Department d 
JOIN Employee e ON d.departmentId = e.departmentId 
GROUP BY d.departmentId 
HAVING COUNT(e.employeeId) > 1;
-- 26. Tìm nhân viên có mức lương cao nhất toàn công ty nhưng không phải là quản lý của bất kỳ ai.
SELECT * 
FROM Employee 
WHERE salary = (SELECT MAX(salary) FROM Employee) 
AND employeeId NOT IN (SELECT DISTINCT managerId FROM Employee WHERE managerId IS NOT NULL);
-- 27. Hiển thị tên của tất cả các dự án có ít nhất một nhân viên thuộc phòng "Engineering" tham gia.
SELECT DISTINCT p.projectName 
FROM Project p 
JOIN EmployeeProject ep ON p.projectId = ep.projectId 
JOIN Employee e ON ep.employeeId = e.employeeId 
WHERE e.departmentId = (SELECT departmentId FROM Department WHERE departmentName = 'Nhân sự');
-- 28. Viết truy vấn hiển thị “cây quản lý” theo từng cấp (employee - manager - grand-manager nếu có).
WITH RECURSIVE ManagementTree AS (
    SELECT employeeId, employeeName, managerId, 0 AS level 
    FROM Employee 
    WHERE managerId IS NULL
    UNION ALL
    SELECT e.employeeId, e.employeeName, e.managerId, mt.level + 1 
    FROM Employee e 
    JOIN ManagementTree mt ON e.managerId = mt.employeeId
)
SELECT * FROM ManagementTree;
-- 29. Nhân viên tham gia dự án trước khi được thuê
SELECT e.* 
FROM Employee e 
JOIN EmployeeProject ep ON e.employeeId = ep.employeeId 
WHERE ep.assignedDate < e.hireDate;
-- 30. Dự án đang hoạt động với ít hơn 3 nhân viên tham gia
SELECT p.* 
FROM Project p 
WHERE p.endDate IS NULL 
AND p.projectId NOT IN (
    SELECT ep.projectId 
    FROM EmployeeProject ep 
    GROUP BY ep.projectId 
    HAVING COUNT(ep.employeeId) >= 1
);

