
insert into salesman values
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');
insert into salesorder values
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');
insert into salesorderdetails values
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);
-- 1. Display the clients (name) who lives in same city.
SELECT client_name
FROM clients c1
INNER JOIN clients c2 ON c1.city = c2.city
and c1.client_name <> c2.client_name;
-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
select clients.city, clients.client_name, salesman.salesman_name 
from clients 
inner join salesman 
on clients.city=salesman.city 
WHERE clients.city = "Thu Dau Mot";
-- 3. Display client name, client number, order number, salesman number, and product number for each
-- order.
select clients.client_name, salesorder.client_number, salesorder.order_number, salesorder.salesman_number, salesorderdetails.product_number
from salesorder
			inner join clients on salesorder.client_number = clients.client_number
			inner join salesman on salesorder.salesman_number = salesman.salesman_number
            inner join salesorderdetails on salesorder.order_number = salesorderdetails.order_number;

-- 4. Find each order (client_number, client_name, order_number) placed by each client.
SELECT 
    clients.client_number, 
    clients.client_name, 
    salesorder.order_number
FROM salesorder
INNER JOIN clients ON salesorder.client_number = clients.client_number;

-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by
-- them.
SELECT 
    clients.client_number, 
    clients.client_name, 
    COUNT(salesorder.order_number) as 'the number of orders which is paid by them '
FROM clients
INNER JOIN salesorder ON clients.client_number = salesorder.client_number
group by clients.client_number, clients.client_name;

-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
select clients.client_number, clients.client_name
from clients
inner join salesorder on clients.client_number = salesorder.client_number
group by clients.client_number, clients.client_name
having count(salesorder.client_number)>2;

-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
select clients.client_number, clients.client_name
from clients
inner join salesorder on clients.client_number = salesorder.client_number
group by clients.client_number, clients.client_name
having count(salesorder.client_number)>1
order by clients.client_number desc;

-- 8. Find the salesman names who sells more than 20 products.
select salesman_name
from salesman
inner join salesorder on salesman.salesman_number = salesorder.salesman_number
inner join salesorderdetails on salesorder.order_number=salesorderdetails.order_number
group by salesman_name
having sum(order_quantity)>20; 

-- 9. Display the client information (client_number, client_name) and order number of those clients who
-- have order status is cancelled.
select clients.client_number, clients.client_name, salesorder.order_number 
from clients
inner join salesorder on clients.client_number = salesorder.client_number
WHERE salesorder.order_status = 'cancelled';
 
-- 10. Display client name, client number of clients C101 and count the number of orders which were
-- received “successful”.
select clients.client_number, clients.client_name, count(order_status="successful") as 'the number of orders which were received “successful”'
from clients
inner join salesorder on clients.client_number = salesorder.client_number
where clients.client_number ='C101';
-- 11. Count the number of clients orders placed for each product.
select salesorderdetails.product_number, count(clients.client_number) as 'the number of clients orders placed for each product'
from salesorderdetails
inner join salesorder on salesorder.order_number = salesorderdetails.order_number
inner join clients on clients.client_number = salesorder.client_number
group by product_number;

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product
-- number.
select salesorderdetails.product_number 
from salesorderdetails
inner join salesorder on salesorder.order_number = salesorderdetails.order_number
inner join clients on clients.client_number = salesorder.client_number
group by product_number
having count(distinct clients.client_number)> 2
order by product_number desc;
-- b) Using nested query with operator (IN, EXISTS, ANY and ALL)
-- 13. Find the salesman’s names who is getting the second highest salary.
select salesman_name
from salesman
order by salary desc
limit 1
offset 1;

-- 14. Find the salesman’s names who is getting second lowest salary.
select salesman_name
from salesman
where salary = (
select distinct salary 
from salesman
order by salary
limit 1
offset 1);

-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the
-- salesman whose salesman number is S001.
select salesman_name, salary
from salesman
where salary> (
select salary 
from salesman
where salesman_number="S001"
);

-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
select distinct salesman.salesman_name
from salesman
inner join salesorder on salesman.Salesman_Number= salesorder.Salesman_Number
inner join salesorderdetails on salesorderdetails.Order_Number = salesorder.Order_Number
where salesorderdetails.product_number="P1002";

-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
select*from salesorder;
select  salesman.salesman_name
from salesman
inner join salesorder on salesman.Salesman_Number= salesorder.Salesman_Number
where salesorder.client_number="P1002" and salesorder.delivery_status="delivered";
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal
-- to 5.
select product.product_name
from product
inner join salesorderdetails on salesorderdetails.Product_Number = product.Product_Number
where salesorderdetails.Order_Quantity = 5;
-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
select salesman.salesman_number, salesman.salesman_name
From salesman
Inner join salesorder on salesman.salesman_number = salesorder.salesman_number
Inner join salesorderdetails on salesorder.order_number = salesorderdetails.order_number
Inner join product on salesorderdetails.product_number = product.product_number
Where product.product_name= 'tv' or product.product_name= 'laptop' or product.product_name= 'pen';
-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.
select salesman.salesman_name
From salesman
Inner join salesorder on salesman.salesman_number = salesorder.salesman_number
Inner join salesorderdetails on salesorderdetails.order_number = salesorder.order_number
Inner join product on salesorderdetails.product_number = product.product_number
Where product.quantity_on_hand >50 and product.sell_price <800;

