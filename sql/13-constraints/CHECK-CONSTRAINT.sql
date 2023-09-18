/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- CHECK CONSTRAINT

    - A CHECK constraint is a kind of constraint that allows you to specify if values in a column must meet a
        specific requirement.
    - The CHECK constraint uses a Boolean expression to evaluate the values before they are inserted or updated to the column.
    - If the values pass the check, PostgreSQL will insert or update these values to the column. Otherwise, PostgreSQL
        will reject the changes and issue a constraint violation error.
    - The CHECK constraints are very useful to place additional logic to restrict values that the columns can accept
        at the database layer. By using the CHECK constraint, you can make sure that data is updated to the database
        correctly.
*/

-- Define PostgreSQL CHECK constraint for new tables -------------------------------------------------------------------

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR (50),
    last_name VARCHAR (50),
    birth_date DATE CHECK (birth_date > '1900-01-01'),
    joined_date DATE CHECK (joined_date > birth_date),
    salary numeric CHECK (salary > 0)
);

-- The insert failed because of the CHECK constraint on the salary column that accepts only positive values.
INSERT INTO
    employees (first_name, last_name, birth_date, joined_date, salary)
VALUES
    ('John', 'Doe', '1972-01-01', '2015-07-01', - 100000);

DROP TABLE employees;

-- Define PostgreSQL CHECK constraints for existing tables -------------------------------------------------------------

CREATE TABLE prices_list (
    id serial PRIMARY KEY,
    product_id INT NOT NULL,
    price NUMERIC NOT NULL,
    discount NUMERIC NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);

ALTER TABLE prices_list
ADD CONSTRAINT price_discount_check
CHECK (
    price > 0
    AND discount >= 0
    AND price > discount
);

ALTER TABLE prices_list
ADD CONSTRAINT valid_range_check
CHECK (valid_to >= valid_from);

DROP TABLE prices_list;