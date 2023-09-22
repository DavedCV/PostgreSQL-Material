/*
    Author: David Castrillón
    Date: 2023
*/

/*
    -- NULLIF

    The NULLIF function returns a null value if argument_1 equals to argument_2, otherwise it returns argument_1.
*/

SELECT NULLIF (1, 1); -- return NULL
SELECT NULLIF (1, 0); -- return 1
SELECT NULLIF ('A', 'B'); -- return A

-- SAMPLE TABLE
CREATE TABLE posts (
    id serial primary key,
    title VARCHAR (255) NOT NULL,
    excerpt VARCHAR (150),
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

INSERT INTO
    posts (title, excerpt, body)
VALUES
    ('test post 1','test post excerpt 1','test post body 1'),
    ('test post 2','','test post body 2'),
    ('test post 3', null ,'test post body 3');

SELECT
    ID,
    title,
    excerpt
FROM
    posts;

SELECT
    id,
    title,
    COALESCE (excerpt, LEFT(body, 40))
FROM
    posts;

-- BECAUSE THERE ARE A MIX OF NULL AND EMPTY STRING WE USE NULLIF
SELECT
    id,
    title,
    COALESCE (
        NULLIF (excerpt, ''),
        LEFT (body, 40)
    )
FROM
    posts;

-- Use NULLIF to prevent division-by-zero error
CREATE TABLE members (
    ID serial PRIMARY KEY,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    gender SMALLINT NOT NULL -- 1: male, 2 female
);

INSERT INTO
    members (first_name, last_name, gender)
VALUES
    ('John', 'Doe', 1),
    ('David', 'Dave', 1),
    ('Bush', 'Lily', 2);

-- If the number of females is zero we prevent this division by zero error, using the NULLIF function
-- as follows:
SELECT
        (SUM (
            CASE
                WHEN gender = 1 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF (
            SUM (
                CASE
                    WHEN gender = 2 THEN 1
                    ELSE 0
                END
            ), 0
        )) * 100 AS "Male/Female ratio"
FROM
    members;

-- CLEANUP
DROP TABLE members;
DROP TABLE posts;