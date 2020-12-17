set -ex
. $(dirname "${BASH_SOURCE[0]}")/up.${1:-system2}

zy9*/openSUSE_Leap_15.2/zypper.sh ar devel:languages:perl 
zy9*/openSUSE_Leap_15.2/zypper.sh ar home:andriinikitin 
zy9*/openSUSE_Leap_15.2/zypper.sh --gpg-auto-import-keys --no-gpg-checks refresh
zy9*/openSUSE_Leap_15.2/zypper.sh -n in --download-only MirrorCache 
