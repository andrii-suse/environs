pgsqlN=$1

set -e
[ ! -z "$pgsqlN" ] || ( >&2 echo "Expected parameter in configure_db.sh"; exit 1 )

matches=$(ls -la $pgsqlN*/get_config.sh | wc -l)

[ $matches -ne 0 ] || ( >&2 echo "Cannot find $pgsqlN*/get_config.sh"; exit 1 )

[ $matches -eq 1 ] || ( >&2 echo "Ambiguous $pgsqlN*/get_config.sh"; exit 1 )

# workaround: for some reasons mb always adds default port to socket path
( 
ls -ld $pgsqlN-system2/ 2>/dev/null && ln -sf $PWD/$(ls -d $pgsqlN*)/dt $PWD/$(ls -d $pgsqlN*)/dt:5432 
:
)

sudo sed -i "s/^\(dbhost\s*=\s*\).*$/\1 $($pgsqlN*/get_config.sh host)/" /etc/mirrorbrain.conf
sudo sed -i "s/^\(dbuser\s*=\s*\).*$/\1 $($pgsqlN*/get_config.sh user mirrorbrain)/" /etc/mirrorbrain.conf
sudo sed -i "s/^\(dbpass\s*=\s*\).*$/\1 $($pgsqlN*/get_config.sh user mirrorbrain)/" /etc/mirrorbrain.conf
sudo sed -i "s,^\(maxmind_asn_db\s*=\s*\).*$,\1 $PWD/.product/mb/.maxmind/mirrorbrain-ci-asn.mmdb," /etc/mirrorbrain.conf
sudo sed -i "s,^\(maxmind_city_db\s*=\s*\).*$,\1 $PWD/.product/mb/.maxmind/mirrorbrain-ci-city.mmdb," /etc/mirrorbrain.conf

# workaround set default password
(
set +e
ls -d $pgsqlN-system 2>/dev/null && echo mirrorbrain > $pgsqlN-system/PGPASSWORD
:
)

$pgsqlN*/create.sh user $($pgsqlN*/get_config.sh user) || :
$pgsqlN*/create.sh db mirrorbrain || :

$pgsqlN*/sql.sh -c 'CREATE EXTENSION ip4r' mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain) || :
$pgsqlN*/sql.sh -f /usr/share/doc/packages/mirrorbrain*/sql/schema-postgresql.sql mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain)
if [ -f /usr/share/doc/packages/mirrorbrain*/sql/migrations/schema-postgresql-add-filearr_split_path_trigger.sql ] ; then
    $pgsqlN*/sql.sh -f /usr/share/doc/packages/mirrorbrain*/sql/migrations/schema-postgresql-add-filearr_split_path_trigger.sql mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain)
    $pgsqlN*/sql.sh -f /usr/share/doc/packages/mirrorbrain*/sql/initialdata-postgresql.sql mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain)
else
    $pgsqlN*/sql.sh -f /usr/share/doc/packages/mirrorbrain*/sql/initialdata-postgresql.sql mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain)
    $pgsqlN*/sql.sh -f /usr/share/doc/packages/mirrorbrain*/sql/migrations/0002-schema-postgresql-move-to-mapping-table.sql mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain)
    $pgsqlN*/sql.sh -f /usr/share/doc/packages/mirrorbrain*/sql/migrations/0003-schema-postgresql-migrate-to-mapping-table.sql mirrorbrain $($pgsqlN*/get_config.sh user mirrorbrain)
fi
echo "
DBDriver pgsql
DBDParams \"host=$($pgsqlN*/get_config.sh host) user=$($pgsqlN*/get_config.sh user mirrorbrain) password=$($pgsqlN*/get_config.sh user mirrorbrain) dbname=mirrorbrain connect_timeout=15\"
MirrorBrainMetalinkPublisher __apN http://127.0.0.1" > __workdir/extra-postgresql.conf
