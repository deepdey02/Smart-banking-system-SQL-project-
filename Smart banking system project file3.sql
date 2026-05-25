use smart_banking_system;
-- ----------------------------------------------
-- STEP 6 — GROUP BY + HAVING
-- ----------------------------------------------
-- Branch-wise Total Balance
select * from accounts;
SELECT
    branch_id,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY branch_id;
-- -------------------------------------------
-- Find Branches Having More Than 1 Lakh Balance
SELECT
    branch_id,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY branch_id
HAVING SUM(balance) > 100000;
-- ---------------------------------------------
-- ---------------------------------------------
-- STEP 7 — JOINS (VERY IMPORTANT)
-- --------------------------------------------
-- INNER JOIN
-- ----------------------------------------------------------
-- Show Customer Name + Account Balance
SELECT c.first_name, c.last_name, a.account_type, a.balance
FROM customers c
INNER JOIN accounts a
ON c.customer_id = a.customer_id;
-- -----------------------------------------------------------
-- JOIN WITH BRANCH
SELECT
    c.first_name,
    a.account_type,
    a.balance,
    b.branch_name
FROM customers c
JOIN accounts a
ON c.customer_id = a.customer_id
JOIN branches b
ON a.branch_id = b.branch_id;
-- ---------------------------------------------------------------
-- STEP 8 — ADVANCED QUERIES
-- --------------------------------------------------------------
-- Subquery
-- Find Customer Having Highest Balance
SELECT *
FROM accounts
WHERE balance = (SELECT MAX(balance)
FROM accounts);
-- ---------------------------------------------------------------
-- Correlated Subquery
-- Find Customers Whose Balance Is Above Average
SELECT *
FROM accounts as a
WHERE balance >
(
    SELECT AVG(balance)
    FROM accounts
    WHERE branch_id = a.branch_id
);
-- ----------------------------------------------------------------
-- STEP 9 — CTEs
-- Common Table Expressions
WITH high_balance_accounts AS
(
    SELECT *
    FROM accounts
    WHERE balance > 50000
)

SELECT *
FROM high_balance_accounts;
-- ------------------------------------------------------------------
-- STEP 10 — WINDOW FUNCTIONS
-- This is SUPER IMPORTANT for interviews.
-- ---------------------------------------------------------------------
-- Rank Customers By Balance
SELECT customer_id, balance,
RANK() OVER( 
ORDER BY balance DESC
) AS balance_rank
FROM accounts;
-- ---------------------------------------------------------------------
-- Running Total
SELECT transaction_id, account_id, amount,
    SUM(amount) OVER(
        PARTITION BY account_id
        ORDER BY transaction_id                 # CONFUSED WITH THIS TOPIC
    ) AS running_total
FROM transactions;
-- -----------------------------------------------------------------------
-- STEP 11 — REAL BUSINESS QUESTIONS
-- Now we move into analytics.
-- ------------------------------------------------------------------------------
-- Find Top 3 Customers
SELECT customer_id,
    SUM(balance) AS total_balance
FROM accounts
GROUP BY customer_id
ORDER BY total_balance DESC
LIMIT 3;
-- -------------------------------------------------------------------------------
-- Monthly Transactions query
SELECT
    DATE_TRUNC('month', transaction_date)
    AS month,

    SUM(amount) AS total_transactions

FROM transactions
GROUP BY month
ORDER BY month;
-- ----------------------------------------------------------------------------------

