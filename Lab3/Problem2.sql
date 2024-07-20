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

create table DEPARTMENTADDRESS(
departmentID int ,
address varchar(30),
 PRIMARY KEY (departmentID,address)
);
create table PROJECTS(
projectID int PRIMARY KEY,
projectName varchar(30) NOT NULL,
projectAddress varchar(100) NOT NULL,
departmentID int
); 
create table ASSIGNMENT(
employeeID varchar(3),
projectID int,
workingHour float ,
primary key( employeeID,projectID)
);
create table RELATIVE(
employeeID varchar(3) ,
relativeName varchar(50),
gender varchar(5) NOT NULL,
date0fBirth date,
relationship varchar(30) NOT NULL,
primary key(employeeID,relativeName)
);
-- Add foreign key constraint to EMPLOYEES table
ALTER TABLE EMPLOYEES
ADD  FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
ADD  FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID);
#alter table EMPLOYEES drop foreign key ;

ALTER TABLE DEPARTMENTADDRESS
ADD  FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE PROJECTS
ADD  FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE ASSIGNMENT
ADD  FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
ADD  FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID);

ALTER TABLE RELATIVE
ADD  FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID);

insert into EMPLOYEES values(

);
