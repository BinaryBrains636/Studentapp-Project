-- Create Database
CREATE DATABASE IF NOT EXISTS studentdb;

USE studentdb;

-- Create Students Table
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_addr VARCHAR(200) NOT NULL,
    student_age VARCHAR(10) NOT NULL,
    student_qual VARCHAR(100) NOT NULL,
    student_percent VARCHAR(10) NOT NULL,
    student_year_passed VARCHAR(10) NOT NULL
);

-- Insert Sample Data (Optional)
-- INSERT INTO students (student_name, student_addr, student_age, student_qual, student_percent, student_year_passed)
-- VALUES ('John Doe', '123 Main St', '22', 'B.Tech', '85.5', '2023');
