#!/bin/bash


usage(){
echo "Usage : $0 Arg1 arg2"
exit 1
}

if [ $# != 2 ]
then
  usage
fi
a=$1
b=$2

res=`expr $a + $b`
echo "Add : $res"
res=`expr $a - $b`
echo "sub : $res"
res=`expr $a \* $b`
echo "multiplication : $res"
res=`expr $a / $b`
echo "devide : $res"
res=`expr $a % $b`
echo "reminder : $res"

if [ $a == $b ]
then
  echo "both are equel"
elif [ $a != $b ]
then
  echo "both are not equeal"
else
  echo "none matched"
fi



