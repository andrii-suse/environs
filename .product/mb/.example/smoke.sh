set -e

./environ.sh pg9-system2
./environ.sh ap9-system2
./environ.sh ap8-system2
./environ.sh ap7-system2
./environ.sh mb9-opensuse

pg9*/start.sh
mb9*/configure_db.sh pg9

ap9=$(ls -d ap9*)

# sed -i "/LoadModule dbd_module/a LoadModule mirrorbrain_module $(pwd)/mb9-opensuse/src/build/mod_mirrorbrain/mod_mirrorbrain.so\nDBDriver pgsql\nDBDParams \"host=$(pwd)/pg9-system2/dt user=$USER dbname=mirrorbrain connect_timeout=15\"\nMirrorBrainMetalinkPublisher 'ap9' http://127.0.0.1" ap9*/httpd.conf

# sed -i '/Directory /a MirrorBrainEngine On\nMirrorBrainDebug On\nFormGET On\nMirrorBrainHandleHEADRequestLocally Off\nMirrorBrainMinSize 0\nMirrorBrainExcludeUserAgent rpm\/4.4.2*\nMirrorBrainExcludeUserAgent *APT-HTTP*\nMirrorBrainExcludeMimeType application\/pgp-keys' ap9*/httpd.conf

echo "
LoadModule mirrorbrain_module $(pwd)/mb9-opensuse/src/build/mod_mirrorbrain/mod_mirrorbrain.so
DBDriver pgsql
DBDParams \"host=$(pwd)/pg9-system2/dt user=$USER dbname=mirrorbrain connect_timeout=15\"
MirrorBrainMetalinkPublisher 'ap9' http://127.0.0.1" >> $ap9/httpd.conf

echo "
MirrorBrainEngine On
MirrorBrainDebug On
FormGET On
MirrorBrainHandleHEADRequestLocally Off
MirrorBrainMinSize 0
MirrorBrainExcludeUserAgent rpm\/4.4.2*
MirrorBrainExcludeUserAgent *APT-HTTP*
MirrorBrainExcludeMimeType application\/pgp-keys" > $ap9/directory-mirrorbrain.conf

# populate test data
for x in ap7 ap8 ap9; do
    mkdir -p $x-system2/dt/downloads/{folder1,folder2,folder3}
    echo $x-system2/dt/downloads/{folder1,folder2,folder3}/{file1,file2}.dat | xargs -n 1 touch
done

mkdir -p ap9-system2/hashes

mb9*/mb.sh makehashes $PWD/ap9-system2/dt/downloads -t $PWD/ap9-system2/hashes/downloads

ap9*/start.sh
ap9*/status.sh
ap9*/curl.sh downloads/folder1/ | grep file1.dat

for x in ap7 ap8; do
    $x*/start.sh
    $x*/status.sh
    mb9*/mb.sh new $x --http http://"$($x-system2/print_address.sh)" --rsync rsync://127.0.0.1/$x-system2/dt/downloads --region NA --country us
    mb9*/mb.sh scan --enable $x
    $x-system2/curl.sh | grep downloads
done

ap9*/curl.sh /downloads/folder1/file1.dat

tail ap9*/dt/error_log | grep 'Chose server '
