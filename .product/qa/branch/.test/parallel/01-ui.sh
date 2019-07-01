. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/ui/start.sh
qa9*/ui/status.sh
if qa8*/ui/status.sh ; then exit 1 ; fi
qa8*/ui/start.sh
qa8*/ui/status.sh
qa9*/ui/stop.sh
qa8*/ui/status.sh

qa9*/ui/status.sh || test $? -gt 0

qa8*/ui/stop.sh
qa8*/ui/status.sh || test $? -gt 0
