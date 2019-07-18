set -e

ifelse(__service,worker1,`',__service,worker2,`',__service,worker3,`',[ ! -f __workdir/TEST_PG ] || {
    export OPENQA_DATABASE=test
    export TEST_PG=$(cat __workdir/TEST_PG)
})
export OPENQA_BASEDIR=__workdir
export OPENQA_CONFIG=__workdir/openqa
export OPENQA_LOGFILE=__workdir/__service/.log

port=$((__wid * 10 + 9526))
mkdir -p __workdir/openqa/db

define(`CMD',ifelse(__service,ui,openqa daemon,
__service,worker1,worker --isotovideo '__workdir/os-autoinst/isotovideo' --host 127.0.0.1:${port} --instance 1 --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF,
__service,worker2,worker --isotovideo '__workdir/os-autoinst/isotovideo' --host 127.0.0.1:${port} --instance 2 --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF,
__service,worker3,worker --isotovideo '__workdir/os-autoinst/isotovideo' --host 127.0.0.1:${port} --instance 3 --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF,
openqa-__service daemon))

ifelse(__service,worker1,`',__service,worker2,`',__service,worker3,`',OPENQA_BASE_PORT=${port} )__srcdir/script/CMD >> __workdir/__service/.cout 2>> __workdir/__service/.cerr &
pid=$!
echo $pid > __workdir/__service/.pid
ifelse(__service,ui,
echo "Waiting (pid $pid) at http://127.0.0.1:${port}"
while kill -0 $pid 2>/dev/null ; do 
    { ( curl --max-time 2 -sI http://127.0.0.1:${port} | grep 200 ) && break; } || :
    sleep 1
    echo -n .
done,`')
__workdir/__service/status.sh
