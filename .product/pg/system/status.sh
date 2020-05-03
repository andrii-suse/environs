sudo systemctl is-active --quiet postgresql.service
res=$?
[ $res != 0 ] || echo postgresql is up
[ $res == 0 ] || echo postgresql is down
(exit $res)
