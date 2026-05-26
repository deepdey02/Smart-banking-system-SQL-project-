-- PHASE 3 — EXPERT SQL (REAL INDUSTRY LEVEL)
use smart_banking_system;
-- ---------------------------------------------------------
/* STEP 26 — UNDERSTAND TRANSACTIONS

A banking system MUST be transactional.

Example:
If ₹10,000 transfers from Account A → B:

debit must happen
credit must happen
BOTH succeed
otherwise rollback */
-- --------------------------------------------------------------------
/* ACID PROPERTIES

These are VERY important interview concepts.

Property	Meaning
Atomicity	All or nothing
Consistency	Data remains valid
Isolation	Transactions don’t conflict
Durability	Data saved permanently */
-- --------------------------------------------------------------------
-- STEP 27 — TRANSACTION CONTROL
-- --------------------------------------------------------------------
-- BEGIN TRANSACTION
BEGIN;
-- ----------------------------------------------------------------------
-- COMMIT
COMMIT;
-- ---------------------------------------------------------------------
-- ROLLBACK
ROLLBACK;
-- ----------------------------------------------------------------------
-- EXAMPLE — MONEY TRANSFER
BEGIN;

UPDATE accounts
SET balance = balance - 5000
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 5000
WHERE account_id = 2;

COMMIT;
-- -----------------------------------------------------
-- WHAT IF ERROR OCCURS?
ROLLBACK;
-- This restores original balances.
-- VERY important concept.
-- -------------------------------------------------------
-- STEP 28 — CREATE AUDIT LOG TABLE
-- Banks always track changes.
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    account_id INT,
    action_type VARCHAR(50),
    old_balance DECIMAL(15,2),
    new_balance DECIMAL(15,2),
    changed_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
);

SELECT * from audit_logs;
-- -----------------------------------------------------------------------------
-- STEP 29 — TRIGGERS/
-- Triggers run automatically.
-- Example:
-- Whenever account balance changes:
-- automatically store old/new value
-- -----------------------------------------------------------------------------
-- CREATE TRIGGER FUNCTION
-- First, make sure audit_logs table exists with columns:
-- account_id, action_type, old_balance, new_balance

DELIMITER $$

CREATE TRIGGER log_balance_changes
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (
        account_id,
        action_type,
        old_balance,
        new_balance
    )
    VALUES (
        OLD.account_id,
        'BALANCE UPDATED',
        OLD.balance,
        NEW.balance
    );
END$$
DELIMITER ;
-- ------------------------------------------------------------------------
-- CREATE TRIGGER
DELIMITER $$

CREATE TRIGGER balance_update_trigger
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    -- Only log if balance actually changed
    IF OLD.balance <> NEW.balance THEN
        INSERT INTO audit_logs (
            account_id,
            action_type,
            old_balance,
            new_balance
        )
        VALUES (
            OLD.account_id,
            'BALANCE UPDATED',
            OLD.balance,
            NEW.balance
        );
    END IF;
END$$

DELIMITER ;
-- ----------------------------------------------------------------------------
-- TEST TRIGGER
UPDATE accounts
SET balance = balance + 1000
WHERE account_id = 1;
-- ------------------------------------------------------------------------------
-- CHECK AUDIT LOGS
SELECT *
FROM audit_logs;
-- ---------------------------------------------------------------------------------
-- STEP 30 — STORED PROCEDURES
-- Very important for banking systems.
-- ----------------------------------------------------------------------------------
-- CREATE MONEY TRANSFER PROCEDURE
DELIMITER $$

CREATE PROCEDURE transfer_money (
    IN sender_account INT,
    IN receiver_account INT,
    IN transfer_amount DECIMAL(10,2)
)
BEGIN
    START TRANSACTION;

    UPDATE accounts
    SET balance = balance - transfer_amount
    WHERE account_id = sender_account;

    UPDATE accounts
    SET balance = balance + transfer_amount
    WHERE account_id = receiver_account;

    COMMIT;
