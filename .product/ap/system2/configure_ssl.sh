set -e

ssldir=__workdir/
cadir=$ssldir/../ca

mkdir -p $cadir

subj='/C=NL/ST=Zuid Holland/L=Rotterdam/O=Sparkling Network/OU=IT Department/CN'

if [ ! -e $cadir/ca.pem ] ; then
    openssl genrsa 2048 > $cadir/ca-key.pem
    openssl req -new -x509 -nodes -days 3600 -key $cadir/ca-key.pem -out $cadir/ca.pem -subj "${subj}=environs"
fi

mkdir -p $ssldir

[ -f $ssldir/server-cert.pem ] || {
    openssl req -newkey rsa:2048 -days 3600 -nodes -keyout $ssldir/server-key.pem -out $ssldir/server-req.pem -subj "${subj}=server-ap8"
    openssl rsa -in $ssldir/server-key.pem -out $ssldir/server-key.pem
    openssl x509 -req -in $ssldir/server-req.pem -days 3600 -CA $cadir/ca.pem -CAkey $cadir/ca-key.pem -set_serial 01 -out "$ssldir/server-cert.pem"
}

# [ -f $ssldir/client-cert.pem ] || {
#    openssl req -newkey rsa:2048 -days 3600 -nodes -keyout $ssldir/client-key.pem -out $ssldir/client-req.pem -subj "${subj}=client-ap8"
#    openssl rsa -in $ssldir/client-key.pem -out $ssldir/client-key.pem
#    openssl x509 -req -in $ssldir/client-req.pem -days 3600 -CA $cadir/ca.pem -CAkey $cadir/ca-key.pem -set_serial 01 -out "$ssldir/client-cert.pem"
# }

echo "LoadModule ssl_module /usr/lib64/apache2/mod_ssl.so
<VirtualHost _default_:__port>
SSLEngine on
SSLCertificateFile $ssldir/server-cert.pem
SSLCertificateChainFile $cadir/ca.pem
SSLCertificateKeyFile $ssldir/server-key.pem

Include __workdir/dir.conf
</VirtualHost>
" > __workdir/dir-ssl.conf

sed -i 's, 127.0.0.1, -k https://127.0.0.1,g' __workdir/curl.sh
sed -i 's,Include __workdir/dir.conf,Include __workdir/dir-ssl.conf,g' __workdir/httpd.conf

