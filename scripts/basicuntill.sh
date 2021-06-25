#!/bin/bash

a=0

until [ "$a" -ge 10 ]
do
  echo  "$a"
  a=`expr $a + 1`
  if [ $a == 5 ]
  then
    #echo "$a"
    break
  fi
done
