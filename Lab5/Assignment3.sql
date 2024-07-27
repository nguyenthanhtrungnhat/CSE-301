
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
select 
-- 10. Display client name, client number of clients C101 and count the number of orders which were
-- received “successful”.
-- 11. Count the number of clients orders placed for each product.
-- 12. Find product numbers that were ordered by more than two clients then order in descending by product
-- number.