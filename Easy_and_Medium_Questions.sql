-- Q.1: Query to delete duplicate emails from the table.
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
DELETE p1 FROM Person as p1, Person as p2 WHERE p1.Email = p2.Email AND p1.Id > p2.Id;


-- Method 3
DELETE FROM your_table
WHERE EXISTS (
  SELECT 1
  FROM your_table t2
  WHERE t2.email = your_table.email
    AND t2.id < your_table.id);
/*
-- The SELECT 1 statement within the subquery serves as a placeholder or a dummy expression. 
-- It is a common practice to use SELECT 1 (or any other constant value) as a way to indicate the existence of a matching row without retrieving any actual data.
-- In this specific context, the purpose of the subquery is to check if there exists another row (t2) in the "your_table" table that has the same email but a smaller id than the current row being evaluated. 
-- If such a row exists, the EXISTS condition evaluates to true, indicating that a duplicate email record is found. 
-- The specific value being selected (1 in this case) does not matter since the subquery is only used for its existence and not for the data it retrieves. 
-- You could use any constant value, such as SELECT 42 or SELECT 'Hello', and it would function the same in this context.
-- The main purpose of the subquery is to provide a condition (EXISTS) that can be used in the WHERE clause of the DELETE statement to filter and remove rows that have duplicate email values.
*/

-- Q.2 Write an SQL query to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.
select activity_date as day, count(distinct(user_id)) as active_users from Activity 
where datediff('2019-07-27', activity_date)<30 --datediff count the number of days in between the given range.
and activity_date <= '2019-07-27'
group by activity_date;


-- Q.3: There is a factory website that has several machines each running the same number of processes. Write an SQL query to find the average time each machine takes to complete a process. 
-- The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.
-- The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

-- Code: 
select machine_id, 
ROUND((SUM( CASE WHEN ACTIVITY_TYPE = "end" then timestamp END)-
SUM( CASE WHEN ACTIVITY_TYPE = "start" then timestamp END))/COUNT(CASE WHEN ACTIVITY_TYPE ='start' THEN 1 END),3) as processing_time
from Activity
group by machine_id

-- Explanation : 
/* SUM(CASE WHEN ACTIVITY_TYPE = 'end' THEN timestamp END) calculates the sum of timestamps where the ACTIVITY_TYPE is 'end'. It adds up all the timestamps associated with activities marked as 'end'.
-- SUM(CASE WHEN ACTIVITY_TYPE = 'start' THEN timestamp END) calculates the sum of timestamps where the ACTIVITY_TYPE is 'start'. It adds up all the timestamps associated with activities marked as 'start'.
-- (SUM(...) - SUM(...)) subtracts the sum of 'start' timestamps from the sum of 'end' timestamps, resulting in the total duration of time elapsed between the start and end activities.
-- COUNT(CASE WHEN ACTIVITY_TYPE = 'start' THEN 1 END) counts the number of occurrences where the ACTIVITY_TYPE is 'start'. It counts the total number of 'start' activities.
-- (SUM(...) - SUM(...)) / COUNT(...) divides the time difference by the count of 'start' activities. This calculates the average processing time per 'start' activity.
-- ROUND(..., 3) rounds the result to 3 decimal places for better readability.
-- AS processing_time assigns the calculated value to a column named "processing_time" in the result set of the query.
-- By executing this code as part of an SQL query against a table named "Activity," you can obtain the average processing time per 'start' activity based on the timestamps of 'start' and 'end' activities.
*/



