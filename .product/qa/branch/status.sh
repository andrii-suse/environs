failures=0
__workdir/ui/status.sh || : $((failures++)) 
__workdir/livehandler/status.sh || : $((failures++))
__workdir/websockets/status.sh || : $((failures++))
__workdir/scheduler/status.sh || : $((failures++))
( exit $failures )
