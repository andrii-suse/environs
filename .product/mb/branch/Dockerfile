FROM opensuse/leap

RUN zypper -n install apache2-devel python3-PyDispatcher python3 python3-devel python wget curl sudo m4 git-core perl-Config-IniFiles perl-Digest-MD4 perl-TimeDate perl-libwww-perl

RUN zypper -n addrepo https://download.opensuse.org/repositories/Apache:/MirrorBrain/$PRETTY_NAME/ Apache:MirrorBrain 
RUN zypper -n addrepo https://download.opensuse.org/repositories/server:/database:/postgresql/$PRETTY_NAME/ server:database:postgresql
RUN zypper -n --gpg-auto-import-keys --no-gpg-checks refresh

RUN zypper -n install --allow-vendor-change apache2-devel apache2-worker apache2-mod_asn apache2-mod_maxminddb apache2-mod_form \
    postgresql-server \
    perl-DBI perl-DBD-Pg libapr-util1-dbd-pgsql \
    python3-cmdln python3-SQLObject python3-psycopg2 python3-FormEncode \
    'libmaxminddb-devel>=1.4.2' 'apache2-mod_maxminddb>=1.2.0' 'python3-geoip2>=3.0.0' 'python3-maxminddb>=1.5.2' 'meson>=0.54'

# we must get rid of this except eventual migrations
RUN v=$(psql -V) \
    if [[ "$v" == *10.* ]]; then
       zypper -n in postgresql10-ip4r
    elif [[ "$v" == *12.* ]]; then
       zypper -n in postgresql12-ip4r
    elif [[ "$v" == *13.* ]]; then
       zypper -n in postgresql13-ip4r
    fi

RUN ln /usr/sbin/httpd /sbin/httpd


