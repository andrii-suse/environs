set -e
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}
! ap9*/status.sh 2>/dev/null || { echo "status.sh expected to return error"; exit 1; }

ap9*/start.sh
ap9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

ap9*/curl.sh

echo $?

ap9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

tail ap9*/dt/error_log

ap9*/stop.sh
! ap9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }


