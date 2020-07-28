port=$((__wid * 10 + 3100))
curl -s 127.0.0.1:$port/"$@"
