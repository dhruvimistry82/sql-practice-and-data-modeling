/* 10 - Interview-style problems
   Short whiteboard questions from class, plus a customers/orders exercise.
   Engine: SQL Server (T-SQL). */

/*Show how many products are in each category.Products(categoryid, productid,productname)*/SELECT categoryid,COUNT(productid),productnameFROM productsGROUP BY categoryid,productname/*write a query to find duplicate email address in customer tablecustomer(customerid, custname,email,address)*/SELECT customeremailFROM customer HAVING COUNT(*)>1/*Select all products that never have been ordered.Products (Productid,productname, category, Stock)Order details(productid,id, orderid,amount) 2 ways of solving  1: using subquery,join as well*/SELECT ProductidFROM Products pJOIN orders oON  p.productid =o.orderidWHERE productid is null/*Metadata: EmployeeProjectsEmployeeProjects (EmpId, ProjectId, Role)Question: Identify employees assigned to multiple projects.*/SELECT EmpIDfrom Employeegroup by empIDHaving COUNT(distinct(projectid)>1;

/* Customers and orders (class exercise) */
--DROP TABLE customer
CREATE TABLE customer (
    CID INT IDENTITY(1,1)
        CONSTRAINT PK_Customer_Cid PRIMARY KEY, -- Primary Key (Green in your image)
    Cname VARCHAR(100) NOT NULL -- Customer Name
);
GO
 
-- 2. Create Order Table
-- Oid: Primary Key
-- Oamount: Order Amount
-- Ocity: Order City
-- Odate: Order Date
-- Cid: Foreign Key referencing Customer.Cid
--DROP TABLE orderTable
CREATE TABLE orderTable ( -- Enclosed in brackets because 'Order' is a reserved keyword
    OID INT IDENTITY(101,1)
        CONSTRAINT PK_Order_Oid PRIMARY KEY, -- Primary Key (Green in your image)
    Oamount DECIMAL(10, 2) NOT NULL,
    Ocity VARCHAR(50) NOT NULL,
    Odate DATE NOT NULL,
    CID INT NOT NULL, -- Foreign Key (Orange in your image)
 
    CONSTRAINT FK_Order_Cid_Customer FOREIGN KEY (CID)
        REFERENCES Customer(CID)
        ON DELETE NO ACTION -- Or CASCADE, SET NULL depending on business rules. NO ACTION is a safe default.
        ON UPDATE NO ACTION  -- Or CASCADE. NO ACTION is a safe default.
);
GO
 
--
INSERT INTO Customer (Cname) VALUES
('A'),
('B'),
('C'),
('D');
 
GO
--
--TRUNCATE TABLE orderTable
INSERT INTO orderTable(Oamount, Ocity, Odate, CID) VALUES
(100, 'NY', '2024-05-01', 1), -- Odate changed from '1-May' to '2024-05-01'
(100, 'NY', '2024-05-06', 1), -- Odate changed from '6-May' to '2024-05-06'
(50, 'CA', '2024-04-05', 2),  -- Odate changed from '5-Apr' to '2024-04-05'
(75, 'CA', '2024-05-31', 2), -- Odate changed from '31-May' to '2024-05-31'
(50, 'CA', '2024-03-07', 4),
(120, 'NY', '2024-06-10', 1),   -- Customer 1, new city, new date
(250, 'CA', '2024-06-15', 2),   -- Customer 2, new city, new date
(80, 'NY', '2024-07-01', 3),    -- Customer 3, NY city, new date
(150, 'CA', '2024-07-20', 3),   -- Customer 3, CA city, new date
(200, 'NY', '2024-08-05', 4),   -- Customer 4, TX city, new date
(350, 'NY', '2024-08-10', 1),   -- Customer 1, NY city, new date (potentially for having SUM(Oamount) > 300 for C1)
(10, 'CA', '2024-09-01', 2),    -- Customer 2, FL city, new date
(180, 'NY', '2024-09-05', 4);
 
GO
--
 
 
SELECT o.CID, c.Cname, SUM(o.Oamount) as Total_Amount, o.Ocity
FROM orderTable o
INNER JOIN customer c ON o.CID = c.CID
WHERE o.Ocity = 'NY' 
	AND o.Odate >= '2024-05-01' and o.Odate <= '2024-05-31'
GROUP BY o.CID, c.Cname, o.Ocity
HAVING SUM(o.Oamount) > 50
ORDER BY o.CID;

/* ALL / ANY with subqueries */
Where OrganizationLevel =( Select MAX(organizationlevel) from HumanResources.Employee)

Where OrganizationLevel > ALL ( Select OrganizationLEvel from HumanResources.Employee
	WHere OrganizationLevel in (1,2))


Where OrganizationLevel > ANY ( Select OrganizationLEvel from HumanResources.Employee
	WHere OrganizationLevel in (1,2))

Where OrganizationLevel > ANY (SELECT 1,2)--not work

/* AdventureWorks warm-ups */
SELECT TOP (1000) [BusinessEntityID]
      ,[NationalIDNumber]
      ,[LoginID]
      ,[OrganizationNode]
      ,[OrganizationLevel]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2016].[HumanResources].[Employee]
  --TOTAL NOP. OF EMPLOYEES PER JOB TITLE
  SELECT COUNT(*),JobTitle
  FROM HumanResources.Employee
  GROUP BY JobTitle

  --SHOW EACH PRODUCT AND NO.OF TIMES IYS ORDERED, PRODUCTION.PRODUCTION,SALES.SALESORDERDETAIL

   --SHOW EACH PRODUCT AND NO.OF TIMES IYS ORDERED, PRODUCTION.PRODUCTION,SALES.SALESORDERDETAIL
  SELECT COUNT(o.OrderQty) AS times_ordered,
  p.Name,p.ProductID
  FROM Production.Product p
  RIGHT JOIN Sales.SalesOrderDetail o
  ON o.ProductID = p.ProductID
  GROUP BY p.Name,p.ProductID
  --find customers who have not ordered 

  SELECT 
  c.*

  FROM Sales.SalesOrderHeader o
    RIGHT JOIN Sales.Customer c
on o.CustomerID = c.CustomerID
    WHERE o.SalesOrderID is null


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- The four whiteboard answers at the top of this file all had problems. Corrected:

-- a) Products per category: grouping by productname as well counted 1 per product.
SELECT categoryid, COUNT(productid) AS products
FROM Products
GROUP BY categoryid;

-- b) Duplicate emails: HAVING needs a GROUP BY on the email column.
SELECT email, COUNT(*) AS occurrences
FROM customer
GROUP BY email
HAVING COUNT(*) > 1;

-- c) Products never ordered: the inner join on productid = orderid can never produce NULLs.
SELECT p.productid, p.productname                  -- 1: LEFT JOIN + IS NULL
FROM Products p
LEFT JOIN OrderDetails od ON od.productid = p.productid
WHERE od.productid IS NULL;

SELECT p.productid, p.productname                  -- 2: NOT EXISTS (safe with NULLs, unlike NOT IN)
FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM OrderDetails od WHERE od.productid = p.productid);

-- d) Employees on multiple projects: query EmployeeProjects (not Employee); parentheses were unbalanced.
SELECT EmpId
FROM EmployeeProjects
GROUP BY EmpId
HAVING COUNT(DISTINCT ProjectId) > 1;

-- ALL / ANY: "> ANY (SELECT 1, 2)" fails because a subquery for ANY must return ONE column.
SELECT * FROM HumanResources.Employee
WHERE OrganizationLevel > ANY (SELECT v FROM (VALUES (1), (2)) AS t(v));
