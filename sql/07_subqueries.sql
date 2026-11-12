/* 07 - Subqueries
   Uses setup/emp_dept.sql and setup/sales_orders.sql.
   Engine: SQL Server (T-SQL). */

--1Write query to display all the orders from the orders table issued by salesman 'Paul Adam'.
SELECT *
FROM Orders
WHERE salesman_id=(SELECT salesman_id
				  FROM Salesman
				  WHERE name='PAUL ADAM')

--2	Write a query in SQL to display all the details of managers.
SELECT *
FROM emp
WHERE emp_id IN(
				SELECT DISTINCT manager_id
				FROM emp
				WHERE manager_id IS NOT NULL )
/*3-	Write a query in SQL to list the employee ID, name, salary, department name of all the 
'MANAGERS' and 'ANALYST' working in SYDNEY, PERTH with an exp more than 5 years
without receiving the commission and display the list in ascending order of location.*/
SELECT e.emp_id,
		e.emp_name,
		e.salary,
		d.dep_location
FROM emp e
join dept d
ON e.dep_id=d.dep_id
WHERE 
    d.dep_id IN (1001, 3001)
    AND YEAR(e.hire_date) = 1991
ORDER by d.dep_location ASC

/*4-	Write a query in SQL to display the employee ID, name, salary, department name, location, department ID,
job name of all the employees working at SYDNEY or working in the FINANCE department with an 
annual salary above 28000, but the monthly salary should not be 3000 or 2800 and 
who does not works as a MANAGER and whose ID containing a digit of '3' or '7' in 3rd position.
List the result in ascending order of department ID and descending order of job name.*/
SELECT e.emp_id,
		e.emp_name,
		e.salary,
		d.dep_name,
		d.dep_location
FROM emp e
JOIN dept d
ON e.dep_id= d.dep_id
WHERE e.salary NOT IN (3000,2800) AND (e.salary*12)>28000
AND emp_id  IN (	SELECT emp_id 
					FROM emp
					WHERE job_name!='manager' AND emp_id  LIKE '%__[37]%' 
									AND dep_id IN(SELECT dep_id
									from dept d
									WHERE d.dep_location ='sydney' OR d.dep_name ='finance' ) )
ORDER BY e.dep_id ASC,e.job_name ASC

/*5-	Write a query in SQL to list all the employees of grade 2 and 3.*/

/*66-	Write a query in SQL to list the employees of grade 3 and 4 working in the department 
of FINANCE or AUDIT and whose salary is more than the salary of ADELYN and experience is 
more than FRANK. List the result in the ascending order of experience.*/
SELECT e.emp_name,
	d.dep_name,
	e.salary
FROM emp e
JOIN dept d
ON e.dep_id=d.dep_id
WHERE d.dep_name IN('finance','audit') AND 
e.salary >(SELECT e.salary
			FROM emp e
			WHERE e.emp_name ='adelyn' 
			)
		AND e.hire_date<(SELECT e.hire_date
						FROM EMP e
						WHERE e.emp_name='FRANK')
ORDER BY e.hire_date ASC
/*7-	Write a query in SQL to list the employees whose designation is same as the designation 
of SANDRINE or ADELYN.*/
SELECT  
	e.emp_name,
	e.job_name
FROM emp e
WHERE e.job_name IN
	(SELECT 
		job_name
	 FROM emp e
	 WHERE emp_name IN('SANDRINE','ADELYN'))
/*
8-	Write a query in SQL to list any job of department ID 1001 those that are not 
found in department ID 2001.*/
SELECT job_name
FROM emp e
where Job_name NOT  IN
(SELECT job_name
FROM emp e
WHERE dep_id =2001) AND dep_id=1001
/*9-	Write a query in SQL to find the highest paid employees in the department MARKETING.*/
SELECT e.emp_name,
		e.salary
		
FROM emp e
WHERE  E.dep_id =3001 and e.salary=(SELECT 
	MAX(e.salary) AS highestsalary
	
FROM emp e
JOIN dept d
ON d.dep_id=e.dep_id
where d.dep_name='marketing'
)
/*10-	Write a query in SQL to list the employees of grade 3 who have been hired in 
most recently and belongs to PERTH.*/
SELECT e.emp_name,
		d.dep_name,
		e.hire_date
