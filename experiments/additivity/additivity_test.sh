#!/bin/bash

PF="../../bin/polyfuse"
TE="../../bin/trec_eval"

SYS="
input.apl04rsTDNfw
input.fub04TDNge
input.NLPR04clus10
input.pircRB04td2
input.SABIR04BA
input.uic0401
input.uogRobLWR10
input.vtumlong436
input.vtumtitle
input.wdoqla1
"
# Get test runs ready
echo "Copy runs and uncompress"
cp ../../data/robust04-historical/input.* .
xz -d *.xz

echo "Fuse all runs"
for m in combsum combmnz combanz combmin combmax combmed
do
  $PF $m $SYS > orig.$m.none.run
  for n in sum std minmax minsum
  do
    $PF $m -n $n $SYS > orig.$m.$n.run
  done
done

for m in borda rrf isr logisr
do
  $PF $m $SYS > orig.$m.none.run
done

m=rbc
for p in 0.5 0.8 0.95 0.99 
do
  $PF $m -p $p $SYS > orig.$m-$p.none.run
done

echo "Compute MAP for all runs"
for f in `ls *.run input.*`
do 
  $TE -m map ../../data/rob04.qrels $f > $f.eval
done

echo "Dump scores and sort"
grep map *.eval | sort -n -k3
