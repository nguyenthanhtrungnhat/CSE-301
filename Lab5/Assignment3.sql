
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
-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.
-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average
-- salary.
-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the
-- average amount paid.