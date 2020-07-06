[ -f __workdir/backstage/.pid ] || exit 0

kill "$(cat __workdir/backstage/.pid)"

# wait ~5 sec, then kill hard
cnt=50
while kill -0 "$(cat __workdir/backstage/.pid)" 2>/dev/null && ! ps -p "$(cat __workdir/backstage/.pid)" | grep -q defunc ; do 
    sleep 0.1
    if [ $((cnt--)) -le 1 ]; then
        kill -9 "$(cat __workdir/backstage/.pid)"
        sleep 0.1
        break
    fi
done
