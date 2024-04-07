--CREATE DATABASE Regency_Hotel
USE Regency_Hotel

--CREATE TABLE Class (
--    Id INT IDENTITY(1,1) PRIMARY KEY,
--    Name VARCHAR(50),
--    CreatedDate DATETIME,
--    ModificationDate DATETIME
--);

--CREATE TABLE Student (
--    Id CHAR(36) PRIMARY KEY,
--    Name VARCHAR(50),
--    Gender INT,
--    DOB DATETIME,
--    ClassId INT,
--    CreatedDate DATETIME,
--    ModificationDate DATETIME,
--    FOREIGN KEY (ClassId) REFERENCES Class(Id)
--);

SELECT * FROM Class

SELECT * FROM Student

GO

INSERT INTO Class (Name, CreatedDate, ModificationDate)
VALUES ('One', '2000-01-01', '2000-01-01');

INSERT INTO Student (Id, Name, Gender, DOB, ClassId, CreatedDate, ModificationDate)
VALUES ('62d40c59-b978-4f9d-976d-3e73e209432e', 'Michel', 1, '2000-01-01', 1, '2000-01-01', '2000-01-01');

SELECT * FROM Student WHERE ClassId = 1;

SELECT c.* FROM Class c
JOIN Student s ON c.Id = s.ClassId
WHERE s.Id = '62d40c59-b978-4f9d-976d-3e73e209432e';

