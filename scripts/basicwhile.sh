#!/bin/bash

a=0

while [ "$a" -le 10 ]
do
  echo  "$a"
  a=`expr $a + 1`
  if [ $a == 5 ]
  then
    #echo "$a"
    break
  fi
done

touch . file1
