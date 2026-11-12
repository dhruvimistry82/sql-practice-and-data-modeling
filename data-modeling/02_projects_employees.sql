/* Case 2: projects and employee assignments in 3NF (SQL Server). Fictional sample data. */

CREATE TABLE JobLevel (
    job_level VARCHAR(20) PRIMARY KEY,
    salary    DECIMAL(10, 2) NOT NULL CHECK (salary > 0)
);

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    dob         DATE,
    gender      CHAR(1) CHECK (gender IN ('M', 'F', 'X')),
    ssn         CHAR(11) NULL,                 -- sensitive: encrypt / mask in a real system
    job_level   VARCHAR(20) NOT NULL REFERENCES JobLevel(job_level),
    street      VARCHAR(100),
    city        VARCHAR(50),
    state       CHAR(2),
    zip         CHAR(5)
);

CREATE TABLE Project (
    project_id    INT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    description   VARCHAR(200),
    planned_hours INT CHECK (planned_hours >= 0),
    street        VARCHAR(100),
    city          VARCHAR(50),
    state         CHAR(2),
    zip           CHAR(5)
);

CREATE TABLE Assignment (
    employee_id INT NOT NULL REFERENCES Employee(employee_id),
    project_id  INT NOT NULL REFERENCES Project(project_id),
    hours       INT NOT NULL CHECK (hours >= 0),
    PRIMARY KEY (employee_id, project_id)
);

INSERT INTO JobLevel VALUES ('Mid Level', 50000), ('Sr Level', 60000);
INSERT INTO Employee VALUES
    (1, 'Nina Shah', '1985-01-01', 'F', NULL, 'Mid Level', '9 Lake Rd', 'Poway', 'CA', '92064'),
    (2, 'Tom Reyes', '1985-01-02', 'M', NULL, 'Sr Level', '4 Hill St', 'San Diego', 'CA', '92128');
INSERT INTO Project VALUES
    (1, 'Reporting', 'Patient report analysis', 1000, '100 Main St', 'Poway', 'CA', '92064'),
    (2, 'ETL', 'Load data to the DWH', 500, '100 Main St', 'Poway', 'CA', '92064');
INSERT INTO Assignment VALUES (1, 1, 100), (2, 1, 75), (1, 2, 50);

-- Rebuild the original flat sheet from the normalized tables:
SELECT p.name AS project, p.description, p.planned_hours, e.name AS employee, e.dob, e.gender,
       e.job_level, j.salary, a.hours AS emp_hours
FROM Assignment a
JOIN Employee e ON e.employee_id = a.employee_id
JOIN JobLevel j ON j.job_level = e.job_level
JOIN Project p  ON p.project_id = a.project_id
ORDER BY p.name, e.name;

-- Allocation check: planned vs assigned hours per project.
SELECT p.name, p.planned_hours, SUM(a.hours) AS assigned_hours
FROM Project p
LEFT JOIN Assignment a ON a.project_id = p.project_id
GROUP BY p.name, p.planned_hours;
