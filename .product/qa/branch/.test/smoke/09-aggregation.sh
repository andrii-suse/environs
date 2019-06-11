set -e
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

pg9*/status.sh || pg9*/start.sh

qa0*/start.sh
qa0*/status.sh
qa0*/ui/status.sh
qa0*/livehandler/status.sh
qa0*/websockets/status.sh

qa0*/stop.sh
sleep 1
if qa0*/ui/status.sh ; then exit 1; fi
if qa0*/livehandler/status.sh ; then exit 1; fi
if qa0*/websockets/status.sh ; then exit 1; fi
if qa0*/status.sh ; then exit 1; fi
pg9*/stop.sh
if pg9*/status.sh ; then exit 1; fi
