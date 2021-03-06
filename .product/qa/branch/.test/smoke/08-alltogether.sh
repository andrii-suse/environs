. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/ui/start.sh
qa9*/ui/status.sh

qa9*/gru/start.sh
qa9*/gru/status.sh

qa9*/livehandler/start.sh
qa9*/livehandler/status.sh

qa9*/websockets/start.sh
qa9*/websockets/status.sh

# in fact services may stop shortly after startup, so let's wait briefly and check status once again
sleep 2

qa9*/ui/status.sh
qa9*/gru/status.sh
qa9*/livehandler/status.sh
qa9*/websockets/status.sh

qa9*/livehandler/stop.sh
qa9*/websockets/stop.sh
qa9*/gru/stop.sh
qa9*/ui/stop.sh
pg9*/stop.sh

if qa9*/ui/status.sh ; then exit 1; fi
if qa9*/gru/status.sh ; then exit 1; fi
if qa9*/livehandler/status.sh ; then exit 1; fi
if qa9*/websockets/status.sh ; then exit 1; fi
if pg9*/status.sh ; then exit 1; fi
