use sakila;

-- 1. Write a query to find what is the total business done by each store.
select s.store_id, sum(p.amount) as total_amount
from sakila.store s
join staff st using (store_id)
join payment p using (staff_id)
group by s.store_id;

-- 2. Convert the previous query into a stored procedure.
DELIMITER //

create procedure business_per_store ()
begin
	select s.store_id, sum(p.amount) as total_amount
	from sakila.store s 
	join staff st using (store_id)
	join payment p using (staff_id)
	group by s.store_id;
end // 
DELIMITER ;

-- 3. Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
DELIMITER //

create procedure business_for_store (in storeid int)
begin
	select s.store_id, sum(p.amount) as total_amount
	from sakila.store s 
	join staff st using (store_id)
	join payment p using (staff_id)
	group by s.store_id
    having s.store_id = storeid;
end // 
DELIMITER ;

call business_for_store(2);

-- 4. Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 
drop procedure if exists total_sales_for_store;

DELIMITER //

create procedure total_sales_for_store (in storeid int)
begin
	declare total_sales_value float;
    
	select sum(p.amount) into total_sales_value
	from sakila.store  s
	join staff st using (store_id)
	join payment p using (staff_id)
	group by s.store_id
    having s.store_id = storeid;
    
    select total_sales_value as total_sales;
end // 
DELIMITER ;

-- Call the stored procedure and print the results.

call total_sales_for_store (2);

-- 5. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DELIMITER //

drop procedure if exists total_sales_for_store;

create procedure total_sales_for_store (in storeid int)
begin
	declare total_sales_value float;
    declare flag varchar(25);
    
	select sum(p.amount) into total_sales_value
	from sakila.store  s
	join staff st using (store_id)
	join payment p using (staff_id)
	group by s.store_id
    having s.store_id = storeid;
    
    if total_sales_value > 30000 then
		set flag = "green_flag";
	else
		set flag = "red_flag";
	end if;
    
    select total_sales_value as total_sales, flag as label_flag;
end // 
DELIMITER ;

call total_sales_for_store (2);
