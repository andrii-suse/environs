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
pg9*/sql.sh openqa_test "insert into api_keys(key, secret, user_id, t_created, t_updated) values ('1234567890ABCDEF','1234567890ABCDEF', 2, now(), now()) on conflict do nothing"

qa9*/worker1/start.sh
qa9*/worker1/status.sh
