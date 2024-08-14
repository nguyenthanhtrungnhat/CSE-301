-- a)
use salemanagerment;

-- 1.	Create a trigger before_total_quantity_update to update total quantity of product when Quantity_On_Hand 
-- and Quantity_sell change values. Then Update total quantity when Product P1004 have Quantity_On_Hand = 30,
--  quantity_sell =35.


delimiter $$
create trigger before_total_quantity_update
before update on product
for each row
begin
		set new.total_quantity  = new.quantity_on_hand + new.quantity_sell;
		end$$;
delimiter ;

update product set quantity_on_hand = 30, quantity_sell = 35 where product_number = 'P1004';
select*from product where product_number = 'P1004';
-- 2.	Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman 
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
alter table salesman
add column per_marks decimal(5,2);
delimiter $$
create trigger before_remark_salesman_update
before update on salesman
for each row
begin
	if new.sales_target > 0 then
		set new.per_marks  = (new.target_achieved*100)/new.sales_target;
	else
		set new.per_marks = 0;
        end if;
end$$;
delimiter ;

update salesman
set sales_target = 80 where salesman_number = 'S008';
select*from salesman where salesman_number = 'S008';

-- 3.	Create a trigger before_product_insert to insert a product in product table when profit>30%.
delimiter $$
create trigger before_product_insert
before insert on product
for each row
begin
	declare profit_percent decimal(5,2);
    set profit_percent = (new.sell_price - new.cost_price)*100/new.cost_price;
    if profit_percent<30 then
		signal SQLSTATE '45000'
        set message_text = 'Profit percentage must be more than or equal 30%';
	end if;
end $$;
delimiter ;
select*from product;
insert into product
values ('P1010', 'tables', '20', '30', '1000.0000', '1000.0000', 50, '50', NULL);
delete from product
where Product_NUmber = 'P1010';

insert into product
values ('P1010', 'chair', '15', '30', '1000.0000', '900.0000', 50, '50', NULL);

-- 4.	Create a trigger to update the delivery status to "Delivered" when an order is marked as "Shipped".
delimiter $$
create trigger update_delivery_status
before update on salesorder
for each row
begin
    if new.Order_Status = 'Shipped' then
		set new.Delivery_Status = 'Delivered';
	end if;
end $$;
delimiter ;
-- xoá constraint chỉ nhận giá trị là successful, cancell, in process  
alter table salesorder
drop constraint salesorder_chk_6;

alter table salesorder
add constraint salesorder_chk_6 CHECK ((`Order_Status` in ('In Process','Successful','Cancelled', 'Shipped')));

update salesorder
set order_status = 'Shipped' where order_number = 'O20001';
select*from salesorder where order_number = 'O20001';

-- 5.	Create a trigger to update the remarks for all salesmen to "Good" when a new salesman is inserted.
delimiter $$
create trigger update_remarks
before insert on salesman
for each row
begin
	set new.remark = 'Good';
end $$;
delimiter ;
drop trigger update_remarks;

insert into salesman
value ('S0010', 'Huu', 'Phu Tan', 'Ho Chi Minh', '700002', 'Ho Chi Minh',
 '15000.0000', '50', '35', '090023623', 'bad', NULL);
select*from salesman where Salesman_Number = 'S0010';


-- 6.	Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.

-- when insert a new client
delimiter $$
create trigger check_first_pincode
before insert on clients
for each row
begin
	    if left(new.pincode,1) <> 7 then
		signal SQLSTATE '45000'
        set message_text = 'The first digit of the pin code must be 7';
	end if;
end $$;
delimiter ;

-- when update information for a person
delimiter $$
create trigger check_update_pincode
before update on clients
for each row
begin
	    if left(new.pincode,1) <> 7 then
		signal SQLSTATE '45000'
        set message_text = 'The first digit of the pin code must be 7';
	end if;
end $$;
delimiter ;

insert into clients
value ('C112', 'Mai Xuan', 'Phu Hoa', 'Dai An', '00001', 'Binh Duong', '10000.0000', '5000.0000'
);
update clients
set pincode = 100 where client_number = 'C105';

-- 7.	Create a trigger to update the city for a specific client to "Unknown" when the client is deleted.
insert into clients
value ('C112', 'Mai Xuan', 'Phu Hoa', 'Dai An', '708001', 'Binh Duong', '10000.0000', '5000.0000'
);
delimiter $$
	create trigger update_city_when_delete
    before delete on clients
	for each row
		begin
			set city = 'Unknown' where client_number = 'C112';
            
           end $$;
