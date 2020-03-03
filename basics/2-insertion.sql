-- Now we are going to want to fill our DB with some good ol' data.
-- To run an insert into users where all fields are specified run, ofcourse we could have just specified one user.
INSERT INTO
  users
VALUES
  (
    DEFAULT,
    'alesando1',
    'Alessandro',
    'Alberga',
    'CarrotMan1',
    'ale.alberga1@gmail.com',
    NOW(),
    NULL,
    NULL,
    DEFAULT
  ),
  (
    DEFAULT,
    'catdog',
    'Cat',
    'Dog',
    'Password1',
    'catdog@gmail.com',
    NOW(),
    NULL,
    NULL,
    DEFAULT
  ),
  (
    DEFAULT,
    'fishfoodz',
    'Fish',
    'Foodz',
    'Password1',
    'fishfoodz@gmail.com',
    NOW(),
    NULL,
    NULL,
    DEFAULT
  );

-- To insert and return, one may run:
INSERT INTO
  roles
VALUES
  (DEFAULT, 'emperor'),
  (DEFAULT, 'employee') RETURNING *;

-- Assign some roles!
INSERT INTO
  user_roles
VALUES
  (DEFAULT, 1, 1, NOW()),
  (DEFAULT, 2, 2, NOW()),
  (DEFAULT, 3, 2, NOW());