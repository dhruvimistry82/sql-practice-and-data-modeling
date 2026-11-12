/* 01 - DDL and constraints
   Tables with PRIMARY KEY, CHECK, UNIQUE and FOREIGN KEY constraints from written requirements.
   Engine: SQL Server (T-SQL). */

/* 1-	Create a table with following requirement
a. Person ID
b. Person Name
c. Salary: Holds yearly salary
d. Gender: Should take 1 or 0 for 1 ' Female, 0 ' Male
e. Marital Status: Should be 1 character it should take 3 values M, S, W  */

CREATE TABLE person(
    person_id INT PRIMARY KEY,
    person_name VARCHAR(200),
    Salary MONEY,
    Gender BIT CHECK (Gender in(0,1)),
    Marital_status VARCHAR(1) CHECK (marital_status IN('s','m','w'))
    )
   
/*2-	Write code to create table/tables to hold this info, if you think it needs more normalization 
please go ahead and do it and then create the tables 
a. Provider ID 
b. Provider Name: should be able to take names with 100 chars (you can split it if you want first, middle and last names)
c. Provider Specialty
d. Date of birth
e. Gender
f. City
g. ZIP
h. Street
i. Street Type
j. Street Number
k. Street Direction
l. State
m. Phone: It should take max of 10 digits
*/


/*3-	Create table for the following columns with proper data types and constraints 
Person(PersonID, Name, Gender, ZIP, Description)
*/



CREATE TABLE Personss (
    PersonID INT PRIMARY KEY,  -- Unique identifier
    Name VARCHAR(100) NOT NULL,  -- Full name
    Gender VARCHAR(6) CHECK (Gender IN ('Male', 'Female')) NOT NULL,  
    ZIP CHAR(5) CHECK (ZIP LIKE '[0-9][0-9][0-9][0-9][0-9]') NOT NULL,  -- 5-digit ZIP code
    Description VARCHAR(255) NULL  -- Optional description
);

/*4-	Create a table with following requirement

a. StudentID (PK)
b. Student Name (Name should have first name and last name seperated by a "," and first name should have atlest 3 chars 
and last name should have at least 2 chars)
c. SSN (it should accept SSN in ***-**-**** format and all of the characters should be INTs except for "-")
d. Gender (Only M or F)
e. Email (should be a proper email format with "@", ".". Domain name should be at least 3 chars, user name should be 
at least 5 chars and user name should not have following @, #, $, %, ^

*/

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
   StudentName VARCHAR(100) NOT NULL CHECK (
    StudentName LIKE '[A-Z][a-z][a-z]%,[A-Z][a-z]%')

    ),

    
    SSN CHAR(11) NOT NULL CHECK (
        SSN LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'
    ),

    -- Only 'M' or 'F'
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),

    -- Email: username (at least 5 chars, no @#$%^), domain name (at least 3 chars)
    Email VARCHAR(100) NOT NULL CHECK (
        Email LIKE '[A-Z][a-z][a-z][a-z][a-z]%' AND
        Email LIKE '%@%.%' AND
        Email NOT LIKE '%[@#$%^]%'  -- excludes forbidden symbols in username
    )
);
/*5-	Create a sample table having following titles: Employee ID, Full Name, Birthdate, E-mail, Position, and Department.
Data Type:

Employee ID - integer
Full Name - string
Birthdate - date
E-mail - string
Position - string
Department - string
*/
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,               -- Unique identifier
    FullName VARCHAR(100) NOT NULL,           -- Full name with space allowed
    Birthdate DATE NOT NULL,                  -- Date of birth
    Email VARCHAR(100) NOT NULL,              -- Email address
    Position VARCHAR(50) NOT NULL,            -- Job title/position
    Department VARCHAR(50) NOT NULL           -- Department name
);
/*
6-	Create a new table named Database with the following columns:
- Name A string (text) describing the name of the database
- Version A number (floating point) of the latest version of this database
- Download_count An integer count of the number of times this database was downloaded
This table has no constraints.
*/
CREATE TABLE Database (
    Name VARCHAR(100),           -- Name of the database
    Version FLOAT,               -- Latest version number
    Download_count INT           -- Number of downloads
);
/*7-	Consider the following relational schema that manages the telephone bills of a mobile phone company.
CUSTOMER ( SSN, Name, Surname, PhoneNum, Plan) 
PRICINGPLAN ( Code, ConnectionFee, PricePerSecond ) 
PHONECALL ( SSN, Date, Time, CalledNum, Seconds) 
BILL ( SSN, Month, Year, amount )

*/
-- 1. CUSTOMER Table
CREATE TABLE CUSTOMER (
    SSN CHAR(11) PRIMARY KEY,                -- Format: 123-45-6789
    Name VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    PhoneNum VARCHAR(15) UNIQUE NOT NULL,    -- E.g., 1234567890 or with country code
    Plan VARCHAR(10) NOT NULL ,               -- Plan code that links to PRICINGPLAN
);

-- 2. PRICINGPLAN Table
CREATE TABLE PRICINGPLAN (
    Code VARCHAR(10) PRIMARY KEY,             -- Unique plan code
    ConnectionFee DECIMAL(6,2) NOT NULL,      -- E.g., $1.00
    PricePerSecond DECIMAL(6,4) NOT NULL      -- E.g., $0.0123 per second
);

