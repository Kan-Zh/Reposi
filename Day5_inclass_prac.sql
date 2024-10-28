/***********Day5*********new*/

-- create views

USE zhou_lib;
drop view if exists books_view;
create view books_view
as select book_title, book_author, available_copies
from books_t
;

select *
from books_view
;

drop view if exists books_tot_stock_view;
create view books_tot_stock_view
as select sum(available_copies) as totel_stock
from books_t
;
select *
from books_tot_stock_view
;


USE day4;


drop view if exists avg_price;
create view avg_price as
select customer_id, round(avg(total_amount),2) as avg_amount
from orders
group by customer_id
;

select *
from avg_price
;

select *
from orders
;

select *
from products
;


-- Index 
CREATE INDEX indx_product_id
ON products(product_id);



-- grant
DROP USER 'report_user'@'localhost';

CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'guest123';

DROP ROLE 'reporting_role';
CREATE ROLE 'reporting_role';

GRANT SELECT ON day4.orders TO 'reporting_role';

-- GRANT SELECT ON day4.orders TO 'report_user'@'localhost';

GRANT select ON day4.* TO 'reporting_role';


GRANT 'reporting_role' to 'report_user'@'localhost';

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'report_user'@'localhost';

show grants for 'report_user'@'localhost';
show grants for 'reporting_role';

flush privileges ;

-- REVOKE 'reporting_role' FROM 'report_user'@'localhost';



/*******Json data********/
create table employees_Json(
employee_id int primary key,
employee_data json);

insert into employees_Json(employee_id, employee_data) values(102,
'{
"name":"John Doe",
"department": "HR",
"skills": ["Communication", "Recruitment", "Payroll"],
"is_active":true
}'
);

insert into employees_Json(employee_id, employee_data) values
(103,'{
"name":"John Doe",
"department": "HR",
"skills": ["Communication", "Recruitment", "Payroll"],
"is_active":true
}'),
(104,'{
"name":"John Doe",
"department": "HR",
"skills": ["Communication", "Recruitment", "Payroll"],
"is_active":true
}')
;

select *
from employees_Json
;

select employee_data->>'$.name' AS employee_name
,employee_data->>'$.skills' AS employee_skills
FROM Employees_JSON
WHERE employee_id = 101;

UPDATE Employees_JSON
SET employee_data = JSON_SET(employee_data, '$.department', 'Finance')
WHERE employee_id = 101;

select employee_data->>'$.name' AS employee_name
,employee_data->>'$.skills' AS employee_skills
FROM Employees_JSON 
-- where employee_data ->>'$.department'='Finance';
 where JSON_contains(employee_data->'$.skills','"Payroll"');

SELECT JSON_ARRAY(102, 'Bob') as json_array;
SELECT JSON_OBJECT('employee', 101, 'name', 'Alice' , 'skills' ,'Payroll') as JSON_OBJECT;

select JSON_TYPE()
;


SELECT JSON_MERGE_PRESERVE('{"name": "Bob"}', '{"name": "Bob"}') ;
SELECT JSON_MERGE_PATCH('{"name": "Bob"}', '{"name": "Bob"}') ;


/******Practice Exercise*******/

create table Customer_Orders(
customer json primary key,
product json,
order_total int,
order_status varchar(20));

-- practice exercise: Database design hanlding JSON data objects
-- 1. creating table 
CREATE TABLE CustomerOrders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_data JSON
);

-- 2. inserting sample data using JSON_Array and JSON objects
INSERT INTO CustomerOrders (order_data)
VALUES 
-- Order 1
(JSON_OBJECT(
    'customer', JSON_OBJECT('customer_id', 1, 'name', 'Alice Smith'),
    'products', JSON_ARRAY(
        JSON_OBJECT('product_id', 101, 'name', 'Laptop', 'quantity', 1, 'price', 1200.00),
        JSON_OBJECT('product_id', 102, 'name', 'Mouse', 'quantity', 2, 'price', 25.00)
    ),
    'order_total', 1250.00,
    'status', 'shipped'
)),

-- Order 2
(JSON_OBJECT(
    'customer', JSON_OBJECT('customer_id', 2, 'name', 'Bob Johnson'),
    'products', JSON_ARRAY(
        JSON_OBJECT('product_id', 103, 'name', 'Keyboard', 'quantity', 1, 'price', 80.00)
    ),
    'order_total', 80.00,
    'status', 'pending'
)),

-- Order 3
(JSON_OBJECT(
    'customer', JSON_OBJECT('customer_id', 3, 'name', 'Charlie Brown'),
    'products', JSON_ARRAY(
        JSON_OBJECT('product_id', 101, 'name', 'Laptop', 'quantity', 2, 'price', 1200.00),
        JSON_OBJECT('product_id', 104, 'name', 'Monitor', 'quantity', 1, 'price', 300.00)
    ),
    'order_total', 2700.00,
    'status', 'delivered'
));

select *
from CustomerOrders
;



-- 3. Retrieve all customer names and order details, by using JSON_EXTRACT() function.
SELECT 
    order_data->>'$.customer.name' AS customer_name,
-- order_data->>'$.products.product_id' AS product_id,    
    order_data->>'$.order_total' AS order_total
FROM CustomerOrders;

select JSON_UNQUOTE(JSON_EXTRACT(order_data,'$.customer.name')) as customer_name,
JSON_EXTRACT(order_data,'$.order_total') as order_total
from CustomerOrders;

-- 4. Add a new product to an existing order using JSON_MERGE_PATCH() function.
UPDATE CustomerOrders
SET order_data = JSON_MERGE_PATCH(order_data, JSON_OBJECT(
    'products', JSON_ARRAY(
        JSON_OBJECT('product_id', 105, 'name', 'Headphones', 'quantity', 1, 'price', 100.00)
    )
))
WHERE order_data->>'$.customer.name' = 'Alice Smith' and order_id=1;

-- JSON_MERGE_PATCH()
-- UPDATE orders
-- SET order_data = JSON_MERGE_PATCH(products, '[{"product_id": 105, "name": "Headphones", "quantity": 1, "price", 100.00}]')
-- WHERE order_data->>'$.customer.name' = 'Alice Smith' ;



SELECT order_data->>'$.products'
FROM CustomerOrders
WHERE order_data->>'$.customer.name' = 'Alice Smith';


-- 5. Aggregate the Total Order Amount by Status
SELECT 
    order_data->>'$.status' AS order_status,
    SUM(order_data->>'$.order_total') AS total_amount
FROM CustomerOrders
GROUP BY order_data->>'$.status';


/*********************-xml-*************************/ 

create table employees_xml(
 employee_id int primary key auto_increment,
 employee_name varchar(50),
 department varchar(50),
 salary decimal(10,2),
 hire_date date
 );


select *
from employees_xml;
