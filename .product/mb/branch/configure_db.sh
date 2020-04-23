pgsqlN=$1

set -e
[ ! -z "$pgsqlN" ] || ( >&2 echo "Expected parameter in configure_db.sh"; exit 1 )

matches=$(ls -la $pgsqlN*/get_connect_string.sh | wc -l)

[ $matches -ne 0 ] || ( >&2 echo "Cannot find $pgsqlN*/get_connect_string.sh"; exit 1 )

[ $matches -eq 1 ] || ( >&2 echo "Ambiguous $pgsqlN*/get_connect_string.sh"; exit 1 )

# workaround: for some reasons mb always adds default port to socket path
ln -s $PWD/$(ls -d $pgsqlN*)/dt $PWD/$(ls -d $pgsqlN*)/dt:5432

$pgsqlN*/get_connect_string.sh > __workdir/TEST_PG

print_config() {
    cat <<EOF
[general]
instances = main`'__wid
maxmind_asn_db = $PWD/.product/mb/.maxmind/mirrorbrain-ci-asn.mmdb
maxmind_city_db = $PWD/.product/mb/.maxmind/mirrorbrain-ci-city.mmdb

[main`'__wid]
dbuser = $USER
dbpass = $USER
dbdriver = postgresql
dbhost = $PWD/$(ls -d $pgsqlN*)/dt
# optional: dbport = ...
dbname = mirrorbrain

[mirrorprobe]
# logfile = __workdir/mirrorprobe.log
# loglevel = INFO
EOF
}

print_config > __workdir/mirrorbrain.conf

$pgsqlN*/create.sh user $USER || :
$pgsqlN*/create.sh db mirrorbrain

$pgsqlN*/sql.sh -c 'CREATE EXTENSION ip4r' mirrorbrain
$pgsqlN*/sql.sh -f __workdir/src/sql/schema-postgresql.sql mirrorbrain
$pgsqlN*/sql.sh -f __workdir/src/sql/migrations/schema-postgresql-add-filearr_split_path_trigger.sql mirrorbrain
$pgsqlN*/sql.sh -f __workdir/src/sql/initialdata-postgresql.sql mirrorbrain
