. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/livehandler/start.sh
qa9*/livehandler/status.sh

if qa8*/livehandler/status.sh ; then exit 1 ; fi
qa8*/livehandler/start.sh
qa8*/livehandler/status.sh

qa9*/livehandler/stop.sh
if qa9*/livehandler/status.sh ; then exit 1 ; fi

qa8*/livehandler/status.sh
qa8*/livehandler/stop.sh
if qa9*/livehandler/status.sh ; then exit 1 ; fi


