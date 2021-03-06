apN=$1

set -e
[ ! -z "$apN" ] || ( >&2 echo "Expected parameter in configure_apache.sh"; exit 1 )

echo "Include $PWD/$(ls -d $apN*/)/httpd.conf" | sudo tee /etc/apache2/conf.d/environs.conf

echo "# LoadModule memcache_module /usr/lib64/apache2/mod_memcache.so
LoadModule form_module        /usr/lib64/apache2/mod_form.so
LoadModule mirrorbrain_module /usr/lib64/apache2/mod_mirrorbrain.so
" > $(ls -d $apN*/)/extra-mirrorbrain.conf

sed "s,__apn,$apN," __workdir/extra-postgresql.conf > $(ls -d $apN*/)/extra-postgresql.conf

echo "
MirrorBrainEngine On
MirrorBrainDebug On
FormGET On
MirrorBrainHandleHEADRequestLocally Off
MirrorBrainMinSize 0
MirrorBrainExcludeUserAgent rpm\/4.4.2*
MirrorBrainExcludeUserAgent *APT-HTTP*
MirrorBrainExcludeMimeType application\/pgp-keys" > $(ls -d $apN*/)/directory-mirrorbrain.conf
