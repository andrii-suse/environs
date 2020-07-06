set -e
port=$((__wid * 10 + 3100))
curl -sI http://127.0.0.1:${port}/download/ | grep 200 || ( >&2 echo UI is not reachable; exit 1 )

[ -f __workdir/.pid ] || ( echo ui not started; exit 1 )
( kill -0 $(cat __workdir/.pid) && ! ps -p "$(cat __workdir/.pid)" | grep -q defunc && echo ui seems running ) || ( echo __service seems be down; exit 1 )
