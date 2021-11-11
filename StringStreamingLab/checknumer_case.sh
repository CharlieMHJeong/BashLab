#!/bin/bash -xv

for ARG in "$@"
do
  index=$(echo $ARG | cut -f1 -d= )
  VAL=$(echo $ARG | cut -f2 -d= )
     
  case $index in
    x) x=$VAL;;
    y) y=$VAL;;
    *)
  esac
done

RESULT=$(( x + y ))
#  echo "index: $index"
#  echo "VAL: $VAL"
echo "RESULT: $RESULT"
