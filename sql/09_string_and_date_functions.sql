/* 09 - String and date functions
   CHARINDEX, LEN/REPLACE word counts, LEFT/RIGHT, date keys. AdventureWorks.
   Engine: SQL Server (T-SQL). */

/*1) state differences between replace and stuff
2) state difference between patindex and charindex
3) use adventureworks employee table
 a) find count of jobtitle with one word
 b) find  count of job title with two word
 c) find count of jobtitle with three words
d) find count of employee who have first and last character same in there job title.
e) create datekeys from hiredate and birthdate.*/

SELECT COUNT(*) AS OneWordJobTitleCount,
	JobTitle
FROM HumanResources.Employee
WHERE CHARINDEX(' ', JobTitle) = 0
GROUP BY JobTitle


/* b) find  count of job title with two word*/
SELECT COUNT(*) AS TwoWordJobTitleCount
,JobTitle
FROM HumanResources.Employee
WHERE LEN(JobTitle) - LEN(REPLACE(JobTitle, ' ', '')) = 1
GROUP BY JobTitle
/*c find count of job title with three words*/
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
WHERE LEN(JobTitle) - LEN(REPLACE(JobTitle, ' ', '')) = 2;


/* find count of employee who have first and last character same in there job title.*/
SELECT 
	FirstName,
	LastName
FROM Person.Person
WHERE LEFT(FirstName,1)=LEFT(LastName,1)

/*e) create datekeys from hiredate and birthdate.*/
select MAX(HireDate),
	MIN(HireDate)
from HumanResources.Employee
/*Find the number of products based on their color and size where there color is black and size is above 40.
Display the resultset in Ascending order.*/
SELECT COUNT(*) ,
Color,
Size
FROM production.Product
WHERE Color= 'black' AND TRY_CAST(Size AS int
GROUP BY Color,Size


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- 1) REPLACE vs STUFF: REPLACE swaps every occurrence of a substring; STUFF deletes N characters at a
--    position and inserts new text there.  2) PATINDEX vs CHARINDEX: CHARINDEX finds a literal string
--    (with an optional start position); PATINDEX finds a pattern with wildcards.

-- 3a-c: the questions ask for a COUNT of titles; GROUP BY JobTitle returned one row per title.
SELECT
    SUM(CASE WHEN words = 1 THEN 1 ELSE 0 END) AS one_word_titles,
    SUM(CASE WHEN words = 2 THEN 1 ELSE 0 END) AS two_word_titles,
    SUM(CASE WHEN words = 3 THEN 1 ELSE 0 END) AS three_word_titles
FROM (SELECT DISTINCT JobTitle,
             LEN(JobTitle) - LEN(REPLACE(JobTitle, ' ', '')) + 1 AS words
      FROM HumanResources.Employee) t;

-- 3d: first and last character of the JOB TITLE (the answer compared first and last names).
SELECT COUNT(*) AS employees
FROM HumanResources.Employee
WHERE LEFT(JobTitle, 1) = RIGHT(JobTitle, 1);

-- 3e: date keys (yyyymmdd integers), as used in data warehouse date dimensions.
SELECT BusinessEntityID,
       CONVERT(INT, FORMAT(HireDate, 'yyyyMMdd'))  AS HireDateKey,
       CONVERT(INT, FORMAT(BirthDate, 'yyyyMMdd')) AS BirthDateKey
FROM HumanResources.Employee;

-- Black products with size above 40 (the original had an unclosed TRY_CAST).
SELECT Color, Size, COUNT(*) AS products
FROM Production.Product
WHERE Color = 'Black' AND TRY_CAST(Size AS INT) > 40
GROUP BY Color, Size
ORDER BY TRY_CAST(Size AS INT) ASC;

-- First and last hire dates.
SELECT MIN(HireDate) AS first_hire, MAX(HireDate) AS last_hire FROM HumanResources.Employee;
