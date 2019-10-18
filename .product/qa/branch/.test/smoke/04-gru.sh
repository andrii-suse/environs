. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/gru/start.sh
qa9*/gru/status.sh
qa9*/gru/stop.sh
qa9*/gru/status.sh || test $? -gt 0

