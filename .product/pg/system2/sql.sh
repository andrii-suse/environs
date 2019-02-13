db=$1
shift
if [ -z "$1" ] ; then
PGHOST=__datadir psql $db
else
PGHOST=__datadir psql $db -P pager=off -c "$*"
fi
