use smart_banking_system;
-- -----------------------------------------------------------------
-- STEP 5 — BASIC SQL PRACTICE
-- Now start querying.
-- ---------------------------------------------------------------
-- QUERY 1 — View All Customers   
select * from customers;
-- -------------------------------------------------------------------
-- QUERY 2 — Find Customers From Mumbai
select * from customers
where city='Mumbai';  
-- -------------------------------------------------------------------
-- QUERY 3 — Find Savings Accounts
SELECT *
FROM accounts
WHERE account_type = 'Savings';
-- --------------------------------------------------------------------
-- QUERY 4 — Sort By Balance
select * from accounts
ORDER BY balance DESC;
-- ---------------------------------------------------------------------
-- QUERY 5 — Total Balance In Bank
select sum(balance) as total_bank_balance
from accounts;
-- ----------------------------------------------------------------------
-- QUERY 6 — Average Balance
select avg(balance) as avg_balance
from accounts;
-- ---------------------------------------------------------------------------
-- QUERY 7 — Count Customers
select count(*) as total_customers
from customers;
-- ---------------------------------------------------------------------------------------