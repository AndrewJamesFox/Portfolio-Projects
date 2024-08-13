-- POPULATING TABLES

-- EMPTY ALL TABLES
DELETE FROM users;
DELETE FROM creator;
DELETE FROM team;
DELETE FROM hunter;
DELETE FROM members;
DELETE FROM treasure_hunt;
DELETE FROM hunts_in;
DELETE FROM treasure;

-- TABLE users
INSERT INTO users (ID, SSN, first_name, last_name, email, age, address, num_wins, winnings) 
VALUES
  (1,5309,"Lamar","West","mauris@aol.couk",18,"5 Foo St.",3,20),
  (2,2089,"Katelyn","Reilly","magna.nam.ligula@icloud.edu",32,"26 Bar Ave.",8,92),
  (3,9365,"Brenna","Harrell","luctus.felis.purus@hotmail.org",21,"37 Dum Ln.",7,82),
  (4,5483,"Declan","Mclean","interdum@yahoo.com",37,"41 Dummer Ln.",2,16),
  (5,3923,"Ariana","Perkins","quis.accumsan@protonmail.org",35,"46 Dummest Ln.",2,34),
  (6,3985,"Uriah","Sutton","hymenaeos.mauris@protonmail.com",19,"38 Foo St.",7,78),
  (7,4280,"Cecilia","Tyler","sed.malesuada@protonmail.couk",28,"40 Bar Ave.",2,15),
  (8,9291,"Zachary","Kelley","vulputate.dui.nec@google.couk",23,"23 Fox St.",2,28),
  (9,5037,"Hedy","Calhoun","ut.nulla@protonmail.edu",24,"41 Joe St.",3,48),
  (10,8573,"Cecilia","Barnett","tincidunt.nunc.ac@yahoo.couk",41,"52 Shmo St.",4,43),
  (12,1102,"Stevie","Wonder","wonderkid@yahoo.couk",55,"52 Motown Dr.",8,105),
  (14,0921,"Diana","Ross","thesupreme@yahoo.couk",57,"21 Motown Dr.",1,5),
  (15,7824,"John","Lennon","iloveyokoono@yahoo.couk",65,"1 Liverpool St.",2,13),
  (16,2277,"Paul","McCartney","justletitbeman@yahoo.couk",63,"2 Liverpool St.",0,0),
  (18,0091,"Ringo","Starr","octopuslover@yahoo.couk",61,"3 Liverpool St.",0,0),
  (19,2854,"George","Harrison","bestbeatle@yahoo.couk",66,"4 Liverpool St.",0,0);

-- TABLE creator
INSERT INTO creator (C_ID)
VALUES
	(1),
    (3),
    (7),
	(12),
    (14),
    (15),
    (16),
    (18),
    (19);
    
-- TABLE team
INSERT INTO team (team_ID, size)
VALUES
	(102, 3),
    (103, 2);
    
-- TABLE hunter
INSERT INTO hunter (H_ID, mobile_lat, mobile_long, team_ID)
VALUES
  (1, -57.927427072,-64.3491790848, NULL),
  (2, -23.1896951808,32.3761432576, 102),
  (3, -65.08109568,-23.2782043136, NULL),
  (4, 78.475065856,175.7109351424, 102),
  (5, 79.0060015616,10.507190784, 103),
  (6, 88.663576576,-115.7045723136, 102),
  (7, 30.8415501312,-34.3938614272, NULL),
  (8, -64.2097180672,111.401597952, NULL),
  (9, -47.4421230592,-174.4167742464, 103),
  (10, 64.3873979392,-1.5559379968, NULL);
    
-- TABLE members
INSERT INTO members (team_ID, H_ID)
VALUES
	(102, 2),
    (102, 4),
    (102, 6),
    (103, 5),
    (103, 9);

-- TABLE treasure_hunt
INSERT INTO treasure_hunt (hunt_ID, difficulty, finder, found_date, end_date, time_limit, creation_date, C_ID)
VALUES
	(201, 3, NULL, NULL, NULL,"13:32","03-08-23", 1),
    (203, 1, 8, "2023-12-31","2023-12-31","23:58","2023-11-27", 3),
    (207, 5, 10, "2023-07-26","2023-07-26","15:05","2023-06-09", 7),
    (202, 1, NULL, NULL, NULL,"15:05","2023-06-09", 12),
    (204, 2, 10, "2023-07-26","2022-01-11","15:05","2022-03-09", 14),
    (205, 3, NULL, NULL, NULL,"15:05","2023-06-09", 15),
    (206, 4, 10, "2023-01-26","2022-12-22","15:05","2022-06-15", 16),
    (208, 4, NULL, NULL, NULL,"15:05","2023-02-20", 18),
    (209, 5, NULL, NULL, NULL,"15:05","2022-03-27", 19);
    
-- TABLE hunts_in
INSERT INTO hunts_in (H_ID, team_ID, hunt_ID, entry_fee)
VALUES
	(2, 102, 201, 50),
    (4, 102, 201, 50),
    (6, 102, 201, 50),
    (5, 103, 201, 75),
    (9, 103, 201, 75);
    
-- TABLE treasure
INSERT INTO treasure (hunt_ID, prize_value, latitude, longitude)
VALUES
	(201, 125, 32.83455987512, -234.9757742764),
    (202, 110, 38.83451728512, 34.7751742764),
    (203, 70, 18.43916987512, 13.9527112764),
    (204, 85, 14.83455982512, 33.1786742764),
    (205, 20, 43.98745987512, -48.3098242764),
    (206, 35, 41.92455987512, 46.3190242764),
    (207, 140, 32.92409487512, 58.0988242764),
    (208, 30, 98.92944987512, 11.1828242764),
    (209, 25, 143.99745997512, -31.3023842764);
    
    
-- SELECT all from tables
SELECT * FROM users;
SELECT * FROM creator;
SELECT * FROM team;
SELECT * FROM hunter;
SELECT * FROM members;
SELECT * FROM treasure_hunt;
SELECT * FROM hunts_in;
SELECT * FROM treasure;