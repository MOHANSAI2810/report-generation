CREATE DATABASE ProjectUFFT;
USE ProjectUFFT;


-- Families Table
CREATE TABLE Families (
    family_id INT AUTO_INCREMENT PRIMARY KEY,
    family_name VARCHAR(255) NOT NULL
);

-- Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    bank_acc_no INT NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mobile_no VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    family_id INT,
    FOREIGN KEY (family_id) REFERENCES Families(family_id)
);


-- Expenses Table
CREATE TABLE Expenses (
    expense_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount FLOAT NOT NULL,
    category_id INT,
    date DATETIME NOT NULL,
    description TEXT,
    family_id INT,
    receipt LONGBLOB,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (family_id) REFERENCES Families(family_id)
);


-- Budgets Table
CREATE TABLE Budgets (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    amount FLOAT NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    recurring BOOLEAN NOT NULL,
    threshold_value FLOAT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- SavingGoals Table
CREATE TABLE SavingGoals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    family_id INT,
    user_id INT,
    user_goal FLOAT NOT NULL,
    family_goal FLOAT NOT NULL,
    target_amount FLOAT NOT NULL,
    current_amount FLOAT NOT NULL,
    deadline DATETIME NOT NULL,
    FOREIGN KEY (family_id) REFERENCES Families(family_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Alerts Table
CREATE TABLE Alerts (
    alert_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT NOT NULL,
    budget_id INT,
    created_at DATETIME NOT NULL,
    read_message BOOLEAN NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (budget_id) REFERENCES Budgets(budget_id)
);

-- Reports Table
CREATE TABLE Reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    generated_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Sample Data

-- Insert data into Families
INSERT INTO Families (family_name) VALUES ('Smith Family'), ('Johnson Family');

-- Insert data into Users
INSERT INTO Users (username, name, bank_acc_no, email, mobile_no, password, role, family_id) 
VALUES ('jsmith', 'John Smith', 123456, 'john.smith@example.com', '1234567890', 'password123', 'Admin', 1),
       ('ajohnson', 'Alice Johnson', 789012, 'alice.johnson@example.com', '0987654321', 'password456', 'User', 2);

-- Insert data into Categories
INSERT INTO Categories (name) VALUES ('Groceries'), ('Utilities');

-- Insert data into Expenses
INSERT INTO Expenses (user_id, amount, category_id, date, description, family_id) 
VALUES (1, 50.75, 1, '2024-12-15 10:30:00', 'Grocery shopping', 1),
       (2, 100.50, 2, '2024-12-14 15:00:00', 'Electricity bill', 2),
       (3, 30.00, 3, '2024-12-16 17:45:00', 'Movie night', 3),
       (4, 20.00, 4, '2024-12-18 09:00:00', 'Bus fare', 4),
       (5, 75.00, 5, '2024-12-19 11:30:00', 'Doctor appointment', 5),
       (1, 25.50, 1, '2024-12-20 13:15:00', 'Grocery shopping', 1),
       (2, 40.00, 4, '2024-12-22 16:00:00', 'Taxi fare', 2),
       (3, 15.00, 3, '2024-12-23 14:00:00', 'Concert tickets', 3),
       (4, 50.00, 6, '2024-12-24 18:00:00', 'Dinner at restaurant', 4),
       (5, 30.00, 6, '2024-12-25 19:00:00', 'Lunch outing', 5),
       (6, 100.00, 2, '2024-12-26 12:00:00', 'Internet bill', 6),
       (6, 150.00, 1, '2024-12-27 10:00:00', 'Grocery shopping', 6);


-- Insert data into Budgets
INSERT INTO Budgets (category_id, amount, start_date, end_date, recurring, threshold_value) 
VALUES (1, 500.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', TRUE, 450.00),
       (2, 300.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', FALSE, 250.00);

-- Insert data into SavingGoals
INSERT INTO SavingGoals (family_id, user_id, user_goal, family_goal, target_amount, current_amount, deadline) 
VALUES (1, 1, 1000.00, 5000.00, 10000.00, 2000.00, '2025-12-31 23:59:59'),
       (2, 2, 2000.00, 7000.00, 15000.00, 3000.00, '2025-06-30 23:59:59');

-- Insert data into Alerts
INSERT INTO Alerts (user_id, message, budget_id, created_at, read_message) 
VALUES (1, 'Budget threshold reached for Groceries', 1, '2024-12-10 09:00:00', FALSE),
       (2, 'New budget created for Utilities', 2, '2024-12-12 14:00:00', TRUE);

-- Insert data into Reports
INSERT INTO Reports (user_id, content, generated_at) 
VALUES (1, 'Monthly expense report for John Smith.', '2024-12-01 12:00:00'),
       (2, 'Quarterly financial summary for Alice Johnson.', '2024-12-01 12:30:00');-- Insert data into Families
INSERT INTO Families (family_name) 
VALUES ('Smith Family'), 
       ('Johnson Family'),
       ('Taylor Family'),
       ('Brown Family'),
       ('Miller Family');

-- Insert data into Users
INSERT INTO Users (username, name, bank_acc_no, email, mobile_no, password, role, family_id) 
VALUES ('jsmith', 'John Smith', 123456, 'john.smith@example.com', '1234567890', 'password123', 'Admin', 1),
       ('ajohnson', 'Alice Johnson', 789012, 'alice.johnson@example.com', '0987654321', 'password456', 'User', 2),
       ('mtaylor', 'Michael Taylor', 345678, 'michael.taylor@example.com', '1122334455', 'password789', 'Admin', 3),
       ('bbrown', 'Brenda Brown', 901234, 'brenda.brown@example.com', '2233445566', 'password101', 'User', 4),
       ('cmiller', 'Charles Miller', 567890, 'charles.miller@example.com', '3344556677', 'password102', 'User', 5);

-- Insert data into Categories
INSERT INTO Categories (name) 
VALUES ('Groceries'), 
       ('Utilities'),
       ('Entertainment'),
       ('Transportation'),
       ('Healthcare');

-- Insert data into Expenses
INSERT INTO Expenses (user_id, amount, category_id, date, description, family_id) 
VALUES (1, 50.75, 1, '2024-12-15 10:30:00', 'Grocery shopping', 1),
       (2, 100.50, 2, '2024-12-14 15:00:00', 'Electricity bill', 2),
       (3, 30.00, 3, '2024-12-16 17:45:00', 'Movie night', 3),
       (4, 20.00, 4, '2024-12-18 09:00:00', 'Bus fare', 4),
       (5, 75.00, 5, '2024-12-19 11:30:00', 'Doctor appointment', 5),
       (1, 25.50, 1, '2024-12-20 13:15:00', 'Grocery shopping', 1),
       (2, 40.00, 4, '2024-12-22 16:00:00', 'Taxi fare', 2),
       (3, 15.00, 3, '2024-12-23 14:00:00', 'Concert tickets', 3);

-- Insert data into Budgets
INSERT INTO Budgets (category_id, amount, start_date, end_date, recurring, threshold_value) 
VALUES (1, 500.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', TRUE, 450.00),
       (2, 300.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', FALSE, 250.00),
       (3, 150.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', TRUE, 120.00),
       (4, 200.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', FALSE, 180.00),
       (5, 100.00, '2024-12-01 00:00:00', '2024-12-31 23:59:59', TRUE, 90.00);

-- Insert data into SavingGoals
INSERT INTO SavingGoals (family_id, user_id, user_goal, family_goal, target_amount, current_amount, deadline) 
VALUES (1, 1, 1000.00, 5000.00, 10000.00, 2000.00, '2025-12-31 23:59:59'),
       (2, 2, 2000.00, 7000.00, 15000.00, 3000.00, '2025-06-30 23:59:59'),
       (3, 3, 1500.00, 8000.00, 12000.00, 3500.00, '2026-03-31 23:59:59'),
       (4, 4, 500.00, 4000.00, 8000.00, 1000.00, '2025-08-31 23:59:59'),
       (5, 5, 800.00, 6000.00, 10000.00, 1500.00, '2025-12-01 23:59:59');

-- Insert data into Alerts
INSERT INTO Alerts (user_id, message, budget_id, created_at, read_message) 
VALUES (1, 'Budget threshold reached for Groceries', 1, '2024-12-10 09:00:00', FALSE),
       (2, 'New budget created for Utilities', 2, '2024-12-12 14:00:00', TRUE),
       (3, 'Budget for Entertainment updated', 3, '2024-12-15 16:30:00', FALSE),
       (4, 'Transportation budget exceeded', 4, '2024-12-20 18:15:00', TRUE),
       (5, 'Healthcare budget adjusted', 5, '2024-12-22 11:00:00', FALSE);

-- Insert data into Reports
INSERT INTO Reports (user_id, content, generated_at) 
VALUES (1, 'Monthly expense report for John Smith.', '2024-12-01 12:00:00'),
       (2, 'Quarterly financial summary for Alice Johnson.', '2024-12-01 12:30:00'),
       (3, 'Monthly expense report for Michael Taylor.', '2024-12-02 08:00:00'),
       (4, 'Quarterly financial summary for Brenda Brown.', '2024-12-02 08:30:00'),
       (5, 'Annual expense report for Charles Miller.', '2024-12-03 10:00:00');
