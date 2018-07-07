#!/bin/bash

PF="../../bin/polyfuse"
TE="../../bin/trec_eval"

rm -rf BM25 FDM DLH13
mkdir -p BM25 FDM DLH13

# Get test runs ready
echo "Copy runs and uncompress"
cp ../../data/robust04-new/terrier-DLH13_Bo1bfree.uqv.run.xz .
cp ../../data/robust04-new/indri-uqv.bm25.run.xz .
cp ../../data/robust04-new/indri-uqv.fdm.qe.run.xz .
xz -d *.xz

echo "Fuse BM25 runs"
./uqvfuse_all.sh indri-uqv.bm25.run
echo "Compute MAP for BM25 runs"
for f in `ls out*.run`
do 
  $TE -m map ../../data/rob04.qrels $f > $f.eval
done
mv out.* BM25 

echo "Fuse DLH13 runs"
./uqvfuse_all.sh terrier-DLH13_Bo1bfree.uqv.run
echo "Compute MAP for DLH13 runs"
for f in `ls out*.run`
do 
  $TE -m map ../../data/rob04.qrels $f > $f.eval
done
mv out.* DLH13 

echo "Fuse FDM runs"
./uqvfuse_all.sh indri-uqv.fdm.qe.run
echo "Compute MAP for FDM runs"
for f in `ls out*.run`
do 
  $TE -m map ../../data/rob04.qrels $f > $f.eval
done
mv out.* FDM 

echo "Dump scores and sort"
find . -name *.eval | xargs grep map | sort -n -k3 > sorted.txt

echo "See sorted.txt for final run comparisons."

