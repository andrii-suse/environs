[ -d __datadir ] || mkdir -p __datadir
__installdir/bin/httpd -d __datadir -f __workdir/httpd.conf -k start
sleep 1
