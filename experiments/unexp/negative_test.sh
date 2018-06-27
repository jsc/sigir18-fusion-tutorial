#!/bin/bash

PF="../../bin/polyfuse"
TE="../../bin/trec_eval"

SYS="atire-bm25L.run
indri-bm25.run
indri-fdm.run
indri-lm.run
indri-qe.run
terrier-bm25-bo1b.run
terrier-dlh13-bo1b.run"

SYSN="atire-bm25L.run
indri-bm25.run
indri-fdm.exp.run
indri-lm.exp.run
indri-qe.exp.run
terrier-bm25-bo1b.run
terrier-dlh13-bo1b.run"

# Get test runs ready
echo "Copy runs and uncompress"
cp ../../data/robust04-new/atire-bm25L.run.xz .
cp ../../data/robust04-new/terrier-dlh13-bo1b.run.xz .
cp ../../data/robust04-new/terrier-bm25-bo1b.run.xz .
cp ../../data/robust04-new/indri-bm25.run.xz .
cp ../../data/robust04-new/indri-lm.run.xz .
cp ../../data/robust04-new/indri-fdm.run.xz .
cp ../../data/robust04-new/indri-qe.run.xz .
xz -d *.xz
# Convert -CE to QL for comparisons
echo "Convert -CE to QL"
./exp.sh < indri-fdm.run > indri-fdm.exp.run
./exp.sh < indri-lm.run > indri-lm.exp.run
./exp.sh < indri-qe.run > indri-qe.exp.run

echo "Fuse all runs"
for m in combsum combmnz combanz combmin combmax combmed
do
  echo "Processing exp=true method=$m norm=none"
  $PF $m $SYSN > exp.$m.none.run  2>debug.log
  echo "Processing exp=false method=$m norm=none"
  $PF $m $SYS > orig.$m.none.run 2>debug.log
  for n in sum std minmax minsum
  do
    echo "Processing exp=true method=$m norm=$n"
    $PF $m -n $n $SYSN > exp.$m.$n.run 2>debug.log
    echo "Processing exp=false method=$m norm=$n"
    $PF $m -n $n $SYS > orig.$m.$n.run 2>debug.log
  done
done

for m in borda rrf isr logisr
do
  echo "Processing exp=false method=$m norm=none"
  $PF $m $SYS > orig.$m.none.run 2>debug.log
done

m=rbc
for p in 0.5 0.8 0.95 0.99 
do
  echo "Processing exp=false method=$m norm=none p=$p"
  $PF $m -p $p $SYS > orig.$m-$p.none.run 2>debug.log
done

echo "Compute MAP for all runs"
for f in `ls *.run`
do 
  $TE -m map ../../data/rob04.qrels $f > $f.eval
done

echo "Dump scores and sort"
grep map *.eval | sort -n -k3 > sorted.txt
