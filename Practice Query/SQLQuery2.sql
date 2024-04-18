--CREATE DATABASE MyStudentDatabase

--USE MyStudentDatabase


CREATE TABLE Student (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(50),
    Age INT,
	[Standard] INT,
	FatherName VARCHAR(100),
	MotherName VARCHAR(100)
);

SELECT TOP 100 * FROM MyStudentDatabase..Student
SELECT TOP 100 * FROM MyPersonalDB..Student

ALTER DATABASE MyStudentDatabase MODIFY NAME = MyPersonalDB


--For Altering Database

ALTER DATABASE MyStudentDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE MyStudentDatabase MODIFY NAME = MyPersonalDB

USE MyPersonalDB
ALTER DATABASE MyPersonalDB SET MULTI_USER;

--CREATE TABLE 

-- Inserting Dummy Data

INSERT INTO MyPersonalDb..Student (Name, Gender, Age, [Standard], FatherName, MotherName) VALUES
('John Doe', 'Male', 18, 12, 'Michael Doe', 'Sarah Doe'),
('Jane Smith', 'Female', 17, 11, 'Robert Smith', 'Emily Smith'),
('David Johnson', 'Male', 16, 10, 'James Johnson', 'Jessica Johnson'),
('Emily Brown', 'Female', 15, 9, 'William Brown', 'Sophia Brown'),
('Michael Wilson', 'Male', 17, 11, 'Daniel Wilson', 'Olivia Wilson');

