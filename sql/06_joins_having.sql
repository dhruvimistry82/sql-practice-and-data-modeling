/* 06 - JOINs with GROUP BY / HAVING
   AdventureWorks.
   Engine: SQL Server (T-SQL). */

/*1)Retrieve the count of orders placed by each customer, but only include customers with more than 5 orders.*/

SELECT COUNT(s.SalesOrderID) AS total_orders,
	c.CustomerID
FROM Sales.SalesOrderHeader s
JOIN Sales.Customer c
on s.customerID =c.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(s.SalesOrderID)>5

--2.Find the average order quantity for each product, but only include products with an average order quantity greater than 10.
SELECT 
	AVG(o.OrderQty) AS avg_orders,
	p.ProductID,
	p.Name
FROM Sales.SalesOrderDetail o
JOIN Production.Product p
ON p.ProductID= o.ProductID
GROUP BY p.ProductID, p.Name
HAVING AVG(o.OrderQty)>10
--3)Calculate the total sales amount for each product category,
--but only include categories with a total sales amount greater than $100,000.
SELECT SUM(s.UnitPrice*s.OrderQty) AS total_sales,
 s.ProductID,
 p.ProductSubcategoryID,p.Name
FROM Sales.SalesOrderDetail s
JOIN Production.Product p
ON s.ProductID= p.ProductID
group by s.ProductID,p.ProductSubcategoryID,p.Name
HAVING SUM(s.UnitPrice*s.OrderQty)>100000


/*4)Retrieve the maximum list price for each product subcategory, but only include subcategories with a
maximum list price greater than $500.*/
SELECT MAX(p.ListPrice) AS PRICE,
	s.Name AS subcategoryname
FROM Production.Product p
join Production.ProductSubcategory s
ON p.ProductSubcategoryID=s.ProductSubcategoryID
group by s.Name
HAVING MAX(p.ListPrice)>500

--5)Find the minimum order date for each customer, but only include customers who have placed an order before January 1, 2023.
SELECT MIN(O.OrderDate) AS minimum_orddate,
	o.CustomerID
FROM  Sales.SalesOrderDetail c
JOIN Sales.SalesOrderHeader o
ON O.SalesOrderID= C.SalesOrderID
GROUP BY O.CustomerID
HAVING MIN(o.OrderDate)< '2023-01-01'

--6)Calculate the average unit price for each product color, but only include colors with an average unit price greater than $50.
SELECT AVG(p.ListPrice),p.Color
FROM production.product p
GROUP BY p.Color
HAVING AVG(p.ListPrice)>50

SELECT COALESCE('Text', NULL, 10);


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Q3 asks for totals per product CATEGORY; the answer grouped per product.
SELECT pc.Name AS category, SUM(sod.LineTotal) AS total_sales
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p             ON p.ProductID = sod.ProductID
JOIN Production.ProductSubcategory ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory pc    ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.Name
HAVING SUM(sod.LineTotal) > 100000;

-- Q5: the order date lives on the header; joining the detail lines is unnecessary work.
SELECT CustomerID, MIN(OrderDate) AS first_order_date
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING MIN(OrderDate) < '2023-01-01';

-- Q6: if "unit price" means the price actually sold at, it lives in SalesOrderDetail (Product only has ListPrice).
-- Products without a color also form their own NULL group; label it.
SELECT ISNULL(p.Color, 'No color') AS color, AVG(sod.UnitPrice) AS avg_unit_price
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON p.ProductID = sod.ProductID
GROUP BY ISNULL(p.Color, 'No color')
HAVING AVG(sod.UnitPrice) > 50;
