set -ex

proj=${1:-Apache:MirrorBrain}
repo=$2

projpath=${proj//:/:\/}

if [ -n "$proj" ] && [ -z "$repo" ]; then
    eval $(grep ^PRETTY_NAME= /etc/*-release | sed 's/ /_/g')
    repo=$PRETTY_NAME
fi

zypper -n install systemd curl hostname iputils vim command-not-found bsdtar zip sudo wget gcc gzip patch m4

if [[ $proj =~ :development ]]; then
    v=3
    parent=${proj%:development}
    parentpath=${parent//:/:\/}
    zypper lr | grep "$parent\s"  || zypper -n addrepo https://download.opensuse.org/repositories/$parentpath/$repo $parent
fi

if ! zypper lr | grep "$proj\s"; then
    zypper -n addrepo https://download.opensuse.org/repositories/$projpath/$repo $proj
    zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
    zypper -n install --from $proj mirrorbrain mirrorbrain-scanner mirrorbrain-tools python$v-mb apache2-mod_maxminddb apache2-mod_mirrorbrain
fi

# this is needed only for ip4r, which we should get rid of
if ! zypper lr | grep server:database:postgresql; then
    zypper -n addrepo https://download.opensuse.org/repositories/server:/database:/postgresql/$repo server:database:postgresql
    zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
    zypper -n install postgresql postgresql-server

    v=$(psql -V)
    if [[ "$v" == *10.* ]]; then
       zypper -n in postgresql10-ip4r
    else
       zypper -n in postgresql12-ip4r
    fi
fi

zypper -n install apache2-devel apache2-worker apache2-mod_asn apache2-mod_form \
    python3-devel python3-cmdln python3-SQLObject python3-psycopg2 python3-FormEncode \
    'libmaxminddb-devel>=1.4.2' 'apache2-mod_maxminddb>=1.2.0' 'python3-geoip2>=3.0.0' 'python3-maxminddb>=1.5.2'

[ -f /etc/mirrorbrain.conf ] || {
cat > /etc/mirrorbrain.conf <<EOF
[general]
instances = main
maxmind_asn_db = $PWD/.product/mb/.maxmind/mirrorbrain-ci-asn.mmdb
maxmind_city_db = $PWD/.product/mb/.maxmind/mirrorbrain-ci-city.mmdb

[main]
dbuser = mirrorbrain
dbpass = mirrorbrain
dbdriver = postgresql
dbhost = 127.0.0.1
# optional: dbport = ...
dbname = mirrorbrain

[mirrorprobe]
# logfile = __workdir/mirrorprobe.log
# loglevel = INFO
EOF
}

sudo -u postgres /usr/share/postgresql/postgresql-script start || :
sudo sudo -u postgres createuser mirrorbrain || :
sudo sudo -u postgres createdb mirrorbrain || :
sudo sudo -u postgres psql -c 'CREATE EXTENSION ip4r' mirrorbrain || :
sudo sudo -u postgres psql -c "alter user mirrorbrain with encrypted password 'mirrorbrain';"
sudo -u postgres /usr/share/postgresql/postgresql-script stop || :

sed -i 's,127.0.0.1/32            ident,127.0.0.1/32            password,' /var/lib/pgsql/data/pg_hba.conf
sed -i 's,\#log_min_duration_statement = -1,log_min_duration_statement = 500,' /var/lib/pgsql/data/postgresql.conf
sed -i 's,\#log_lock_waits = off,log_lock_waits = on,' /var/lib/pgsql/data/postgresql.conf
sed -i 's,\#deadlock_timeout = 1s,deadlock_timeout = 10,' /var/lib/pgsql/data/postgresql.conf

# this is needed for system2 environ to run without root
ln -s /usr/sbin/httpd /sbin/httpd

