. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/livehandler/start.sh
qa9*/livehandler/status.sh
qa9*/livehandler/stop.sh
sleep 1
if qa9*/livehandler/status.sh ; then exit 1 ; fi

qa9*/livehandler/start.sh
qa9*/livehandler/status.sh
qa9*/livehandler/stop.sh
sleep 1
if qa9*/livehandler/status.sh ; then exit 1 ; fi

qa9*/livehandler/start.sh
qa9*/livehandler/status.sh
qa9*/livehandler/stop.sh
sleep 1
if qa9*/livehandler/status.sh ; then exit 1 ; fi

