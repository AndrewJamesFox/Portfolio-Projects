-- QUERIES
-- Query 1 : Which users have won more than 2 times? (simple)
SELECT ID, num_wins
FROM users
WHERE num_wins > 2;


-- Query 2 : How much money have users won in total? (aggregate)
SELECT sum(winnings) AS total_winnings
FROM users;


-- Query 3 : View the users and the team they belong to. (inner join)
SELECT u.ID, m.team_ID
FROM users AS u
INNER JOIN members AS m 
ON (u.ID = m.H_ID);


-- Query 4 : Which users are on team 2? (nested)
SELECT ID
FROM users
WHERE ID IN (
	SELECT H_ID
    FROM members
    WHERE team_ID = 102);
    

-- Query 5 : Select teams with at least three hunters (correlated)
SELECT t.team_ID
FROM team t
WHERE 2 <
	(SELECT COUNT(*)
	FROM members m
	WHERE m.team_ID = t.team_ID);


-- Query 6 : Who has the highest winnings on team 102? (ANY or ALL)
SELECT h.H_ID
FROM hunter AS H JOIN users AS U ON (h.H_ID = u.ID)
WHERE h.team_ID = 102
AND u.winnings >= ALL
	(SELECT winnings FROM users AS u JOIN hunter AS h ON (h.H_ID=u.ID));


-- Query 7 : Find hunters who are on a team or currently hunting for a treasure. (set operations)
SELECT H_ID
FROM hunter
WHERE team_ID IS NOT NULL
UNION
SELECT H_ID
FROM hunter
WHERE H_ID IN (SELECT H_ID FROM hunts_in);


-- Query 8 : Find the difficulty rating of treasures that haven't been found. (subquery in select/from)
SELECT hunt_ID, difficulty 
FROM (SELECT * FROM treasure_hunt WHERE found_date IS NULL) AS treasures;







