. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/ui/start.sh
qa9*/ui/status.sh
qa9*/ui/stop.sh

qa9*/ui/status.sh || test $? -gt 0

