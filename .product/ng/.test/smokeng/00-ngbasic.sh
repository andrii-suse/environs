set -e
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}

! ng9*/status.sh 2>/dev/null || { echo "status.sh expected to return error"; exit 1; }

ng9*/start.sh
ng9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

ng9*/curl.sh

echo $?

ng9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

tail ng9*/dt/error*log

ng9*/stop.sh
! ng9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }
