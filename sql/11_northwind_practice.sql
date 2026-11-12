/* 11 - Northwind practice set
   About 55 progressive problems on the Northwind sample database (filtering, joins, CTEs, CASE, outer joins).
   Engine: SQL Server (T-SQL). */

--1return all fields from shipper
SELECT * 
FROM shippers

--2 certain fields from categories
SELECT categoryName,description 
FROM categories

--sales representatives

SELECT 
	firstname,
	lastname,
	hiredate
FROM employees
where title ='sales representative'

-- 4 sales representative in USA

SELECT 
	firstname,
	lastname,
	hiredate
FROM employees
WHERE title='sales representative' AND country ='USA'

--5 orders by specific employee id

SELECT 
	orderID,
	orderdate
FROM orders
where EmployeeID = 5

--6 supplier and contactTitle

SELECT 
	SupplierID,
	ContactName,
	ContactTitle
FROM Suppliers 
WHERE ContactTitle != 'marketing manager'

--7 products with 'queso' in productname

SELECT 
	ProductID,
	ProductName
FROM Products
WHERE ProductName LIKE '%queso%'

--8 orders shipping france or belgium

SELECT
	OrderID,
	CustomerID,
	ShipCountry
FROM Orders
WHERE ShipCountry IN('france','belgium')

--9 order shipping to any country in latin america

SELECT
	OrderID,
	CustomerID,
	ShipCountry
FROM Orders
WHERE ShipCountry IN ('brazil','mexico','argentina','venezuela')

--10 employees in order of age

SELECT 
	FirstName,
	LastName,
	BirthDate
FROM Employees
ORDER BY BirthDate ASC

--11 showing only date with date time field

SELECT
	FirstName,
	LastName,
	Title,
	CONVERT(date,BirthDate) AS birthdate
FROM Employees

--12 employees full name

SELECT
	FirstName,
	LastName,
	CONCAT(firstname,' ',LastName)
FROM Employees

--13orderdetails amount per item

SELECT
	OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	unitprice*quantity As total_amount
FROM [Order Details]

--14how many customers

SELECT count(*)
FROM Customers

--15first order ever mad

SELECT
	MIN(OrderDate)
FROM Orders

--16 countries where there are customers

SELECT 
	Country
FROM Customers
GROUP BY Country

--17 Contacttitle from customers

SELECT
	COUNT(*) AS total_contacttitles,
	ContactTitle
FROM Customers
GROUP BY ContactTitle

--18product with associated supplier names

SELECT 
	p.ProductID,
	p.ProductName,
	s.CompanyName
FROM Products p
JOIN Suppliers s
ON p.SupplierID= s.SupplierID

--19orders and shippers that were used

SELECT 
	o.OrderID,
	o.OrderDate,
	s.ShipperID,
	s.CompanyName
FROM Orders o
JOIN Shippers s
ON o.ShipVia= s.ShipperID
WHERE o.OrderID < 10270

--20categories,total products in each category

SELECT
	c.CategoryName,

	COUNT(*) AS totalproducts
FROM Products p
JOIN categories c
ON c.categoryID =p.CategoryID
group by c.CategoryName


--21 customer per country and city

SELECT 
    Country,
    City,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY Country, City;

--22 products that need reordering

SELECT 
	ProductID,
	ProductName,
	UnitsInStock,
	ReorderLevel
FROM Products
WHERE UnitsInStock<ReorderLevel

--23products needing reordering part 2

SELECT
	ProductID,
	ProductName,
	UnitsInStock,
	UnitsOnOrder
FROM Products
WHERE UnitsInStock + UnitsOnOrder <=ReorderLevel 
	AND Discontinued =0

--24 customer list by region

SELECT 
	CustomerID,
	CompanyName,
	Region,
CASE 
	when Region is NULL then '0'
	else 1
END
FROM Customers
ORDER BY Region DESC
--25 high freight charges

SELECT TOP 3
	shipcountry,
	AVG(Freight) AS avg_freight
FROM Orders
GROUP BY ShipCountry
ORDER BY avg_freight DESC

--26high freight charges (SOLVE WITH DATE FUNCTION,YEAR)

SELECT TOP 3
	shipcountry,
	AVG(Freight) AS avg_freight
FROM Orders
WHERE OrderDate >= '01-01-2015' AND OrderDate <='01-01-2016'
GROUP BY ShipCountry
ORDER BY avg_freight DESC

