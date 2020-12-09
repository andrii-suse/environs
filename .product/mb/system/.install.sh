set -ex

proj=${1:-Apache:MirrorBrain}
repo=$2

projpath=${proj//:/:\/}

if [ -n "$proj" ] && [ -z "$repo" ]; then
    eval $(grep ^PRETTY_NAME= /etc/*-release | sed 's/ /_/g')
    repo=$PRETTY_NAME
fi

zypper -n install systemd curl hostname iputils vim command-not-found bsdtar zip sudo wget gcc gzip patch m4

# mirrorbrain brings sql files in /usr/share/doc/packages, so we adjust config 
sed -i 's,rpm.install.excludedocs = yes,rpm.install.excludedocs = no,' /etc/zypp/zypp.conf

if [[ $proj =~ :development ]]; then
    v=3
    parent=${proj%:development}
    parentpath=${parent//:/:\/}
    zypper lr | grep "$parent\s"  || zypper -n addrepo https://download.opensuse.org/repositories/$parentpath/$repo $parent
fi

# this is needed only for ip4r, which we should get rid of
if ! zypper lr | grep server:database:postgresql; then
    zypper -n addrepo https://download.opensuse.org/repositories/server:/database:/postgresql/$repo server:database:postgresql
fi

if ! zypper lr | grep "$proj\s"; then
    zypper -n addrepo https://download.opensuse.org/repositories/$projpath/$repo $proj
    zypper -n --gpg-auto-import-keys --no-gpg-checks refresh
    zypper -n install --from $proj mirrorbrain$v mirrorbrain$v-scanner mirrorbrain$v-tools python$v-mb apache2-mod_maxminddb apache2-mod_mirrorbrain postgresql postgresql-server

    v=$(psql -V)
    if [[ "$v" == *10.* ]]; then
       zypper -n in postgresql10-ip4r
    elif [[ "$v" == *12.* ]]; then
       zypper -n in postgresql12-ip4r
    else
       zypper -n in postgresql13-ip4r
    fi
fi

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
which mb || ( ln -n $(which mb3) /usr/bin/mb )
which mirrorprobe || ( ln -n $(which mirrorprobe3) /usr/bin/mirrorprobe )
