apN=$1

set -e
[ ! -z "$apN" ] || ( >&2 echo "Expected parameter in configure_apache.sh"; exit 1 )

echo "
DBDriver pgsql
DBDParams \"host=__datadir user=$USER dbname=mirrorbrain connect_timeout=15\"
MirrorBrainMetalinkPublisher '$apN' http://127.0.0.1" > $(ls -d $apN*/)/extra-postgresql.conf
