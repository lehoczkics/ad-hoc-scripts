#!/bin/bash

# TCP port checker script
# uses 'timeout' command from 'coreutils' package

# Set hostnames and ports in the following arrays:
hosts=('localhost' 'google.com')
ports=('22' '443') # declared as string!

# For color prompt
red=`tput setaf 1`
green=`tput setaf 2`
magenta=`tput setaf 5`
nocolor=`tput sgr0`

# test 'timeout' util
which timeout &>/dev/null
if [ $? -ne 0 ]; then 
  echo "  ${red}ERROR: \"timeout\" command not found."
  echo "  Please install \"coreutils\" package. ${nocolor}"
  exit 1
fi

for myhost in ${hosts[@]}; do
  for myport in ${ports[@]}; do
    echo -n "Testing $myhost on TCP port $myport:"
    timeout 2 bash -c "</dev/tcp/${myhost}/${myport}" &>/dev/null
    case $? in
      0)
        echo "${green} OPEN ${nocolor}"
        ;;
      1)
        echo "${magenta} CLOSED, nothing listens here ${nocolor}"
        ;;
      124)
        echo "${red} TIMEOUT, unreachable (firewall?) ${nocolor}"
        ;;
      *)
        echo "${red} ERROR {nocolor}"
        ;;
    esac
  done
done

exit 0

