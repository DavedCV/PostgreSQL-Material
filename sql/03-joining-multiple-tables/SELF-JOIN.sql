/*
    Author: David Castrillón
    Date: 2023
*/

-- SELF JOIN
/*
    - A self-join is a regular join that joins a table to itself. In practice, you typically use a self-join to
        query hierarchical data or to compare rows within the same table.
    - To form a self-join, you specify the same table twice with different table aliases and provide the
        join predicate after the ON keyword.
    - A PostgreSQL self-join is a regular join that joins a table to itself using the INNER JOIN or LEFT JOIN.
*/

-- sample querying hierarchical data:
-- In this employee table, the manager_id column references the employee_id column. The value in the manager_id
-- column shows the manager to whom the employee directly reports. When the value in the manager_id column
-- is null, that employee does not report to anyone. In other words, he or she is the top manager.

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR (255) NOT NULL,
    last_name VARCHAR (255) NOT NULL,
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employee (employee_id) ON DELETE CASCADE
);

INSERT INTO employee (
    employee_id,
    first_name,
    last_name,
    manager_id
)
VALUES
    (1, 'Windy', 'Hays', NULL),
    (2, 'Ava', 'Christensen', 1),
    (3, 'Hassan', 'Conner', 1),
    (4, 'Anna', 'Reeves', 2),
    (5, 'Sau', 'Norman', 2),
    (6, 'Kelsie', 'Hays', 3),
    (7, 'Tory', 'Goff', 3),
    (8, 'Salley', 'Lester', 3);

-- INNER JOIN
SELECT
    e.first_name || ' ' || e.last_name employee,
    m.first_name || ' ' || m.last_name manager
FROM employee e
INNER JOIN employee m
    ON m.employee_id = e.manager_id
ORDER BY manager;

-- LEFT JOIN to show the top manager
SELECT
            e.first_name || ' ' || e.last_name employee,
            m.first_name || ' ' || m.last_name manager
FROM employee e
LEFT JOIN employee m
    ON m.employee_id = e.manager_id
ORDER BY manager;

DROP TABLE employee;

-- Comparing the rows with the same table
-- find all pair of films that have the same length
SELECT
    f1.title,
    f2.title,
    f1.length
FROM film f1
INNER JOIN film f2
 ON f1.length = f2.length AND
    f1.film_id != f2.film_id;