[ -f __workdir/dbus/.pid ] && kill "$(cat __workdir/dbus/.pid)"

# wait ~5 sec, then kill hard
cnt=50
while kill -0 "$(cat __workdir/dbus/.pid)" 2>/dev/null && ! ps -p "$(cat __workdir/dbus/.pid)" | grep -q defunc ; do
    sleep 0.1
    if [ $((cnt--)) -le 1 ]; then
        kill -9 "$(cat __workdir/dbus/.pid)"
        sleep 0.1
        break
    fi
done
