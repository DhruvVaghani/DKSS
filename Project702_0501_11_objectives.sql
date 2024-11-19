USE BUDT702_Project_0501_11

-- Q1) Which season had the maximum number of wins in the past 3 years? What was the reason behind this win?
--     below query gives the season having maximum wins
SELECT s.seasonYear AS 'Year', g.seasonId, COUNT(g.gameResult) AS 'Total Win per Season'
FROM [DKSS.Game] g
	JOIN [DKSS.Season] s ON g.seasonId = s.seasonId
WHERE gameResult = 'UMD'
GROUP BY g.seasonId, s.seasonYear
HAVING COUNT(g.gameResult) = (
        SELECT MAX(WinCount)
        FROM (
            SELECT COUNT(gameResult) AS WinCount
            FROM [DKSS.Game]
            WHERE gameResult = 'UMD'
            GROUP BY seasonId )
        AS WinCounts
 )
-- below query gives all the result in descending order of wins
SELECT s.seasonYear AS 'Year', g.seasonId, COUNT(g.gameResult) AS 'Total Win per Season'
FROM [DKSS.Game] g
	JOIN [DKSS.Season] s ON g.seasonId = s.seasonId
WHERE gameResult = 'UMD'
GROUP BY g.seasonId, s.seasonYear
ORDER BY [Total Win per Season] DESC

-- we can also confirm why season had the maximum wins. Average goal scored was good although not highest but 
-- the reason behind this win is due to lowest average of goals conceded. This shows that our defence was strong.