--27 TRUY UPPER QUERY WITH BETWEEN

SELECT TOP 3
	shipcountry,
	AVG(Freight) AS avg_freight
FROM Orders
WHERE CONVERT(DATE,OrderDate) BETWEEN '1997-01-01' AND '1998-12-31'
GROUP BY ShipCountry
ORDER BY avg_freight DESC

-- 28. Top 3 countries by average freight for orders in the last year (from 1997-05-06 to 1998-05-06)
-- WRONG ANSWER 
SELECT TOP 3
    ShipCountry,
    AVG(Freight) AS avg_freight
FROM Orders
WHERE OrderDate BETWEEN DATEADD(YEAR, -1, '1998-05-06') AND '1998-05-06'
GROUP BY ShipCountry
ORDER BY avg_freight DESC;

-- 29. employee/order detail report

SELECT 
	e.EmployeeID,
	e.LastName,
	o.OrderID,
	p.ProductName,
	od.Quantity
FROM Employees e
JOIN orders o
ON e.EmployeeID=o.EmployeeID
JOIN [Order Details] od
ON od.OrderID= o.OrderID
JOIN Products p
ON p.ProductID = od.ProductID

--30 customers with no orders

SELECT
	c.CustomerID,
	o.OrderID
FROM Customers C
LEFT JOIN Orders O
ON C.CustomerID=O.CustomerID
WHERE o.OrderID IS NULL

--31customers with no oRder for employee id 4

SELECT 
	o.customerid,
	c.CustomerID
FROM Customers c
 LEFT JOIN Orders o
ON c.CustomerID= o.CustomerID
--AND o.EmployeeID = 4
WHERE  o.OrderID IS null AND o.EmployeeID = 4

--32high value customers

SELECT
	C.CustomerID,
	C.CompanyName,
	O.OrderID,
	SUM(od.UnitPrice*od.Quantity) AS total_amount
FROM Customers C
JOIN Orders o
ON c.CustomerID=o.CustomerID
JOIN [Order Details] od
ON o.OrderID= od.OrderID
WHERE YEAR(o.OrderDate)='1997'
GROUP BY c.CustomerID,c.CompanyName,o.OrderID
HAVING SUM(od.UnitPrice*od.Quantity)>10000
--order by is needed what id amount is greater thn 20k 
--how will you figure it out which one is highest

--33 high value customers

SELECT
	C.CustomerID,
	C.CompanyName,
SUM(od.UnitPrice*od.Quantity) AS total_amount
FROM Customers C
JOIN Orders o
ON c.CustomerID=o.CustomerID
JOIN [Order Details] od
ON o.OrderID= od.OrderID
WHERE year(o.OrderDate)>=2016 AND YEAR(o.OrderDate)<2017
GROUP BY c.CustomerID,c.CompanyName
HAVING SUM(od.UnitPrice*od.Quantity)>=15000
ORDER BY total_amount DESC

--34 high value customers with discount

SELECT 
	c.CustomerID,
	c.CompanyName,
SUM (od.UnitPrice*Quantity)AS totalprice_no_discount,
SUM(od.UnitPrice*od.Quantity*(1-od.Discount))AS totalprice_with_discount
FROM customers c
JOIN orders o
On c.CustomerID= o.CustomerID
join [Order Details] od 
ON o.OrderID= od.OrderID
GROUP BY C.CustomerID,C.CompanyName
HAVING SUM(od.UnitPrice*od.Quantity*(1-od.Discount))>10000
ORDER BY totalprice_With_discount DESC

--35 MONTH_END orders

SELECT
	e.employeeID,
	o.OrderID,
EOMONTH(o.orderdate)
FROM Employees e
JOIN Orders o
ON e.EmployeeID= o.EmployeeID
ORDER BY e.EmployeeID,o.OrderID

--36 order many line items

SELECT top 10
COUNT(*) AS totalorderdetails,
O.OrderID
FROM [Order Details] od
JOIN orders o
ON od.OrderID =o.OrderID
GROUP BY o.orderID
order by totalorderdetails desc

--37orders-random assortment


--random value


--38 orders-accidental double entry

SELECT 
	od.OrderID
FROM Products p
JOIN [Order Details] od
ON p.ProductID= od.ProductID
WHERE quantity >=60
GROUP BY od.orderID,Quantity
HAVING COUNT (*)>1
--ORDER BY od.OrderID

