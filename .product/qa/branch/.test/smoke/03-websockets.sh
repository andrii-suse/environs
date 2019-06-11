. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa0*/websockets/start.sh
qa0*/websockets/status.sh
qa0*/websockets/stop.sh
qa0*/websockets/status.sh || test $? -gt 0

