drop database if exists ipl;
create database ipl ;
use ipl;
drop table if exists matches; 
CREATE TABLE matches (
    ID INT PRIMARY KEY UNIQUE NOT NULL,
    season VARCHAR(255),
    city VARCHAR(255),
    date DATE,
    Team1 VARCHAR(255),
    Team2 VARCHAR(255),
    TossWinner VARCHAR(255),
    TossDecision VARCHAR(255),
    Result VARCHAR(255),
    DLappied INT,
    Winner VARCHAR(255),
    WinbyRuns INT,
    WinbyWickets INT,
    PlayerofMatch VARCHAR(255),
    Venue VARCHAR(255),
    Umpire1 VARCHAR(255),
    Umpire2 VARCHAR(255),
    Umpire3 VARCHAR(255)
);

SELECT 
    *
FROM
    matches;

CREATE TABLE deliveries (
    MatchID INT,
    Inning INT,
    BattingTeam VARCHAR(255),
    BowlingTeam VARCHAR(255),
    Over_ INT,
    Ball INT,
    Batsman VARCHAR(255),
    NonStriker VARCHAR(255),
    Bowler VARCHAR(255),
    IsSuperOver INT,
    WideRuns INT,
    ByeRuns INT,
    LegByeRuns INT,
    NoBallRuns INT,
    PenaltyRuns INT,
    BatsmanRuns INT,
    ExtraRuns INT,
    TotalRuns INT,
    PlayerDismissed VARCHAR(255),
    DismissalKind VARCHAR(255),
    Fielder VARCHAR(255),
    FOREIGN KEY (MatchID)
        REFERENCES matches (ID)
);


show tables;

SELECT 
    *
FROM
    deliveries;


use ipl;

-- 1.City which hosted most number of seasons according to the data is

SELECT 
    city
FROM
    matches
GROUP BY city
ORDER BY COUNT(city) DESC
LIMIT 1;

-- 2.Which year has the most number of matches played?

SELECT 
    season,COUNT(*) as No_of_Matches
FROM
    matches
GROUP BY season
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 3.Maximum wins by Mumbai Indians in 2011 are

SELECT 
    winner,COUNT(*) AS Wins
FROM
    matches
WHERE
    winner = 'mumbai indians'
        AND season = '2011';

-- 4.What is the percentage of getting bat and field in feature 'toss_descision'?

with cte1 as 
(select tossdecision ,count(*) as count  from matches
group by tossdecision),
cte2 as
(select sum(count) as sum from cte1),
cte3 as 
(select * from cte1
join cte2)
select tossdecision as TossDecision,(count/sum)*100 as Percentange from cte3
;

-- 5.In which years where taking batting second have won more number of matches?

SELECT 
    season, COUNT(*) AS count
FROM
    matches
WHERE
    tossdecision = 'field'
        AND tosswinner = winner
GROUP BY season
ORDER BY count DESC;

-- 6.In 2019 which batsman scored highest number of runs by hitting 6's and 4's?

with cte1 as 
(select * from matches as m
join deliveries as d
on m.id = d.matchid
where season = '2019')
select batsman,sum(batsmanruns) as Total from cte1
where batsmanruns = 6 or batsmanruns = 4
group by batsman
order by total desc
limit 5;

-- 7.Most number of wickets taken by a bowler is

SELECT 
    bowler, COUNT(*) AS Wickets
FROM
    deliveries
WHERE
    dismissalkind = 'bowled'
        OR dismissalkind = 'caught'
        OR dismissalkind = 'lbw'
        OR dismissalkind = 'caught and bowled'
        OR dismissalkind = 'stumped'
        OR dismissalkind = 'hit wicket'
GROUP BY bowler
ORDER BY Wickets DESC
LIMIT 5;

-- 8.What is the strike rate of Kohli in 2016
-- HINT: strike rate = (Total Runs / Total Balls Faced) * 100

with cte1 as 
(select * from matches as m
join deliveries as d
on m.id = d.matchid
where season = '2016' and batsman = 'v kohli'
),
cte2 as 
(select (sum(batsmanruns)/count(*))*100 as Strikerate from cte1
where batsman = 'v kohli'),
cte3 as 
(select * from cte1
join cte2 )
select strikerate from cte3
limit 1;


--  9.Bowlers with maximum number of extras

SELECT 
    bowler, SUM(extraruns) AS ExtraRuns
FROM
    deliveries
GROUP BY bowler
ORDER BY ExtraRuns DESC
LIMIT 1;

-- 10.Which venue has hosted most number of IPL matches?

SELECT 
    venue, COUNT(*) AS count
FROM
    matches
GROUP BY venue
ORDER BY count DESC
LIMIT 1;

-- 11. In 2017 when sunrisers hyderabad clashed against Royal Challengers Bangalore which team player won player of the match?

SELECT 
    Playerofmatch AS Player_of_the_Match
FROM
    matches
WHERE
    winner = 'Sunrisers hyderabad'
        AND season = '2017'
        AND (team1
        OR team2 = 'Royal Challengers Bangalore');
        
-- 12.Across seasons who are the top three batsman's with most number of run out?

SELECT 
    batsman, COUNT(*) AS count
FROM
    deliveries
WHERE
    dismissalkind = 'run out'
GROUP BY batsman
ORDER BY count DESC
LIMIT 3;

-- 13.What are the total runs scored by V Kohli when the bowler was JJ Burmah?

SELECT 
    SUM(batsmanruns) AS Runs
FROM
    deliveries
WHERE
    batsman = 'v kohli'
        AND bowler = 'jj bumrah';
        
        
-- 14.Across all seasons which player was dismissed the maximum number of times via caught and bowled

SELECT 
    batsman, COUNT(*) AS count
FROM
    deliveries
WHERE
    dismissalkind = 'caught and bowled'
GROUP BY batsman
ORDER BY count DESC
LIMIT 1;


-- 15.which player has the highest hard-hitting ability?

SELECT 
    batsman, COUNT(batsmanruns) AS count
FROM
    deliveries
WHERE
    batsmanruns = 6
GROUP BY batsman
ORDER BY count DESC
LIMIT 1;