--39 details for those double entry orders

WITH entries AS(
SELECT 
	OD.OrderID,
	od.Quantity
FROM Products p
JOIN [Order Details] od
ON p.ProductID= od.ProductID
WHERE quantity >=60
GROUP BY od.orderID,Quantity
HAVING COUNT (*)>1
)
SELECT od.OrderID,
	od.Discount,
	od.ProductID,
	od.UnitPrice,
	e.*
from entries e
JOIN [Order Details] Od
ON od.OrderID=e.OrderID
ORDER BY od.OrderID

--40 ORDERS- accidental double entry details, derived table

SELECT 
	od.OrderID,
	od.ProductID,
	od.UnitPrice,
	od.Discount,
	od.Quantity
FROM [Order Details] od
JOIN (
		SELECT
			DISTINCT(od.orderID)
		FROM [Order Details] od
		WHERE od.Quantity>=60
		GROUP BY od.OrderID,od.Quantity
		HAVING COUNT(*)>1
		)potentialproblemorders
	ON potentialproblemorders.OrderID=od.OrderID
	ORDER BY od.OrderID, od.ProductID

--41 LATE ORDERS

SELECT 
	RequiredDate,
	ShippedDate,
	OrderID
FROM Orders
WHERE ShippedDate>RequiredDate
ORDER BY OrderID

--42late order by which employees

SELECT
	e.EmployeeID,
	e.LastName,
	COUNT(*) AS lateorders
FROM Orders o
JOIN Employees e
ON  o.EmployeeID= e.EmployeeID
WHERE o.ShippedDate>o.RequiredDate
GROUP BY e.EmployeeID,e.LastName

--43late orders vs total orders
;WITH late_orders AS
(
SELECT
	e.EmployeeID,
	e.LastName,
	COUNT(*) AS lateorders
FROM Orders o
JOIN Employees e
ON  o.EmployeeID= e.EmployeeID
WHERE o.ShippedDate>o.RequiredDate
GROUP BY e.EmployeeID,e.LastName
),
total_orders AS
(
	SELECT 
		e.EmployeeID,
		e.LastName,
		COUNT(*) AS totalorders
	FROM Employees e
	JOIN orders o
	ON e.EmployeeID=o.EmployeeID
	GROUP BY e.EmployeeID,e.LastName

)
SELECT
	   t.EmployeeID,
	   t.LastName,
	   t.totalorders,
	   l.lateorders
FROM total_orders t
JOIN late_orders l
ON t.EmployeeID= l.EmployeeID

-- 43 late orders-missding employee
;WITH late_orders AS
(
SELECT
	e.EmployeeID,
	e.LastName,
	COUNT(*) AS lateorders
FROM Orders o
JOIN Employees e
ON  o.EmployeeID= e.EmployeeID
WHERE o.ShippedDate>o.RequiredDate
GROUP BY e.EmployeeID,e.LastName
),
total_orders AS
(
	SELECT 
		e.EmployeeID,
		e.LastName,
		COUNT(*) AS totalorders
	FROM Employees e
	JOIN orders o
	ON e.EmployeeID=o.EmployeeID
	GROUP BY e.EmployeeID,e.LastName

)
SELECT
	   t.EmployeeID,
	   t.LastName,
	   t.totalorders,
	   l.lateorders
FROM total_orders t
LEFT JOIN late_orders l  
ON t.EmployeeID= l.EmployeeID 
WHERE l.lateorders IS NULL

--LATE ORDERS VS TOTAL ORDERS FIX NULL

;WITH late_orders AS
(
SELECT
	e.EmployeeID,
	e.LastName,
	COUNT(*) AS lateorders
FROM Orders o
JOIN Employees e
ON  o.EmployeeID= e.EmployeeID
WHERE o.ShippedDate>o.RequiredDate
GROUP BY e.EmployeeID,e.LastName
),
total_orders AS
(
	SELECT 
		e.EmployeeID,
		e.LastName,
		COUNT(*) AS totalorders
	FROM Employees e
	JOIN orders o
	ON e.EmployeeID=o.EmployeeID
	GROUP BY e.EmployeeID,e.LastName

)
SELECT
	   t.EmployeeID,
	   t.LastName,
	   t.totalorders,
	   ISNULL(L.lateorders,0)
FROM total_orders t
LEFT JOIN late_orders l  
ON t.EmployeeID= l.EmployeeID 


