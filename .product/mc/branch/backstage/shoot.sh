set -e

[ ! -f __workdir/TEST_PG ] || {
    export TEST_PG=$(cat __workdir/TEST_PG)
}

MIRRORCACHE_ROOT=__workdir/dt  __srcdir/script/mirrorcache backstage run --oneshot -j 10
