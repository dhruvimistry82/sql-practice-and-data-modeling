/* Practice tables for sql/07_subqueries.sql. */

CREATE TABLE emp (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    job_name VARCHAR(50),
    manager_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    dep_id INT
);
INSERT INTO emp (emp_id, emp_name, job_name, manager_id, hire_date, salary, commission, dep_id)
VALUES 
(68319, 'KAYLING', 'PRESIDENT', NULL, '1991-11-18', 6000.00, NULL, 1001),
(66928, 'BLAZE', 'MANAGER', 68319, '1991-05-01', 2750.00, NULL, 3001),
(67832, 'CLARE', 'MANAGER', 68319, '1991-06-09', 2550.00, NULL, 1001),
(65646, 'JONAS', 'MANAGER', 68319, '1991-04-02', 2957.00, NULL, 2001),
(67858, 'SCARLET', 'ANALYST', 65646, '1997-04-19', 3100.00, NULL, 2001),
(69062, 'FRANK', 'ANALYST', 65646, '1991-12-03', 3100.00, NULL, 2001),
(63679, 'SANDRINE', 'CLERK', 69062, '1990-12-18', 900.00, NULL, 2001),
(64989, 'ADELYN', 'SALESMAN', 66928, '1991-02-20', 1700.00, 400.00, 3001);

CREATE TABLE dept (
    dep_id INT PRIMARY KEY,
    dep_name VARCHAR(30),
    dep_location VARCHAR(30)
);
INSERT INTO dept (dep_id, dep_name, dep_location) VALUES
    (1001, 'FINANCE', 'SYDNEY'),
    (2001, 'AUDIT', 'MELBOURNE'),
    (3001, 'MARKETING', 'PERTH'),
    (4001, 'PRODUCTION', 'BRISBANE');
