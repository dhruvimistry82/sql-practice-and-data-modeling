/* Practice tables for sql/05_aggregates_group_by.sql and sql/07_subqueries.sql (fictional data). */

CREATE TABLE Salesman (
    salesman_id INT PRIMARY KEY,
    name        VARCHAR(50),
    city        VARCHAR(50),
    commission  DECIMAL(4, 2)
);
INSERT INTO Salesman VALUES
    (5001, 'Lena Brooks', 'New York', 0.15),
    (5002, 'Omar Haddad', 'Paris', 0.13),
    (5003, 'Ivy Chen', 'San Jose', 0.12),
    (5005, 'Rafael Ortiz', 'London', 0.11),
    (5006, 'Mia Laurent', 'Paris', 0.14),
    (5007, 'Paul Adam', 'Rome', 0.13);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    cust_name   VARCHAR(50),
    city        VARCHAR(50),
    grade       INT NULL,
    salesman_id INT REFERENCES Salesman(salesman_id)
);
INSERT INTO Customer VALUES
    (3001, 'Nora Field', 'London', NULL, 5005),
    (3002, 'Arjun Mehta', 'New York', 100, 5001),
    (3003, 'Sofia Rossi', 'Moscow', 200, 5007),
    (3004, 'Luc Martin', 'Paris', 300, 5006),
    (3005, 'Grace Kim', 'California', 200, 5002),
    (3007, 'Ben Carter', 'New York', 200, 5001),
    (3008, 'Hana Sato', 'London', 300, 5002),
    (3009, 'Felix Wagner', 'Berlin', 100, 5003);

CREATE TABLE Orders (
    ord_no      INT PRIMARY KEY,
    purch_amt   DECIMAL(10, 2),
    ord_date    DATE,
    customer_id INT REFERENCES Customer(customer_id),
    salesman_id INT REFERENCES Salesman(salesman_id)
);
INSERT INTO Orders VALUES
    (70001, 150.50, '2012-10-05', 3005, 5002),
    (70002, 65.26, '2012-10-05', 3002, 5001),
    (70003, 2480.40, '2012-10-10', 3009, 5003),
    (70004, 110.50, '2012-08-17', 3009, 5003),
    (70005, 2400.60, '2012-07-27', 3007, 5001),
    (70007, 948.50, '2012-09-10', 3005, 5002),
    (70008, 5760.00, '2012-09-10', 3002, 5001),
    (70009, 270.65, '2012-09-10', 3001, 5005),
    (70010, 1983.43, '2012-10-10', 3004, 5006),
    (70011, 75.29, '2012-08-17', 3003, 5007),
    (70012, 250.45, '2012-06-27', 3008, 5002),
    (70013, 3045.60, '2012-04-25', 3002, 5001);