SELECT s.seasonId, s.seasonGoal AS TotalGoals, s.seasonGoalConceded AS 'Total Goals Conceded', COUNT(g.gameId) AS 'Total Games', 
	ROUND(CAST(s.seasonGoal AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS 'Avg Goals PerGame',
    ROUND(CAST(s.seasonGoalConceded AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS 'Avg Goals Conceded PerGame'
FROM [DKSS.Season] s
	LEFT JOIN [DKSS.Game] g ON s.seasonId = g.seasonId
GROUP BY s.seasonId, s.seasonGoal, s.seasonGoalConceded
ORDER BY TotalGoals DESC;

-- End of question 1 

--Q2. Which season had the weakest performance? Identify the reason behind weakest performance. 
-- below query shows that lowest win was in S3
SELECT s.seasonId, s.seasonYear, ROUND(CAST(SUM(CASE WHEN g.gameresult = 'UMD' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(g.gameid) * 100,2) AS 'Win Percentage'
FROM [DKSS.Season] s
	LEFT JOIN [DKSS.Game] g ON s.seasonId = g.seasonid
GROUP BY s.seasonId, s.seasonYear
ORDER BY [Win Percentage];

-- below query gives the season average cards per game. S3 had maximum cards (yellow and red)
SELECT s.seasonId, SUM(us.umdStatRedCard + us.umdStatYellowCard) AS TotalCards, COUNT(g.gameId) AS TotalGames, 
	ROUND(CAST(SUM(us.umdStatRedCard + us.umdStatYellowCard) AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS AvgCardsPerGame
FROM [DKSS.Game] g
	JOIN [DKSS.Season] s ON g.seasonId = s.seasonId
	JOIN [DKSS.UmdStat] us ON g.umdStatId = us.umdStatId
GROUP BY s.seasonId
ORDER BY TotalCards DESC;


-- Below query gives the details of average shot per game. Though the shots are high in S03 the conversion 
-- of shots to goals is low which can be reason of poor performance

SELECT s.seasonId, SUM(u.umdStatShotFirstHalf + u.umdStatShotSecondHalf) AS TotalShots, COUNT(g.gameId) AS TotalGames, 
	ROUND(CAST(SUM(u.umdStatShotFirstHalf + u.umdStatShotSecondHalf) AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS AverageShotsPerGame
FROM [DKSS.Game] g
	JOIN [DKSS.Season] s ON g.seasonId = s.seasonId
	JOIN [DKSS.UmdStat] u ON g.umdStatId = u.umdStatId
GROUP BY s.seasonId
ORDER BY TotalShots DESC;

-- the reason behind team’s underperformance. Goals conceded were highest in S3

SELECT s.seasonId, s.seasonGoal AS TotalGoals, s.seasonGoalConceded AS TotalGoalsConceded, COUNT(g.gameId) AS TotalGames, 
	ROUND(CAST(s.seasonGoal AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS AvgGoalsPerGame, 
	ROUND(CAST(s.seasonGoalConceded AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS AvgGoalsConcededPerGame
FROM [DKSS.Season] s
	LEFT JOIN [DKSS.Game] g ON s.seasonId = g.seasonId
GROUP BY s.seasonId, s.seasonGoal, s.seasonGoalConceded
ORDER BY AvgGoalsConcededPerGame DESC;



--Q3. Which opponents did our team perform poorly against, and what were the contributing factors to these performances?

-- Below Query gives the list of opponents against whom UMD lost most number of matches across all 3 seasons
SELECT g.gameResult AS 'Opponent Name', COUNT(*) AS 'Matches Lost'
FROM [DKSS.Game] g
WHERE g.gameResult != 'UMD' AND g.gameResult != 'Tie'
GROUP BY g.gameResult
ORDER BY 'Matches Lost' DESC

-- doing a deeper analysis of shots between first and second half
-- Below Query shows shots in first & second half for opponents against whom UMD lost most number of matches


DROP VIEW IF EXISTS GameStatistics
GO
CREATE VIEW GameStatistics AS
SELECT 
    g.gameResult AS 'Opponent Name', 
    u.umdStatShotFirstHalf AS 'UMD Stat Shot First Half', 
    o.opponentStatShotFirstHalf AS 'Opponent Stat Shot First Half',
    u.umdStatShotSecondHalf AS 'UMD Stat Shot Second Half', 
    o.opponentStatShotSecondHalf AS 'Opponent Stat Shot Second Half'
FROM 
    [DKSS.Game] g 
JOIN 
    [DKSS.UmdStat] u ON g.umdStatId = u.umdStatId
JOIN 
    [DKSS.OpponentStat] o ON g.opponentStatId = o.opponentStatId
WHERE 
    g.gameResult IN ('Indiana', 'Penn St.', 'Wisconsin')

SELECT * FROM GameStatistics

-- Below Query shows Total Fouls committed by opponents and UMD
--For opponents with whom our team lost the most matches it is observed that the opponent team was aggressive. 
--This is derived from the data that in those matches the opponent team committed the most fouls. 
--Furthermore, our team had the most yellow cards which emphasizes that our team goes into defensive mode against such opponents and may try to intentionally 
--disrupt the opponent’s flow. 
SELECT g.gameId ,g.gameResult AS 'Game Result', u.umdStatFoul, o.opponentStatFoul
FROM [DKSS.Game] g JOIN [DKSS.UmdStat] u
	ON g.umdStatId = u.umdStatId
	JOIN [DKSS.OpponentStat] o
		ON g.opponentStatId = o.opponentStatId
WHERE g.gameResult IN ('Indiana', 'Penn St.', 'Wisconsin')
ORDER BY g.gameResult

-- Below Query shows Total Yellow Cards and Red Cards given to opponents and UMD
SELECT g.gameId AS 'Game Id',g.gameResult AS 'Game Result', u.umdStatYellowCard AS 'UMD Stat Yellow Card', o.opponentStatYellowCard AS 'Opponent Stat Yellow Card' , u.umdStatRedCard AS 'UMD Stat Red Card', o.opponentStatRedCard AS 'Opponent Stat Red Card', g.seasonId AS 'Season Id'
FROM [DKSS.Game] g JOIN [DKSS.UmdStat] u
	ON g.umdStatId = u.umdStatId
	JOIN [DKSS.OpponentStat] o
		ON g.opponentStatId = o.opponentStatId
WHERE g.gameResult IN ('Indiana', 'Penn St.', 'Wisconsin')
ORDER BY g.gameResult

-- Below Query shows Total Corners of opponents and UMD
SELECT g.gameId AS 'Game Id',g.gameResult AS 'Game Result', u.umdStatCorner AS 'UMD Stat Corner', o.opponentStatCorner AS 'Opponent Stat Corner'
FROM [DKSS.Game] g JOIN [DKSS.UmdStat] u
	ON g.umdStatId = u.umdStatId
	JOIN [DKSS.OpponentStat] o
		ON g.opponentStatId = o.opponentStatId
WHERE g.gameResult IN ('Indiana', 'Penn St.', 'Wisconsin')
ORDER BY g.gameResult





--Q4 To check if team follow all rules and are consistent in discipline
-- below query gives the season average cards per game
SELECT 
    s.seasonId AS 'Season Id', 
    (SELECT SUM(umdStatRedCard + umdStatYellowCard) 
     FROM [DKSS.UmdStat] 
     WHERE umdStatId IN (SELECT umdStatId FROM [DKSS.Game] WHERE seasonId = s.seasonId)) AS 'Total Cards' ,
    (SELECT COUNT(gameId) 
     FROM [DKSS.Game] 
     WHERE seasonId = s.seasonId) AS 'Total Games',
    ROUND(
        CAST((SELECT SUM(umdStatRedCard + umdStatYellowCard) 
              FROM [DKSS.UmdStat] 
              WHERE umdStatId IN (SELECT umdStatId FROM [DKSS.Game] WHERE seasonId = s.seasonId)) AS FLOAT) 
        / NULLIF((SELECT COUNT(gameId) 
                   FROM [DKSS.Game] 
                   WHERE seasonId = s.seasonId), 0), 2) AS 'Average Cards Per Game'
FROM 
    [DKSS.Season] s
ORDER BY 
    'Total Cards' DESC;


-- same result can be fetched using join 
SELECT s.seasonId AS 'Season Id', SUM(us.umdStatRedCard + us.umdStatYellowCard) AS 'Total Cards', COUNT(g.gameId) AS 'Total Games',
    ROUND(CAST(SUM(us.umdStatRedCard + us.umdStatYellowCard) AS FLOAT) / NULLIF(COUNT(g.gameId), 0),2) AS 'Average Cards Per Game'
FROM [DKSS.Game] g
	JOIN [DKSS.Season] s ON g.seasonId = s.seasonId
	JOIN [DKSS.UmdStat] us ON g.umdStatId = us.umdStatId
GROUP BY s.seasonId
ORDER BY 'Total Cards' DESC;



--Q5 What was the Goal to Shot ratio per season?
DROP VIEW IF EXISTS GameStatsView;
GO

CREATE VIEW GameStatsView AS
SELECT 
    g.seasonId AS 'Season Id',
    SUM(u.umdStatShotFirstHalf + u.umdStatShotSecondHalf) AS 'UMD Total Shots',
    SUM(u.umdStatGoalsFirstHalf + u.umdStatGoalsSecondHalf) AS 'UMD Total Goals',
    SUM(o.opponentStatShotFirstHalf + o.opponentStatShotSecondHalf) AS 'Opponent Total Shots',
    ROUND(CAST(SUM(u.umdStatGoalsFirstHalf + u.umdStatGoalsSecondHalf) AS FLOAT) / NULLIF(SUM(u.umdStatShotFirstHalf + u.umdStatShotSecondHalf), 0), 2) AS 'Goal Shot Ratio'
FROM 
    [DKSS.Game] g
JOIN 
    [DKSS.UmdStat] u ON g.umdStatId = u.umdStatId
JOIN 
    [DKSS.OpponentStat] o ON g.opponentStatId = o.opponentStatId
GROUP BY 
    g.seasonId;

SELECT * 
FROM GameStatsView
