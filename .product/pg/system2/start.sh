pg_ctl -D __datadir -l __workdir/log_test_postgresql start -w
# a hack
createdb -h __datadir openqa_test 2>/dev/null || :
