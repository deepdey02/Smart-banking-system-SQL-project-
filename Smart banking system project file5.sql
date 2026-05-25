-- NOW WE START IMPORTANT SQL
use smart_banking_system;
-- ---------------------------------------------
-- STEP 17 — CASE WHEN
-- Categorize Customers Based On Balance
SELECT
    account_id,
    balance,
    CASE
        WHEN balance >= 100000
        THEN 'High Balance'

        WHEN balance >= 50000
        THEN 'Medium Balance'

        ELSE 'Low Balance'
    END AS balance_category
FROM accounts;
-- -------------------------------------------------------------
-- STEP 18 — SELF JOIN
-- This is VERY important.
-- ------------------------------------------------------------
-- Employee + Manager Name
SELECT
e.first_name AS employee_name,
m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;
-- -----------------------------------------------------------------
-- STEP 19 — MULTIPLE JOINS
-- Loan Report
SELECT c.first_name,c.last_name,l.loan_type,l.loan_amount,b.branch_name
FROM customers as c

JOIN accounts as a
ON c.customer_id = a.customer_id

JOIN branches as b
ON a.branch_id = b.branch_id

JOIN loans as l
ON c.customer_id = l.customer_id;
-- -----------------------------------------------------------------------
-- STEP 20 — IMPORTANT SUBQUERIES
-- Find Employees Earning More Than Average Salary
SELECT *
FROM employees

WHERE salary >
(
    SELECT AVG(salary)
    FROM employees
);
-- ------------------------------------------------------------------------
-- Find Second Highest Salary
SELECT MAX(salary)
FROM employees
WHERE salary <
(
    SELECT MAX(salary)
    FROM employees
);
-- -----------------------------------------------------------------------
-- Find Third Highest Salary
SELECT MAX(salary)
FROM employees
WHERE salary <
(
    SELECT MAX(salary)
    FROM employees
    WHERE salary <
    (
        SELECT MAX(salary)
        FROM employees
    )
);
-- --------------------------------------------------------------------------------
-- STEP 21 — CTEs (VERY IMPORTANT)
-- ------------------------------------------------------------------------------
-- Department Salary Report
WITH department_salary AS
(
    SELECT
        department_id,
        AVG(salary) AS avg_salary

    FROM employees

    GROUP BY department_id
)

SELECT *
FROM department_salary;
-- ------------------------------------------------------------
-- STEP 22 — WINDOW FUNCTIONS MASTER LEVEL
-- ROW_NUMBER()
SELECT
    employee_id,
    first_name,
    salary,

    ROW_NUMBER() OVER(
        ORDER BY salary DESC
    ) AS row_num

FROM employees;
-- -------------------------------------------------------------
-- RANK()
SELECT employee_id,first_name,salary,
RANK() OVER(
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;
-- ---------------------------------------------------------------
-- DENSE_RANK()
SELECT employee_id,first_name,salary,
DENSE_RANK() OVER(
        ORDER BY salary DESC
    ) AS dense_rnk
FROM employees;
-- -----------------------------------------------------------------
/* IMPORTANT DIFFERENCE
Function	Skips Rank?
ROW_NUMBER	No duplicates
RANK	Skips numbers
DENSE_RANK	No skips */
-- ------------------------------------------------------------------