-- 3. PHONECALL Table
CREATE TABLE PHONECALL (
    SSN CHAR(11) NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    CalledNum VARCHAR(15) NOT NULL,           
    Seconds INT CHECK (Seconds > 0),      
    PRIMARY KEY (SSN, Date, Time),
    FOREIGN KEY (SSN) REFERENCES CUSTOMER(SSN)
);

-- 4. BILL Table
CREATE TABLE BILL (
    SSN CHAR(11) NOT NULL,
    Month INT CHECK (Month BETWEEN 1 AND 12),
    Year INT CHECK (Year >= 2000),           
    Amount DECIMAL(10,2) NOT NULL,  
    PRIMARY KEY (SSN, Month, Year),
    FOREIGN KEY (SSN) REFERENCES CUSTOMER(SSN)
);


/* 
8-	Consider the following relational schema that manages the assignment of scholarships to students.
 APPLICATION (StudentID, Date, State) 
COURSE (CourseID, Title, Credits) 
RANKING (StudentID, Average, Credits, Rank)  [Average should be >= 50]
EXAM (CourseID, StudentID, Date, Grade) [Grade should not be 'C']

*/

-- 1. APPLICATION Table
CREATE TABLE APPLICATION (
    StudentID INT NOT NULL,
    Date DATE NOT NULL,
    State VARCHAR(50),
    PRIMARY KEY (StudentID, Date)
);

-- 2. COURSE Table
CREATE TABLE COURSE (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- 3. RANKING Table
CREATE TABLE RANKING (
    StudentID INT PRIMARY KEY,
    Average DECIMAL(5,2) CHECK (Average >= 50),  -- Enforce >= 50
    Credits INT CHECK (Credits >= 0),
    Rank INT CHECK (Rank > 0)
);

-- 4. EXAM Table
CREATE TABLE EXAM (
    CourseID INT NOT NULL,
    StudentID INT NOT NULL,
    Date DATE NOT NULL,
    Grade CHAR(1) NOT NULL CHECK (Grade <> 'C'),  -- Disallow Grade 'C'
    PRIMARY KEY (CourseID, StudentID, Date)
);


/* ==========================================================================
   REVIEW: issues found when revisiting these answers, with corrected queries
   ========================================================================== */

-- Q2 (Provider) was left unanswered. Normalized answer: name split, phone limited to 10 digits,
-- specialty in its own table so it isn't retyped per provider.
CREATE TABLE Specialty (
    SpecialtyID   INT IDENTITY PRIMARY KEY,
    SpecialtyName VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE Provider (
    ProviderID      INT PRIMARY KEY,
    FirstName       VARCHAR(40) NOT NULL,
    MiddleName      VARCHAR(20) NULL,
    LastName        VARCHAR(40) NOT NULL,          -- 40 + 20 + 40 = 100 chars total
    SpecialtyID     INT NOT NULL REFERENCES Specialty(SpecialtyID),
    DateOfBirth     DATE,
    Gender          CHAR(1) CHECK (Gender IN ('M', 'F', 'X')),
    StreetNumber    VARCHAR(10),
    StreetDirection VARCHAR(2) CHECK (StreetDirection IN ('N', 'S', 'E', 'W', 'NE', 'NW', 'SE', 'SW')),
    StreetName      VARCHAR(60),
    StreetType      VARCHAR(10),                   -- St, Ave, Blvd ...
    City            VARCHAR(50),
    State           CHAR(2),
    ZIP             CHAR(5) CHECK (ZIP LIKE '[0-9][0-9][0-9][0-9][0-9]'),
    Phone           VARCHAR(10) CHECK (Phone NOT LIKE '%[^0-9]%')   -- digits only, max 10
);

-- Q4 Student email: the original CHECK can never pass. It requires '@' (LIKE '%@%.%')
-- but also forbids '@' anywhere (NOT LIKE '%[@#$%^]%'). Check the username part only.
-- (Also note: in a LIKE character class, % is literal, so [@#$%^] is fine.)
CREATE TABLE Student_v2 (
    StudentID   INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL CHECK (StudentName LIKE '[A-Z][a-z][a-z]%,[A-Z][a-z]%'),   -- original rule kept
    SSN         CHAR(11) NOT NULL CHECK (SSN LIKE '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    Gender      CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    Email       VARCHAR(100) NOT NULL,
    CONSTRAINT CK_Student_Email CHECK (
        Email LIKE '_%@_%._%'                                              -- shape: user@domain.tld
        AND CHARINDEX('@', Email) > 5                                      -- username >= 5 chars
        AND LEFT(Email, CHARINDEX('@', Email) - 1) NOT LIKE '%[@#$%^]%'   -- no forbidden chars in username
        AND CHARINDEX('.', Email, CHARINDEX('@', Email)) - CHARINDEX('@', Email) > 3   -- domain name >= 3 chars
    )
);

-- Q6: DATABASE is a reserved word in T-SQL, so the table name must be delimited.
CREATE TABLE [Database] (Name VARCHAR(100), Version FLOAT, Download_count INT);

-- Q7: CUSTOMER.Plan was described as linking to PRICINGPLAN but had no foreign key.
ALTER TABLE CUSTOMER ADD CONSTRAINT FK_Customer_Plan FOREIGN KEY (Plan) REFERENCES PRICINGPLAN(Code);

-- Q8: EXAM and RANKING should reference COURSE / students consistently.
ALTER TABLE EXAM ADD CONSTRAINT FK_Exam_Course FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID);
