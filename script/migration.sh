#!/bin/sh

if [ $1 == "development" ] || [ $1 == "test" ]; then
  cd /home/hemant/leaves
  rake db:database:clear[$1]
  cd /home/hemant/myrecruit
  rake db:database:clear[$1]
elif [ $1 == "both" ]; then
  index=0
  env_var=(development test)
  length=${#env_var[*]}
  while [ $index -lt $length ]; do
    cd /home/hemant/leaves
    rake db:database:clear[${env_var[$index]}]
    cd /home/hemant/myrecruit
    rake db:database:clear[${env_var[$index]}]
    let index++
  done
else
  echo "-----------------------------
        Please enter environment variable.
        Available options are development and test."
  echo "-----------------------------"
fi
