set -e

[ ! -f __workdir/TEST_PG ] || {
    export TEST_PG=$(cat __workdir/TEST_PG)
}

MIRRORCACHE_ROOT=${MIRRORCACHE_ROOT:-__workdir/dt} \
MIRRORCACHE_CITY_MMDB=__srcdir/t/data/city.mmdb \
MOJO_LISTEN=http://127.0.0.1:${port} \
__srcdir/script/mirrorcache backstage run --oneshot
