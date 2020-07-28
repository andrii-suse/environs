set -e
port=$((__wid * 10 + 3100))

__srcdir/script/client --host http://127.0.0.1:${port} $* 
