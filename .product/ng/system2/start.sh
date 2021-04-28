[ -d __datadir/tmp ] || mkdir -p __datadir/tmp
if [[ $(/usr/sbin/nginx -v 2>&1) =~ 1.[2-9] ]]; then
    /usr/sbin/nginx -c __workdir/nginx.conf -p __datadir -e __datadir/error.log
else
    /usr/sbin/nginx -c __workdir/nginx.conf -p __datadir
fi
sleep 1
