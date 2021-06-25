#!/bin/bash

# string operator example

a=$1
b=$2

if [ $a = $b ]
then
  echo "$a is equal to $b"
else
  echo "$a is not equal to $b"
fi

if [ $a != $b ]
then
  echo "$a is not equal to $b"
else
  echo "both are equal"
fi

if [ -z$a ]
then
  echo "$a length is not zero"
else
  echo "$a is zero"
fi

if [ -n$a ]
then
  echo "$a is non zero"
else
  echo "$a length is zero"
fi

if [ $a ]
then
  echo "string is not empty"
else 
  echo " string is empty"
fi
   


