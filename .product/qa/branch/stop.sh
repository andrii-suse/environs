failures=0
set -x
if __workdir/ui/status.sh ; then __workdir/ui/stop.sh || : $((failures++))  ; fi
if __workdir/livehandler/status.sh ; then __workdir/livehandler/stop.sh || : $((failures++)) ; fi
if __workdir/resource-allocator/status.sh ; then __workdir/resource-allocator/stop.sh || : $((failures++)) ; fi
if __workdir/scheduler/status.sh > /dev/null ; then __workdir/scheduler/stop.sh || : $((failures++)) ; fi
if __workdir/websockets/status.sh > /dev/null ; then __workdir/websockets/stop.sh || : $((failures++)) ; fi

if __workdir/worker1/status.sh > /dev/null ; then __workdir/worker1/stop.sh || : ; fi
if __workdir/worker2/status.sh > /dev/null ; then __workdir/worker2/stop.sh || : ; fi
if __workdir/worker3/status.sh > /dev/null ; then __workdir/worker3/stop.sh || : ; fi
( exit $failures )
