set -x
[ ! -f __workdir/PGPASSWORD ] || export PGPASSWORD=$(cat __workdir/PGPASSWORD)
if [[ $1 == -* ]] ; then
PGHOST=127.0.0.1 psql "$@"
elif [ -z "$2" ]; then
PGHOST=127.0.0.1 psql $1
else
db=$1
shift
PGHOST=127.0.0.1 psql $db -P pager=off -c "$*"
fi
