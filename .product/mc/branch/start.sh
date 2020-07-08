set -e

[ ! -f __workdir/TEST_PG ] || {
    export TEST_PG=$(cat __workdir/TEST_PG)
}

port=$((__wid * 10 + 3100))
mkdir -p __workdir/dt

MIRRORCACHE_ROOT=__workdir/dt \
MIRRORCACHE_CITY_MMDB=__srcdir/t/data/city.mmdb \
MOJO_LISTEN=http://127.0.0.1:${port} \
__srcdir/script/mirrorcache daemon -i 100 -H 400 -w 30 -c 1 -G 800 >> __workdir/.cout 2>> __workdir/.cerr &

pid=$!
echo $pid > __workdir/.pid
echo "Waiting (pid $pid) at http://127.0.0.1:${port}"
while kill -0 $pid 2>/dev/null ; do 
    { ( curl --max-time 2 -sI http://127.0.0.1:${port}/download/ | grep 200 ) && break; } || :
    sleep 1
    echo -n .
done
__workdir/status.sh
