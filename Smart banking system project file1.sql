-- STEP 1 — DATABASE DESIGN
-- CREATE DATABASE
create database smart_banking_system;
use smart_banking_system;
-- ---------------------------------------------------------------
-- CREATE TABLES
 # BRANCHES TABLE
 CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    state VARCHAR(50)
);
-- --------------------------------------------
# CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ----------------------------------------------------
# ACCOUNTS TABLE
-- Concepts:
-- Foreign Key
-- CHECK constraint
-- DEFAULT

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    branch_id INT REFERENCES branches(branch_id),

    account_type VARCHAR(20)
    CHECK(account_type IN ('Savings', 'Current')),

    balance DECIMAL(15,2) DEFAULT 0,

    account_status VARCHAR(20)
    DEFAULT 'Active',

    opened_date DATE DEFAULT (CURDATE())
);
-- ----------------------------------------------------------------
-- TRANSACTION TYPES table
CREATE TABLE transaction_types (
    transaction_type_id SERIAL PRIMARY KEY,
    transaction_name VARCHAR(50)
);
-- -------------------------------------------------------------------
-- TRANSACTIONS TABLE
-- This is the MOST IMPORTANT TABLE.
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,

    account_id INT
    REFERENCES accounts(account_id),

    transaction_type_id INT
    REFERENCES transaction_types(transaction_type_id),

    amount DECIMAL(12,2) NOT NULL,

    transaction_date TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP,

    remarks VARCHAR(255)
);
-- ----------------------------------------------------------------
-- STEP 4 — INSERT SAMPLE DATA
-- Insert Branches
INSERT INTO branches(branch_name, city, state)
VALUES
('Mumbai Main Branch', 'Mumbai', 'Maharashtra'),
('Delhi Central Branch', 'Delhi', 'Delhi'),
('Bangalore Tech Branch', 'Bangalore', 'Karnataka'),
('Kolkata Main Branch', 'Kolkata', 'West Bengal');
-- ----------------------------------------------------------------
-- Insert Customers
INSERT INTO customers
(first_name, last_name, gender, date_of_birth, phone, email, city)
VALUES
('Rahul', 'Sharma', 'Male', '1998-05-10',
'9876543210', 'rahul@gmail.com', 'Mumbai'),

('Priya', 'Patel', 'Female', '1995-08-20',
'9876543211', 'priya@gmail.com', 'Ahmedabad'),

('Amit', 'Verma', 'Male', '2000-01-15',
'9876543212', 'amit@gmail.com', 'Delhi'),

('Anuja', 'Dey', 'Female', '2000-01-11',
'816930  6837', 'anuja@gmail.com', 'West Bengal');
-- -------------------------------------------------------------------
-- Insert Accounts
INSERT INTO accounts
(customer_id, branch_id, account_type, balance)
VALUES
(1, 1, 'Savings', 50000),

(2, 2, 'Current', 120000),

(3, 3, 'Savings', 75000),

(4, 4, 'Current', 150000);
-- ------------------------------------------------------------------
-- Insert Transaction Types
INSERT INTO transaction_types(transaction_name)
VALUES
('Deposit'),
('Withdrawal'),
('Transfer'),
('Deposit');
-- -----------------------------------------------------------------
-- Insert Transactions
INSERT INTO transactions
(account_id, transaction_type_id, amount, remarks)
VALUES
(1, 1, 10000, 'Salary Deposit'),

(1, 2, 2000, 'ATM Withdrawal'),

(2, 1, 50000, 'Business Deposit'),

(3, 3, 10000, 'Transferred to Friend'),

(3, 4, 5000, 'ATM Withdrawal');
-- ---------------------------------------------------------------------------