-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average
-- salary.
select salesman.salesman_name, salesman.salary
From salesman
Where salesman.salary >(select avg(salesman.salary) from salesman);

-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the
-- average amount paid.
Select clients.client_name, clients.amount_due
From clients
Where clients.amount_due>(
select avg(clients.amount_due)
From clients
);
-- 23. Find the product price that was sold to Le Xuan.
Select product.sell_price
From product
Inner join salesorderdetails on salesorderdetails.product_number = product.product_number
Inner join salesorder on salesorder.order_number = salesorderdetails.order_number
Inner join clients on clients.client_number = salesorder.client_number
Where clients.client_name = 'Le Xuan';

-- 24. Determine the product name, client name and amount due that was delivered.
select product.product_name, clients.client_name, clients.amount_due
from product 
Inner join salesorderdetails on salesorderdetails.product_number = product.product_number
Inner join salesorder on salesorder.order_number = salesorderdetails.order_number
Inner join clients on clients.client_number = salesorder.client_number
where delivery_status ='delivered';
-- 25. Find the salesman’s name and their product name which is cancelled.
select salesman.salesman_name, product.product_name
from salesman
inner join salesorder on salesman.salesman_number = salesorder.salesman_number
Inner join salesorderdetails on salesorder.order_number = salesorderdetails.order_number
Inner join product on salesorderdetails.product_number = product.product_number
where salesorder.order_status='cancelled';

-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
SELECT product.product_name, product.sell_price, salesorder.delivery_status
FROM product
INNER JOIN salesorderdetails ON salesorderdetails.product_number = product.product_number
INNER JOIN salesorder ON salesorder.order_number = salesorderdetails.order_number
INNER JOIN clients ON clients.client_number = salesorder.client_number
WHERE clients.client_name = 'Nguyen Thanh ';

select * from clients;
select * from salesorder;
select*from salesorderdetails;
select*from product;
-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information 
-- for each customer.
select c.Client_Name, p.Product_Name, p.Sell_Price, s.Salesman_Name, so.Delivery_Status, sod.Order_Quantity
from clients c inner join salesorder so
on c.Client_Number = so.Client_Number
inner join salesman s
on so.Salesman_Number = s.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
order by c.Client_Name;
-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been 
-- successful but the items have not yet been delivered to the client.
select s.Salesman_Name, p.Product_Name, so.Order_Date
from salesman s inner join salesorder so
on s.Salesman_Number = so.Salesman_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
where so.Order_Status = 'Successful' and so.Delivery_Status <> 'Delivered';
-- 29. Find each clients’ product which in on the way.
select c.Client_Name, p.Product_Name, so.Delivery_Status
from clients c inner join salesorder so
on c.Client_Number = so.Client_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
where so.Delivery_Status = 'On Way'
order by c.Client_Name;
-- 30. Find salary and the salesman’s names who is getting the highest salary.
select salesman_name,salary from salesman where salary = (select max(salary) from salesman);
-- 31. Find salary and the salesman’s names who is getting second lowest salary.
select salesman_name, salary from salesman
where salary = (select distinct salary from salesman order by salary limit 1 offset 1);
-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more 
-- than 9.
select p.Product_Name from product p
where p.Product_Number = any
(select sod.Product_Number from salesorderdetails sod
where sod.Order_Quantity > 9);
-- 33. Find the name of the customer who ordered the same item multiple times.
select c.client_name, p.Product_Name, p.Product_Number from clients c
inner join salesorder so
on c.Client_Number = so.Client_Number
inner join salesorderdetails sod
on so.Order_Number = sod.Order_Number
inner join product p
on sod.Product_Number = p.Product_Number
group by c.Client_Name, p.Product_Name, p.Product_Number
having count(*) > 1;
-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average 
-- salary and works in any of Thu Dau Mot city.
select salesman_name, Salesman_Number, salary, city from salesman
where
city = 'Thu Dau Mot'
and
salary < (select avg(salary) from salesman);
-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than 
-- the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to 
-- highest.
select salesman_name, Salesman_Number, salary from salesman
where
salary > (select max(salary) from salesman inner join salesorder on salesman.Salesman_Number = salesorder.Salesman_Number where salesorder.Order_Status = 'Cancelled')
order by salary;
-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
select distinct salary from salesman order by salary desc limit 1 offset 3;
-- 37. Write a query to find the 3th minimum salary in the salesman’s table
select distinct salary from salesman order by salary desc limit 1 offset 2;