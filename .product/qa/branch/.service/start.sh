set -e
[ ! -f __workdir/TEST_PG ] || {
    export OPENQA_DATABASE=test
    export TEST_PG=$(cat __workdir/TEST_PG)
}
if [ -f __workdir/dbus/.vars ] ; then
    eval $(cat __workdir/dbus/.vars)
    export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS}
fi
export OPENQA_BASEDIR=__workdir
export OPENQA_CONFIG=__workdir/openqa

ifelse(__service,ui,port=$((__wid * 10 + 9526)),
__service,websockets,port=$((__wid * 10 + 9527)),
__service,livehandler,port=$((__wid * 10 + 9528)),
__service,worker1,port=$((__wid * 10 + 9526)),
__service,worker2,port=$((__wid * 10 + 9526)),
__service,worker3,port=$((__wid * 10 + 9526)),`'`')

mkdir -p __workdir/openqa/db

define(`CMD',ifelse(__service,ui,openqa daemon,
__service,websockets,openqa-websockets,
__service,livehandler,openqa-livehandler daemon,
__service,worker1,worker --isotovideo '__workdir/os-autoinst/isotovideo' --host localhost:${port} --instance 1 --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF,
__service,worker2,worker --isotovideo '__workdir/os-autoinst/isotovideo' --host localhost:${port} --instance 2 --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF,
__service,worker3,worker --isotovideo '__workdir/os-autoinst/isotovideo' --host localhost:${port} --instance 3 --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF,
openqa-__service))

MOJO_LISTEN=http://localhost:${port} __srcdir/script/CMD >> __workdir/__service/.log 2>> __workdir/__service/.err &
pid=$!
echo $pid > __workdir/__service/.pid
ifelse(__service,ui,
echo "Waiting (pid $pid) at http://localhost:${port}"
while kill -0 $pid 2>/dev/null ; do 
    { ( curl --max-time 2 -sI http://localhost:${port} | grep 200 ) && break; } || :
    sleep 1
    echo -n .
done,
sleep 1
__workdir/__service/status.sh)
