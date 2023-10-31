# 1. Write a stored procedure that accepts the month and year as inputs and prints the ordernumber, orderdate and status of the orders placed in that month. 
#Example:  call order_status(2005, 11);
# created stored procedure call_order_status_procedure(y int,m int)
delimiter //
CREATE PROCEDURE `call_order_status_procedure`(y int,m int)
BEGIN
select ordernumber,orderdate,status from orders
where year(orderdate)=y and month(orderdate)=m;
END //
DELIMITER ;
call assignment.call_order_status_procedure(2003, 3);
#-------------------------------------------------------------------------------------------------------------------------------------------#
# 2. a. Write function that takes the customernumber as input and returns the purchase_status based on the following criteria . [table:Payments]
# if the total purchase amount for the customer is < 25000 status = Silver, amount between 25000 and 50000, status = Gold if amount > 50000 Platinum

select * from payments;
# created function purchase_status_function(custnum int)

delimiter //
CREATE  FUNCTION `purchase_status_function`(custnum int) RETURNS varchar(50) 
    DETERMINISTIC
BEGIN
	declare total_amount integer;
	declare p_status varchar(50);
	set total_amount= (select sum(amount) from payments where customernumber=custnum);

	set p_status = (case when total_amount<25000 then 'Silver'
						when total_amount>=25000 and total_amount<=50000 then 'Gold'
						else 'Platinum'
                        end );
	RETURN p_status;
END //
DELIMITER ;

# b. Write a query that displays customerNumber, customername and purchase_status from customers table.
select * from customers;
select customernumber,customername, purchase_status_function(customernumber) as 'purchase_status'
from customers;
#-------------------------------------------------------------------------------------------------------------------------------------------#
# 3. Replicate the functionality of 'on delete cascade' and 'on update cascade' using triggers on movies and rentals tables.
# Note: Both tables - movies and rentals - don't have primary or foreign keys. Use only triggers to implement the above.

DELIMITER //
CREATE TRIGGER del_cascade
  AFTER DELETE on movies
    FOR EACH ROW 
    BEGIN
      UPDATE rentals
        SET movieid = NULL
          WHERE movieid
                       NOT IN
            ( SELECT distinct id
              from movies );
    END //
DELIMITER ;

drop trigger if exists del_cascade;

select *
  from movies;

INSERT INTO movies ( id,             title,          category )
      Values ( 11, '2012', 'Action');

INSERT INTO rentals ( memid, first_name, last_name, movieid ) 
           Values (     9,     'Moin',   'Dalvi',      11 );

delete from movies
  where id = 11;

SELECT id
  from movies;

SELECT *
  from rentals;

DELIMITER //
CREATE TRIGGER update_cascade
  AFTER UPDATE on movies
    FOR EACH ROW 
    BEGIN
      UPDATE rentals
        SET movieid = new.id
          WHERE movieid = old.id;
    END //
DELIMITER ;

DROP trigger if exists update_cascade;

INSERT INTO movies ( id,             title,          category )
      Values ( 12, 'Jurassic Park', 'Adventure'); 

UPDATE rentals
  SET movieid = 12
    WHERE memid = 9;

UPDATE movies
  SET id = 11
    WHERE title regexp 'Jurassic Park';

select *
  from movies;

select *
  from rentals;
#-------------------------------------------------------------------------------------------------------------------------------------------#

#4. Select the first name of the employee who gets the third highest salary. [table: employee]
with cte as (select *,dense_rank() over(order by salary desc) as'dn' from employee)
select * from cte where dn=3;

#-------------------------------------------------------------------------------------------------------------------------------------------#

# 5. Assign a rank to each employee  based on their salary. The person having the highest salary has rank 1. [table: employee]
select *,rank() over(order by salary desc) as 'rank' from employee;
