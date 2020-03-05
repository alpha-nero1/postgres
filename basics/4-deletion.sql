/*
 https://www.postgresql.org/docs/8.2/sql-droptable.html
 https://www.postgresql.org/docs/10/sql-delete.html
 */
-- Now lets create a dummy table to demonstrate deleting a table.
CREATE TABLE lollies(
  id INTEGER SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE
)
/* Now lets make a table that depends on lollies. */
CREATE TABLE user_lollies(
  id INTEGER SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  lolly_id INTEGER NOT NULL,
  CONSTRAINT user_lollies_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_lollies_lolly_id_fkey FOREIGN KEY (lolly_id) REFERENCES lollies (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
)
/*
 Now we've made everything and the council has decided that the lollies table is garbage, we need
 to remove it.
 
 In typical senario we would love to just:
 */
DROP TABLE lollies -- and be done with it.
/*
 But there is an issue, there are constraints on table user_lollies that NEED to reference the lollies table.
 We need to run a "DROP CASCADE" this will drop the specified table and andy tables that RELY on it i.e. user_lollies
 */
DROP TABLE lollies CASCADE;

/*
 Now the council has changed its mind we want to create lollies and give one to each user.
 Re-run the creations.
 */
INSERT INTO
  lollies
VALUES
  (DEFAULT, 'redskin'),
  (DEFAULT, 'chuppa chupp'),
  (DEFAULT, 'white chocolate');

/* And lets allocate them. */
INSERT INTO
  user_lollies
VALUES
  (DEFAULT, 1, 1),
  (DEFAULT, 2, 2),
  (DEFAULT, 3, 3);

/*
 Now the Jedi council has announced that white chocolate is not only terrible but it is
 NOT A LOLY ?!?!?!?
 
 We need to remove the record.
 */
DELETE FROM
  lollies
WHERE
  name = 'white chocolate' CASCADE;

/* 
 But this is going to leave user id 3 with nothing to snack on,
 this is outrageous, it's unfair, so we give them a chuppa chupp.
 */
INSERT INTO
  user_lollies
VALUES
  (DEFAULT, 3, 2);

/*
 Now lets say we want to remove all lollies from users whos first name and last name
 are 'Boris Johnson' we could run:
 */
DELETE FROM
  user_lollies ul USING users u
WHERE
  ul.user_id = u.id
  AND u.first_name = 'Boris'
  AND u.last_name = 'Johnson';

/* OR equivalently we can run a subquery, whichever is cooler is up to you! */
DELETE FROM
  user_lollies
WHERE
  user_id IN (
    SELECT
      id
    FROM
      users
    WHERE
      AND first_name = 'Boris'
      AND last_name = 'Johnson'
  );