set -e

[ ! -f __workdir/TEST_PG ] || {
    export TEST_PG=$(cat __workdir/TEST_PG)
}

[ "$#" -ne 1 ] || extra=-e

MIRRORCACHE_ROOT=__workdir/dt  __srcdir/script/mirrorcache minion job $extra "$@"
