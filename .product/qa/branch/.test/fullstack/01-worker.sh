. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/start.sh

pg9*/sql.sh openqa_test "insert into users(username, email, fullname, nickname, is_operator, is_admin, feature_version, t_created, t_updated) values ('Demo','demo@user.org', 'Demo User', 'Demo', 1, 1, 1, now(), now()) on conflict do nothing"
pg9*/sql.sh openqa_test "insert into api_keys(key, secret, user_id, t_created, t_updated) values ('1234567890ABCDEF','1234567890ABCDEF', 2, now(), now()) on conflict do nothing"

qa9*/worker1/start.sh
qa9*/worker1/status.sh

exit 0

qa9*/worker1/stop.sh

set +e
if qa9*/worker1/status.sh ; then (exit 1) ; fi
