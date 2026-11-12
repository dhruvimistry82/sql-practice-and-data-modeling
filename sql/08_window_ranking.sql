/* 08 - Window functions: ranking
   AdventureWorks Sales.SalesOrderHeader.
   Engine: SQL Server (T-SQL). */

/*
use adventure works sales.salesorderheader

Rank the top 10 sales orders based on the highest Subtotal amount.
.*/

SELECT SalesOrderID, SubTotal, SalesRank
FROM (
    SELECT 
        SalesOrderID,
        SubTotal,
        DENSE_RANK() OVER (ORDER BY SubTotal DESC) AS SalesRank
    FROM Sales.SalesOrderHeader
) AS RankedSales
WHERE SalesRank <= 10;

/*Rank all sales orders for each CustomerID based on the OrderDate, starting with the most recent order.*/
SELECT 
	CustomerID,
	OrderDate,
	DENSE_RANK() OVER(PARTITION BY customerID ORDER BY orderdate DESC) AS ranked_orders
FROM Sales.SalesOrderHeader
/*
Rank sales orders based on the TaxAmt for each TerritoryID, starting with the highest tax amount.*/
SELECT
     SalesOrderID,
     TerritoryID,
     DENSE_RANK()OVER (PARTITION BY territoryID ORDER BY taxamt desc) AS taxrank
FROM Sales.SalesOrderHeader
/*Rank the sales orders by Freight within each ShipMethodID, starting with the lowest freight cost.*/
SELECT 
	SalesOrderID,
	ShipMethodID,
	Freight,
	DENSE_RANK()OVER(PARTITION BY shipmethodID ORDER BY freight ASC) AS freightrank
FROM Sales.SalesOrderHeader

/*
For each year, rank the sales orders by the TotalDue amount, starting with the highest total due*/
SELECT
	PurchaseOrderNumber,
	YEAR(OrderDate) AS orderyear,
	totaldue,
	DENSE_RANK() OVER (PARTITION BY YEAR(orderdate) ORDER BY  totaldue DESC) AS rank_sales
FROM Sales.SalesOrderHeader


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- "Top 10 orders": DENSE_RANK can return more than 10 rows when subtotals tie; ROW_NUMBER returns exactly 10.
SELECT TOP 10 SalesOrderID, SubTotal, ROW_NUMBER() OVER (ORDER BY SubTotal DESC) AS rn
FROM Sales.SalesOrderHeader
ORDER BY SubTotal DESC;

-- Per-year ranking: PurchaseOrderNumber is NULL for online orders; SalesOrderID identifies every order.
SELECT SalesOrderID, YEAR(OrderDate) AS order_year, TotalDue,
       DENSE_RANK() OVER (PARTITION BY YEAR(OrderDate) ORDER BY TotalDue DESC) AS rank_in_year
FROM Sales.SalesOrderHeader;
