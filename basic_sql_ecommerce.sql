
-- Problem set week 3
-- Please add the proper SQL query to follow the instructions below  

-- 1) Select ecommerce as your default database 

use ecommerce;

-- 2) Show the PK, name, and quantity per unit from all products in stock

select productID
,  productName
,  quantityPerUnit
from products
where unitsInStock > 0
;

-- 3) Show the number of products ever on sale in our stores

select count(productID)
from products 
;

-- 4) Show the number of products in stock (available right now) in our store

select count(productID)
from products
where unitsInStock > 0
;


--  5) Show the number of products with more orders than stock

select count(productid)
from products
where unitsOnOrder > unitsInStock
;


-- 6) List all products available in the store and order them alphabetically from a to z 
-- Show just the first ten products 

select productName
from products
order by productName
LIMIT 10
;


--  7) Create a new table in a separated schema. Call it Products2 with the same content of table products
create database test;
create table test.products2 as select * from products;


--  8) Delete the previously created table
drop database test;


--  9) Show how many customer the store has from Mexico

select count(customerID)
from customers
where country = "Mexico"
;

-- 10) Show how many different countries our customers come from

select count(distinct(country))
from customers
;

--  11) Define a new table and call it ReportAlpha 
--  Show all fields from table "categories"
--  Add a field FullName as the concatenation of Category Name and Description
--  if field Picture is NULL Replace it by the 'NULL' string, and
--  if field Picture is the empty string replace it by 'No picture'
--  (hint: use the CONCAT function and the CASE WHEN statement)

create table ReportAlpha (primary key (categoryID)) as
select categoryID
, categoryName
, description
, concat(categoryName, ' ',  description) as FullName 
, case 
	when picture IS NULL then 'NULL'
	when picture = '' then 'No Picture'
  end as picture
from categories;
 
-- select * from ReportAlpha;
-- drop table ReportAlpha;

--  12) Show how many customers are from Mexico, Argentina, or Brazil 
--  whose contact title is  aSales Representative or a Sales Manager

select count(customerID) from customers 
where country in ("Mexico", "Argentina", "Brazil")
and contactTitle in ("Sales Representative", "Sales Manager")
;

--  13) Show the number of employees that are 50 years old or more 
--  as at 2014-10-06 (you will probably need to use the DATE_FORMAT function) 

select count(birthdate)
from employees
where datediff('2014-10-06', date(birthdate)) / 365 > 50
;

-- where timestampdiff(year, birthdate, '2014-10-06') > 50


--  14) Show the age of the oldest employee of the company
--  (hint: use the YEAR and DATE_FORMAT functions)

select truncate(max(datediff('2014-10-06', date(birthdate))) / 365, 0) as max_age
from employees
;


--  15) Show the number of products whose quantity per unit is measured in bottles

select count(productID)
from products
where quantityPerUnit like '%bottle%'
;

-- 16) Show the number of customers with a Spanish or British common surname
--  (a surname that ends with -on or -ez)

select count(contactName)
from customers
where contactName like '%on' or contactName like '%ez';

--  17) Show how many distinct countries our 
--  customers with a Spanish or British common surname come from
--  (a surname that ends with -on or -ez)

select distinct(country)
from customers
where contactName like '%on' or contactName like '%ez';

--  18) Show the number of products whose names do not contain the letter 'a'
--  (Note: patterns are not case sensitive)

select count(productID)
from products
where lower(productName) not like '%a%';

--  19) Get the total number of single items sold ever

select productID
from order_details
where quantity = 1
group by productID
;

--  20) Get the id of all products sold at least one time

select distinct(productID)
from order_details
;

--  21) Is there any product that was never sold?

-- most efficient solution
select distinct(p.productID)
from products p left outer join order_details o
on p.productID = o.productID
where o.productID is null;

-- alternative solution

select productID from products where productID not in (select productID from order_details);

--  22) Get the list of products sorted by category on the following way:
--  2,4,6,7,3,1,5,8
--  i.e. first all products of category 2, then all products of 
--  category 4, and so on.
--  Sort alphabetically by ProductName inside one category (hint: use CASE WHEN)

select productName
from products
order by field (categoryID, 2, 4, 6, 7, 3, 1, 5, 8)
, productName;

-- ALERNATIVE SOLUTION

select productName
from products
order by case categoryID
	when 2 then 1
	when 4 then 2
	when 6 then 3
	when 7 then 4
	when 3 then 5
	when 1 then 6
	when 5 then 7
	when 8 then 8
end
, productName
;


