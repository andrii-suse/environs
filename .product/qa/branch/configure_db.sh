pgsqlN=$1
set -e
matches=$(ls -la $pgsqlN*/get_connect_string.sh | wc -l)

[ $matches -ne 0 ] || ( >&2 echo "Cannot find $pgsqlN*/get_connect_string.sh"; exit 1 )

[ $matches -eq 1 ] || ( >&2 echo "Ambigous $pgsqlN*/get_connect_string.sh"; exit 1 )

$pgsqlN*/get_connect_string.sh > __workdir/TEST_PG
