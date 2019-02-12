set -e
[ -f __workdir/ui/.pid ] || ( echo UI was never started; exit 1 )
( kill -0 $(cat __workdir/ui/.pid) && echo UI seems running ) || ( echo UI seems be down; exit 1)
