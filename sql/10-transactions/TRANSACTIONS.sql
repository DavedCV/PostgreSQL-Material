/*
    Author: David Castrillón
    Date: 2023
*/

-- TRANSACTIONS

/*
    A database transaction is a single unit of work that consists of one or more operations.

    A classical example of a transaction is a bank transfer from one account to another. A complete transaction must
    ensure a balance between the sender and receiver accounts. It means that if the sender account transfers X amount,
    the receiver receives X amount, no more or no less.

    A PostgreSQL transaction is atomic, consistent, isolated, and durable. These properties are often referred to as
    ACID:

    - Atomicity guarantees that the transaction completes in an all-or-nothing manner.
    - Consistency ensures the change to data written to the database must be valid and follow predefined rules.
    - Isolation determines how transaction integrity is visible to other transactions.
    - Durability makes sure that transactions that have been committed will be stored in the database permanently.

*/

-- sample table

CREATE TABLE accounts (
    id INT GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    balance DEC(15,2) NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO accounts(name,balance)
VALUES('Bob',10000);

-- start a TRANSACTION
BEGIN TRANSACTION;

-- insert a new row into the accounts table
INSERT INTO accounts(name,balance)
VALUES('Alice',10000);

-- COMMIT the change (or roll it back later)
COMMIT TRANSACTION;

/*

    PostgreSQL COMMIT: Bank account transfer example

    In this demonstration, we will show you how to transfer 1000USD from Bob’s account to Alice’s account.
    We will use two sessions for viewing the change of each operation.

*/

BEGIN TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

-- In the second session, check the account balance of both accounts:
SELECT
    id,
    name,
    balance
FROM
    accounts;

-- add same amount to alice's account
UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT TRANSACTION;

-- see from any session
SELECT
    id,
    name,
    balance
FROM
    accounts;

-- ROLLING BACK a TRANSACTION
-- To roll back or undo the change of the current transaction, you use any of the following statement:
ROLLBACK TRANSACTION;

-- cleanup
DROP TABLE accounts;