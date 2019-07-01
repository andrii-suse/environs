. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/ui/start.sh
qa9*/ui/status.sh
qa8*/ui/start.sh
qa8*/ui/status.sh

qa9*/livehandler/start.sh
qa9*/livehandler/status.sh
qa8*/livehandler/start.sh
qa8*/livehandler/status.sh

qa9*/websockets/start.sh
qa9*/websockets/status.sh
qa8*/websockets/start.sh
qa8*/websockets/status.sh

qa9*/ui/status.sh
qa9*/livehandler/status.sh
qa9*/websockets/status.sh

qa8*/ui/status.sh
qa8*/livehandler/status.sh
qa8*/websockets/status.sh

qa9*/livehandler/stop.sh
qa9*/websockets/stop.sh
qa9*/ui/stop.sh
pg9*/stop.sh

qa8*/livehandler/stop.sh
qa8*/websockets/stop.sh
qa8*/ui/stop.sh
pg8*/stop.sh

if qa9*/ui/status.sh ; then exit 1; fi
if qa9*/livehandler/status.sh ; then exit 1; fi
if qa9*/websockets/status.sh ; then exit 1; fi
if pg9*/status.sh ; then exit 1; fi

if qa8*/ui/status.sh ; then exit 1; fi
if qa8*/livehandler/status.sh ; then exit 1; fi
if qa8*/websockets/status.sh ; then exit 1; fi
if pg8*/status.sh ; then exit 1; fi
