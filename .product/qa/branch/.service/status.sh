ifelse(__service,ui,
port=$((__wid * 10 + 9526))
curl -sI http://127.0.0.1:${port} | grep 200 || ( >&2 echo UI is not reachable; exit 1 ),
set -e
[ -f __workdir/__service/.pid ] || ( echo __service not started; exit 1 )
( kill -0 $(cat __workdir/__service/.pid) && ! ps -p "$(cat __workdir/__service/.pid)" | grep -q defunc && echo __service seems running ) || ( echo __service seems be down; exit 1 ))
