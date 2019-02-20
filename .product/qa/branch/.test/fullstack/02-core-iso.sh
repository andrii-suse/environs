. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

qa9*/start.sh

pg9*/sql.sh openqa_test "insert into users(username, email, fullname, nickname, is_operator, is_admin, feature_version, t_created, t_updated) values ('Demo','demo@user.org', 'Demo User', 'Demo', 1, 1, 1, now(), now()) on conflict do nothing"
pg9*/sql.sh openqa_test "insert into api_keys(key, secret, user_id, t_created, t_updated) values ('1234567890ABCDEF','1234567890ABCDEF', 2, now(), now()) on conflict do nothing"

qa9*/worker1/start.sh
qa9*/worker1/status.sh


qa9*/example/start_job.sh

max_wait=20

sleep 10

qa9*/worker1/status.sh

set +x
while [ $((max_wait--)) -gt 0 ] && qa9*/client.sh jobs get | grep result | tail -n 1 | grep -q none ; do
    sleep 10
    echo -n .
done

[ $max_wait -gt 0 ] || ( echo "Timeout exceeded"; exit 1 )
qa9*/client.sh jobs get
qa9*/client.sh jobs get | grep result
qa9*/client.sh jobs get | grep result | tail -n 1
set -x
qa9*/client.sh jobs get | grep result | tail -n 1 | grep -q passed
