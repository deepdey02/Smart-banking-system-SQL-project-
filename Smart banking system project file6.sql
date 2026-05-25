use smart_banking_system;
-- ------------------------------------------------
-- LAG()
-- Previous Salary
SELECT employee_id,first_name,salary,
    LAG(salary)
    OVER(ORDER BY salary)
    AS previous_salary
FROM employees;
-- --------------------------------------------------
-- LEAD()
-- Next Salary
SELECT employee_id,first_name,salary,
    LEAD(salary)
    OVER(ORDER BY salary)
    AS next_salary
FROM employees;
-- ---------------------------------------------------------
-- RUNNING TOTAL   ( which means cumulative frequency)
SELECT employee_id,salary,
    SUM(salary)
    OVER(
        ORDER BY employee_id
    ) AS running_salary_total
FROM employees;
-- -----------------------------------------------------------
-- STEP 23 — ADVANCED ANALYTICS QUESTIONS
-- These are REAL interview-style queries.
-- ----------------------------------------------------------------
-- Top 3 Highest Paid Employees
SELECT *
FROM
(SELECT employee_id,first_name,salary,
        DENSE_RANK() OVER(
            ORDER BY salary DESC
        ) AS salary_rank
    FROM employees
) x
WHERE salary_rank <= 3;
-- -----------------------------------------------------------------
-- Find Total Loan Amount Per Customer
SELECT c.first_name,
    SUM(l.loan_amount)
    AS total_loan_amount
FROM customers c
JOIN loans l
ON c.customer_id = l.customer_id
GROUP BY c.first_name;
-- -----------------------------------------------------------------
-- Find Customers Without Loans
SELECT
    c.customer_id,
    c.first_name

FROM customers c

LEFT JOIN loans l
ON c.customer_id = l.customer_id

WHERE l.loan_id IS NULL;
-- ------------------------------------------------------------------------
-- Find Branch With Highest Total Balance
SELECT
    b.branch_name,

    SUM(a.balance)
    AS total_balance

FROM branches b

JOIN accounts a
ON b.branch_id = a.branch_id

GROUP BY b.branch_name

ORDER BY total_balance DESC
LIMIT 1;
-- ----------------------------------------------------
-- STEP 24 — DATE FUNCTIONS
-- -----------------------------------------------------
-- Monthly Loan Report
/* SELECT
    DATE_TRUNC('month', issue_date)
    AS loan_month,

    SUM(loan_amount)
    AS total_loans

FROM loans

GROUP BY loan_month
ORDER BY loan_month;  */
-- ---------------------------------------------------------------
-- Calculate Employee Experience
/* SELECT
    employee_id,
    first_name,

    AGE(CURRENT_DATE, hire_date)
    AS experience

FROM employees; */
-- ----------------------------------------------------------------------------------------------------------
-- STEP 25 — INTERVIEW-LEVEL SQL
-- ----------------------------------------------------------------------------------------------------------
-- Find Duplicate Emails
SELECT email,
    COUNT(*)
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;
-- -----------------------------------------------------------------------------------------------------------
-- Delete Duplicate Records Using CTE
WITH duplicate_rows AS
(
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY email
        ORDER BY customer_id
    ) AS rn
                                                  # (not being able to understand)
    FROM customers
)

DELETE FROM customers
WHERE customer_id IN
(
    SELECT customer_id
    FROM duplicate_rows
    WHERE rn > 1
);
-- ---------------------------------------------------------------------------------------------------------------
