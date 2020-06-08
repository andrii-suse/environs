set -e
eval $(grep ^PRETTY_NAME= /etc/*-release | sed 's/ /_/g')
echo $PRETTY_NAME

zypper -n install apache2-devel python3-PyDispatcher python3 python3-devel python wget curl sudo m4 git-core perl-Config-IniFiles perl-Digest-MD4 perl-TimeDate perl-libwww-perl

zypper -n addrepo https://download.opensuse.org/repositories/Apache:/MirrorBrain/$PRETTY_NAME/ Apache:MirrorBrain 
zypper -n addrepo https://download.opensuse.org/repositories/server:/database:/postgresql/$PRETTY_NAME/ server:database:postgresql
zypper -n --gpg-auto-import-keys --no-gpg-checks refresh

zypper -n install --allow-vendor-change apache2-devel apache2-worker apache2-mod_asn apache2-mod_maxminddb apache2-mod_form \
    postgresql-server \
    perl-DBI perl-DBD-Pg libapr-util1-dbd-pgsql \
    python3-cmdln python3-SQLObject python3-psycopg2 python3-FormEncode \
    'libmaxminddb-devel>=1.4.2' 'apache2-mod_maxminddb>=1.2.0' 'python3-geoip2>=3.0.0' 'python3-maxminddb>=1.5.2' 'meson>=0.54'

# we must get rid of this except eventual migrations
v=$(psql -V)
if [[ "$v" == *10.* ]]; then
   zypper -n in postgresql10-ip4r
else
   zypper -n in postgresql12-ip4r
fi

ln /usr/sbin/httpd /sbin/httpd
