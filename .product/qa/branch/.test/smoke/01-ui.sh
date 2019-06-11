. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa0*/ui/start.sh
qa0*/ui/status.sh
qa0*/ui/stop.sh

qa0*/ui/status.sh || test $? -gt 0

