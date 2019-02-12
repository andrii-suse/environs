[ ! -f __workdir/postgresql.conf ] || \
  [ ! __wordir/pg_is_running.sh ] || \
    export TEST_PG=$(__wordir/get_pg_connect_string.sh)

(
cd __srcdir
prove -v t/*.t
prove -v t/ui/*.t
)
