set -e
port=$((__wid * 10 + 3101))

[ -f __workdir/backstage/.pid ] || ( echo backstage not started; exit 1 )
( kill -0 $(cat __workdir/backstage/.pid) && ! ps -p "$(cat __workdir/backstage/.pid)" | grep -q defunc && echo backstage seems running ) || ( echo backstage seems be down; exit 1 )
