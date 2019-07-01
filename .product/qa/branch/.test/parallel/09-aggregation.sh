set -e
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

pg9*/status.sh || pg9*/start.sh
pg8*/status.sh || pg8*/start.sh

qa9*/start.sh
qa8*/start.sh
qa9*/status.sh
qa8*/status.sh
qa9*/ui/status.sh
qa8*/ui/status.sh
qa9*/livehandler/status.sh
qa8*/livehandler/status.sh
qa9*/websockets/status.sh
qa8*/websockets/status.sh

qa9*/stop.sh
if qa9*/ui/status.sh ; then exit 1; fi
if qa9*/livehandler/status.sh ; then exit 1; fi
if qa9*/websockets/status.sh ; then exit 1; fi
if qa9*/status.sh ; then exit 1; fi
pg9*/stop.sh
if pg9*/status.sh ; then exit 1; fi


qa8*/stop.sh
if qa8*/ui/status.sh ; then exit 1; fi
if qa8*/livehandler/status.sh ; then exit 1; fi
if qa8*/websockets/status.sh ; then exit 1; fi
if qa8*/status.sh ; then exit 1; fi
pg8*/stop.sh
if pg8*/status.sh ; then exit 1; fi
