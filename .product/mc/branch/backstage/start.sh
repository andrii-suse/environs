set -e

[ ! -f __workdir/TEST_PG ] || {
    export TEST_PG=$(cat __workdir/TEST_PG)
}

MIRRORCACHE_ROOT=__workdir/dt  __srcdir/script/mirrorcache backstage run -I 15 -C 1 -j 10 >> __workdir/backstage/.cout 2>> __workdir/backstage/.cerr &

pid=$!
echo $pid > __workdir/backstage/.pid
sleep 1
__workdir/backstage/status.sh
