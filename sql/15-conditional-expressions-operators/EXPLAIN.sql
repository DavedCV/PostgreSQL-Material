/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- EXPLAIN

    - The EXPLAIN statement returns the execution plan which PostgreSQL planner generates for a given statement.
    - The EXPLAIN shows how tables involved in a statement will be scanned by index scan or sequential scan, etc., and
        if multiple tables are used, what kind of join algorithm will be used.
    - The most important and useful information that the EXPLAIN statement returns are start-cost before the first row
        can be returned and the total cost to return the complete result set.

    EXPLAIN [ ( option [, ...] ) ] sql_statement;

    where option can be one of the following:
    ANALYZE [ boolean ]
    VERBOSE [ boolean ]
    COSTS [ boolean ]
    BUFFERS [ boolean ]
    TIMING [ boolean ]
    SUMMARY [ boolean ]
    FORMAT { TEXT | XML | JSON | YAML }

    The boolean specifies whether the selected option should be turned on or off. You can use TRUE, ON, or 1 to enable
    the option, and FALSE, OFF, or 0 to disable it. If you omit the boolean, it defaults to ON.

    The ANALYZE statement actually executes the SQL statement and discards the output information, therefore, if you
    want to analyze any statement such as INSERT, UPDATE, or DELETE without affecting the data, you should wrap
    the EXPLAIN ANALYZE in a transaction and ROLLBACK
*/

EXPLAIN SELECT * FROM film;
EXPLAIN SELECT * FROM film WHERE film_id = 100;
EXPLAIN SELECT COUNT(*) FROM film;

EXPLAIN ANALYZE
SELECT
    f.film_id,
    title,
    name category_name
FROM
    film f
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON c.category_id = fc.category_id
ORDER BY title;