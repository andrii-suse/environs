. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}

! rs9*/status.sh 2>/dev/null || { echo "status.sh expected to return error"; exit 1; }

rs9*/configure_dir.sh example01

rs9*/start.sh
rs9*/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }

rs9*/ls_example01.sh | grep ls_example01.sh

rs9-system2/stop.sh
! rs9-system2/status.sh 2>/dev/null || { echo "status.sh expected to return no error"; exit 1; }
