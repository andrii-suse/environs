address=$(grep DBUS_SESSION_BUS_ADDRESS __workdir/dbus/.vars)
changecom(BC,EC)dbus-monitor --address "${address#DBUS_SESSION_BUS_ADDRESS=}"