--46 LATE ORDER VS TOTAL IN PERCENTAGE

;WITH late_orders AS
(
SELECT
	e.EmployeeID,
	e.LastName,
	COUNT(*) AS lateorders
FROM Orders o
JOIN Employees e
ON  o.EmployeeID= e.EmployeeID
WHERE o.ShippedDate>o.RequiredDate
GROUP BY e.EmployeeID,e.LastName
),
total_orders AS
(
	SELECT 
		e.EmployeeID,
		e.LastName,
		COUNT(*) AS totalorders
	FROM Employees e
	JOIN orders o
	ON e.EmployeeID=o.EmployeeID
	GROUP BY e.EmployeeID,e.LastName

)
SELECT
	   t.EmployeeID,
	   t.LastName,
	   t.totalorders,
	  ISNULL(L.lateorders,0)*1.00 AS lateorders_null,
	   ISNULL(L.lateorders,0)*1.00/t.totalorders AS late_order_percentage
FROM total_orders t
LEFT JOIN late_orders l  
ON t.EmployeeID= l.EmployeeID 
--47 late orders vs total order- fix deciMAL

;WITH late_orders AS
(
SELECT
	e.EmployeeID,
	e.LastName,
	COUNT(*) AS lateorders
FROM Orders o
JOIN Employees e
ON  o.EmployeeID= e.EmployeeID
WHERE o.ShippedDate>o.RequiredDate
GROUP BY e.EmployeeID,e.LastName
),
total_orders AS
(
	SELECT 
		e.EmployeeID,
		e.LastName,
		COUNT(*) AS totalorders
	FROM Employees e
	JOIN orders o
	ON e.EmployeeID=o.EmployeeID
	GROUP BY e.EmployeeID,e.LastName

)
SELECT
	   t.EmployeeID,
	   t.LastName,
	   t.totalorders,
	   ISNULL(L.lateorders,0)*1.00 AS lateorders_null,
	  CONVERT( DECIMAL(2,2),(l.lateorders*1.00)/t.totalorders) AS late_order_percentage
FROM total_orders t
LEFT JOIN late_orders l  
ON t.EmployeeID= l.EmployeeID 

--48 CUSTOMER GROUPING

 WITH amounts AS
 (SELECT
	C.CustomerID,
	C.CompanyName,
	
	SUM(od.UnitPrice*od.Quantity) AS total_amount
FROM Customers C
JOIN Orders o
ON c.CustomerID=o.CustomerID
JOIN [Order Details] od
ON o.OrderID= od.OrderID
WHERE YEAR(o.OrderDate)='1997'
GROUP BY c.CustomerID,c.CompanyName
)
SELECT 
	a.CustomerID,
	a.CompanyName,
	a.total_amount,
	
CASE WHEN total_amount  BETWEEN 0 AND 1000
	THEN 'LOW'
	WHEN total_amount  BETWEEN 1000 AND 5000
	THEN 'MEDIUM'
	WHEN total_amount BETWEEN 5000 AND 10000
	THEN'HIGH'
	WHEN total_amount>10000
	THEN'VERY HIGH'
END AS customer_grouping
FROM amounts a
ORDER BY a.CustomerID

--49 customer grouping fix null


 WITH amounts AS
 (SELECT
	C.CustomerID,
	C.CompanyName,
	
	SUM(od.UnitPrice*od.Quantity) AS total_amount
FROM Customers C
JOIN Orders o
ON c.CustomerID=o.CustomerID
JOIN [Order Details] od
ON o.OrderID= od.OrderID
WHERE YEAR(o.OrderDate)='1997'
GROUP BY c.CustomerID,c.CompanyName
)
SELECT 
	a.CustomerID,
	a.CompanyName,
	a.total_amount,
	
CASE WHEN total_amount>=0 AND total_amount<1000
	THEN 'LOW'
	WHEN total_amount>=1000 AND total_amount<5000
	THEN 'MEDIUM'
	WHEN total_amount>=5000 AND total_amount<10000
	THEN'HIGH'
	WHEN total_amount>10000
	THEN'VERY HIGH'
END AS customer_grouping
FROM amounts a
ORDER BY a.CustomerID

--50 customer grouping - percentage

