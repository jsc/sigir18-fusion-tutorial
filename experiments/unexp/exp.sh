#!/bin/bash

while read c1 c2 c3 c4 c5 c6
do
  t=`echo "e ($c5)" | bc -l`
  echo "$c1 $c2 $c3 $c4 $t $c6"
done
