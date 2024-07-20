create database Problem2;
use Problem2;
CREATE TABLE EMPLOYEES (
    employeeID VARCHAR(3) PRIMARY KEY,
    lastName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20),
    firstName VARCHAR(20) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender VARCHAR(5) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    address VARCHAR(100) NOT NULL,
    managerID VARCHAR(3),
    departmentID INT
);
create table DEPARTMENT(
departmentID int primary key,
departmentName varchar(10) not null,
managerID varchar(3) ,
date0fEmployment date NOT NULL
);
-- Add foreign key constraint to EMPLOYEES table
ALTER TABLE EMPLOYEES
ADD  FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
ADD  FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

-- Add foreign key constraint to DEPARTMENT table
ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID);
#alter table EMPLOYEES drop foreign key employees_ibfk_1;
