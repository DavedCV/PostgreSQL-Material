/*
    Author: David Castrillón
    Date: 2023
*/

-- FULL OUTER JOIN

/*
    - The full outer join combines the results of both the left join and the right join.
    - If the rows in the joined table do not match, the full outer join sets NULL values for every column of the
        table that does not have the matching row.
    - If a row from one table matches a row in another table, the result row will contain columns populated
        from columns of rows from both tables.
*/

-- sample tables
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(254) NOT NULL
);
INSERT INTO departments (department_name)
VALUES
    ('Sales'),
    ('Marketing'),
    ('HR'),
    ('IT'),
    ('Production');
SELECT * FROM departments;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR (255),
    department_id INTEGER
);
INSERT INTO employees (
    employee_name,
    department_id
)
VALUES
    ('Bette Nicholson', 1),
    ('Christian Gable', 1),
    ('Joe Swank', 2),
    ('Fred Costner', 3),
    ('Sandra Kilmer', 4),
    ('Julia Mcqueen', NULL);
SELECT * FROM employees;

-- FULL OUTER JOIN to query data from both tables
SELECT
    employee_name,
    department_name
FROM employees e
FULL JOIN departments d
    ON e.department_id = d.department_id;

-- find department without employee
SELECT
    employee_name,
    department_name
FROM employees e
         FULL JOIN departments d
ON e.department_id = d.department_id
WHERE e.employee_name ISNULL;

-- find employee without department
SELECT
    employee_name,
    department_name
FROM employees e
FULL JOIN departments d
    ON e.department_id = d.department_id
WHERE d.department_name ISNULL;


DROP TABLE departments;
DROP TABLE employees;