#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate tables in db
echo $($PSQL "TRUNCATE TABLE games, teams")

# read the file with data and apply a while loop to read row by row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # exclude column names row
  if [[ $WINNER != "winner" ]]
  then
    # get team's names
    TEAM_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    TEAM_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    
    # WINNER
    # if team name is not in the table, include to the table
    if [[ -z $TEAM_WINNER ]]
    then
      # insert new team
      INSERT_TEAM_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # echo team was inserted
      if [[ $INSERT_TEAM_WINNER == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
    fi

    # OPPONENT
    # if team name is not in the table, include to the table
    if [[ -z $TEAM_OPPONENT ]]
    then
      # insert new team
      INSERT_TEAM_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # echo team was inserted
      if [[ $INSERT_TEAM_OPPONENT == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi

    # get team_id
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert game
    INSERT_GAME=$($PSQL "INSERT INTO games(year,round,WINNER_ID,OPPONENT_ID,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$TEAM_WINNER_ID','$TEAM_OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
    # echo team was inserted
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo Inserted game $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    fi

  fi


done

