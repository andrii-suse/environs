. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

ps auxwww | grep e2

qa0*/ui/start.sh
qa0*/ui/status.sh

qa0*/livehandler/start.sh
qa0*/livehandler/status.sh

qa0*/websockets/start.sh
qa0*/websockets/status.sh

qa0*/ui/status.sh
qa0*/livehandler/status.sh
qa0*/websockets/status.sh

qa0*/livehandler/stop.sh
qa0*/websockets/stop.sh
qa0*/ui/stop.sh
pg9*/stop.sh

if qa0*/ui/status.sh ; then exit 1; fi
if qa0*/livehandler/status.sh ; then exit 1; fi
if qa0*/websockets/status.sh ; then exit 1; fi
if pg9*/status.sh ; then exit 1; fi
