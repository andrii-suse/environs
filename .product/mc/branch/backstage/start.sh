set -e

[ ! -f __workdir/TEST_PG ] || {
    export TEST_PG=$(cat __workdir/TEST_PG)
}

MIRRORCACHE_ROOT=__workdir/dt \
MIRRORCACHE_CITY_MMDB=__srcdir/t/data/city.mmdb \
MOJO_LISTEN=http://127.0.0.1:${port} \
__srcdir/script/mirrorcache backstage run -I 15 -C 1 -j 10 >> __workdir/backstage/.cout 2>> __workdir/backstage/.cerr &

pid=$!
echo $pid > __workdir/backstage/.pid
sleep 1
__workdir/backstage/status.sh
