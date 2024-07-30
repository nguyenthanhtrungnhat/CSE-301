use salemanagerment;
SET SQL_SAFE_UPDATES = 0;
-- 1. How to check constraint in a table?
-- Example:
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'products';
-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information 
-- about product name and its buying price. 
CREATE TABLE ProductCost (
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Cost_Price DECIMAL(15,4) NOT NULL
);
-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
select * from product;
alter table product add column profit float;
update product set profit = (sell_price - cost_price)/cost_price*100;
-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
ALTER TABLE salesman ADD COLUMN remarks VARCHAR(10);

UPDATE salesman 
SET remarks = 'Good' 
WHERE (Target_Achieved/Sales_Target)*100>=75;
select * from salesman;
-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
UPDATE salesman 
SET remarks = 'Average' 
WHERE (Target_Achieved / Sales_Target) * 100 > 50 
AND (Target_Achieved / Sales_Target) * 100 < 75;
-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
UPDATE salesman 
SET remarks = 'Poor' 
WHERE (Target_Achieved / Sales_Target) * 100 <= 50 ;
-- 7. Find the total quantity for each product. (Query)
SELECT Product_Name,(Quantity_On_Hand + Quantity_Sell) AS 'Total_Quantity'
FROM product;
-- 8. Add a new column and find the total quantity for each product.
ALTER TABLE product ADD COLUMN total_quantity int;
UPDATE product 
SET total_quantity = (Quantity_On_Hand + Quantity_Sell) ;
select * from product;
-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
ALTER TABLE product ADD COLUMN discount_rate int;

SELECT Product_Number,
    CASE
        WHEN Quantity_On_Hand > 10 THEN 10
        ELSE 5
    END AS discount_rate
FROM product;

-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is
-- between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
UPDATE product
SET discount_rate = CASE
    WHEN Quantity_On_Hand >= 20 THEN 10
    WHEN Quantity_On_Hand >= 10 THEN 5
    WHEN Quantity_On_Hand > 5 THEN 3
    ELSE 0
END;
select * from clients;
-- 11. The first number of pin code in the client table should be start with 7.
ALTER TABLE clients
ADD CONSTRAINT question11
CHECK (Pincode LIKE '7%');
-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
CREATE OR REPLACE VIEW clients_view AS
	SELECT *
	FROM clients
	WHERE City='Thu Dau Mot';
-- 13. Drop the “client_view”.
DROP VIEW clients_view;
-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
CREATE OR REPLACE VIEW clients_order 
AS
	SELECT clients.Client_Name, salesorder.*
	FROM clients
	inner join salesorder on salesorder.Client_Number = clients.Client_Number
	WHERE City='Thu Dau Mot';
-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average 
-- sell price.
CREATE OR REPLACE VIEW question15 AS
	SELECT *
	FROM product
	WHERE Sell_Price > (SELECT AVG(Sell_Price) FROM product);

-- 16. Creates a view name as salesman_view that show all salesman information and products (product names, 
-- product price, quantity order) were sold by them.
CREATE OR REPLACE VIEW salesman_view AS
	SELECT salesman.*, product.Product_Name, product.Sell_Price, product.Quantity_Sell
	FROM salesman
    inner join salesorder on salesorder.Salesman_Number = salesman.Salesman_Number
    inner join salesorderdetails on salesorderdetails.Order_Number = salesorder.Order_Number
    inner join product on product.Product_Number = salesorderdetails.Product_Number;
-- 17. Creates a view name as sale_view that show all salesman information and product (product names, 
-- product price, quantity order) were sold by them with order_status = 'Successful'.
CREATE OR REPLACE VIEW sale_view AS
	SELECT salesman.*, product.Product_Name, product.Sell_Price, product.Quantity_Sell
	FROM salesman
    inner join salesorder on salesorder.Salesman_Number = salesman.Salesman_Number
    inner join salesorderdetails on salesorderdetails.Order_Number = salesorder.Order_Number
    inner join product on product.Product_Number = salesorderdetails.Product_Number
    where salesorder.Order_Status= 'Successful';
  
-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity 
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
CREATE OR REPLACE VIEW sale_amount_view AS
	SELECT
		salesman_name,salesman.Salesman_Number,Address,City,Pincode,Province,Salary,Sales_Target,
        Target_Achieved,Phone,remarks,
		SUM(product.Quantity_Sell)
	FROM
		salesman
		INNER JOIN salesorder ON salesorder.Salesman_Number = salesman.Salesman_Number
		INNER JOIN salesorderdetails ON salesorderdetails.Order_Number = salesorder.Order_Number
		INNER JOIN product ON product.Product_Number = salesorderdetails.Product_Number
	WHERE
		salesorder.Order_Status = 'Successful'
		AND product.Quantity_Sell >= 20
        group by salesman_name,salesman.Salesman_Number,Address,City,City,Pincode,Province,Salary,Sales_Target,
        Target_Achieved,Phone,remarks;
        
select*from sale_amount_view;
-- 19. Amount paid and amounted due should not be negative when you are inserting the data. 
ALTER TABLE clients
ADD CONSTRAINT question19
CHECK (Amount_Paid >= 0);
-- 20. Remove the constraint from pincode;
ALTER TABLE clients
DROP CONSTRAINT question11;
-- 21. The sell price and cost price should be unique.
ALTER TABLE product
ADD CONSTRAINT unique_sell_price
UNIQUE (Sell_Price);

ALTER TABLE product
ADD CONSTRAINT unique_cost_price
UNIQUE (Cost_Price);

-- 22. The sell price and cost price should not be unique.
ALTER TABLE product
DROP INDEX unique_sell_price; 

ALTER TABLE product
DROP INDEX unique_cost_price;  
-- 23. Remove unique constraint from product name.
ALTER TABLE product
DROP INDEX unique_product_name; 
-- 24. Update the delivery status to “Delivered” for the product number P1007.
UPDATE salesorder
inner join salesorderdetails on salesorderdetails.Order_Number = salesorder.Order_Number
SET Delivery_Status = 'Delivered'
WHERE salesorderdetails.Product_Number = 'P1007';
select*from salesorder;
-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
UPDATE clients
SET address = 'Phu Hoa' , city= 'Thu Dau Mot'
WHERE client_Number = 'C104';
select*from clients;

-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
ALTER TABLE Product
ADD COLUMN Exp_Date DATE;

-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
ALTER TABLE Clients
ADD COLUMN Phone VARCHAR(15);

-- 28. Update remarks as “Good” for all salesman.
UPDATE salesman
SET remarks = 'Good';

-- 29. Change remarks to "bad" whose salesman number is "S004".
UPDATE salesman
SET remarks = 'bad'
WHERE Salesman_Number = 'S004';

-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
ALTER TABLE Clients
MODIFY COLUMN Phone VARCHAR(10);

-- 31. Delete the “Phone” column from “Clients” table.
ALTER TABLE Clients
DROP COLUMN Phone;

-- 33. Change the sell price of Mouse to 120.
UPDATE product
SET Sell_Price = 120
WHERE Product_Name = 'Mouse';
-- 34. Change the city of client number C104 to “Ben Cat”.
UPDATE Clients
SET city = 'Ben Cat'
WHERE Client_Number = 'C104';

-- 35. If On_Hand_Quantity greater than 5, then 10% discount. If On_Hand_Quantity greater than 10, then 15% 
-- discount. Othrwise, no discount
UPDATE product
SET discount_rate = 
    CASE
        WHEN Quantity_On_Hand > 10 THEN 15
        WHEN Quantity_On_Hand > 5 THEN 10
        ELSE 0
    END;
