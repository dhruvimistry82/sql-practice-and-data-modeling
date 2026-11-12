/* 05 - Aggregates, GROUP BY, HAVING
   Uses setup/sales_orders.sql.
   Engine: SQL Server (T-SQL). */

/*1. Calculate Total Purchase Amount of All Orders
From the following table, write a SQL query to calculate total purchase amount of all orders. Return total purchase amount.*/
SELECT 
	SUM(purch_amt)
FROM Orders

/*2Write a SQL query to calculate the total purchase amount for orders placed in the year 2012.*/
SELECT 
	SUM(purch_amt)
FROM Orders
WHERE  YEAR(ord_date)='2012'
/*3Write a SQL query to calculate the total purchase amount for orders placed by customer ID 3005.*/
SELECT sum(purch_amt) AS total_purch_amt,customer_id
FROM Orders
WHERE customer_id=3005
GROUP BY customer_id

/*Write a SQL query to calculate the total purchase amount for orders placed by salesman ID 5001.*/
SELECT SUM(purch_amt)
FROM Orders
WHERE salesman_id = 5001
/*4Write a SQL query to calculate the total purchase amount for orders placed between '2012-07-01' and '2012-09-30'.*/
SELECT
	SUM(purch_amt),
	ord_date
FROM Orders
WHERE  ord_date BETWEEN '2012-07-01' AND '2012-09-30' 
GROUP BY ord_date
/*5.From the following table, write a SQL query to calculate the average purchase amount of all orders.
Return average purchase amount*/
SELECT
	AVG(purch_amt)
FROM Orders
/*6.Write a SQL query to calculate the average purchase amount for orders placed by salesman ID 5003.*/
SELECT 
	AVG(purch_amt)
FROM Orders
WHERE salesman_id=5003
/*7Write a SQL query to calculate the average purchase amount for orders placed in the month of October 2012.*/
SELECT 
	AVG(purch_amt)
FROM Orders
WHERE MONTH(ord_date) =10
			AND YEAR(ord_date)=2012
/*8Write a SQL query to calculate the average purchase amount for orders with a purchase amount greater than 1000.*/
SELECT 
	AVG(purch_amt)
FROM Orders
WHERE purch_amt >1000
/*9. Count the Number of Unique Salespeople

From the following table, write a SQL query that counts the number of unique salespeople. Return number of salespeople.  */
SELECT 
	COUNT(DISTINCT(salesman_id))
FROM Salesman
/*10.Write a SQL query to count the number of unique salespeople who have made sales in the city 'New York'.*/
SELECT COUNT(DISTINCT(salesman_id))
FROM Salesman
WHERE city ='New York'
/*11.Write a SQL query to count the number of unique salespeople who have made sales to customer ID 3009.*/
SELECT
	COUNT(DISTINCT(salesman_id))
FROM Customer
WHERE customer_id=3009
/*12.Write a SQL query to count the number of unique salespeople who have made sales in the year 2012.*/
SELECT
	COUNT(DISTINCT(salesman_id))
FROM Orders
WHERE YEAR(ord_date)=2012

/*13.Write a SQL query to count the number of unique salespeople who have made sales with a purchase amount greater than 2000.*/
SELECT COUNT(DISTINCT(salesman_id))
FROM Orders
WHERE purch_amt>2000
/*14. Count the Number of Customers.From the following table, write a SQL query to count the number of customers. 
Return number of customers.  */
SELECT COUNT(customer_id)
FROM Customer
/*15Write a SQL query to count the number of customers who are from the city 'London'.*/
SELECT COUNT(customer_id)
FROM Customer
WHERE  city ='london'
/*16Write a SQL query to count the number of customers who have a grade of 200.*/
SELECT 
	COUNT(customer_id)
FROM Customer
WHERE grade = 200
/*17Write a SQL query to count the number of customers who have made at least one purchase.*/
SELECT COUNT(customer_id)
FROM Orders
HAVING COUNT(customer_id)>1

/*18Write a SQL query to count the number of customers who are assigned to salesman ID 5002.*/
SELECT COUNT(customer_id)
FROM Customer
WHERE salesman_id = 5002
/*19Find Maximum Purchase Amount.From the following table, write a SQL query to find the maximum purchase amount.  
Sample table: orders*/
SELECT MAX(purch_amt)
FROM Orders
/*21Find Highest Purchase Amount Ordered by Each Customer
From the following table, write a SQL query to find the highest purchase amount ordered by each customer.
Return customer ID, maximum purchase amount. */
SELECT
	customer_id,
	MAX(purch_amt) AS MAX_PURCHAMOUNT
FROM Orders
GROUP BY customer_id
/*22Write a SQL query to find the highest purchase amount for each customer, but only for customers with a grade of 200 or higher.*/
SELECT 
	MAX(o.purch_amt),
	c.cust_name,
	c.customer_id,
	c.grade
FROM Customer c
JOIN Orders o
ON c.customer_id= o.customer_id
WHERE grade >=200
GROUP BY cust_name,grade,c.customer_id
/*23Write a SQL query to find the highest purchase amount for each customer, but only for customers from the city 'New York'.*/
SELECT
	MAX(o.purch_amt)
FROM Orders o
JOIN Customer c
ON c.customer_id= o.customer_id
WHERE c.city ='new york'
GROUP BY o.customer_id
/*24Write a SQL query to find the highest purchase amount for each customer, but only for customers who have made at least two purchases.
*/
SELECT 
	max(o.purch_amt),
	COUNT(o.customer_id) AS REPEATED_CUSTOMERS,
	c.cust_name
FROM Orders o
JOIN Customer c
ON o.customer_id= c.customer_id
GROUP BY c.cust_name
HAVING COUNT( O.customer_id)>=2

/*25Write a SQL query to find the highest purchase amount for each customer, but only for customers assigned to salesman ID 5001.*/
SELECT 
	MAX(o.purch_amt),
	c.salesman_id,
	c.customer_id
FROM Orders o
JOIN Customer c
ON o.customer_id= c.customer_id
WHERE o.salesman_id =5001
GROUP BY c.salesman_id,c.customer_id


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Q4 asks for ONE total for Jul-Sep 2012; GROUP BY ord_date returned one total per day.
SELECT SUM(purch_amt) AS total_purch_amt
FROM Orders
WHERE ord_date BETWEEN '2012-07-01' AND '2012-09-30';

-- Q11: salespeople who SOLD to customer 3009 are found in Orders, not in the Customer table.
SELECT COUNT(DISTINCT salesman_id) FROM Orders WHERE customer_id = 3009;

-- Q17: "customers with at least one purchase" = distinct customers in Orders.
-- COUNT(customer_id) ... HAVING COUNT(*) > 1 counted orders, and only if there were 2+.
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders FROM Orders;

-- Q23: return which customer each maximum belongs to.
SELECT o.customer_id, MAX(o.purch_amt) AS max_purch_amt
FROM Orders o
JOIN Customer c ON c.customer_id = o.customer_id
WHERE c.city = 'New York'
GROUP BY o.customer_id;

-- Q24: group by the key, not the name (two customers can share a name).
SELECT c.customer_id, c.cust_name, MAX(o.purch_amt) AS max_purch_amt, COUNT(*) AS orders
FROM Orders o
JOIN Customer c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.cust_name
HAVING COUNT(*) >= 2;

-- Q25: "customers ASSIGNED to salesman 5001" is Customer.salesman_id, not who took the order.
SELECT c.customer_id, MAX(o.purch_amt) AS max_purch_amt
FROM Orders o
JOIN Customer c ON c.customer_id = o.customer_id
WHERE c.salesman_id = 5001
GROUP BY c.customer_id;
