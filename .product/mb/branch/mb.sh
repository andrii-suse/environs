[ "$1" != scan ] || extra='--scanner __workdir/src/tools/scanner.pl'
PYTHONPATH=__workdir/src/install/usr/lib/python3.8/site-packages  __workdir/src/install/usr/bin/mb --config=__workdir/mirrorbrain.conf "$@" $extra
