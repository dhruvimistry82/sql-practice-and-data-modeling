/* 02 - DML: INSERT, UPDATE, DELETE
   Categories, employees and suppliers exercises.
   Engine: SQL Server (T-SQL). */

/*In this question, we have a table called categories with the following data:
category_id	category_name
25	Deli
50	Produce
75	Bakery
100	General Merchandise
125	Technology

1.	Write a query to create the above categories table & insert all records.
*/

CREATE TABLE Categories(
	 category_id INT Primary key,
	 category_name VARCHAR(50) NOT NULL
	 
	 )

INSERT INTO Categories(category_id,category_name)
VALUES(25,'Deli'),
(50,'Produce'),
(75,'Bakery'),
(100,'General Merchandise'),
(125,'Technology')

/*2.	Write a SQL query to insert one record into the categories table. This new record would have a category_id of 150 
and a category_name as 'Miscellaneous'.
*/
INSERT INTO Categories(category_id,category_name)
VALUES(150,'Miscellaneous')

/*3.	Write a SQL code to delete all the records where category_id is less than 100.*/
DELETE FROM Categories
WHERE category_id<100;


/*In this question, we have a table called employees with the following data:
employee_number	last_name	first_name	salary	dept_id
1001	Smith	John	62000	500
1002	Anderson	Jane	57500	500
1003	Everest	Brad	71000	501
1004	Horvath	Jack	42000	501

1.	Write a SQL Code to create employees table.

4.	Write a code to update all salary of employees by 20 percent.
*/

CREATE TABLE Employees
(employee_number INT Primary Key,
last_name VARCHAR(50) ,
First_name VARCHAR(50) ,
salary INT NOT NULL,
dept_id INT  )

 
/*2.	Write a single SQL statement to insert all records in employees table.*/
INSERT INTO Employees (employee_number, last_name, first_name, salary, dept_id)
VALUES 
    (1001, 'Smith', 'John', 62000, 500),
    (1002, 'Anderson', 'Jane', 57500, 500),
    (1003, 'Everest', 'Brad', 71000, 501),
    (1004, 'Horvath', 'Jack', 42000, 501);

/*3.	Write a code to insert record in employees table. This new record would have employee_number of 1005,
first_name as 'Mary', salary of 47500 & employee_number of 1006, last_name as 'William', salary of 32000.*/
INSERT INTO Employees (employee_number,first_name, salary)
VALUES 
    (1005,  'Mary', 47500),
    (1006, 'William',32000);
  
  /*4.	Write a code to update all salary of employees by 20 percent. */
UPDATE Employees
SET salary= salary*1.20

SELECT salary		--test query
FROM Employees

/*5.	Write a SQL query to delete all records for dept_id of 501.*/
DELETE  FROM Employees
WHERE dept_id =501

SELECT dept_id			--test query
 FROM Employees

 /*In this question, we have a table called suppliers with the following data:
supplier_id	supplier_name	city	state
100	Microsoft	Redmond	Washington
200	Google	Mountain View	California
300	Oracle	Redwood City	California
400	Kimberly-Clark	Irving	Texas
500	Tyson Foods	Springdale	Arkansas
600	SC Johnson	Racine	Wisconsin
700	Dole Food Company	Westlake Village	California
800	Flowers Foods	Thomasville	Georgia
900	Electronic Arts	Redwood City	California

1.	Write a SQL Query to create & insert all records in suppliers table.
2.	Write a query to delete a record where state as 'California' and supplier_name as 'Google'.
3.	Write a query to delete a record where state as 'California' and supplier_name as 'Google' and 'Oracle'.
4.	Write a query to delete a record from suppliers table where supplier_name as 'Microsoft'.
5.	Write a query to delete a record from suppliers table where state as 'California'.*/


CREATE table Suppliers(
	supplier_id INT,	
	supplier_name VARCHAR(50),	
	city VARCHAR(50),	
	supplier_state VARCHAR(50))

INSERT INTO Suppliers(supplier_id,supplier_name,city,	supplier_state)
VALUES('100','Microsoft','Redmond',	'Washington'),
('200','Google','Mountain View','California'),
('300','Oracle','Redwood City',	'California'),
('400','Kimberly-Clark','Irving','Texas'),
('500','Tyson Foods','Springdale','Arkansas'),
('600','SC Johnson','Racine','Wisconsin'),
('700',	'Dole Food Company','Westlake Village','California'),
('800','Flowers Foods',	'Thomasville',	'Georgia'),
('900',	'Electronic Arts','Redwood City','California')

/*2.	Write a query to delete a record where state as 'California' and supplier_name as 'Google'.*/
DELETE FROM suppliers
WHERE supplier_state ='California' AND supplier_name ='google'

/*3.	Write a query to delete a record where state as 'California' and supplier_name as 'Google' and 'Oracle'.*/
DELETE FROM Suppliers
WHERE supplier_state ='california' AND supplier_name IN('google','Oracle')
/*4.	Write a query to delete a record from suppliers table where supplier_name as 'Microsoft'.*/
DELETE FROM Suppliers
WHERE supplier_name='Microsoft'
/*5.	Write a query to delete a record from suppliers table where state as 'California'*/
DELETE FROM Suppliers
WHERE supplier_state='California'

SELECT *
FROM Suppliers


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Q3 (employees): 'William' is the LAST name of employee 1006, but it was inserted as first_name.
INSERT INTO Employees (employee_number, first_name, salary) VALUES (1005, 'Mary', 47500);
INSERT INTO Employees (employee_number, last_name, salary)  VALUES (1006, 'William', 32000);

-- Q4: salary is INT, so salary * 1.20 is rounded on the way back in; use DECIMAL for money.
ALTER TABLE Employees ALTER COLUMN salary DECIMAL(10, 2) NOT NULL;
UPDATE Employees SET salary = salary * 1.20;
