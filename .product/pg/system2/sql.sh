if [[ $1 == -* ]] ; then
PGHOST=__datadir psql "$@"
elif [ -z "$2" ]; then
PGHOST=__datadir psql $1
else
db=$1
shift
PGHOST=__datadir psql $db -P pager=off -c "$*"
fi
