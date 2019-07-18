set -e
port=$((__wid * 10 + 9526))

__srcdir/script/client --host http://127.0.0.1:${port} --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF $* 
