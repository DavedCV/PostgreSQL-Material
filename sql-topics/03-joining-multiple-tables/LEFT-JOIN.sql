/*
    Author: David Castrillón
    Date: 2023
*/

-- LEFT JOIN

/*
    - The LEFT JOIN clause starts selecting data from the left table. For each row in the left table, it compares
        the value in the selected column with the value of each row in the selected column in the right table. If these
        values are equal, the left join clause creates a new row that contains columns that appear in the SELECT
        clause and adds this row to the result set. In case these values are not equal, the left join clause also
        creates a new row that contains columns that appear in the SELECT clause. In addition, it fills the
        columns that come from the right table with NULL.
*/

-- Let’s look at the following film and inventory tables from the sample database.
-- Each row in the film table may have zero or many rows in the inventory table.
-- Each row in the inventory table has one and only one row in the film table.
-- The film_id column establishes the link between the film and inventory tables.

SELECT
    film.film_id,
    title,
    inventory_id
FROM
    film
LEFT JOIN inventory
    ON film.film_id = inventory.film_id
ORDER BY title;

-- find films that are not in the inventory
SELECT
    film.film_id,
    title,
    inventory_id
FROM
    film
LEFT JOIN inventory
    ON film.film_id = inventory.film_id
WHERE inventory.film_id ISNULL
ORDER BY title;