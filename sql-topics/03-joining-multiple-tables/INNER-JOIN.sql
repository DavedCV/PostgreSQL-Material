/*
    Author: David Castrillón
    Date: 2023
*/

-- INNER JOIN

/*
    - To join table A with the table B. For each row in the table A, inner join compares the value in the selected
        column with the value in the selected column of every row in the table B: If these values are equal, the inner
        join creates a new row that contains all columns of both tables and adds it to the result set. In case these
        values are not equal, the inner join just ignores them and moves to the next row.
    - When both tables have the same column, you can use the USING syntax.
*/

-- INNER JOIN to join two tables
SELECT
    customer.customer_id,
    first_name,
    last_name,
    amount,
    payment_date
FROM
    customer
INNER JOIN payment
    ON payment.customer_id = customer.customer_id
ORDER BY payment_date;

-- INNER JOIN with USING
SELECT
    customer.customer_id,
    first_name,
    last_name,
    amount,
    payment_date
FROM
    customer
INNER JOIN payment USING(customer_id)
ORDER BY payment_date;

-- INNER JOIN to join 3 tables
-- staff, payment, customer
-- Each staff handles zero or many payments. And each payment is processed by one and only one staff.
-- Each customer made zero or many payments. Each payment is made by one customer.

SELECT
    c.customer_id,
    c.first_name customer_first_name,
    c.last_name customer_last_name,
    s.first_name staff_first_name,
    s.last_name staff_last_name,
    p.amount,
    p.payment_date
FROM customer c
INNER JOIN payment p
    ON p.customer_id = c.customer_id
INNER JOIN staff s
    ON p.staff_id = s.staff_id
ORDER BY p.payment_date;