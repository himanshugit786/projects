create database sport_tournament_tracker;
use sport_tournament_tracker;

CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team_id INT,
    position VARCHAR(50),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

CREATE TABLE Matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    match_date DATE NOT NULL,
    team1_id INT,
    team2_id INT,
    team1_score INT DEFAULT 0,
    team2_score INT DEFAULT 0,
    venue VARCHAR(100),
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id)
);

CREATE TABLE Stats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT,
    player_id INT,
    points_scored INT DEFAULT 0,
    assists INT DEFAULT 0,
    rebounds INT DEFAULT 0,
    fouls INT DEFAULT 0,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);
-- Insert Teams
INSERT INTO Teams (team_name) VALUES
('Eagles'), ('Tigers'), ('Sharks'), ('Wolves');

-- Insert Players
INSERT INTO Players (player_name, team_id, position) VALUES
('Alice Johnson', 1, 'Forward'),
('Bob Smith', 1, 'Guard'),
('Charlie Lee', 2, 'Center'),
('Diana Prince', 2, 'Forward'),
('Evan Davis', 3, 'Guard'),
('Fiona White', 3, 'Forward'),
('George King', 4, 'Center'),
('Hannah Scott', 4, 'Guard');

INSERT INTO Matches (match_date, team1_id, team2_id, team1_score, team2_score, venue) VALUES
('2024-06-01', 1, 2, 78, 65, 'Stadium A'),
('2024-06-02', 3, 4, 55, 60, 'Stadium B'),
('2024-06-05', 1, 3, 82, 75, 'Stadium A'),
('2024-06-06', 2, 4, 70, 69, 'Stadium C');

INSERT INTO Stats (match_id, player_id, points_scored, assists, rebounds, fouls) VALUES
(1, 1, 25, 5, 8, 2),
(1, 2, 20, 7, 3, 1),
(1, 3, 30, 4, 10, 3),
(1, 4, 15, 2, 5, 4),

(2, 5, 22, 6, 7, 2),
(2, 6, 18, 7, 4, 2),
(2, 7, 28, 3, 11, 3),
(2, 8, 20, 5, 6, 1),

(3, 1, 35, 4, 9, 2),
(3, 2, 28, 8, 3, 0),
(3, 5, 25, 6, 5, 1),
(3, 6, 20, 3, 7, 1),

(4, 3, 24, 7, 9, 2),
(4, 4, 18, 6, 6, 3),
(4, 7, 30, 2, 12, 4),
(4, 8, 19, 5, 4, 2);
-- Query: Get all match results ordered by date
SELECT 
  m.match_id,
  m.match_date,
  t1.team_name AS team1,
  m.team1_score,
  t2.team_name AS team2,
  m.team2_score,
  m.venue
FROM Matches m
JOIN Teams t1 ON m.team1_id = t1.team_id
JOIN Teams t2 ON m.team2_id = t2.team_id
ORDER BY m.match_date;

SELECT 
  p.player_name,
  t.team_name,
  SUM(s.points_scored) AS total_points,
  SUM(s.assists) AS total_assists,
  SUM(s.rebounds) AS total_rebounds
FROM Stats s
JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
GROUP BY p.player_id
ORDER BY total_points DESC;
-- Leaderboard: Team standings by points (Win=3, Draw=1, Loss=0)
CREATE OR REPLACE VIEW TeamStandings AS
SELECT 
    team_id,
    team_name,
    COUNT(*) AS games_played,
    SUM(CASE 
        WHEN (team_id = Matches.team1_id AND team1_score > team2_score) OR (team_id = Matches.team2_id AND team2_score > team1_score) THEN 1 
        ELSE 0 
    END) AS wins,
    SUM(CASE 
        WHEN team1_score = team2_score THEN 1 
        ELSE 0 
    END) AS draws,
    SUM(CASE 
        WHEN (team_id = Matches.team1_id AND team1_score < team2_score) OR (team_id = Matches.team2_id AND team2_score < team1_score) THEN 1 
        ELSE 0 
    END) AS losses,
    SUM(CASE 
        WHEN team_id = Matches.team1_id THEN team1_score
        WHEN team_id = Matches.team2_id THEN team2_score
        ELSE 0 
    END) AS goals_for,
    SUM(CASE 
        WHEN team_id = Matches.team1_id THEN team2_score
        WHEN team_id = Matches.team2_id THEN team1_score
        ELSE 0 
    END) AS goals_against
FROM Teams
JOIN Matches ON (team_id = Matches.team1_id OR team_id = Matches.team2_id)
GROUP BY team_id, team_name
ORDER BY (wins * 3 + draws) DESC, (goals_for - goals_against) DESC;

CREATE OR REPLACE VIEW PlayerLeaderboard AS
SELECT 
  p.player_id,
  p.player_name,
  t.team_name,
  SUM(points_scored) AS total_points,
  SUM(assists) AS total_assists,
  SUM(rebounds) AS total_rebounds
FROM Stats s
JOIN Players p ON s.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
GROUP BY p.player_id
ORDER BY total_points DESC;
-- CTE to calculate average stats per player
WITH AvgPlayerPerformance AS (
  SELECT 
    p.player_id,
    p.player_name,
    t.team_name,
    COUNT(s.match_id) AS matches_played,
    AVG(s.points_scored) AS avg_points,
    AVG(s.assists) AS avg_assists,
    AVG(s.rebounds) AS avg_rebounds
  FROM Stats s
  JOIN Players p ON s.player_id = p.player_id
  JOIN Teams t ON p.team_id = t.team_id
  GROUP BY p.player_id
)
SELECT * FROM AvgPlayerPerformance
ORDER BY avg_points DESC;
SELECT 
  ts.team_name,
  ts.games_played,
  ts.wins,
  ts.draws,
  ts.losses,
  ts.goals_for,
  ts.goals_against,
  (ts.wins * 3 + ts.draws) AS points
FROM TeamStandings ts
ORDER BY points DESC, (ts.goals_for - ts.goals_against) DESC;
