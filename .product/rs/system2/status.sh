set -e
[ -f __workdir/rsyncd.pid ] || ( >&2 echo Pid file not found __workdir/rsyncd.pid; exit 1 )

( kill -0 $(cat __workdir/rsyncd.pid) && ! ps -p "$(cat __workdir/rsyncd.pid)" | grep -q defunc && echo rsyncd __wid seems running ) || ( >&2 echo rsyncd __wid seems be down; exit 1 )


