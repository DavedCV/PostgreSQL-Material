/*
    basic database interaction
*/

-- table creation
CREATE TABLE users(
    name VARCHAR(128),
    email VARCHAR(128)
);

-- data insertion
INSERT INTO users (name, email) VALUES ('Chuck', 'csev@umich.edu');
INSERT INTO users (name, email) VALUES ('Colleen', 'cvl@umich.edu');
INSERT INTO users (name, email) VALUES ('Ted', 'ted@umich.edu');
INSERT INTO users (name, email) VALUES ('Sally', 'a1@umich.edu');
INSERT INTO users (name, email) VALUES ('Ted', 'ted@umich.edu');
INSERT INTO users (name, email) VALUES ('Kristen', 'kf@umich.edu');

-- data deletion
DELETE FROM users WHERE email='ted@umich.edu';

-- data updating
UPDATE users SET name="Charles" WHERE email='csev@umich.edu';

-- database query
SELECT * FROM users;

-- using where
SELECT * FROM users WHERE email='csev@umich.edu';

-- using order by
SELECT * FROM users ORDER BY email;
SELECT * FROM users ORDER BY name DESC;

-- using pattern matching
SELECT * FROM users WHERE name LIKE '%e%';

-- using limit and offset
SELECT * FROM users ORDER BY email DESC LIMIT 2;
SELECT * FROM users ORDER BY email OFFSET 1 LIMIT 2;

-- using aggregate functions
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM users WHERE email='csev@umich.edu';

-- table deletion
DROP TABLE users;

-- table creation with serial (auto_increment), primary key and unique constrain
CREATE TABLE users (
    id SERIAL,
    name VARCHAR(128),
    email VARCHAR(128) UNIQUE,
    PRIMARY KEY(id)
);

-- data insertion
INSERT INTO users (name, email) VALUES ('Chuck', 'csev@umich.edu');
INSERT INTO users (name, email) VALUES ('Colleen', 'cvl@umich.edu');
INSERT INTO users (name, email) VALUES ('Ted', 'ted@umich.edu');

-- Note the SERIAL field auto-supplied
SELECT * from users;

-- Watch for failure due to UNIQUE
INSERT INTO users (name, email) VALUES ('Ted', 'ted@umich.edu');
