set -e
[ -f __workdir/dbus/.pid ] || ( echo Dbus not started; exit 1 )
( kill -0 $(cat __workdir/dbus/.pid) && ! ps -p "$(cat __workdir/dbus/.pid)" | grep -q defunc && echo Dbus seems running ) || ( echo Dbus seems be down ; exit 1 )
