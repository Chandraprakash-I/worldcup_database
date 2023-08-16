#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

"$($PSQL "TRUNCATE TABLE games,teams;")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $WINNER != 'winner' ]] 
then
    INSERT_STATUS1="$($PSQL "insert into teams(name) values('$WINNER')")"
    INSERT_STATUS2="$($PSQL "insert into teams(name) values('$OPPONENT')")"
    if [[  $INSERT_STATUS1 == 'INSERT 0 1' ]] 
    then
      echo $WINNER
    elif [[ $INSERT_STATUS2 == 'INSERT 0 1' ]]
    then
      echo $OPPONENT
    fi
fi

done

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $WINNER != 'winner' ]] 
then
  
    WINNER_ID="$($PSQL "select team_id from teams  where name= '$WINNER'")"
    OPPONENT_ID="$($PSQL "select team_id from teams  where name= '$OPPONENT'")"

    # echo $WINNER_ID
    # echo $OPPONENT_ID

    INSERT_STATUS3="$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")";
    
    if [[  $INSERT_STATUS3 == 'INSERT 0 1' ]] 
    then
      echo $WINNER
    fi
fi

done