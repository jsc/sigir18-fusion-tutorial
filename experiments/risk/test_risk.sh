TE="../../bin/trec_eval"

SYS="
input.pircRB04td2
indri-bm25.run
indri-qe.run
BM25-uqv.run
"

ln -s ../../external/pairwise-ttest/pairwise.r .

# Get test runs ready
echo "Copy runs and uncompress"
cp ../../data/robust04-historical/input.pircRB04td2.xz .
cp ../../data/robust04-new/indri-bm25.run.xz .
cp ../../data/robust04-new/indri-qe.run.xz .
cp ../uqv/BM25/out.combsum.minsum.run BM25-uqv.run 
xz -d *.xz

for f in $SYS
do
  $TE -nq -m map ../../data/rob04.qrels $f > $f.eval
  $TE -m map ../../data/rob04.qrels $f > $f.evala
  cat $f.eval | awk '{print $2, $3}' > $f.map
done

echo "Rename files for comparison"
mv indri-bm25.run.map SysA
mv indri-qe.run.map SysB
mv input.pircRB04td2.map SysC
mv BM25-uqv.run.map SysD
pairwise-ttest.sh SysA SysB SysC SysD

echo "Run t-risk comparisons"
../../external/trisk/trisk_trec.sh BM25-uqv.run.eval indri-bm25.run.eval > trisk.bm25.txt
../../external/trisk/trisk_trec.sh indri-qe.run.eval indri-bm25.run.eval > trisk.qe.txt
