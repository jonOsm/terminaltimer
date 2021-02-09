#!/bin/bash

duration=3
current_selection=-1

SELECTION_START_TIMER=1
SELECTION_SET_TIMER=2 
SELECTION_EXIT=0 

format_time(){
  let local hours="$1/3600"
  let local mins="($1%3600)/60"
  let local secs="($1%3600)%60"
  printf -v mins "%02g" $mins
  printf -v secs "%02g" $secs
  #TODO: modify to echo and pipe instead of global varaible
  echo "$hours:$mins:$secs"
}

menu() {
  
  echo "1 - Start Timer ($1)"
  echo "2 - Set Timer Duration"
  echo "0 - Exit"
  echo
  #ugly use of global. can't use $() because previous echo doesn't get output.
  #TODO: find a better pattern for handing return values
  read -p "Enter Selection: " current_selection 
}

#for breakdown of "overwrite" see https://stackoverflow.com/a/51858404
overwrite() { echo -e "\r\033[1A\033[0K$@"; }

start_timer() {
  # note that {%1..0} does not work. bash resolves the range before the variable for... reasons?
  for ((remaining=$1;remaining>=0;remaining--))
  do
    #TODO: add feature allowing pause or stop timer
    overwrite $(format_time $remaining)
    sleep 1s
  done
  echo "Timer Complete."
  read -p "('Enter' to continue)"
}

echo
echo "============ TERMINAL TIMER ============="
while true;
do
  echo
  echo "MENU:"
  menu $(format_time $duration)
  #SUGGESTION: convert to case statement
  if [[ $current_selection -eq $SELECTION_START_TIMER ]]
  then 
    start_timer $duration
  elif [[ $current_selection -eq $SELECTION_SET_TIMER ]]
  then
    #TODO: invalid input handling for setting duration
    #TODO: move set duration into own function
    read -p "Enter total hours: " hours 
    read -p "Enter total minutes: " mins
    duration=$hours*60*60+$mins*60
    echo "Duration Accepted."
    read -p '("Enter" to continue)'
  #TODO: determine why text input resolves to "true" here.
  elif [[ $current_selection -eq $SELECTION_EXIT ]]
  then
    echo "Goodbye."
    echo "========================================="
    exit
  else
    echo "INVALID INPUT."
  fi
done


