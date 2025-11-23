-- Complete MoviesDB Schema and Sample Data
-- Run this script against MoviesDB database to create all tables and populate with sample data

-- Drop tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS dbo.rental;
DROP TABLE IF EXISTS dbo.movies;
DROP TABLE IF EXISTS dbo.customer;
DROP TABLE IF EXISTS dbo.genre;
GO

-- Create Customer table
CREATE TABLE dbo.customer (
  CUST_ssn NVARCHAR(50) NOT NULL PRIMARY KEY,
  CUST_name NVARCHAR(200) NOT NULL,
  CUST_dob DATE NULL,
  CUST_memberdate DATE NULL
);
GO

-- Create Movies table
CREATE TABLE dbo.movies (
  MOV_code NVARCHAR(50) NOT NULL PRIMARY KEY,
  MOV_title NVARCHAR(200) NOT NULL
);
GO

-- Create Genre table
CREATE TABLE dbo.genre (
  GEN_code NVARCHAR(50) NOT NULL PRIMARY KEY,
  GEN_name NVARCHAR(200) NOT NULL
);
GO

-- Create Rental table with foreign keys
CREATE TABLE dbo.rental (
  RENT_id INT IDENTITY(1,1) PRIMARY KEY,
  RENT_movie NVARCHAR(50) NOT NULL,
  RENT_customer NVARCHAR(50) NOT NULL,
  RENT_date DATE NULL,
  RENT_duedate DATE NULL,
  RENT_returndate DATE NULL,
  CONSTRAINT FK_rental_movie FOREIGN KEY (RENT_movie) REFERENCES dbo.movies(MOV_code),
  CONSTRAINT FK_rental_customer FOREIGN KEY (RENT_customer) REFERENCES dbo.customer(CUST_ssn)
);
GO

-- Insert sample genres
INSERT INTO dbo.genre (GEN_code, GEN_name) VALUES 
('ACT','Action'),
('COM','Comedy'),
('DRA','Drama'),
('SCI','Sci-Fi'),
('HOR','Horror'),
('ROM','Romance');
GO

-- Insert sample movies
INSERT INTO dbo.movies (MOV_code, MOV_title) VALUES 
('M001','The Matrix'),
('M002','Toy Story'),
('M003','Titanic'),
('M004','Avatar'),
('M005','The Avengers'),
('M006','Finding Nemo'),
('M007','The Dark Knight'),
('M008','Frozen');
GO

-- Insert sample customers
INSERT INTO dbo.customer (CUST_ssn, CUST_name, CUST_dob, CUST_memberdate) VALUES 
('C001','John Doe','1990-01-01',GETDATE()),
('C002','Jane Smith','1985-05-15',GETDATE()),
('C003','Bob Johnson','1992-03-20',GETDATE()),
('C004','Alice Brown','1988-07-10',GETDATE()),
('C005','Mike Wilson','1995-11-30',GETDATE());
GO

-- Insert sample rentals (some active, some returned)
INSERT INTO dbo.rental (RENT_movie, RENT_customer, RENT_date, RENT_duedate, RENT_returndate) VALUES 
('M001','C001','2024-01-01','2024-01-04','2024-01-03'),
('M002','C002','2024-01-05','2024-01-08',NULL),
('M003','C003','2024-01-10','2024-01-13','2024-01-12'),
('M004','C001','2024-01-15','2024-01-18',NULL),
('M005','C004','2024-01-20','2024-01-23',NULL);
GO

-- Verify data
SELECT 'Customers' AS TableName, COUNT(*) AS RecordCount FROM dbo.customer
UNION ALL
SELECT 'Movies', COUNT(*) FROM dbo.movies
UNION ALL
SELECT 'Genres', COUNT(*) FROM dbo.genre
UNION ALL
SELECT 'Rentals', COUNT(*) FROM dbo.rental;

PRINT 'Database schema and sample data created successfully!';
