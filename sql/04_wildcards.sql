/* 04 - LIKE and wildcards
   AdventureWorks + class examples.
   Engine: SQL Server (T-SQL). */

/*Use adventure works database
1: Find the job title which have 3rd character as ‘p’?

*/

SELECT
	JobTitle
FROM HumanResources.Employee
WHERE JobTitle LIKE '__P%'
/*2: Find the first name of the employees, where name start with any vowel?
*/
SELECT
	FirstName
FROM Person.Person
WHERE FirstName LIKE '[aeiou]%'
/*3: Give the name of the territory where fourth character is ‘t’?*/

SELECT
	Name
FROM Sales.SalesTerritory
WHERE Name LIKE '___t%'
/*5: what are the different wildcards you know, write name and symbol?
wildcards are used for approximate matching or pattern searching/matching in a string
 %-anything can come after this ,Represents zero or more characters
_ means only one character
[]any charcters can be in the result set ,Represents any single character within the brackets
^Represents any character not in the brackets 
ESCAPE will escape all the wildcards in a string*/
/*
6: Use escape character to exclude _ from the name john_01(assume the data just write query)*/
SELECT JOHN_01
WHERE LIKE '%._%'
ESCAPE '.'
/*
7: In which wildcard escape need to be used?
8: write about functioning and use of escape with an example

ANS 7: When there are wildcard characters in a string which i want them to use normally and not use wildcards i use escape function.
For example,instagram username can have underscore , but we dont want to use it as a wildcard. at that time we use ESCAPE WILDCARD

ANS 8:Find product descriptions like "50% off":

SELECT Description
FROM Products
WHERE Description LIKE '%!%%' ESCAPE '!';
!% → literal `% (because it's escaped)
rest % signs act as wildcard*/

/* Class examples */
/*Retrieve the names of people whose last name starts with "S"*/

SELECT lastname
FROM person.person
WHERE lastname like 'S%'

/*WHERE last name like 'J__'
'J _ _ '*/
SELECT lastname
FROM person.person
WHERE lastname like 'j__'

/*Find people whose lastname starts with "A" and is followed by any character except 'e' or 'i.'*/
SELECT lastname
FROM person.person
WHERE lastname like 'A[^E,I]%'


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Class example: LIKE 'A[^E,I]%' also excludes a comma; inside [ ] the comma is a literal character.
SELECT LastName FROM Person.Person WHERE LastName LIKE 'A[^EI]%';