FROM emp e
JOIN dept d
ON e.dep_id=d.dep_id
WHERE d.dep_location='perth' AND
	e.hire_date<(SELECT MAX(hire_date)
				FROM emp e
				JOIN dept d
				ON e.dep_id=d.dep_id
				WHERE d.dep_location='perth'
				)
/*11-	Write a query in SQL to list the employees who are senior to the most recently hired 
employee working under KAYLING.*/
SELECT * 
FROM EMP e
 WHERE manager_id=68319 AND e.hire_date<
(SELECT MAX(e.hire_date)
FROM emp e
)
/*12-	Write a query in SQL to list the employees who joined in 1991 in a designation same as 
the most senior person of the year 1991.*/
SELECT *
FROM emp
WHERE 
    YEAR(hire_date) = 1991
    AND job_name = (
        SELECT TOP 1 job_name
        FROM emp
        WHERE YEAR(hire_date) = 1991
        ORDER BY hire_date ASC
    )
ORDER BY hire_date ASC;

/*13-	Write a query in SQL to list the employees in department 1001 whose salary is more than 
the average salary of employees in department 2001*/
SELECT emp_name,
salary,
dep_id
FROM emp 
WHERE salary >(SELECT AVG(salary)
FROM emp
WHERE dep_id=2001) AND dep_id=1001
/*14-	Write a query in SQL to list the details of the departments where 
maximum number of employees are working.*/


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Q3 hard-coded department IDs and the year 1991 instead of expressing the conditions.
SELECT e.emp_id, e.emp_name, e.salary, d.dep_name, d.dep_location
FROM emp e
JOIN dept d ON d.dep_id = e.dep_id
WHERE e.job_name IN ('MANAGER', 'ANALYST')
  AND d.dep_location IN ('SYDNEY', 'PERTH')
  AND DATEDIFF(YEAR, e.hire_date, GETDATE()) > 5
  AND e.commission IS NULL
ORDER BY d.dep_location ASC;

-- Q4: "3rd position is 3 or 7" is LIKE '__[37]%' (the leading % allowed any position);
-- the question also asks for job name DESCENDING.
SELECT e.emp_id, e.emp_name, e.salary, d.dep_name, d.dep_location, e.dep_id, e.job_name
FROM emp e
JOIN dept d ON d.dep_id = e.dep_id
WHERE (d.dep_location = 'SYDNEY' OR d.dep_name = 'FINANCE')
  AND e.salary * 12 > 28000
  AND e.salary NOT IN (3000, 2800)
  AND e.job_name <> 'MANAGER'
  AND CAST(e.emp_id AS VARCHAR(10)) LIKE '__[37]%'
ORDER BY e.dep_id ASC, e.job_name DESC;

-- Q9 hard-coded dep_id 3001; filter by the department name in the outer query too.
SELECT e.emp_name, e.salary
FROM emp e
JOIN dept d ON d.dep_id = e.dep_id
WHERE d.dep_name = 'MARKETING'
  AND e.salary = (SELECT MAX(e2.salary) FROM emp e2 JOIN dept d2 ON d2.dep_id = e2.dep_id
                  WHERE d2.dep_name = 'MARKETING');

-- Q10 "hired most recently" means = MAX(hire_date); < MAX returned everyone except them.
SELECT e.emp_name, d.dep_name, e.hire_date
FROM emp e
JOIN dept d ON d.dep_id = e.dep_id
WHERE d.dep_location = 'PERTH'
  AND e.hire_date = (SELECT MAX(e2.hire_date) FROM emp e2 JOIN dept d2 ON d2.dep_id = e2.dep_id
                     WHERE d2.dep_location = 'PERTH');

-- Q11: compare with the most recent hire UNDER KAYLING, not the most recent hire overall.
SELECT *
FROM emp
WHERE hire_date < (SELECT MAX(hire_date) FROM emp
                   WHERE manager_id = (SELECT emp_id FROM emp WHERE emp_name = 'KAYLING'));

-- Q14 was left unanswered: departments with the most employees (ties included).
SELECT d.*
FROM dept d
WHERE d.dep_id IN (SELECT TOP 1 WITH TIES dep_id FROM emp GROUP BY dep_id ORDER BY COUNT(*) DESC);
