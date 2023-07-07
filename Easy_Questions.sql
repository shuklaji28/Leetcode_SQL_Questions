-- Q.1 : Query to delete duplicate emails from the table.


-- Method 1
DELETE FROM Person
WHERE email IN (
  SELECT email
  FROM (
    SELECT email, ROW_NUMBER() OVER (PARTITION BY email ORDER BY email) AS rn
    FROM Person
  ) AS subquery
  WHERE rn > 1
);


--Method 2
