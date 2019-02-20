set -e
__workdir/dbus/status.sh || __workdir/dbus/start.sh
__workdir/ui/start.sh
__workdir/livehandler/start.sh
__workdir/resource-allocator/start.sh
__workdir/websockets/start.sh
__workdir/scheduler/start.sh
