/* 
 Senario: We have duplicates in the users table, oh no!
 A bug we introduced in our backend code has created the same user record twice on signup, we must remove all
 duplicates and keep just one record. Here we can execute:
 (Credit to David Watson for conceiving the finesse below)
 */
DELETE FROM
  users
WHERE
  id IN (
    -- Select from users and join onto users using different aliases.
    SELECT
      DISTINCT users_first.id
    FROM
      users users_first
      JOIN users users_second ON -- Specify that we want records matched where the username is the same
      -- Or in other scenarious whatever should make each record unique.
      users_first.username = users_second.username -- Then select where the user ids are less than that of the second set,
      -- That will return all user records exept the last, which is the unique one we are keeping.
      AND users_second.id < users_first.id
  );

/*
 Now, going forward we want to prevent this ever happening again (I know we have already unique(username) on
 users but incase we didn't) so we add:
 */
ALTER TABLE
  users
ADD
  user_username_unique UNIQUE(username);

-- And vice versa if we needed to remove the constraint we would run.
ALTER TABLE
  users DROP CONSTRAINT IF EXISTS user_username_unique;