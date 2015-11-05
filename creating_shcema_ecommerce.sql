--------------------------------------------------------------------
-- DWH&BI homework week 2

-- Solution file
-- By Guglielmo Bartolozzi


-- create the database

drop database ecommerce;
create database ecommerce;

-- select the database

use ecommerce;

-- create the required tables

create table products (

ProductID int(11) not null,
ProductName nvarchar(40),
SupplierID int(11),
CategoryID int(11),
QuantityPerUnit nvarchar(20),
UnitPrice smallint,
UnitsInStock smallint,
UnitsOnOrder smallint,
ReorderLevel smallint,
Discontinued tinyint,

primary key (ProductID)

);

create table order_details (

odID int(10) not null,
OrderID int(11),
ProductID int(11),
UnitPrice smallint not null,
Quantity smallint not null,
Discount real not null,

primary key (odID)

);

create table suppliers (

SupplierID int(11) not null,
CompanyName nvarchar(40) not null,
ContactName nvarchar(30) not null,
ContactTitle nvarchar(30) not null,
Address nvarchar(60) not null,
City nvarchar(15) not null,
Region nvarchar(15) not null,
PostalCode nvarchar(10) not null,
Country nvarchar(15) not null,
Phone nvarchar(24) not null,
Fax nvarchar(24) not null,
Homepage text not null,

primary key (SupplierID)

);

create table categories (

CategoryID int(11) not null,
CategoryName nvarchar(15) not null,
Description text not null,
Picture nvarchar(40),

primary key (CategoryID)

);

create table employees (

EmployeeID int(11) not null,
LastName nvarchar(20) not null,
FirstName nvarchar(10) not null,
Title nvarchar(30) not null,
TitleOfCourtesy nvarchar(25) not null,
BirthDate datetime not null,
HireDate datetime not null,
Address nvarchar(60) not null,
City nvarchar(15) not null,
Region nvarchar(15) not null,
PostalCode nvarchar(10) not null,
Country nvarchar(15) not null,
HomePhone nvarchar(24) not null,
Extension nvarchar(4) not null,
Photo nvarchar(40) not null,
Notes text not null,
ReportsTo int not null,

primary key (EmployeeID)

);


create table orders (

OrderID int(11) not null,
CustomerID nchar(5),
EmployeeID int(11),
OrderDate datetime not null,
RequiredDate datetime not null,
ShippedDate datetime not null,
ShipVia int(11),
Freight smallint not null,
ShipName nvarchar(40),
ShipAddress nvarchar(60),
ShipCity nvarchar(15),
ShipRegion nvarchar(15),
ShipPostalCode nvarchar(10),
ShipCountry nvarchar(15),

primary key (OrderID)

);

create table customers (

CustomerID nchar(5) not null,
CompanyName nvarchar(40) not null,
ContactName nvarchar(30) not null,
ContactTitle nvarchar(30) not null,
Address nvarchar(60) not null,
City nvarchar(15) not null,
Region nvarchar(15) not null,
PostalCode nvarchar(10) not null,
Country nvarchar(15) not null,
Phone nvarchar(24) not null,
Fax nvarchar(24) not null,

primary key (CustomerID)

);


create table shippers (

ShipperID int(11) not null,
CompanyName nvarchar(40) not null,
Phone nvarchar(24) not null,

primary key (ShipperID)

);


-- define integrity and referential constraints

alter table employees add constraint 
fk_employee_self foreign key (ReportsTo) references employees(employeeID) on delete no action on update no action;

alter table products add constraint 
foreign key (CategoryID) references categories (CategoryID) on delete no action on update no action;

alter table orders add constraint
foreign key (CustomerID) references customers (CustomerID) on delete no action on update no action;

alter table orders add constraint
foreign key (EmployeeID) references employees (EmployeeID) on delete no action on update no action;

alter table order_details add constraint
foreign key (OrderID) references orders (OrderID) on delete no action on update no action;

alter table orders add constraint
foreign key (ShipVia) references shippers (ShipperID) on delete no action on update no action;

alter table order_details add constraint
foreign key (ProductID) references products (ProductID) on delete no action on update no action;

alter table products add constraint
foreign key (SupplierID) references suppliers (SupplierID) on delete no action on update no action;


-- end of file
------------------------------------------------------------------------------------------------------
