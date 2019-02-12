dbus-launch > __workdir/dbus/.vars
pid=$(grep DBUS_SESSION_BUS_PID __workdir/dbus/.vars)
changecom(BC,EC)echo ${pid#DBUS_SESSION_BUS_PID=} > __workdir/dbus/.pid
