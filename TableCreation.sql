CREATE DATABASE UESystem;
USE UESystem;

-- Students Table: 
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gpa DECIMAL(3,2) NOT NULL CHECK (gpa >= 0.0 AND gpa <= 4.0)
);

-- Professors Table: 
CREATE TABLE Professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- Courses Table: 
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 1 AND 5),
    professor_id INT NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

-- SignUp Table:
CREATE TABLE SignUp (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enroll_date DATE NOT NULL,
    grade INT CHECK (grade BETWEEN 1 AND 20),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

 

