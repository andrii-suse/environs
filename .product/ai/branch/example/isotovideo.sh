(
set -e
cd __workdir/example
__workdir/src/isotovideo

grep result testresults/*.json

grep -q '"result" : "ok"' testresults/*.json || ( echo "Test doesn't seem to finish"; exit 1 )
! grep -q '"result" : "fail"' testresults/*.json || ( echo "Test has failures"; exit 1 )
)



