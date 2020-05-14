id=${1:-__wid}
dir=${2:-__workdir}

user=${3:-$(id -un)}
password=${4:-${user}}

echo $user:$password > __workdir/$id.secrets
chmod 600 __workdir/$id.secrets

echo "[$id]
path = $dir
auth users = $user
secrets file = __workdir/$id.secrets" >> __workdir/rsyncd.conf

port=$((__wid * 10 + 9000))

echo "RSYNC_PASSWORD=$password rsync --list-only --port=$port 127.0.0.1::$id" > __workdir/ls_$id.sh
chmod +x __workdir/ls_$id.sh
