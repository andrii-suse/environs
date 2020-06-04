[ "$1" != scan ] || extra='--scanner __workdir/src/tools/scanner.pl'
PYTHONPATH=$(ls -d __workdir/src/install/usr/lib/python3.*/site-packages/ | tail -n1):$(ls -d __workdir/src/install/usr/lib64/python3.*/site-packages/ | tail -n1)  __workdir/src/install/usr/bin/mb --config=__workdir/mirrorbrain.conf "$@" $extra
