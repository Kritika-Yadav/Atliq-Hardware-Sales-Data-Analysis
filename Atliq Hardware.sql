use sales;
-- Studying data in Tables
select * from customers;
select count(*) from customers;
-- No redundant(PK) or corrupt data
-- Count = 38
select * from date;
select count(*) from date;
-- No redundant(PK) or corrupt data
-- Count = 1126
select * from markets;
select count(*) from markets;
-- Count = 17
-- No redundant data(PK), New York and Paris markets irrelevant
select * from products; 
select count(*) from products;
-- No redundant(PK) or corrupt data
-- Count = 279
select * from transactions;
select count(*) from transactions;
-- Redundant data maybe present(No PK), Transaction amount less than 1,Transactions in INR as well as USD
-- Count = 150283
select count(*) from transactions where sales_qty>=1 and sales_amount>0; 
-- Count of Valid Transactions = 148672
select count(*) from transactions
where currency like "%USD%";
-- Count of Transactions in USD = 4
select count(distinct product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency) from transactions
where sales_qty>=1 and sales_amount>0;
-- Count of Distinct Valid Transactions = 148395
select count(distinct product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency) from transactions 
where sales_qty>=1 and sales_amount>0 and currency like "%USD%";
-- Count of Distinct Transactions in USD = 2


-- DATA CLEANING
delete from markets 
where zone not in ('Central','North','South');
-- Deleting records of Markets outside India
delete from transactions
where sales_qty<1 or sales_amount<=0; 
-- Deleting invalid transactions with Amount<=0 or Quantity<1
update transactions
set sales_amount = sales_amount*75, currency = "INR"
where currency like "%USD%";
-- Converting transactions in USD to INR
update transactions
set currency = "INR"
where currency like "%INR%";
-- Converting INR transactions to same form
create table dist_transactions(
product_code varchar(255) not null, 
customer_code varchar(255) not null,
market_code varchar(255) not null,
order_date date not null,
sales_qty int not null,
sales_amount int not null,
currency varchar(255) not null);
-- New table for non duplicate transactions
insert into dist_transactions
select distinct product_code, customer_code, market_code, order_date, sales_qty, sales_amount, currency
from transactions;
-- Adding non duplicate transactions

-- CHECKING FOR CORRUPTION IN CLEANED FILES
select count(*) from dist_transactions;

-- CREATING CSV FILES OF CLEANED DATA
select * from customers;
select * from date;
select * from markets;
select * from products;
select * from dist_transactions;

-- CHECKING RESULTS
select SUM(sales_amount) from sales.dist_transactions;

