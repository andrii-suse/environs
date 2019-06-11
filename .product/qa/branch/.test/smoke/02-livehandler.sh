. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa0*/livehandler/start.sh
qa0*/livehandler/status.sh
qa0*/livehandler/stop.sh
sleep 1
if qa0*/livehandler/status.sh ; then exit 1 ; fi

qa0*/livehandler/start.sh
qa0*/livehandler/status.sh
qa0*/livehandler/stop.sh
sleep 1
if qa0*/livehandler/status.sh ; then exit 1 ; fi

qa0*/livehandler/start.sh
qa0*/livehandler/status.sh
qa0*/livehandler/stop.sh
sleep 1
if qa0*/livehandler/status.sh ; then exit 1 ; fi

