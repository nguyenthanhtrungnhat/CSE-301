create	database SaleManagerment;
use SaleManagerment;
create table clients(
Client_Number varchar(10),
Client_Name varchar(25) not null,
Address varchar(30),
City varchar(30),
Pincode int not null,
Province char(25),
Amount_Paid decimal(15,4),
Amount_Due decimal(15,4), check(Client_Number like '%'), primary key(Client_Number)
);
create table product(
Product_Number varchar(15),
Product_Name varchar(25) not null unique, Quantity_On_Hand int not null,
Quantity_Sell int not null,
Sell_Price decimal(15,4) not null, Cost_Price decimal (15,4) not null, check(Product_Number like 'P%'),
check(Cost_Price<>0),
primary key(Product_Number)
);
create table Salesman(
Salesman_Number varchar(15),
Salesman_Name varchar(25) not null,
Address varchar(30),
City varchar(30),
Pincode int not null,
Province char(25) default('Viet Nam'),
Salary decimal(15,4) not null,
Sales_Target int not null,
Target_Achieved int,
Phone char(10) not null unique,
check(Salesman_Number like '%'),
check(Salary<>0),
check (Sales_Target<>0),
primary key(Salesman_Number)
);
create table SalesOrder( 
Order_Number varchar(15), 
Order_Date date,
Client_Number varchar(15),
Salesman_Number varchar(15),
Delivery_Status char(15),
Delivery_Date date,
Order_Status varchar(15),
primary key (Order_Number),
foreign key (Client_Number) references clients (Client_Number),
foreign key (Salesman_Number) references salesman (Salesman_Number), check (Order_Number like '0%'),
check (Client_Number like 'C%'),
check (Salesman_Number like '%'),
check (Delivery_Status in ('Delivered', 'On Way', 'Ready to Ship')), check (Delivery_Date>Order_Date),
check (Order_Status in ('In Process', 'Successful', 'Cancelled'))
);
create table SalesOrderDetails(
Order_Number varchar(15),
Product_Number varchar(15),
Order_Quantity int,
check (order_number like '0%'), check (Product_Number like 'P%'),
foreign key (Order_Number)
references salesorder (Order_Number), foreign key (Product_Number)
references product (Product_Number)
);
insert into `clients` values 
('C101','Mai Xuan','Phu Hoa','Dai An',700001,'Binh Duong',10000,5000),
('C102','Le Xuan','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',18000,3000),
('C103','Trinh Huu','Phu Loi','Da Lat',700051,'Lam Dong ',7000,3200),
('C104','Tran Tuan','Phu Tan','Thu Dau Mot',700080,'Binh Duong',8000,0),
('C105','Ho Nhu','Chanh My','Hanoi',700005,'Hanoi',7000,150),
('C106','Tran Hai','Phu Hoa','Ho Chi Minh',700002,'Ho Chi Minh',7000,1300),
('C107','Nguyen Thanh ','Hoa Phu','Dai An',700023,'Binh Duong',8500,7500),
('C108','Nguyen Sy','Tan An','Da Lat',700032,'Lam Dong ',15000,1000),
('C109','Duong Thanh','Phu Hoa','Ho Chi Minh',700011,'Ho Chi Minh',12000,8000),
('C110','Tran Minh','Phu My','Hanoi',700005,'Hanoi',9000,1000);
insert into `product` values
('P1001','TV',10,30,1000,800),
('P1002','Laptop',12,25,1500,1100),
('P1003','AC',23,10,400,300),
('P1004','Modem',22,16,250,230),
('P1005','Pen',19,13,12,8),
('P1006','Mouse',5,10,100,105),
('P1007','Keyboard',45,60,120,90),
('P1008','Headset',63,75,50,40);




