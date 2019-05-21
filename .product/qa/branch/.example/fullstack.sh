git clone https://github.com/os-autoinst/os-autoinst || :
git clone https://github.com/os-autoinst/openQA || :

./environ.sh ai9 $(pwd)/os-autoinst
./environ.sh qa9 $(pwd)/openQA
./environ.sh pg9-system2

pg9*/status.sh > /dev/null || pg9*/start.sh

ln -sf `pwd`/ai9/src qa9/os-autoinst
qa9*/configure_db.sh pg9

pg9*/start.sh

qa9*/dbus/start.sh
qa9*/start.sh

pg9*/sql.sh openqa_test "insert into users(username, email, fullname, nickname, is_operator, is_admin, feature_version, t_created, t_updated) values ('Demo','demo@user.org', 'Demo User', 'Demo', 1, 1, 1, now(), now()) on conflict do nothing"
pg9*/sql.sh openqa_test "insert into api_keys(key, secret, user_id, t_created, t_updated, t_expiration) values ('1234567890ABCDEF','1234567890ABCDEF', 2, now(), now(), now() + interval '1 year') on conflict do nothing"

qa9*/worker1/start.sh
qa9*/worker1/status.sh

qa9*/example/start_job.sh

# will wait 20*10 sec
max_wait=20

sleep 15

set +x
while [ $((max_wait--)) -gt 0 ] && qa9*/client.sh jobs get | grep result | tail -n 1 | grep -q none ; do
    sleep 10
    echo -n .
done

[ $max_wait -gt 0 ] || ( echo "Timeout exceeded"; exit 1 )
qa9*/client.sh jobs get 
qa9*/client.sh jobs get | grep result
set -x
qa9*/client.sh jobs get | grep result | tail -n 1 | grep passed

