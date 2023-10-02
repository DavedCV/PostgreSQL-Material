/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- CREATE TABLE

    A relational database consists of multiple related tables. A table consists of rows and columns. Tables allow you
    to store structured data like customers, products, employees, etc.

    To create a new table, you use the CREATE TABLE statement. The following illustrates the basic syntax of the
    CREATE TABLE statement:

    - First, specify the name of the table after the CREATE TABLE keywords.
    - Second, creating a table that already exists will result in a error. The IF NOT EXISTS option allows you to
        create the new table only if it does not exist. When you use the IF NOT EXISTS option and the table already exists,
        PostgreSQL issues a notice instead of the error and skips creating the new table.
    - Third, specify a comma-separated list of table columns. Each column consists of the column name, the kind of
        data that column stores, the length of data, and the column constraint. The column constraints specify rules
        that data stored in the column must follow. For example, the not-null constraint enforces the values in the
        column cannot be NULL. The column constraints include not null, unique, primary key, check, foreign key
        constraints.
    - Finally, specify the table constraints including primary key, foreign key, and check constraints.

    Note that some table constraints can be defined as column constraints like primary key, foreign key, check,
    unique constraints.
*/

/*
    -- CONSTRAINTS

    PostgreSQL includes the following column constraints:

    - NOT NULL – ensures that values in a column cannot be NULL.
    - UNIQUE – ensures the values in a column unique across the rows within the same table.
    - PRIMARY KEY – a primary key column uniquely identify rows in a table. A table can have one and only one primary
        key. The primary key constraint allows you to define the primary key of a table.
    - CHECK – a CHECK constraint ensures the data must satisfy a boolean expression.
    - FOREIGN KEY – ensures values in a column or a group of columns from a table exists in a column or group of
        columns in another table. Unlike the primary key, a table can have many foreign keys.

    Table constraints are similar to column constraints except that they are applied to more than one column.
*/

-- The following statement creates the accounts table:
CREATE TABLE accounts(
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP
);

-- The following statement creates the  roles table
CREATE TABLE roles(
  role_id SERIAL PRIMARY KEY,
  role_name VARCHAR(255) UNIQUE NOT NULL
);

/*
    -- The following statement creates the account_roles.

    - The primary key of the account_roles table consists of two columns: user_id and role_id, therefore, we have
        to define the primary key constraint as a table constraint.
    - Because the user_id column references to the user_id column in the accounts table, we need to define a foreign key
        constraint for the user_id column.
    - The role_id column references the role_id column in the roles table, we also need to define a foreign key
        constraint for the role_id column.
*/
CREATE TABLE account_roles(
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    grant_date TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (role_id) REFERENCES roles (role_id),
    FOREIGN KEY (user_id) REFERENCES accounts (user_id)
);

-- CLEANUP
DROP TABLE accounts CASCADE;
DROP TABLE roles CASCADE;
DROP TABLE account_roles CASCADE;

