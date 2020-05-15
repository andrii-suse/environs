set -e

add=$1

ssldir=__workdir
cadir=$ssldir/../ca

mkdir -p $cadir

subj='/C=NL/ST=Zuid Holland/L=Rotterdam/O=Sparkling Network/OU=IT Department/CN'

if [ ! -e $cadir/ca.pem ] ; then
    openssl genrsa 2048 > $cadir/ca-key.pem
    openssl req -new -x509 -nodes -days 3600 -key $cadir/ca-key.pem -out $cadir/ca.pem -subj "${subj}=environs"
fi

mkdir -p $ssldir

[ -f $ssldir/server-cert.pem ] || {
    openssl req -newkey rsa:2048 -days 3600 -nodes -keyout $ssldir/server-key.pem -out $ssldir/server-req.pem -subj "${subj}=ap`'__wid"
    openssl rsa -in $ssldir/server-key.pem -out $ssldir/server-key.pem
    openssl x509 -req -in $ssldir/server-req.pem -days 3600 -CA $cadir/ca.pem -CAkey $cadir/ca-key.pem -set_serial 01 -out "$ssldir/server-cert.pem"
}

# [ -f $ssldir/client-cert.pem ] || {
#    openssl req -newkey rsa:2048 -days 3600 -nodes -keyout $ssldir/client-key.pem -out $ssldir/client-req.pem -subj "${subj}=client-ap`'__wid"
#    openssl rsa -in $ssldir/client-key.pem -out $ssldir/client-key.pem
#    openssl x509 -req -in $ssldir/client-req.pem -days 3600 -CA $cadir/ca.pem -CAkey $cadir/ca-key.pem -set_serial 01 -out "$ssldir/client-cert.pem"
# }

sslport=__port

if [[ $add != add ]]; then
    sed -i 's, 127.0.0.1, -k https://127.0.0.1,g' __workdir/curl.sh
    sed -i "s,Include __workdir/dir.conf,Include __workdir/dir-ssl.conf,g" __workdir/httpd.conf
else
    sslport=$((200+__port))
    sed "s, 127.0.0.1:__port, -k https://127.0.0.1:$sslport,g" __workdir/curl.sh > __workdir/curl_https.sh
    chmod +x __workdir/curl_https.sh
    echo "<VirtualHost _default_:__port>
Include __workdir/dir.conf
</VirtualHost>
" > __workdir/dir-virt.conf

    sed -i "s,Include __workdir/dir.conf,Listen $sslport\nInclude __workdir/dir-virt.conf\nInclude __workdir/dir-ssl.conf,g" __workdir/httpd.conf
fi

echo "LoadModule ssl_module /usr/lib64/apache2/mod_ssl.so
<VirtualHost _default_:$sslport>
SSLEngine on
SSLCertificateChainFile $cadir/ca.pem
SSLCertificateFile $ssldir/server-cert.pem
SSLCertificateKeyFile $ssldir/server-key.pem

Include __workdir/dir.conf
</VirtualHost>
" > __workdir/dir-ssl.conf
