#!/bin/bash

option=$1

case $option in 

status)
    echo "status of the script"
    ;;
start)
    echo "atrting the script"
  ;;
stop)
    echo "stopping the script"
  ;;
restart)
   echo "reatsrting the script"
 ;;
 *)
  echo "wrong option choosed"

esac



