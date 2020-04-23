set -e

sudo zypper -n install apache2-devel meson libapr-util1-dbd-pgsql python3-PyDispatcher python3-dnspython python3-pycountry

eval $(grep ^NAME= /etc/*-release | sed 's/ /_/')

wget -nv -r -l1 -np https://download.opensuse.org/repositories/Apache:/MirrorBrain/$NAME/x86_64 -A 'apache2-mod_form*.rpm' -A 'apache2-mod_asn*.rpm'  -R '*debug*' -P .
sudo rpm --replacepkgs -i download.opensuse.org/repositories/Apache:/MirrorBrain/$NAME/x86_64/*

wget -nv -r -l1 -np https://download.opensuse.org/repositories/Apache:/MirrorBrain/$NAME/noarch -A 'python3-*.rpm' -R '*debug*' -P .

for x in download.opensuse.org/repositories/Apache:/MirrorBrain/$NAME/noarch/*; do 
    sudo rpm --replacepkgs -i $x || :
done

sudo zypper -n addrepo https://download.opensuse.org/repositories/server:/database:/postgresql/$NAME/ server:database:postgresql
sudo zypper -n --gpg-auto-import-keys --no-gpg-checks refresh

# we must get rid of this except eventual migrations
v=$(psql -V)
if [ "$v" == *10.* ]; then
   sudo zypper -n in postgresql10-ip4r
else
   sudo zypper -n in postgresql12-ip4r
fi

