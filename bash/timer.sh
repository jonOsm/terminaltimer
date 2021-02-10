#!/bin/bash

duration=3 #in seconds
current_selection=-1
enable_audio=true

SELECTION_START_TIMER=1
SELECTION_SET_TIMER=2 
SELECTION_TOGGLE_AUDIO=3 
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
  echo "3 - Toggle Audio"
  echo "0 - Exit"
  echo
  #ugly use of global. can't use $() because previous echo doesn't get output.
  #TODO: find a better pattern for handing return values
  read -p "Enter Selection: " current_selection 
}

#for breakdown of "overwrite" see https://stackoverflow.com/a/51858404
overwrite() { echo -e "\r\033[1A\033[0K$@"; }

start_timer() {
  echo $2
  # note that {%1..0} does not work. bash resolves the range before the variable
  for ((remaining=$1;remaining>=0;remaining--))
  do
    #TODO: add feature allowing pause or stop timer
    overwrite $(format_time $remaining)
    sleep 1s
  done
  echo "Timer Complete."
  #ignore error if notify-send is unavailable on current distro
  notify-send "Timer Complete." 2> /dev/null
  
  if $2
  then 
    #ignore error if spd-say is unavailable on current distro
    spd-say -i -30 "Timer Complete" 2> /dev/null 
  fi
  echo
  read -p "'Enter' to continue..."
}

is_integer() {
  #https://stackoverflow.com/a/806923
  if [[ $1 =~ ^[0-9]+$ ]] #GOTCHA: regex should NOT be in quotations
  then
    echo "true"
  else
    echo "false"
  fi
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
    start_timer $duration $enable_audio
  elif [[ $current_selection -eq $SELECTION_SET_TIMER ]]
  then
    #TODO: handle invalid input handling for setting duration
    #TODO: move set duration into own function
    #TODO: abstract input check into own function
    while true
    do
      read -p "Enter total hours: " hours
      $(is_integer $hours) && break
      echo "Invalid input. Must be positive integer"
    done

    while true
    do
      read -p "Enter total minutes: " mins
      $(is_integer $mins) && break
      echo "Invalid input. Must be positive integer"
    done
    
    duration=$(($hours*60*60+$mins*60)) #in seconds
    echo "New duration Accepted."
  elif [[ $current_selection -eq $SELECTION_TOGGLE_AUDIO ]]
  then
    #can't do x=!x in bash because there is no real boolean.
    #true and false are just commands that resolve to 1 and 0 
    #is there a shorter way to toggle true and false?
    if $enable_audio
    then
      enable_audio=false
      echo "Audio Disabled."
    else
      enable_audio=true
      echo "Audio Enabled."
    fi
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


