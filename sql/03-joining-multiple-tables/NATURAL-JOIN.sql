/*
    Author: David Castrillón
    Date: 2023
*/

-- NATURAL JOIN

/*
    - A natural join is a join that creates an implicit join based on the same column names in
        the joined tables.
    - A natural join can be an inner join, left join, or right join. If you do not specify a join explicitly
        e.g., INNER JOIN, LEFT JOIN, RIGHT JOIN, PostgreSQL will use the INNER JOIN by default.
    -  If you use the asterisk (*) in the select list, the result will contain the following columns:
            - All the common columns, which are the columns from both tables that have the same name.
            - Every column from both tables, which is not a common column.
    - The convenience of the NATURAL JOIN is that it does not require you to specify the join clause because it
        uses an implicit join clause based on the common column.
    - However, you should avoid using the NATURAL JOIN whenever possible because sometimes it may
        cause an unexpected result, for example, when there are more than one common column, natural join
        tends to use the last, and that column could not be a foreign key.
*/

-- sample tables
-- The category_id is the common column that we will use to perform the natural join.

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR (255) NOT NULL
);
INSERT INTO categories (category_name)
VALUES
    ('Smart Phone'),
    ('Laptop'),
    ('Tablet');
SELECT * FROM categories;

CREATE TABLE products (
    product_id serial PRIMARY KEY,
    product_name VARCHAR (255) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories (category_id)
);
INSERT INTO products (product_name, category_id)
VALUES
    ('iPhone', 1),
    ('Samsung Galaxy', 1),
    ('HP Elite', 2),
    ('Lenovo Thinkpad', 2),
    ('iPad', 3),
    ('Kindle Fire', 3);
SELECT * FROM products;

-- NATURAL JOIN
SELECT
    *
FROM
    products
NATURAL JOIN categories;

SELECT * FROM city
NATURAL JOIN country;

-- cleanup
DROP TABLE products;
DROP TABLE categories;
