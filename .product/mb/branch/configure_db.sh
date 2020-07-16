pgsqlN=$1

set -e
[ ! -z "$pgsqlN" ] || ( >&2 echo "Expected parameter in configure_db.sh"; exit 1 )

matches=$(ls -la $pgsqlN*/get_connect_string.sh | wc -l)

[ $matches -ne 0 ] || ( >&2 echo "Cannot find $pgsqlN*/get_connect_string.sh"; exit 1 )

[ $matches -eq 1 ] || ( >&2 echo "Ambiguous $pgsqlN*/get_connect_string.sh"; exit 1 )

# workaround: for some reasons mb always adds default port to socket path
ln -sf $PWD/$(ls -d $pgsqlN*)/dt $PWD/$(ls -d $pgsqlN*)/dt:5432

$pgsqlN*/get_connect_string.sh mirrorbrain > __workdir/TEST_PG

print_config() {
    cat <<EOF
[general]
instances = main`'__wid
maxmind_asn_db = $PWD/.product/mb/.maxmind/mirrorbrain-ci-asn.mmdb
maxmind_city_db = $PWD/.product/mb/.maxmind/mirrorbrain-ci-city.mmdb

[main`'__wid]
dbuser = $($pgsqlN*/get_config.sh user $USER)
dbpass = $($pgsqlN*/get_config.sh user $USER)
dbdriver = postgresql
dbhost = $($pgsqlN*/get_config.sh host)
# optional: dbport = ...
dbname = mirrorbrain

[mirrorprobe]
# logfile = __workdir/mirrorprobe.log
# loglevel = INFO
EOF
}

print_config > __workdir/mirrorbrain.conf

# workaround set default password
(
set +e
ls -d $pgsqlN-system 2>/dev/null && echo mirrorbrain > $pgsqlN-system/PGPASSWORD
:
)

$pgsqlN*/create.sh user $USER || :
$pgsqlN*/create.sh db mirrorbrain || :

$pgsqlN*/sql.sh -c 'CREATE EXTENSION ip4r' mirrorbrain || :
$pgsqlN*/sql.sh -f __workdir/src/sql/schema-postgresql.sql mirrorbrain
$pgsqlN*/sql.sh -f __workdir/src/sql/initialdata-postgresql.sql mirrorbrain
$pgsqlN*/sql.sh -f __workdir/src/sql/migrations/0002-schema-postgresql-move-to-mapping-table.sql mirrorbrain
$pgsqlN*/sql.sh -f __workdir/src/sql/migrations/0003-schema-postgresql-migrate-to-mapping-table.sql mirrorbrain

echo "
DBDriver pgsql
DBDParams \"host=$($pgsqlN*/get_config.sh host) user=$($pgsqlN*/get_config.sh user $USER) dbname=mirrorbrain connect_timeout=15\"
MirrorBrainMetalinkPublisher __apN http://127.0.0.1" > __workdir/extra-postgresql.conf
