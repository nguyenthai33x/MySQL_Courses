Create Database Student_Management;
Use Student_Management;

-- Question 1: Tạo bảng và thêm dữ liệu
CREATE TABLE Student (
    StudentID VARCHAR(10) PRIMARY KEY,
    Name NVARCHAR(50),
    Age INT CHECK (Age >= 5 AND Age <= 100),
    Gender INT CHECK (Gender IN (0, 1)) NULL -- 0: Male, 1: Female, NULL: Unknown
);

CREATE TABLE Subject (
    SubjectID VARCHAR(10) PRIMARY KEY,
    Name NVARCHAR(50)
);

CREATE TABLE StudentSubject (
    StudentID VARCHAR(10),
    SubjectID VARCHAR(10),
    Mark DECIMAL(4,2) CHECK (Mark >= 0 AND Mark <= 10),
    ExamDate DATE,
    PRIMARY KEY(StudentID, SubjectID, ExamDate),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subject(SubjectID)
);

-- Dữ liệu mẫu
INSERT INTO Student VALUES 
('STU_A17', 'Nguyen Van Khoi', 17, 0),
('STU_B18', 'Tran Thi Bich', 18, 1),
('STU_C19', 'Pham Duy Linh', 19, NULL);

INSERT INTO Subject VALUES
('SUB_M01', 'Mathematics'),
('SUB_P01', 'Physics'),
('SUB_C01', 'Chemistry'),
('SUB_H01', 'History');

INSERT INTO StudentSubject VALUES
('STU_A17', 'SUB_M01', 8.5, '2025-03-12'),
('STU_B18', 'SUB_M01', 7.0, '2025-03-12'),
('STU_B18', 'SUB_P01', 9.0, '2025-03-14');

-- Question 2: Truy vấn dữ liệu
-- a) Môn học không có điểm nào
SELECT s.SubjectID, s.Name
FROM Subject s
LEFT JOIN StudentSubject ss ON s.SubjectID = ss.SubjectID
WHERE ss.SubjectID IS NULL;

-- b) Môn học có ít nhất 2 điểm
SELECT SubjectID, COUNT(*) AS SoLuongDiem
FROM StudentSubject
GROUP BY SubjectID
HAVING COUNT(*) >= 2;

-- Question 3: Tạo View "StudentInfo"
CREATE VIEW StudentInfo AS
SELECT 
    s.StudentID,
    ss.SubjectID,
    s.Name AS StudentName,
    s.Age AS StudentAge,
    CASE 
        WHEN s.Gender = 0 THEN 'Male'
        WHEN s.Gender = 1 THEN 'Female'
        ELSE 'Unknown'
    END AS Gender,
    sub.Name AS SubjectName,
    ss.Mark,
    ss.ExamDate AS Date
FROM Student s
JOIN StudentSubject ss ON s.StudentID = ss.StudentID
JOIN Subject sub ON ss.SubjectID = sub.SubjectID;

-- Question 4: Trigger không dùng Cascade
-- a) Trigger SubjectUpdateID - Cập nhật SubjectID thủ công khi đổi ID
( DELIMITER //
CREATE TRIGGER SubjectUpdateID
BEFORE UPDATE ON Subject
FOR EACH ROW
BEGIN
    -- Update the StudentSubject table
    UPDATE StudentSubject
    SET SubjectID = NEW.SubjectID
    WHERE SubjectID = OLD.SubjectID;
END; //

DELIMITER ; );

-- b) Trigger StudentDeleteID - Xóa luôn StudentSubject khi xóa Student
DELIMITER $$
CREATE TRIGGER StudentDeleteID
AFTER DELETE
ON Student
FOR EACH ROW
BEGIN
    -- Xóa các bản ghi từ StudentSubject sau khi xóa Student
    DELETE FROM StudentSubject
    WHERE StudentID = OLD.StudentID;
END $$
DELIMITER ;

-- Question 5: Store Procedure xóa học sinh theo tên (có hỗ trợ "*")
DELIMITER $$

CREATE PROCEDURE DeleteStudentByName(IN Name VARCHAR(50))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE student_id INT;
    DECLARE cur CURSOR FOR
        SELECT StudentID FROM Student WHERE Name = Name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    IF Name = '*' THEN
        DELETE FROM StudentSubject;
        DELETE FROM Student;
    ELSE
        OPEN cur;

        read_loop: LOOP
            FETCH cur INTO student_id;
            IF done THEN
                LEAVE read_loop;
            END IF;

            DELETE FROM StudentSubject WHERE StudentID = student_id;
        END LOOP;

        CLOSE cur;

        DELETE FROM Student WHERE Name = Name;
    END IF;
END $$

DELIMITER ;





