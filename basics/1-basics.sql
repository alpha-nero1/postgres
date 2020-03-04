-- Table creation basics based off: https://www.postgresqltutorial.com/postgresql-create-table/
-- A great resource!
-- You can also find a reference for all commands here: https://www.postgresql.org/docs/9.1/sql-commands.html
/*
 Things to consider before the create:
 Column constraints one can use are:
 a. NOT NULL – the value of the column cannot be NULL.
 b. UNIQUE – the value of the column must be unique across the whole table. However, the column can have many NULL values because PostgreSQL treats each NULL value to be unique. Notice that SQL standard only allows one NULL value in the column that has the UNIQUE constraint.
 c. PRIMARY KEY – this constraint is the combination of NOT NULL and UNIQUE constraints. You can define one column as PRIMARY KEY by using column-level constraint. In case the primary key contains multiple columns, you must use the table-level constraint.
 d. CHECK – enables to check a condition when you insert or update data. For example, the values in the price column of the product table must be positive values.
 e. REFERENCES – constrains the value of the column that exists in a column in another table. You use REFERENCES to define the foreign key constraint.
 */
CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP NOT NULL,
  last_login TIMESTAMP,
  date_of_birth DATE,
  disabled BOOLEAN NOT NULL DEFAULT FALSE
);

-- Lets say you forgot to add a PK (one that auto-increments), you could add it later.
ALTER TABLE
  users
ADD
  COLUMN id SERIAL PRIMARY KEY;

/* Now lets say the users need roles, a new role table is needed. We will make the link later. */
CREATE TABLE roles(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  disabled BOOLEAN NOT NULL DEFAULT FALSE
);
/* And now each user has a role so we need to add the relation. */
CREATE TABLE user_roles(
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  grant_date TIMESTAMP WITHOUT TIME ZONE,
  -- Joint primary key def.
  PRIMARY KEY (user_id, role_id),
  -- Constraint definitions, kinda as you would column decs.
  CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
); -- And to create an index which will order user ids and make querying more efficient (but deal a blow to mutations) the following is done:
CREATE INDEX user_roles_user_id_idx ON user_roles (user_id);

-- Notice that PRIMARY KEY(user_id, role_id) will create an index but only with the joint params like (1-1) and searching for instance:
SELECT
  *
FROM
  user_roles
WHERE
  user_id = 1;

-- will not trigger a lookup of the index because you didnt specify both for the where statement i.e.
SELECT
  *
FROM
  user_roles
WHERE
  user_id = 1
  AND role_id = 1;

-- Therefore becuase we will almost always search for user_id on this particular link table, the correct and most efficient definition is:
CREATE TABLE user_roles(
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  grant_date TIMESTAMP WITHOUT TIME ZONE,
  -- Constraint definitions, kinda as you would column decs.
  CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE INDEX user_roles_user_id_idx ON user_roles (user_id);

/*
 Aditionally to see how a query is really operating you can use the "EXPLAIN" and "EXPLAIN ANALYZE" tokens before running the query.
 For mysql and other DB's this token is usually "DESCRIBE". Therefore you can verify that an index is being used in this way.
 */
EXPLAIN ANALYZE
SELECT
  *
FROM
  user_roles
WHERE
  user_id = 1;