WITH amounts AS (
	SELECT
		C.CustomerID,
		C.CompanyName,
		SUM(od.UnitPrice * od.Quantity) AS total_amount
	FROM Customers C
	JOIN Orders o ON c.CustomerID = o.CustomerID
	JOIN [Order Details] od ON o.OrderID = od.OrderID
	WHERE YEAR(o.OrderDate) = '1997'
	GROUP BY c.CustomerID, c.CompanyName
),
c_grouping AS (
	SELECT 
		a.CustomerID,
		a.CompanyName,
		a.total_amount,
		CASE 
			WHEN total_amount >= 0 AND total_amount < 1000 THEN 'LOW'
			WHEN total_amount >= 1000 AND total_amount < 5000 THEN 'MEDIUM'
			WHEN total_amount >= 5000 AND total_amount < 10000 THEN 'HIGH'
			WHEN total_amount >= 10000 THEN 'VERY HIGH'
		END AS customer_grouping
	FROM amounts a
),
group_counts AS (
	SELECT 
		customer_grouping,
		COUNT(*) AS total_in_group
	FROM c_grouping
	GROUP BY customer_grouping
),
total_customers AS (
	SELECT COUNT(*) AS overall_total FROM c_grouping
)
SELECT 
	gc.customer_grouping,
	gc.total_in_group,
	tc.overall_total,
	CAST(gc.total_in_group * 100.0 / tc.overall_total AS DECIMAL(5,2)) AS percentage_share
FROM group_counts gc
CROSS JOIN total_customers tc;

--52 
SELECT  region FROM CUSTOMERS
	UNION 
SELECT region  FROM Suppliers


--54 countries with suppliers
WITH customer_countries AS (
    SELECT COUNT(*) AS Total_customers, ROW_NUMBER() OVER (ORDER BY country) AS rn,Country
    FROM Customers
	GROUP BY Country
),
supplier_countries AS (
    SELECT  COUNT(*) AS total_suppliers, ROW_NUMBER() OVER (ORDER BY country) AS rn,Country
    FROM Suppliers
	GROUP BY Country
)

SELECT 
    cc.country AS customer_country,
    sc.country AS supplier_country,
	cc.total_customers,
	sc.total_suppliers
FROM customer_countries cc
FULL OUTER JOIN supplier_countries sc
ON cc.rn = sc.rn;

--55 first order in each country
SELECT 
	ShipCountry,
	CustomerID,
	OrderID,
	CONVERT(date,OrderDate) AS orddate
FROM Orders


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- #31 Customers with no orders FOR EMPLOYEE 4: the employee filter must be in the JOIN condition.
-- In WHERE it removes the NULL rows, turning the LEFT JOIN back into an inner join (the commented
-- line in the original was the right idea).
SELECT c.CustomerID
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID AND o.EmployeeID = 4
WHERE o.OrderID IS NULL;

-- #47 DECIMAL(2,2) only holds values below 1 (it overflows at 100% late), and employees with
-- no late orders produce NULL. Use ISNULL and a wider type.
WITH late AS (SELECT EmployeeID, COUNT(*) AS late_orders FROM Orders
              WHERE ShippedDate > RequiredDate GROUP BY EmployeeID),
     total AS (SELECT EmployeeID, COUNT(*) AS total_orders FROM Orders GROUP BY EmployeeID)
SELECT e.EmployeeID, e.LastName, t.total_orders, ISNULL(l.late_orders, 0) AS late_orders,
       CAST(ISNULL(l.late_orders, 0) * 1.0 / t.total_orders AS DECIMAL(5, 2)) AS late_pct
FROM total t
JOIN Employees e ON e.EmployeeID = t.EmployeeID
LEFT JOIN late l ON l.EmployeeID = t.EmployeeID;

-- #49: "> 10000" leaves customers with exactly 10000 ungrouped; #50 already fixes it with >= 10000.

-- #54 matched customer and supplier countries by ROW_NUMBER, so unrelated countries lined up.
-- Join on the country itself.
WITH cc AS (SELECT Country, COUNT(*) AS total_customers FROM Customers GROUP BY Country),
     sc AS (SELECT Country, COUNT(*) AS total_suppliers FROM Suppliers GROUP BY Country)
SELECT COALESCE(cc.Country, sc.Country) AS country,
       ISNULL(cc.total_customers, 0) AS total_customers,
       ISNULL(sc.total_suppliers, 0) AS total_suppliers
FROM cc
FULL OUTER JOIN sc ON sc.Country = cc.Country
ORDER BY country;
