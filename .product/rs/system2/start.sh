port=$((__wid * 10 + 9000))

rsync --daemon --port=$port --config=__workdir/rsyncd.conf
