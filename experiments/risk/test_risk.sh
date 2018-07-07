TE="../../bin/trec_eval"

SYS="
input.pircRB04td2
indri-bm25.run
indri-qe.run
indri-fdm.run
BM25-uqv.run
triple.run
uqv-best.run
"

ln -s ../../external/pairwise-ttest/pairwise.r .

# Get test runs ready
echo "Copy runs and uncompress"
cp ../../data/robust04-historical/input.pircRB04td2.xz .
cp ../../data/robust04-new/indri-bm25.run.xz .
cp ../../data/robust04-new/indri-qe.run.xz .
cp ../../data/robust04-new/indri-fdm.run.xz .
cp ../uqv/BM25/out.combsum.minsum.run BM25-uqv.run 
cp ../uqv/DLH13/out.combsum.minsum.run uqv-best.run 
xz -d *.xz

# Generate triple fused run
../../bin/polyfuse rrf ../uqv/FDM/out.combsum.minmax.run ../uqv/BM25/out.combsum.minsum.run indri-qe.run > triple.run 2>debug.log

for f in $SYS
do
  $TE -nq -m map ../../data/rob04.qrels $f > $f.eval
  $TE -m map ../../data/rob04.qrels $f > $f.evalm
  $TE -m all_trec ../../data/rob04.qrels $f | grep -e "^map " -e "^P_10 " -e "ndcg_cut_10 "> $f.evald
  cat $f.eval | awk '{print $2, $3}' > $f.map
done

echo "Rename files for comparison"
mv indri-bm25.run.map SysA
mv indri-qe.run.map SysB
mv input.pircRB04td2.map SysC
mv BM25-uqv.run.map SysD
mv triple.run.map SysE
mv uqv-best.run.map SysF
pairwise-ttest.sh SysA SysB SysC SysD SysE SysF

echo "Run t-risk comparisons"
../../external/trisk/trisk_trec.sh BM25-uqv.run.eval indri-bm25.run.eval > trisk.bm25.txt
../../external/trisk/trisk_trec.sh indri-qe.run.eval indri-bm25.run.eval > trisk.qe.txt
../../external/trisk/trisk_trec.sh indri-fdm.run.eval indri-bm25.run.eval > trisk.fdm.txt