END$$

DELIMITER ;
-- ----------------------------------------------------------------------
-- CALL PROCEDURE
CALL transfer_money(1, 2, 2000);

-- IMPORTANT IMPROVEMENT
-- Current procedure has a flaw:
-- it allows negative balances
-- Now we improve logic.
-- ------------------------------------------------------------------------
-- ADVANCED PROCEDURE
DELIMITER $$

CREATE PROCEDURE safe_transfer_money (
    IN sender_account INT,
    IN receiver_account INT,
    IN transfer_amount DECIMAL(10,2)
)
BEGIN
    DECLARE sender_balance DECIMAL(10,2);

    -- Get sender's balance
    SELECT balance
    INTO sender_balance
    FROM accounts
    WHERE account_id = sender_account;

    -- Check balance
    IF sender_balance < transfer_amount THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient Balance';
    ELSE
        START TRANSACTION;

        -- Debit sender
        UPDATE accounts
        SET balance = balance - transfer_amount
        WHERE account_id = sender_account;

        -- Credit receiver
        UPDATE accounts
        SET balance = balance + transfer_amount
        WHERE account_id = receiver_account;

        COMMIT;
    END IF;
END$$

DELIMITER ;
-- ------------------------------------------------------------------------------------------
-- TEST IT
CALL safe_transfer_money(1, 2, 1000);
-- ----------------------------------------------------------------------------------------
/* STEP 31 — FUNCTIONS

Difference:

Procedure	               Function
Can modify data	           Usually returns value
Called using CALL	       Used in SELECT*/
-- -----------------------------------------------------------------------------------------
-- FUNCTION — TOTAL BALANCE
DELIMITER $$

