DKSS: Data-Driven Insights for UMD Soccer Success

A database management project enabling UMD Soccer coaches to make informed decisions through detailed performance analysis and strategic insights.



Mission Statement

This project focuses on analyzing data from the UMD Soccer Team stored in an SQL database, with the objective of providing actionable insights to the coaching staff. By processing and examining past performance trends, the project aims to assist the team in developing effective strategies and improving overall performance. Key objectives include identifying the most successful season with the highest number of wins and uncovering the factors contributing to this success. Conversely, the analysis will also explore seasons of weaker performance, investigating the underlying reasons for the team's underperformance.

Additionally, the project seeks to evaluate the team’s record against specific opponents, highlighting patterns of poor performance and their potential causes. Compliance with game rules and disciplinary consistency will also be reviewed to ensure the team maintains high standards of sportsmanship.

Further, by analyzing the team's strengths and weaknesses, and metrics like the ratio of goals to shots across seasons, the project provides a comprehensive assessment of the team’s efficiency. This data-driven approach enables the coach to make informed decisions, enhance team tactics, and build on areas requiring improvement, ultimately setting the foundation for sustained success. 




Mission Objectives:

a.	To find the season with the highest number of wins and key success.
b.	To find the season with the weakest performance and understand the reason behind the team’s underperformance
c.	To check for opponents with whom our team’s performance is poor and why
d.	To check if the team follows all rules and is consistent in discipline
e.	Analyze our team’s strengths and weaknesses
f.	Analyze team performance throughout the seasons on the basis of Goal to Shots per season.




Relational Schema

Season (seasonId, seasonYear, seasonWin, SeasonLoss, seasonDraw )

OpponentStat (opponentStatId, opponentStatName, opponentStatShotFirstHalf, opponentStatShotSecondHalf, opponentStatFoul, opponentStatRedCard, opponentStatYellowCard, opponentCorner)

UmdStat(umdStatId, umdStatGoalsFirstHalf, umdStatGoalsSecondHalf, umdStatFoul, umdStatAttempt, umdStatShotFirstHalf, umdStatShotSecondHalf,umdStatRedCard, umdStatYellowCard, umdStatCorner)

Game( gameId, gameDate, gameLocation, matchAttendence, gameResult, opponentStatId, umdStatId, seasonId )




Data Sources

https://umterps.com/sports/mens-soccer/stats

https://umterps.com/sports/mens-soccer/stats/2023/

https://umterps.com/sports/mens-soccer/stats/2022/

https://umterps.com/sports/mens-soccer/stats/2021/



ER Diagram


![image](https://github.com/user-attachments/assets/e69c696e-1200-4970-9557-e6311e1f62ae)


