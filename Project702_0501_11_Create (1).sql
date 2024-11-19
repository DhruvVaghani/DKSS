USE BUDT702_Project_0501_11

CREATE TABLE [DKSS.Season] (
    seasonId CHAR(4) NOT NULL,
    seasonYear Char(4),
    seasonWin INT NOT NULL,
    seasonLoss INT NOT NULL,
    seasonDraw INT NOT NULL,
	seasonGoal INT NOT NULL,
	seasonGoalConceded INT NOT NULL,
	CONSTRAINT pk_Season_seasonId PRIMARY KEY (seasonId)
);


CREATE TABLE [DKSS.OpponentStat] (
    opponentStatId CHAR(4) NOT NULL,
    opponentStatName VARCHAR(30),
    opponentStatShotFirstHalf INT,
    opponentStatShotSecondHalf INT,
    opponentStatFoul INT,
    opponentStatRedCard INT,
    opponentStatYellowCard INT,
    opponentStatCorner INT,
	CONSTRAINT pk_OpponentStat_opponentStatId PRIMARY KEY (opponentStatId)
);

CREATE TABLE [DKSS.UmdStat] (
    umdStatId CHAR(6) NOT NULL,
    umdStatGoalsFirstHalf INT,
    umdStatGoalsSecondHalf INT,
	umdStatShotFirstHalf INT,
	umdStatShotSecondHalf INT,
    umdStatFoul INT,
    umdStatCorner INT,
    umdStatYellowCard INT,
    umdStatRedCard INT,
   CONSTRAINT pk_UmdStat_umdStatId PRIMARY KEY (umdStatId)
);

CREATE TABLE [DKSS.Game] (
    gameId CHAR(4) NOT NULL,
    gameDate DATE,
    gameLocation VARCHAR(10),
    gameAttendance INT,
	gameResult VARCHAR (20),
    seasonId CHAR(4),
	opponentStatId CHAR(4),
	umdStatId CHAR(6),
	CONSTRAINT pk_Game_gameId PRIMARY KEY (gameId),
	CONSTRAINT fk_Game_seasonId FOREIGN KEY (seasonId)
		REFERENCES [DKSS.Season] (seasonId)
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT fk_Game_umdStatId FOREIGN KEY (umdStatId)
		REFERENCES [DKSS.UmdStat] (umdStatId)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_Game_opponentStatId FOREIGN KEY (opponentStatId)
		REFERENCES [DKSS.OpponentStat] (opponentStatId)
		ON UPDATE NO ACTION ON DELETE NO ACTION,
		 
);

	

