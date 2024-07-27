use salemanagerment;
-- Practice in Class
-- 1. Show the all-clients details who lives in “Binh Duong”.
select * from clients where province = 'Binh Duong';
-- 2. Find the client’s number and client’s name who do not live in “Hanoi”.
select client_number, client_name from clients where city <> 'Hanoi';
-- 3. Identify the names of all products with less than 25 in stock.
select product_name from product where quantity_on_hand <25;
-- 4. Find the product names where company making losses. 
select product_name from product where sell_price < cost_price;
-- 5. Find the salesman’s details who are able achieved their target.
select * from salesman where target_achieved >= sales_target ;
-- 6. Select the names and city of salesman who are not received salary between 10000 and 17000.
select city from salesman where salary not between 10000 and 17000;
-- 7. Show order date and the clients_number of who bought the product between '2022-01-01' and 
-- '2022-02-15'.
select order_date, client_number from salesorder where order_date between '2022-01-01' and '2022-02-15';
-- 8. Find the names of cities in clients table where city name starts with "N"
select city from clients where city like 'n%';
-- 9. Display clients’ information whose names have "u" in third position.
select * from clients where client_name like '__u%';
-- 10. Find the details of clients whose names have "u" in second last position.
select * from clients where client_name like '%u_';
-- 11. Find the names of cities in clients table where city name starts with "D" and ends with “n”.
select city from clients where city like 'd%n';
-- 12. Select all clients details who belongs from Ho Chi Minh, Hanoi and Da Lat.
select * from clients where city in ('Ho Chi Minh' , 'Hanoi' , 'Da Lat');
select * from clients where city = 'Ho Chi Minh' or city = 'Hanoi' or city = 'Da Lat';
-- 13. Choose all clients data who do not reside in Ho Chi Minh, Hanoi and Da Lat.
select * from clients where city not in ('Ho Chi Minh' , 'Hanoi' , 'Da Lat');
-- 14. Find the average salesman’s salary.
select avg(salary) from salesman; 
-- 15. Find the name of the highest paid salesman.
select salesman_name from salesman where salary  = (select max(salary) from salesman ) ; 
-- 16. Find the name of the salesman who is paid the lowest salary.
select salesman_name from salesman where salary  = (select min(salary) from salesman ) ; 
-- 17. Determine the total number of salespeople employed by the company.
select count(salesman_number) from salesman;
-- 18. Compute the total salary paid to the company's salesman.
select sum(salary) from salesman;
-- 19. Select the salesman’s details sorted by their salary.
select * from salesman order by salary;
-- 20. Display salesman names and phone numbers based on their target achieved (in ascending order) 
-- and their city (in descending order).
select salesman_name, phone from salesman order by target_achieved asc, city desc; 
-- 21. Display 3 first names of the salesman table and the salesman’s names in descending order.
select salesman_name from salesman order by salesman_name desc limit 3;
-- 22. Find salary and the salesman’s names who is getting the highest salary.
select salary, salesman_name from salesman where salary = (select max(salary) from salesman);
-- 23. Find salary and the salesman’s names who is getting second lowest salary.
select salary, salesman_name from salesman where salary  > (select min(salary) from salesman ) limit 1 ; 
-- 24. Display the first five sales orders in formation from the sales order table.
select * from salesorder limit 5;
-- 25. Display next ten sales order information from sales order table except first five sales order.
select * from salesorder limit 10 offset 5;
-- 26. If there are more than one client, find the name of the province and the number of clients in each 
-- province, ordered high to low. 
select province, count(*) totalclients from clients group by province having count(*)>1 order by count(*) desc;
-- 27. Display information clients have number of sales order more than 1.
select * from clients where client_number in (select client_number from salesorder group by client_number having count(client_number)>1);
-- 28. Display the name and due amount of those clients who lives in “Hanoi”.
select client_name, amount_due from clients where city = 'hanoi';
-- 29. Find the clients details who has due more than 3000.
select * from clients where amount_due >3000;
-- 30. Find the clients name and their province who has no due.
select client_name from clients where amount_due = 0;
-- 31. Show details of all clients paying between 10,000 and 13,000.
select * from clients where amount_paid between 10000 and 13000;
-- 32. Find the details of clients whose name is “Dat”.
select * from clients where client_name = '%Dat%';
-- 33. Display all product name and their corresponding selling price.
select Product_Name, Sell_Price from product;
-- 34. How many TVs are in stock?
select Quantity_On_Hand from product where product_name ='TV';
-- 35. Find the salesman’s details who are not able achieved their target.
select * from salesman where target_achieved < sales_target ;
-- 36. Show all the product details of product number ‘P1005’.
select * from product where product_number ='P1005';
-- 37. Find the buying price and sell price of a Mouse.
select Cost_Price, Sell_Price from product where product_name ='mouse';
-- 38. Find the salesman names and phone numbers who lives in Thu Dau Mot.
select Salesman_Name, Phone from salesman where City ='Thu Dau Mot';
-- 39. Find all the salesman’s name and salary.
select Salesman_Name, salary from salesman;
-- 40. Select the names and salary of salesman who are received between 10000 and 17000.
select Salesman_Name, salary from salesman where salary  between 10000 and 17000;
-- 41. Display all salesman details who are received salary between 10000 and 20000 and achieved 
-- their target. 
select * from salesman where salary  between 10000 and 20000 and target_achieved >= sales_target;
-- 42. Display all salesman details who are received salary between 20000 and 30000 and not achieved 
-- their target. 
select * from salesman where salary  between 20000 and 30000 and target_achieved < sales_target;
-- 43. Find information about all clients whose names do not end with "h".
select * from clients where client_name not like '%h';
-- 44. Find client names whose second letter is 'r' or second last letter 'a'.
select client_name from clients where client_name like '%a_' or '_r%';
-- 45. Select all clients where the city name starts with "D" and at least 3 characters in length.
select  * from clients where city like 'd__%';
-- 46. Select the salesman name, salaries and target achieved sorted by their target_achieved in 
-- descending order
select salesman_name, salary, target_achieved from salesman order by  target_achieved desc;
-- 47. Select the salesman’s details sorted by their sales_target and target_achieved in ascending order.
select * from salesman order by  sales_target , target_achieved ;
-- 48. Select the salesman’s details sorted ascending by their salary and descending by achieved target.
select * from salesman order by  salary asc, target_achieved desc ;
-- 49. Display salesman names and phone numbers in descending order based on their sales target.
select Salesman_Name, Phone from salesman order by  sales_target desc ;
-- 50. Display the product name, cost price, and sell price sorted by quantity in hand.
select Product_Name,Cost_Price,Sell_Price from product order by Quantity_On_Hand ;
-- 51. Retrieve the clients’ names in ascending order.
select Client_Name from clients order by  Client_Name;
-- 52. Display client information based on order by their city.
select * from clients order by  City;
-- 53. Display client information based on order by their address and city.
select * from clients order by address, City;
-- 54. Display client information based on their city, sorted high to low based on amount due.
select * from clients order by  City , Amount_Due desc;
-- 56. Display last five sales order information from sales order table.
select * from salesorder   order by Order_Number desc limit 5;
-- 57. Count the pincode in client table.
select count(Pincode) from clients;
-- 58. How many clients are living in Binh Duong?
select count(Client_Number) from clients where  Province='Binh Duong';
-- 59. Count the clients for each province.
SELECT province, COUNT(client_number) AS total_clients
FROM clients
GROUP BY province;

-- 60. If there are more than three clients, find the name of the province and the number of clients in each 
-- province.
SELECT province, COUNT(client_number) AS total_clients
FROM clients
GROUP BY province
HAVING COUNT(client_number) > 3;

-- 61. Display product number and product name and count number orders of each product more than 1 
-- (in ascending order).
SELECT p.product_number, p.product_name, COUNT(s.order_number) AS order_count
FROM product p
JOIN salesorder s ON p.product_number = s.product_number
GROUP BY p.product_number, p.product_name
HAVING COUNT(s.order_number) > 1
ORDER BY order_count ASC;

-- 62. Find products which have more quantity on hand than 20 and less than the sum of average
SELECT product_name
FROM product
WHERE quantity_on_hand > 20
AND quantity_on_hand < (SELECT AVG(cost_price) + AVG(sell_price) FROM product);

