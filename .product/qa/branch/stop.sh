failures=0
__workdir/ui/stop.sh || : $((failures++)) 
__workdir/livehandler/stop.sh || : $((failures++))
__workdir/resource-allocator/stop.sh || : $((failures++))
__workdir/scheduler/stop.sh || : $((failures++))
__workdir/websockets/stop.sh || : $((failures++))
( exit $failures )
