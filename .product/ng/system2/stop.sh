set -e
[ -f __workdir/.pid ] || (
    echo pid file not found __workdir/.pid
    exit 1
)
kill -QUIT $(cat __workdir/.pid)
sleep 2
