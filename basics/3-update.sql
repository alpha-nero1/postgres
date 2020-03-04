/*
  https://www.postgresql.org/docs/9.1/sql-update.html
*/
-- Now lets say that fishfoodz wants to change their username becuase it is silly.
-- We would run.
UPDATE users SET username = 'fishManGreatDan' where id = 3;
-- Note: the "UPDATE" token requires the "SET" token and will update fields specified
-- that correspond to the where clause provided.
-- To set multiple columns we can run either.
UPDATE users SET username = 'fishManGoon', first_name = 'Grobble', last_name = 'Tankerson' where id = 3;
-- or we can use parenthesis syntax.
UPDATE users SET (username, first_name, last_name) = ('fishManGoon', 'Grobble', 'Tankerson') where id = 3;
-- Note: "RETURNING" token is also valid on update.

/*
  FINESSE TIME!
  We want to create a new user and we want this new user to have the same first name and DOB as fishManGoon.
*/
INSERT INTO users (username, first_name, last_name, password, email, created_at, date_of_birth)
VALUES
('JohnR', 'John', 'Rowlands', 'Password1', 'john.rowlands@gmail.com', NOW(), '1950-07-07');

UPDATE users SET (first_name, date_of_birth) = (SELECT first_name, date_of_birth FROM users WHERE id = 3) WHERE id = 4;
-- AND If we want to grant the same permissions:
INSERT INTO user_roles VALUES (DEFAULT, 4, (SELECT role_id FROM user_roles WHERE user_id = 3), NOW());