CREATE FUNCTION get_total_balance (customer INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_balance DECIMAL(10,2);

    SELECT SUM(balance)
    INTO total_balance
    FROM accounts
    WHERE customer_id = customer;

    RETURN total_balance;
END$$

DELIMITER ;
-- -------------------------------------------------------------------------------------------------
-- USE FUNCTION
SELECT
    get_total_balance(1);
-- --------------------------------------------------------------------------------------------------
-- STEP 32 — VIEWS
-- Views simplify complex queries.
-- ----------------------------------------------------------------------------------------------------
-- CREATE CUSTOMER ACCOUNT VIEW
CREATE VIEW customer_account_summary as
SELECT c.customer_id, c.first_name, c.last_name, a.account_id, a.account_type, a.balance
FROM customers c
JOIN accounts a
ON c.customer_id = a.customer_id;
-- ------------------------------------------------------------------------------------------------------
-- QUERY VIEW
SELECT *
FROM customer_account_summary;
-- ----------------------------------------------------------------------------------------------------
/* STEP 33 — MATERIALIZED VIEWS
Important for performance.
Difference:
View = always fresh
Materialized View = stored physically

Good for:
dashboards
reports
analytics*/
-- ---------------------------------------------------------------------------------------------------
-- CREATE MATERIALIZED VIEW
-- CREATE MATERIALIZED VIEW branch_total_balance AS

-- SELECT
--     branch_id,
--     SUM(balance) AS total_balance

-- FROM accounts

-- GROUP BY branch_id;
-- --------------------------------------------------------------------------------------------------------
-- MySQL doesn’t support materialized views the way PostgreSQL does. 
-- In MySQL, you can only create regular views (which are virtual and always query the underlying tables). 
-- If you want a “materialized” view (i.e., a snapshot stored physically), you need to simulate it.
-- -------------------------------------------------------------------------------------------------------
/* STEP 34 — INDEXING
CRITICAL FOR PERFORMANCE.

Without index:
full table scan

With index:
fast searching */
-- ----------------------------------------------------------------------------------------------------------
-- CREATE INDEX
CREATE INDEX idx_customer_email
ON customers(email);
-- ---------------------------------------------------------------------------------------------------------
-- INDEX ON TRANSACTIONS
CREATE INDEX idx_transaction_date
ON transactions(transaction_date);
-- ---------------------------------------------------------------------------------------------------------
-- STEP 35 — EXPLAIN ANALYZE
-- Very important for optimization interviews.
-- EXPLAIN ANALYZE
SELECT *
FROM customers
WHERE email = 'rahul@gmail.com';
-- -----------------------------------------------------------------------------------------------------------
-- STEP 36 — COMPOSITE INDEX
CREATE INDEX idx_account_customer_branch
ON accounts(customer_id, branch_id);
-- ---------------------------------------------------------------------------------------------------------------
-- STEP 37 — FRAUD DETECTION QUERIES
-- This is REAL banking analytics.
-- ---------------------------------------------------------------------------------------------------------------
-- Find Large Transactions
SELECT *
FROM transactions
WHERE amount > 30000;
-- ---------------------------------------------------------------------------------------------------------------
-- Find Multiple Transactions Same Day
SELECT
    account_id,
    DATE(transaction_date) AS txn_date,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY
    account_id,
    DATE(transaction_date)
HAVING COUNT(*) > 3;
-- ------------------------------------------------------------------------------------------------------------------
-- Detect Sudden Spending Increase
SELECT
    account_id,
    amount,

    AVG(amount)
    OVER(
        PARTITION BY account_id
    ) AS avg_transaction

FROM transactions;
-- ------------------------------------------------------------------------------------------------------------------
-- STEP 38 — ADVANCED WINDOW FUNCTIONS
-- NTILE()
-- ------------------------------------------------------------------------------------------------------------------
-- Divide customers into groups.
SELECT
    customer_id,
    balance,

    NTILE(4)
    OVER(ORDER BY balance DESC)
    AS customer_segment

FROM accounts;
-- ------------------------------------------------------------------------------------------------------------------
-- FIRST_VALUE()
SELECT
    employee_id,
    salary,

    FIRST_VALUE(salary)
    OVER(
        ORDER BY salary DESC
    ) AS highest_salary

FROM employees;
-- ---------------------------------------------------------------------------------------------
-- STEP 39 — PARTITIONING (ADVANCED)
-- Used for HUGE tables.

-- Example:
-- Transactions table split by year/month.

-- Concept:
-- improves performance
-- easier maintenance
-- -----------------------------------------------------------------------------------------------
-- PARTITION TABLE EXAMPLE
/* CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    amount DECIMAL(10,2)
)
PARTITION BY RANGE (YEAR(transaction_date)) (
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pmax VALUES LESS THAN MAXVALUE
); */
-- -------------------------------------------------------------------------------------------------
-- STEP 40 — REAL INTERVIEW QUESTIONS
-- -----------------------------------------------------------------------------------------------
-- Find 3rd Highest Salary
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;
-- ----------------------------------------------------------------------------------------
-- Find Duplicate Customers
SELECT
    first_name,
    last_name,
    COUNT(*)

FROM customers

GROUP BY
    first_name,
    last_name

HAVING COUNT(*) > 1;
-- -----------------------------------------------------------------------
-- Find Customers With No Transactions
SELECT c.customer_id, c.first_name
FROM customers c
LEFT JOIN accounts a
ON c.customer_id = a.customer_id

LEFT JOIN transactions t
ON a.account_id = t.account_id

WHERE t.transaction_id IS NULL;
-- ----------------------------------------------------------------
-- Find Monthly Growth
/* SELECT
    DATE_TRUNC('month', transaction_date)
    AS month,

    SUM(amount) AS monthly_total,

    LAG(SUM(amount))
    OVER(
        ORDER BY DATE_TRUNC('month', transaction_date)
    ) AS previous_month

FROM transactions

GROUP BY month;  */
-- ----------------------------------------------------------------------------------
-- 

