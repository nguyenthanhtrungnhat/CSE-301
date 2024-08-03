-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman"
-- table.
select city from clients 
union 
select city from salesman;
-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
select city from clients 
union all
select city from salesman;
-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the
-- "salesman" table.
select city from clients where city= 'Ho Chi Minh'
union 
select city from salesman where city= 'Ho Chi Minh';
-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the
-- "salesman" table.
select city from clients where city= 'Ho Chi Minh'
union all
select city from salesman where city= 'Ho Chi Minh';
-- 5. SQL statement lists all Clients and salesman.
select client_name as allName, city from clients 
union
select salesman_name as allName, city from salesman;	
-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with
-- information: ID, Name, City and Type.
select client_number as ID, client_name as allName, city ,'cliennts' `type` from clients 
where city='Hanoi'
union
select salesman_number as ID,salesman_name as allName, city,'salesman' `type`  from salesman
where city='Hanoi';

-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return
-- ID, name and order by ID.
SELECT *
FROM (
    SELECT 
        c.client_number AS ID, 
        c.client_name AS allName, 
        c.city 
    FROM clients AS c
    INNER JOIN salesorder AS so ON so.client_number = c.client_number
    GROUP BY c.client_number, c.client_name, c.city
    HAVING COUNT(so.order_number) > 1
    
    UNION
    
    SELECT 
        s.salesman_number AS ID, 
        s.salesman_name AS allName, 
        s.city 
    FROM salesman AS s
    INNER JOIN salesorder AS so ON so.salesman_number = s.salesman_number
    GROUP BY s.salesman_number, s.salesman_name, s.city
    HAVING COUNT(so.order_number) > 1
) AS T
ORDER BY ID;

-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client
-- names who placed orders and the salesman names who processed those orders.
select * from(
select 
    c.client_name AS allName, 
	so.order_number,  
    'client'`type`, 
    s.salesman_name as 'who processed or placed_orders those orders' 
    
from clients as c
    inner join salesorder as so on c.client_number = so.client_number
    inner join salesman as s on s.salesman_number = so.salesman_number
union
select 
	s.salesman_name AS allName, 
	so.order_number, 
	'salesman' AS `type`, 
	c.client_name AS 'who processed those orders or who_placed_orders' 
from salesman as s
	inner join salesorder as so on s.salesman_number = so.salesman_number
    inner join clients as c on c.client_number = so.client_number
    ) as T
 order by order_number;

-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and
-- target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High
-- Achieved', while the others will have the words 'Low Achieved'.
-- Query for salesmen with target 60 or greater
SELECT 
    salesman_number AS ID, 
    city, 
    Target_Achieved,
    'High Achieved' AS achievement_status
FROM salesman
WHERE Target_Achieved >= 60

UNION

SELECT 
    salesman_number AS ID, 
    city, 
    Target_Achieved,
    'Low Achieved' AS achievement_status
FROM salesman
WHERE Target_Achieved < 60;

-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'.
select Product_Number AS ID, Product_Name AS Name,Quantity_On_Hand AS Quantity,
	case
		when Quantity_On_Hand >0
		then 'More 5 pieces in Stock'
		else 'Less 5 pieces in Stock'
		end as 'stock status'
from product;
-- 11. Create a procedure stores get_clients _by_city () saves the all Clients in table. Then Call procedure
-- stores.
Delimiter $$
	Create procedure get_clients_by_city(in cityin varchar(30))
    begin 
    select * from clients
    where city = cityin;
    end$$
Delimiter ;
    call get_clients_by_city('Hanoi');

-- 12. Drop get_clients _by_city () procedure stores.
 drop procedure get_clients_by_city;
-- 13. Create a stored procedure to update the delivery status for a given order number. Change value
-- delivery status of order number “O20006” and “O20008” to “On Way”.
DELIMITER $$
CREATE PROCEDURE update_delivery_status()
BEGIN
    UPDATE salesorder
    SET delivery_status = 'On Way'
    WHERE order_number IN ('O20006', 'O20008');
END $$
DELIMITER ;

-- 14. Create a stored procedure to retrieve the total quantity for each product.
DELIMITER $$
CREATE PROCEDURE the_total_quantity_for_each_product()
BEGIN
	SELECT total_quantity FROM product
    GROUP BY Product_Number, Product_Name;
END $$
DELIMITER ;
-- 15. Create a stored procedure to update the remarks for a specific salesman.
DELIMITER $$
CREATE PROCEDURE update_remarks(IN idin VARCHAR(15), IN update_remarks VARCHAR(10))
BEGIN
    UPDATE salesman
    SET remarks = update_remarks
    WHERE salesman_number = idin;