delimiter ;
delete from clients
where client_number = 'C111';
drop trigger update_city_when_delete;




drop trigger update_city_when_delete;
-- 8.	Create a trigger to update the delivery status to "Cancelled" for corresponding order
--  details when an order is cancelled.
alter table salesorderdetails
add column order_status_details varchar(15);
delimiter $$
	create trigger update_delivery_status_for_orderdetails
    after update on salesorder
	for each row
		begin
			if new.order_status = 'Cancelled' then 
				update salesorderdetails
				set order_status_details = 'Cancelled'
				where order_number = new.order_number;
			end if;
		end $$;
delimiter ;
update salesorder
set order_status = 'Cancelled' where order_number = 'O20016';
select*from salesorderdetails where order_number = 'O20016';
    
-- 9.	Create a trigger to update the delivery status to "Pending" for a specific order when 
-- an order is inserted
alter table salesorder
drop constraint salesorder_chk_4;

alter table salesorder
add constraint salesorder_chk_4 CHECK ((`Delivery_Status` in ('Delivered','On Way',
'Ready to Ship','Pending')));
delimiter $$
	create trigger update_delivery_status_for 
    before insert on salesorder
    for each row
		begin 
			set new.delivery_status = 'Pending';
		end $$;
delimiter ;
insert into salesorder
values ('O20017', '2022-09-16', 'C109', 'S008', 'Ready to Ship', NULL, 'Cancelled');
select*from salesorder where order_number = 'O20017';

-- 10.	Create a trigger before_remark_salesman_update to update Percentage of per_remarks 
-- in a salesman table (will be stored in PER_MARKS column)  If  per_remarks >= 75%, his remarks 
-- should be ‘Good’. If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%,
--  he is considered 'Poor'.
drop trigger before_remark_salesman_update;
delimiter $$
	create trigger before_remark_salesman_update
    before update on salesman
    for each row
		begin
			if new.per_marks>= 75 then set new.remark = 'Good';
            elseif new.per_marks >=50 && new.per_marks <75 then set new.remark = 'Average';
            else set new.remark = 'Poor';
			end if;
		end $$;
delimiter ;

update salesman
set per_marks = 40 where salesman_number = 'S009';
select*from salesman where salesman_number = 'S009';
				
-- b) Writing Function:
-- 1.
delimiter //
create function Average_Salesman_Salary()
returns decimal(15,4)
deterministic
begin
declare averageSalary decimal(15,4);
select avg(salary) into averageSalary from salesman;
return averageSalary;
end//
select Average_Salesman_Salary();
-- 2.
delimiter //
create function Highest_paid_salesman()
returns varchar(255)
deterministic
begin
    declare highestSalary varchar(255);
    select GROUP_CONCAT(salesman_name) 
    into highestSalary 
    from salesman 
    where salary = (select max(salary) from salesman);
    return highestSalary;
end//
select Highest_paid_salesman();
-- 3.
delimiter //
create function Lowest_paid_salesman()
returns varchar(255)
deterministic
begin
    declare lowestSalary varchar(255);
    select GROUP_CONCAT(salesman_name) 
    into lowestSalary 
    from salesman 
    where salary = (select min(salary) from salesman);
    return lowestSalary;
end//
select Lowest_paid_salesman();

-- 4.
delimiter //
create function Total_salesman()
returns int
deterministic
begin
    declare count int;
    select count(Salesman_Number)
    into count 
    from salesman ;
    return count;
end//
select Total_salesman();

-- 5.
delimiter //
create function Total_paid_salesman()
returns decimal(15,4)
deterministic
begin
    declare sum decimal(15,4);
    select sum(salary) 
    into sum 
    from salesman ;
    return sum;
end//
select Total_paid_salesman();

-- 6.
delimiter //
create function find_clients_in_prvince()

-- 7.
delimiter //
create function Total_sales()
returns int
deterministic
begin
    declare count int;
    select sum(Quantity_Sell)
    into count 
    from  product;
    return count;
end//
select Total_sales();

-- 8.
delimiter //
create function Total_order()
returns int
deterministic
begin
    declare count int;
    select count(Order_Number)
    into count 
    from  salesorder;
    return count;
end//
select Total_order();