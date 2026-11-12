# SQL Practice & Data Modeling

My SQL Server practice from data engineering training, organized by topic, plus two data modeling case studies taken from a flat spreadsheet to **3NF**, with ER diagrams and working DDL.

Each SQL file keeps my original answers and ends with a **REVIEW** section: when I revisited the work, I checked every answer against its question and wrote corrected versions where something was wrong or could be better. The review is part of the point: reading SQL critically matters as much as writing it.

## Data modeling

| Case | What it shows |
|---|---|
| [Retail sales orders](data-modeling/01_retail_orders.md) | Splitting one sales list into Customer, Clerk, Item, SalesOrder and SalesOrderLine; why `total sales` is derived and not stored; why the line keeps the price at the time of sale |
| [Projects & employee assignments](data-modeling/02_projects_employees.md) | A many-to-many relationship resolved with an Assignment table (composite key); a transitive dependency (job level → salary) removed in 3NF; handling sensitive data (SSN) |

Each case walks through the conceptual model, 1NF, 2NF and 3NF, ends with an ER diagram (crow's foot) and has a `.sql` file that creates the tables, loads sample data and rebuilds the original view with joins.

## SQL by topic

| File | Topic | Database |
|---|---|---|
| [01_ddl_constraints](sql/01_ddl_constraints.sql) | CREATE TABLE with PK, FK, CHECK (incl. pattern checks for SSN, ZIP, email), UNIQUE | - |
| [02_dml](sql/02_dml.sql) | INSERT, UPDATE, DELETE | - |
| [03_filtering_hospital_billing](sql/03_filtering_hospital_billing.sql) | SELECT, WHERE, BETWEEN, IN, AND/OR | `setup/hospital_billing.sql` |
| [04_wildcards](sql/04_wildcards.sql) | LIKE, `_`, `%`, `[ ]`, `[^ ]` | AdventureWorks |
| [05_aggregates_group_by](sql/05_aggregates_group_by.sql) | SUM, AVG, COUNT(DISTINCT), MAX, GROUP BY, HAVING | `setup/sales_orders.sql` |
| [06_joins_having](sql/06_joins_having.sql) | Multi-table joins with aggregation | AdventureWorks |
| [07_subqueries](sql/07_subqueries.sql) | Scalar, IN and correlated subqueries | `setup/emp_dept.sql` |
| [08_window_ranking](sql/08_window_ranking.sql) | DENSE_RANK / ROW_NUMBER with PARTITION BY | AdventureWorks |
| [09_string_and_date_functions](sql/09_string_and_date_functions.sql) | CHARINDEX, LEN/REPLACE word counts, LEFT/RIGHT, TRY_CAST, date keys | AdventureWorks |
| [10_interview_style_problems](sql/10_interview_style_problems.sql) | Duplicates, "never ordered" (LEFT JOIN vs NOT EXISTS), ALL/ANY | mixed |
| [11_northwind_practice](sql/11_northwind_practice.sql) | ~55 progressive problems: CTEs, CASE bucketing, outer joins, percentages | Northwind |

## Highlights from the review

| Where | What was wrong | Lesson |
|---|---|---|
| `01` email CHECK | Required an `@` and also forbade `@` anywhere, so no email could ever be inserted | Test constraints with both valid and invalid rows |
| `10` "products never ordered" | Inner join on the wrong column; an inner join can never return the NULLs being filtered for | LEFT JOIN … IS NULL or NOT EXISTS |
| `11` #31 | Filter on the outer table in `WHERE` turned a LEFT JOIN into an inner join | Put outer-table filters in `ON` |
| `11` #54 | Customer and supplier countries matched by row number | Join on the business key; FULL OUTER JOIN for both sides |
| `05` Q17 | `COUNT(...) HAVING > 1` instead of `COUNT(DISTINCT customer_id)` | Count what the question asks about |
| `03` Q6 | "Between two dates" written as `IN (date1, date2)` | IN matches exact values only |
| `07` Q3, Q9 | Hard-coded IDs and years instead of the stated conditions | Encode the rule, not today's answer |

## Run it

1. SQL Server (Developer or Express) and SSMS / Azure Data Studio.
2. Run the scripts in `setup/` for the custom tables; install AdventureWorks and Northwind for the rest (links in [`setup/README.md`](setup/README.md)).
3. Run the data modeling `.sql` files in an empty database.
