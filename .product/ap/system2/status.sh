/sbin/httpd -d __datadir -f __workdir/httpd.conf -k status
[ -f __workdir/http.pid ] || ( >&2 echo Pid file not found __workdir/httpd.pid; exit 1 )

( kill -0 $(cat __workdir/httpd.pid) && ! ps -p "$(cat __workdir/httpd.pid)" | grep -q defunc && echo httpd seems running ) || ( >&2 echo httpd seems be down; exit 1 )
