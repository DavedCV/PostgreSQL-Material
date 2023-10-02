/*
    Author: David Castrillón
    Date: 2023
*/

-- UPDATE

/*
    - The PostgreSQL UPDATE statement allows you to modify data in a table.
    - The WHERE clause is optional. If you omit the WHERE clause, the UPDATE statement will update all rows in the table.
    - The UPDATE statement has an optional RETURNING clause that returns the updated rows.
*/

-- sample table
CREATE TABLE courses(
    course_id serial primary key,
    course_name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    published_date date
);

INSERT INTO
    courses(course_name, description, published_date)
VALUES
    ('PostgreSQL for Developers','A complete PostgreSQL for Developers','2020-07-13'),
    ('PostgreSQL Admininstration','A PostgreSQL Guide for DBA',NULL),
    ('PostgreSQL High Performance',NULL,NULL),
    ('PostgreSQL Bootcamp','Learn PostgreSQL via Bootcamp','2013-07-11'),
    ('Mastering PostgreSQL','Mastering PostgreSQL in 21 Days','2012-06-30');
SELECT * FROM courses;

-- UPDATE
UPDATE courses
SET published_date = '2020-08-01'
WHERE course_id = 3;

SELECT *
FROM courses
WHERE course_id = 3;

-- UPDATE and RETURN
UPDATE courses
SET published_date = '2020-07-01'
WHERE course_id = 2
RETURNING *;

DROP TABLE courses;