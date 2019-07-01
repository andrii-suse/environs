. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/websockets/status.sh || test $? -gt 0
qa8*/websockets/status.sh || test $? -gt 0

qa9*/websockets/start.sh
qa9*/websockets/status.sh
qa8*/websockets/status.sh || test $? -gt 0

qa8*/websockets/start.sh
qa8*/websockets/status.sh
qa9*/websockets/status.sh

qa9*/websockets/stop.sh
qa9*/websockets/status.sh || test $? -gt 0

qa8*/websockets/status.sh
qa8*/websockets/stop.sh
qa8*/websockets/status.sh || test $? -gt 0
