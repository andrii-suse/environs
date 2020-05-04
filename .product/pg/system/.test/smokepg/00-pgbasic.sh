. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}
n=0
pg9-system2/init_db.sh
! pg9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return error ($((n++)))"; exit 1; }

pg9-system2/start.sh
pg9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return no error ($((n++)))"; exit 1; }

pg9-system2/sql.sh openqa_test 'select version()'

pg9-system2/stop.sh
! pg9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return no error $((n++)))"; exit 1; }