END $$
DELIMITER ;
-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
DELIMITER $$
CREATE PROCEDURE find_clients(in idin varchar(10))
BEGIN
    select * from clients 
    where Client_Number= idin;
END $$
DELIMITER ;
-- 17. Create a procedure stores salary_salesman() saves all of salesman (salesman_number, salesman_name,
-- salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman
-- table.
DELIMITER $$
CREATE PROCEDURE salary_salesman(in dataIn int)
BEGIN
    select salesman_number, salesman_name,salary 
    from salesman
    where salary>15000
    limit dataIn;	
END $$
DELIMITER ;
CALL salary_salesman(2);
CALL salary_salesman(4);

-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
DELIMITER $$
CREATE PROCEDURE get_max_salary()
BEGIN
    SELECT MAX(salary) AS max_salary
    FROM salesman;
END $$
DELIMITER ;

-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder
-- table.
DELIMITER $$
CREATE PROCEDURE finding_amount_of_order_status(in vos varchar(15))
BEGIN
    SELECT count(vos) AS 'amount of order_status'
    FROM salesorder;
END $$
DELIMITER ;

-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000;
-- SALARY = 20000.
DELIMITER $$
CREATE PROCEDURE count_salesmen_by_salary()
BEGIN
    SELECT 
        'SALARY < 20000' AS 'condition',
        COUNT(salesman_number) AS count
    FROM salesman
    WHERE salary < 20000

    UNION ALL
    
    SELECT 
        'SALARY = 20000' AS 'condition',
        COUNT(salesman_number) AS count
    FROM salesman
    WHERE salary = 20000

    UNION ALL

    SELECT 
        'SALARY > 20000' AS 'condition',
        COUNT(salesman_number) AS count
    FROM salesman
    WHERE salary > 20000;
END $$
DELIMITER ;

-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
DELIMITER $$
CREATE PROCEDURE question22(in idIn varchar(15))
BEGIN
   select sum(Order_Quantity), salesorder.salesman_number from salesorderdetails
   inner join salesorder on salesorder.Order_Number = salesorderdetails.Order_Number
	group by salesman_number
   having salesorder.salesman_number = idIn;
END $$
DELIMITER ;

CALL question22('S003');

-- 23. Create a stored procedure to add a new product:
-- Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price,
-- Cost_Price.
DELIMITER $$
CREATE PROCEDURE add_new_product(
    IN p_Product_Number VARCHAR(15),
    IN p_Product_Name VARCHAR(25),
    IN p_Quantity_On_Hand INT,
    IN p_Quantity_Sell INT,
    IN p_Sell_Price DECIMAL(15, 4),
    IN p_Cost_Price DECIMAL(15, 4)
)
BEGIN
    INSERT INTO product (
        Product_Number,
        Product_Name,
        Quantity_On_Hand,
        Quantity_Sell,
        Sell_Price,
        Cost_Price
    )
    VALUES (
        p_Product_Number,
        p_Product_Name,
        p_Quantity_On_Hand,
        p_Quantity_Sell,
        p_Sell_Price,
        p_Cost_Price
    );
END $$

DELIMITER ;

-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"
DELIMITER $$

CREATE PROCEDURE calculate_order_value_and_classification(
    IN p_Order_Number VARCHAR(15),
    OUT p_TotalValue DECIMAL(15, 4),
    OUT p_OrderStatus VARCHAR(15)
)
BEGIN
    -- Declare variables
    DECLARE v_Product_Price DECIMAL(15, 4);
    DECLARE v_Quantity INT;
    DECLARE v_Total DECIMAL(15, 4) DEFAULT 0.0000;
    DECLARE done INT DEFAULT FALSE;
    
    -- Declare cursor
    DECLARE cur CURSOR FOR 
        SELECT Sell_Price, Quantity
        FROM salesorderdetails
        WHERE Order_Number = p_Order_Number;

    -- Declare CONTINUE HANDLER for cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open cursor
    OPEN cur;

    -- Loop through all rows in the cursor
    read_loop: LOOP
        FETCH cur INTO v_Product_Price, v_Quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate total value
        SET v_Total = v_Total + (v_Product_Price * v_Quantity);
    END LOOP;

    -- Close cursor
    CLOSE cur;

    -- Set output parameters
    SET p_TotalValue = v_Total;
    
    -- Determine order classification
    SET p_OrderStatus = CASE
        WHEN v_Total >= 10000 THEN 'Large'
        WHEN v_Total >= 5000 THEN 'Medium'
        ELSE 'Small'
    END;
END $$

DELIMITER ;

