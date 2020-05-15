set -e
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}
! ap9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return error"; exit 1; }

ap9-system2/start.sh
ap9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

ap9-system2/curl.sh
echo $?

ap9-system2/curl_https.sh
echo $?

ap9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

cat ap9-system2/dt/error_log

ap9-system2/stop.sh
! ap9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

