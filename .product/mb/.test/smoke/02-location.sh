. $(dirname "${BASH_SOURCE[0]}")/up.${1:-ln}

ap9*/start.sh
ap9*/status.sh
ap9*/curl.sh downloads/folder1/ | grep file1.dat

for x in ap7 ap8; do
    xx=$(ls -d $x*/)
    $xx/start.sh
    $xx/status.sh

    mb9*/mb.sh new $x --http http://"$($xx/print_address.sh)" --region NA --country us
    mb9*/mb.sh scan --enable $x
    $xx/curl.sh | grep downloads
done

ap9*/curl.sh /downloads/folder1/file1.dat

tail ap9*/dt/error_log | grep 'Chose server ap'
