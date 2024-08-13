-- Create schema for database
CREATE SCHEMA IF NOT EXISTS treasure_hunt_app;

-- Use treasure_hunt_app schema
USE treasure_hunt_app;

-- DROP all tables before creation in case of updates
DROP TABLE IF EXISTS users, creator, team, hunter, members, treasure_hunt, hunts_in, treasure;

-- CREATE TABLES
-- Create users table
CREATE TABLE IF NOT EXISTS users (
	ID SMALLINT NOT NULL PRIMARY KEY,
    SSN CHAR(11),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    age NUMERIC NOT NULL,
    address VARCHAR(255),
    num_wins SMALLINT,
    winnings SMALLINT
);

-- Create creator table
CREATE TABLE IF NOT EXISTS creator (
	C_ID SMALLINT NOT NULL PRIMARY KEY,
	FOREIGN KEY (C_ID) REFERENCES users (ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create team table
CREATE TABLE IF NOT EXISTS team (
	team_ID SMALLINT NOT NULL PRIMARY KEY,
    size TINYINT
);

-- Create hunter table
CREATE TABLE IF NOT EXISTS hunter (
	H_ID SMALLINT NOT NULL PRIMARY KEY,
    mobile_lat FLOAT(12, 9) NOT NULL,
    mobile_long FLOAT(12, 9) NOT NULL,
    team_ID SMALLINT NULL,
    FOREIGN KEY (team_ID) REFERENCES team (team_ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create members table
CREATE TABLE IF NOT EXISTS members (
	team_ID SMALLINT NOT NULL,
    H_ID SMALLINT NOT NULL,
    FOREIGN KEY (team_ID) REFERENCES team (team_ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (H_ID) REFERENCES hunter (H_ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create treasure_hunt table
CREATE TABLE IF NOT EXISTS treasure_hunt (
	hunt_ID SMALLINT NOT NULL PRIMARY KEY,
    difficulty TINYINT,
    finder SMALLINT NULL,
    found_date DATE,
    end_date DATE,
    time_limit TIME,
    creation_date DATE,
    C_ID SMALLINT NOT NULL,
    FOREIGN KEY (finder) REFERENCES USERS (ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (C_ID) REFERENCES creator (C_ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create hunts_in table
CREATE TABLE IF NOT EXISTS hunts_in (
	H_ID SMALLINT NOT NULL,
    team_ID SMALLINT NULL,
    hunt_ID SMALLINT NOT NULL,
    PRIMARY KEY (H_ID, hunt_ID),
    entry_fee SMALLINT,
    FOREIGN KEY (H_ID) REFERENCES hunter (H_ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (team_ID) REFERENCES team (team_ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (hunt_ID) REFERENCES treasure_hunt (hunt_ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);

-- Crate treasure table
CREATE TABLE IF NOT EXISTS treasure (
	hunt_ID SMALLINT NOT NULL PRIMARY KEY,
    prize_value SMALLINT,
    latitude FLOAT(12, 9) NOT NULL,
    longitude FLOAT(12, 9) NOT NULL,
    FOREIGN KEY (hunt_ID) REFERENCES treasure_hunt (hunt_ID)
		ON DELETE CASCADE ON UPDATE CASCADE
);





