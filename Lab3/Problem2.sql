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

ALTER TABLE DEPARTMENTADDRESS
ADD  FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE PROJECTS
ADD  FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

ALTER TABLE ASSIGNMENT
ADD  FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
ADD  FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID);

ALTER TABLE RELATIVE
ADD  FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID);

-- Insert data into EMPLOYEES table
INSERT INTO EMPLOYEES (
    employeeID, lastName, middleName, firstName, dateOfBirth, gender, salary, address, managerID, departmentID
) VALUES
('123', 'Dinh', 'Ba', 'Tien', '1995-01-09', 'Nam', 30000.00, '731 Tran Hung Dao Q1 TPHCM', '333', 5),
('333', 'Nguyen', 'Thanh', 'Tung', '1945-12-08', 'Nam', 40000.00, '638 Nguyen Van Cu QS TPHCM', '888', 5),
('453', 'Tran', 'Thanh', 'Tam', '1962-07-31', 'Nam', 25000.00, '543 Mai Thi Luu Ba Dinh Ha Noi', '333', 5),
('666', 'Nguyen', 'Manh', 'Hung', '1952-09-15', 'Nam', 38000.00, '975 Le Lai P3 Vung Tau', '333', 5),
('777', 'Tran', 'Hong', 'Quang', '1959-03-29', 'Nam', 25000.00, '980 Le Hong Phong Vung Tau', '987', 4),
('888', 'Vuong', 'Ngoc', 'Quyen', '1927-10-10', 'Nu', 55000.00, '450 Trung Vuong My Tho TG', NULL, 1),
('957', 'Le', 'Thi', 'Nban', '1931-06-20', 'Nu', 43000.00, '291 Ho Van Hue QPN TPHCM', '588', 1),
('999', 'Bui', 'Thuy', 'Vu', '1958-07-19', 'Nam', 25000.00, '332 Nguyen Thai Hoe Quy Nhon', '987', 4);

