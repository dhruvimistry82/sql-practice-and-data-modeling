/* Case 1: retail sales orders in 3NF (SQL Server). Fictional sample data. */

CREATE TABLE Customer (
    customer_no INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    street      VARCHAR(100),
    city        VARCHAR(50),
    state       CHAR(2),
    zip         CHAR(5)
);

CREATE TABLE Clerk (
    clerk_no   INT PRIMARY KEY,
    clerk_name VARCHAR(100) NOT NULL
);

CREATE TABLE Item (
    item_id     INT PRIMARY KEY,
    description VARCHAR(200) NOT NULL,
    unit_price  DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE SalesOrder (
    order_no    INT PRIMARY KEY,
    order_date  DATE NOT NULL,
    customer_no INT NOT NULL REFERENCES Customer(customer_no),
    clerk_no    INT NOT NULL REFERENCES Clerk(clerk_no)
);

CREATE TABLE SalesOrderLine (
    order_no           INT NOT NULL REFERENCES SalesOrder(order_no),
    item_id            INT NOT NULL REFERENCES Item(item_id),
    quantity           INT NOT NULL CHECK (quantity > 0),
    unit_price_at_sale DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_no, item_id)
);

INSERT INTO Customer VALUES (1, 'Ava Patel', '12 Elm St', 'Tempe', 'AZ', '85281'),
                            (2, 'Sam Ruiz', '7 Oak Ave', 'Mesa', 'AZ', '85201');
INSERT INTO Clerk VALUES (1001, 'Leo Grant'), (1002, 'Mia Chen');
INSERT INTO Item VALUES (10, 'Oats', 4.50), (11, 'Milk', 3.20);
INSERT INTO SalesOrder VALUES (101, '2025-09-05', 1, 1001), (102, '2025-09-06', 2, 1002);
INSERT INTO SalesOrderLine VALUES (101, 10, 2, 4.50), (101, 11, 1, 3.20), (102, 10, 3, 4.50);

-- Total sales is derived, not stored:
SELECT o.order_no, c.name, SUM(l.quantity * l.unit_price_at_sale) AS total_sales
FROM SalesOrder o
JOIN Customer c       ON c.customer_no = o.customer_no
JOIN SalesOrderLine l ON l.order_no = o.order_no
GROUP BY o.order_no, c.name;
