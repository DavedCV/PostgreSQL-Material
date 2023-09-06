/*
    Author: David Castrillón
    Date: 2023
*/

-- INTERSECT

/*
    - Like the UNION operator, the PostgreSQL INTERSECT operator combines result sets of two or more SELECT statements
        into a single result set.
    - The INTERSECT operator returns any rows that are available in both result sets.
    - To use the INTERSECT operator, the columns that appear in the SELECT statements must follow the folowing rules:
        - The number of columns and their order in the SELECT clauses must be the same.
        - The data types of the columns must be compatible.
    - If you want to sort the result set returned by the INTERSECT operator, you place the ORDER BY at the final
        query in the query list
*/

-- sample tables with similar columns
CREATE TABLE top_rated_films(
    title VARCHAR NOT NULL,
    release_year SMALLINT
);
INSERT INTO
    top_rated_films(title,release_year)
VALUES
    ('The Shawshank Redemption',1994),
    ('The Godfather',1972),
    ('12 Angry Men',1957);
SELECT * FROM top_rated_films;

CREATE TABLE most_popular_films(
    title VARCHAR NOT NULL,
    release_year SMALLINT
);
INSERT INTO
    most_popular_films(title,release_year)
VALUES
    ('An American Pickle',2020),
    ('The Godfather',1972),
    ('Greyhound',2020);
SELECT * FROM most_popular_films;

-- INTERSECT

SELECT * FROM most_popular_films
INTERSECT
SELECT * FROM top_rated_films;

--cleanup
DROP TABLE most_popular_films;
DROP TABLE top_rated_films;