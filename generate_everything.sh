./create_tools.sh
if [ $? -ne 0 ];
do
  echo "Compile tools failed. Exiting.
  exit 1
done
cd experiments/additivity
./additivity_test.sh
if [ $? -ne 0 ];
do
  echo "Additivity test failed. Exiting.
  exit 1
done
cd -
cd experiments/unexp
./negative_test.sh
if [ $? -ne 0 ];
do
  echo "Exp test failed. Exiting.
  exit 1
done
cd -
cd experiments/uqv
./uqv_test.sh
if [ $? -ne 0 ];
do
  echo "UQV test failed. Exiting.
  exit 1
done
cd -
cd experiments/risk
./test_risk.sh
if [ $? -ne 0 ];
do
  echo "Risk test failed. Exiting.
  exit 1
done
cd -
