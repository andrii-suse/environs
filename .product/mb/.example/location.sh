set -e

./environ.sh pg9-system2
./environ.sh ap9-system2
./environ.sh ap8-system2
./environ.sh ap7-system2
./environ.sh mb9-opensuse

pg9*/start.sh

mb9*/configure_db.sh pg9
mb9*/configure_apache.sh ap9

# sed -i "/LoadModule dbd_module/a LoadModule mirrorbrain_module $(pwd)/mb9-opensuse/src/build/mod_mirrorbrain/mod_mirrorbrain.so\nDBDriver pgsql\nDBDParams \"host=$(pwd)/pg9-system2/dt user=$USER dbname=mirrorbrain connect_timeout=15\"\nMirrorBrainMetalinkPublisher 'ap9' http://127.0.0.1" ap9*/httpd.conf

# sed -i '/Directory /a MirrorBrainEngine On\nMirrorBrainDebug On\nFormGET On\nMirrorBrainHandleHEADRequestLocally Off\nMirrorBrainMinSize 0\nMirrorBrainExcludeUserAgent rpm\/4.4.2*\nMirrorBrainExcludeUserAgent *APT-HTTP*\nMirrorBrainExcludeMimeType application\/pgp-keys' ap9*/httpd.conf

# sed -i "s,127.0.0.1,127.0.0.2," ap7*/httpd.conf
# sed -i "s,127.0.0.1,127.0.0.3," ap8*/httpd.conf

# populate test data
for x in ap7 ap8 ap9; do
    xx=$(ls -d $x*/)
    mkdir -p $xx/dt/downloads/{folder1,folder2,folder3}
    echo $xx/dt/downloads/{folder1,folder2,folder3}/{file1,file2}.dat | xargs -n 1 touch
done

mkdir -p ap9-system2/hashes

mb9*/mb.sh makehashes $PWD/ap9-system2/dt/downloads -t $PWD/ap9-system2/hashes/downloads

ap9*/start.sh
ap9*/status.sh
ap9*/curl.sh downloads/folder1/ | grep file1.dat

ap7*/start.sh
ap7*/status.sh
mb9*/mb.sh new ap7 --http http://"$(ap7*/print_address.sh | sed 's/127.0.0.1/127.0.0.2/' )" --rsync rsync://127.0.0.1/$(ls -d ap7*)/dt/downloads --region NA --country us
mb9*/mb.sh scan --enable ap7

ap8*/start.sh
ap8*/status.sh
mb9*/mb.sh new ap8 --http http://"$(ap8*/print_address.sh | sed 's/127.0.0.1/127.0.0.3/' )" --rsync rsync://127.0.0.1/$(ls -d ap8*)/dt/downloads --region EU --country de
mb9*/mb.sh scan --enable ap8

curl --interface 127.0.0.2 $(ap9*/print_address.sh)/downloads/folder1/file1.dat

tail ap9*/dt/error_log | grep 'Chose server ap7'
