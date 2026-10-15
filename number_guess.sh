#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess  -q -t --no-align -c"
RANDOM_NUMBER=$(( $RANDOM % 1000 +1 ))
echo "Enter your username:"
read USER_NAME

USER_NAME_FROM_DATA_BASE=$($PSQL "SELECT username FROM user_data WHERE username= '$USER_NAME'")

if [[ $USER_NAME_FROM_DATA_BASE ]]
then
games_played=$($PSQL "SELECT games_played FROM user_data WHERE username= '$USER_NAME'")
best_game=$($PSQL "SELECT best_game FROM user_data WHERE username= '$USER_NAME'")
games_played_plus_one=$(( $games_played+1 ))
echo "Welcome back, $USER_NAME_FROM_DATA_BASE! You have played $games_played games, and your best game took $best_game guesses."
echo "Guess the secret number between 1 and 1000:"
$PSQL "UPDATE user_data SET games_played=$games_played_plus_one WHERE username='$USER_NAME'"
else
echo "Welcome, $USER_NAME! It looks like this is your first time here."
$PSQL "INSERT INTO user_data(username, games_played, best_game) VALUES('$USER_NAME', 1, 0)"
echo "Guess the secret number between 1 and 1000:"
fi

tries=0

while [[ $RANDOM_NUMBER != $SECRET_NUMBER ]]
do

read SECRET_NUMBER
if [[ $SECRET_NUMBER =~ ^[0-9]*$ ]]
then

if [[ $SECRET_NUMBER > $RANDOM_NUMBER ]]
then
echo "It's lower than that, guess again:"
fi

if [[ $SECRET_NUMBER < $RANDOM_NUMBER ]]
then
echo "It's higher than that, guess again:"
fi


else
echo "That is not an integer, guess again:"
fi
tries=$(( $tries+1 ))
done


if [[ -z $best_game ]]
then
$PSQL "UPDATE user_data SET best_game=$tries WHERE username='$USER_NAME'"
else
if [[ $tries < $best_game ]]
then
$PSQL "UPDATE user_data SET best_game=$tries WHERE username='$USER_NAME'"
fi
fi

echo "You guessed it in $tries tries. The secret number was $RANDOM_NUMBER. Nice job!"