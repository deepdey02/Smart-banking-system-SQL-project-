-- PHASE 2
use smart_banking_system;
-- --------------------------------------------------------------------
-- STEP 13 — CREATE DEPARTMENTS TABLE
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);
-- -----------------------------------------------------------------
-- INSERT DEPARTMENTS
INSERT INTO departments(department_name)
VALUES
('HR'),
('Finance'),
('Operations'),
('IT');
SELECT * FROM DEPARTMENTS;
-- ------------------------------------------------------------------
-- STEP 14 — CREATE EMPLOYEES TABLE
/* Concepts:
Foreign Keys
Self Join preparation
Salary analytics */

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,

    first_name VARCHAR(50),
    last_name VARCHAR(50),

    department_id INT
    REFERENCES departments(department_id),

    manager_id INT,

    salary DECIMAL(12,2),

    hire_date DATE,

    city VARCHAR(50)
);
-- ----------------------------------------------------------------
-- INSERT EMPLOYEES
INSERT INTO employees
(first_name, last_name, department_id,
manager_id, salary, hire_date, city)

VALUES
('Amit', 'Shah', 1, NULL, 90000, '2020-01-15', 'Mumbai'),

('Neha', 'Patel', 2, 1, 75000, '2021-03-10', 'Delhi'),

('Rohit', 'Verma', 3, 1, 60000, '2022-07-20', 'Pune'),

('Sneha', 'Iyer', 4, 2, 85000, '2019-11-11', 'Bangalore');

select * from employees;
-- --------------------------------------------------------------------
-- STEP 15 — CREATE LOANS TABLE
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,

    customer_id INT
    REFERENCES customers(customer_id),

    loan_type VARCHAR(50),

    loan_amount DECIMAL(15,2),

    interest_rate DECIMAL(5,2),

    loan_status VARCHAR(20),

    issue_date DATE
);
-- ----------------------------------------------------------------------
-- INSERT LOANS
INSERT INTO loans
(customer_id, loan_type,
loan_amount, interest_rate,
loan_status, issue_date)

VALUES
(1, 'Home Loan', 2500000, 8.5, 'Active', '2023-01-01'),

(2, 'Car Loan', 800000, 9.2, 'Active', '2024-05-10'),

(3, 'Personal Loan', 300000, 12.5, 'Closed', '2022-09-15');
select * from loans;
-- ----------------------------------------------------------------------------
-- STEP 16 — CREATE LOAN PAYMENTS TABLE
CREATE TABLE loan_payments (
    payment_id SERIAL PRIMARY KEY,

    loan_id INT
    REFERENCES loans(loan_id),

    payment_amount DECIMAL(12,2),

    payment_date DATE
);
-- -------------------------------------------------------------------------------
-- INSERT LOAN PAYMENTS
INSERT INTO loan_payments
(loan_id, payment_amount, payment_date)

VALUES
(1, 50000, '2025-01-10'),

(1, 50000, '2025-02-10'),

(2, 25000, '2025-01-15'),

(3, 300000, '2023-05-01');
select * from loan_payments;
-- ------------------------------------------------------------------------------------
